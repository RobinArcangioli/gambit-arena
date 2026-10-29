extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Settings = preload("res://scripts/app/combat_settings.gd")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
var checks: int=0
var failures: int=0
func check(ok: bool, text: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func tap(viewport: Viewport,button: Control) -> void:
	var at:Vector2=button.get_global_rect().get_center()
	for pressed in [true,false]:
		var finger:=InputEventScreenTouch.new();finger.position=at;finger.index=0;finger.pressed=pressed;viewport.push_input(finger,true)
		var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.position=at;mouse.global_position=at;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=pressed;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0;viewport.push_input(mouse,true)
func _ready() -> void:
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var path:String="user://combat-settings-test-%d.cfg"%resolution.y
		if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";app.combat_settings_path=path;viewport.add_child(app);await settle();viewport.notify_mouse_entered()
		check(app.combat==null,"settings absent outside arena")
		app.open_arena();await settle()
		var game=app.combat;game.set_physics_process(false);game.set_process(false)
		game.safe_area_override=Rect2(8,24,resolution.x-16,resolution.y-44);game._update_layout();await settle()
		check(game.combat_settings.hero_bars and game.combat_settings.enemy_bars,"new installation defaults")
		check(game.settings_button.text.is_empty() and game.settings_button.icon!=null,"settings button is gear only")
		check(game.settings_button.get_theme_stylebox("normal") is StyleBoxEmpty and game.settings_button.get_theme_stylebox("focus") is StyleBoxEmpty,"gear has no background or border")
		check(game.combat_rect.encloses(game.settings_button.get_global_rect()),"settings button in central combat area")
		check(game.settings_button.get_global_rect().position.y>game.pause_button.get_global_rect().end.y,"settings below global Pause")
		check(not game.combat_settings.grid and not game.floor_canvas.show_grid,"grid defaults hidden")
		var run_id:int=game.simulation.run_id
		var clock:float=game.simulation.clock.elapsed
		tap(viewport,game.settings_button);await settle()
		check(game.settings_menu.visible and not game.paused,"touch opens settings without pause")
		check(game.settings_menu.ok_button.size.x>=56 and game.settings_menu.ok_button.size.x<90,"OK fits text with reasonable padding")
		check(game.settings_menu.find_children("*","CheckBox",true,false).size()==6,"grid, two bar groups and three floating text settings")
		check(game.combat_rect.encloses(game.settings_menu.get_global_rect()),"small settings menu fits central area")
		game._physics_process(.02)
		check(game.simulation.clock.elapsed>clock and game.simulation.run_id==run_id,"combat continues in settings")
		tap(viewport,game.settings_menu.grid_box);await settle()
		check(game.combat_settings.grid and game.floor_canvas.show_grid,"grid toggles immediately with physical tap")
		var grid_saved:=Settings.new(path);grid_saved.load_preferences()
		check(grid_saved.grid and not game.paused,"grid is remembered without pausing combat")
		game.settings_menu.scroller.ensure_control_visible(game.settings_menu.bars_box);await settle()
		tap(viewport,game.settings_menu.bars_box);await settle()
		check(not game.combat_settings.hero_bars,"one physical tap toggles checkbox once")
		check(game.simulation.heroes.all(func(unit):return not game.overhead.has(unit.combat_id) or not game.overhead[unit.combat_id].visible),"hero overhead bars hidden")
		check(game.simulation.enemies.all(func(unit):return not unit.state.alive or game.overhead[unit.combat_id].visible),"enemy bars retained")
		check(game.hero_panels[0].bars.visible and game.hero_panels[1].bars.visible,"hero panel bars retained")
		game.settings_menu.scroller.ensure_control_visible(game.settings_menu.enemy_bars_box);await settle()
		tap(viewport,game.settings_menu.enemy_bars_box);await settle()
		check(not game.combat_settings.enemy_bars,"one physical tap toggles enemy checkbox once")
		check(game.simulation.enemies.all(func(unit):return not game.overhead.has(unit.combat_id) or not game.overhead[unit.combat_id].visible),"enemy overhead bars hidden independently")
		check(game.hero_panels[0].bars.visible and game.hero_panels[1].bars.visible,"panels stay visible when both overhead groups hidden")
		var loaded:=Settings.new(path);loaded.load_preferences()
		check(not loaded.hero_bars and not loaded.enemy_bars,"both preferences saved immediately")
		tap(viewport,game.settings_menu.ok_button);await settle()
		check(not game.settings_menu.visible and not game.paused,"OK only closes menu")
		game._toggle_pause();game._replay_combat();await settle()
		check(not game.combat_settings.hero_bars and not game.combat_settings.enemy_bars and game.floor_canvas.show_grid,"replay retains preferences and grid")
		tap(viewport,game.settings_button);await settle();game.handle_back();await settle()
		check(not game.settings_menu.visible and not game.paused,"Back closes settings without abandoning")
		tap(viewport,game.settings_button);await settle()
		game.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);game.notification(NOTIFICATION_APPLICATION_PAUSED);await settle()
		check(not game.settings_menu.visible and game.paused and game.pause_layer.visible,"background closes settings and pauses safely")
		game.notification(NOTIFICATION_APPLICATION_RESUMED);game.notification(NOTIFICATION_APPLICATION_FOCUS_IN);await settle()
		check(game.paused,"return never auto resumes")
		app.return_home();await settle();app.open_arena();await settle()
		game=app.combat;game.set_physics_process(false);game.set_process(false)
		check(not game.combat_settings.hero_bars and not game.combat_settings.enemy_bars and game.floor_canvas.show_grid,"new combat loads remembered settings and grid")
		game._open_settings();await settle()
		check(game.settings_menu.grid_box.button_pressed,"menu reflects saved grid setting")
		tap(viewport,game.settings_menu.grid_box);await settle()
		check(not game.floor_canvas.show_grid,"grid can be hidden again")
		game._close_settings()
		var projection:Rect2=game.floor_canvas.active_view.image_rect
		for arena_id in Catalog.ids():
			if arena_id==&"reference":continue
			game.floor_canvas.set_definition(Catalog.definition(arena_id));game._sync_projection()
			var art=game.floor_canvas.active_view
			var info:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/art/arenas/generation.json"))
			var entries:Array=info.assets
			var supplied:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/art/arenas/supplied_additions.json"))
			entries=entries+supplied.assets.map(func(row):return {"id":row.id,"generated":row.asset,"sha256":row.sha256})
			var asset:Dictionary=entries.filter(func(row):return row.id==String(arena_id))[0]
			check(FileAccess.get_sha256("res://"+asset.generated)==asset.sha256 and art.background.get_size()==Vector2(540,960),"only clean background at original canvas for "+String(arena_id))
		check(projection.has_area(),"valid calibrated projection")
		viewport.queue_free();await settle();DirAccess.remove_absolute(path)
	var corrupt:=ConfigFile.new();corrupt.set_value("display","grid","wrong");corrupt.set_value("display","hero_bars",12);corrupt.set_value("display","enemy_bars","wrong");corrupt.save("user://settings-invalid.cfg")
	var restored:=Settings.new("user://settings-invalid.cfg");restored.load_preferences()
	check(restored.hero_bars and restored.enemy_bars and not restored.grid,"invalid preference types use defaults")
	DirAccess.remove_absolute("user://settings-invalid.cfg")
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan menus")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
