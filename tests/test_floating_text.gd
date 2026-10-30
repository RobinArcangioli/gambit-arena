extends Node
const Text=preload("res://scripts/presentation/floating_combat_text.gd")
const Presenter=preload("res://scripts/presentation/combat_presenter.gd")
const Settings=preload("res://scripts/app/combat_settings.gd")
const App=preload("res://scenes/app/app_root.tscn")
var checks:int=0
var failures:int=0
func check(ok:bool,caption:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("FloatingText: "+caption)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func tap(viewport:Viewport,button:Control) -> void:
	var at:Vector2=button.get_global_rect().get_center()
	for down in [true,false]:
		var event:=InputEventScreenTouch.new();event.position=at;event.index=0;event.pressed=down;viewport.push_input(event,true)
		var mouse:=InputEventMouseButton.new();mouse.position=at;mouse.global_position=at;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=down;mouse.device=-1;viewport.push_input(mouse,true)
func impact(seq:int,team:int,amount:int=7) -> Dictionary:
	return {"run_id":1,"kind":"resolve","source_id":1,"target_id":2,"target_team":team,"sequence":seq,"skill":"basic","damage":amount,"target_position":Vector3(1,0,2)}
func _ready() -> void:
	var presenter:=Presenter.new();add_child(presenter);presenter.reset_run(1)
	presenter.consume(impact(1,1));presenter.consume(impact(2,0))
	check(presenter.damage_texts.size()==2,"each impact has its own number")
	var white=presenter.damage_texts[0].view;var red=presenter.damage_texts[1].view
	check(white.text=="7" and white.tint==Color.WHITE,"enemy damage is white and uses actual amount")
	check(red.tint==Color("e44949"),"hero damage is red regardless of source camp")
	check(white.duration==1 and white.font_size==48 and is_equal_approx(white.pixel_size,.006),"same former healing number dimensions and duration")
	var heal:Dictionary=impact(3,0,0);heal.skill="heal";heal.healing=5;presenter.consume(heal)
	var effect=presenter.heal_effects[0].view;var green=effect.amount_label
	check(green is Text and green.text=="+5" and green.tint==Color(.72,1,.8),"healing uses common animator and unchanged green")
	presenter.present([],[],.25,1)
	check(is_equal_approx(white.age,green.age) and is_equal_approx(white.modulate.a,green.modulate.a),"damage and healing share exact animation envelope")
	check(is_equal_approx(white.position.y,1.55+.25*.24),"same upward drift as former healing text")
	var frozen:Array=[white.age,white.position,white.modulate,green.position,green.modulate]
	for dt in [0.0,-1.0,INF,NAN]:white.advance_visual(dt);green.advance_visual(dt)
	check(frozen==[white.age,white.position,white.modulate,green.position,green.modulate],"pause and invalid steps freeze all floating text")
	presenter.consume(impact(2,0));check(presenter.damage_texts.size()==2,"duplicate or stale impacts do not duplicate numbers")
	presenter.set_text_preferences(false,true,false)
	check(not white.visible and red.visible and not green.visible and effect.visible,"independent toggles hide text only, never healing rings")
	presenter.consume(impact(4,1));check(presenter.damage_texts.size()==2,"disabled enemy damage creates no new text")
	presenter.consume(impact(5,0));check(presenter.damage_texts.size()==3,"hero damage remains enabled independently")
	presenter.consume(impact(6,0,0));check(presenter.damage_texts.size()==3,"zero damage creates no text")
	presenter.set_text_preferences(true,true,true)
	check(white.visible and green.visible,"reenabling restores still-active text")
	presenter.consume({"run_id":1,"kind":"death","actor_id":2})
	check(presenter.damage_texts.size()==3 and presenter.heal_effects.is_empty(),"killing hit stays visible through target death")
	presenter.present([],[],1,1);check(presenter.damage_texts.is_empty(),"numbers expire even after target is removed")
	check(white.modulate.a==0 and white.outline_modulate.a==0,"number and outline end fully transparent")
	presenter.reset_run(2);presenter.consume(impact(7,1));check(presenter.damage_texts.is_empty(),"previous combat impacts cannot reappear")
	presenter.reset_run(1)
	for seq in range(80):presenter.consume(impact(seq+1,1))
	check(presenter.damage_texts.size()==presenter.MAX_DAMAGE_TEXTS,"visual effects remain bounded during extreme bursts")
	presenter.enabled=false;presenter.present([],[],0,1);check(presenter.damage_texts.is_empty(),"disabling presenter clears remaining text")
	presenter.queue_free();await settle()
	for resolution in [Vector2i(540,960),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";app.combat_settings_path="user://floating-%d.cfg"%resolution.x
		if FileAccess.file_exists(app.combat_settings_path):DirAccess.remove_absolute(app.combat_settings_path)
		viewport.add_child(app);await settle();viewport.notify_mouse_entered();app.open_arena();await settle()
		var game=app.combat;game.set_physics_process(false);game.set_process(false)
		tap(viewport,game.settings_button);await settle()
		check(game.settings_menu.visible and not game.paused,"settings do not pause combat")
		check(game.combat_rect.encloses(game.settings_menu.get_global_rect()),"settings stay inside central arena even on small portrait")
		check(game.settings_menu.find_children("*","CheckBox",true,false).size()==7,"grid, AOE, two bar options and three floating options")
		var prefs=game.combat_settings
		check(prefs.damage_dealt_text and prefs.damage_received_text and prefs.healing_text,"all floating options default on")
		game.settings_menu.scroller.scroll_vertical=0;await settle()
		var start:Vector2=game.settings_menu.scroller.get_global_rect().get_center()
		var finger:=InputEventScreenTouch.new();finger.index=0;finger.position=start;finger.pressed=true;viewport.push_input(finger,true)
		var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=start-Vector2(0,50);drag.relative=Vector2(0,-50);viewport.push_input(drag,true)
		finger=InputEventScreenTouch.new();finger.index=0;finger.position=drag.position;finger.pressed=false;viewport.push_input(finger,true);await settle()
		check(prefs.hero_bars and prefs.enemy_bars and prefs.damage_dealt_text and prefs.damage_received_text and prefs.healing_text,"swipe never toggles any checkbox")
		var bar:VScrollBar=game.settings_menu.scroller.get_v_scroll_bar()
		check(bar.max_value<=bar.page or game.settings_menu.scroller.scroll_vertical>0,"real finger scroll reaches options on short screens")
		for box in [game.settings_menu.outgoing_box,game.settings_menu.incoming_box,game.settings_menu.healing_box]:
			game.settings_menu.scroller.ensure_control_visible(box);await settle();tap(viewport,box);await settle()
			check(not box.button_pressed,"real touch plus mouse copy toggles each option once")
		check(not game.action_presenter.outgoing_text and not game.action_presenter.incoming_text and not game.action_presenter.healing_text,"display preferences reach presentation")
		var loaded:=Settings.new(app.combat_settings_path);loaded.load_preferences()
		check(not loaded.damage_dealt_text and not loaded.damage_received_text and not loaded.healing_text,"all three options saved immediately")
		var elapsed:float=game.simulation.clock.elapsed;game._physics_process(.02)
		check(game.simulation.clock.elapsed>elapsed,"combat continues with settings and text disabled")
		game._reset();check(game.action_presenter.damage_texts.is_empty() and not game.action_presenter.outgoing_text,"replay clears texts and retains preference")
		app.return_home();await settle();app.open_arena();await settle()
		check(not app.combat.action_presenter.healing_text,"next combat reloads remembered text settings")
		var path:String=app.combat_settings_path;viewport.queue_free();await settle();DirAccess.remove_absolute(path)
	var cfg:=ConfigFile.new();cfg.set_value("display","hero_bars",false);cfg.set_value("floating_text","damage_dealt_text","false");cfg.set_value("floating_text","healing_text",2);cfg.save("user://floating-old.cfg")
	var old:=Settings.new("user://floating-old.cfg");old.load_preferences()
	check(not old.hero_bars and old.enemy_bars and old.damage_dealt_text and old.damage_received_text and old.healing_text,"older or invalid preferences keep bars and default new flags on")
	DirAccess.remove_absolute("user://floating-old.cfg")
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no retained labels meshes or actors")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
