extends Node
const App=preload("res://scenes/app/app_root.tscn")
const Composition=preload("res://scripts/party/team_composition.gd")
const Orders=preload("res://scripts/gambits/orders.gd")
const Bars=preload("res://scripts/presentation/overhead_bars.gd")
const Formation=preload("res://scripts/waves/infinite_schedule.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,text:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func touch(viewport:Viewport,at:Vector2,pressed:bool,index:int=0,canceled:bool=false) -> void:
	var event:=InputEventScreenTouch.new();event.index=index;event.position=at;event.pressed=pressed;event.canceled=canceled
	viewport.push_input(event,true)
	var mouse:=InputEventMouseButton.new();mouse.device=InputEvent.DEVICE_ID_EMULATION
	mouse.button_index=MOUSE_BUTTON_LEFT;mouse.position=at;mouse.global_position=at;mouse.pressed=pressed
	viewport.push_input(mouse,true)
func move(viewport:Viewport,at:Vector2,index:int=0) -> void:
	var event:=InputEventScreenDrag.new();event.index=index;event.position=at;viewport.push_input(event,true)
func mouse(viewport:Viewport,at:Vector2,pressed:bool) -> void:
	var event:=InputEventMouseButton.new();event.position=at;event.global_position=at
	event.button_index=MOUSE_BUTTON_LEFT;event.pressed=pressed;viewport.push_input(event,true)
func center(page,slot:int) -> Vector2:return page.cards[slot].get_global_rect().get_center()
func swap(viewport:Viewport,page,from_slot:int,to_slot:int,use_mouse:bool=false) -> void:
	var start:Vector2=center(page,from_slot);var end:Vector2=center(page,to_slot)
	if use_mouse:mouse(viewport,start,true)
	else:touch(viewport,start,true)
	page.gesture.advance(.45);page._update_drag_visual()
	if use_mouse:
		var event:=InputEventMouseMotion.new();event.position=end;event.global_position=end
		event.button_mask=MOUSE_BUTTON_MASK_LEFT;viewport.push_input(event,true)
		mouse(viewport,end,false)
	else:move(viewport,end);touch(viewport,end,false)
	await settle()
func _ready() -> void:
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var path:String="user://team002-%d.json"%resolution.y
		if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport);viewport.notify_mouse_entered()
		var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle()
		app.composition.path=path;app.composition.load_or_create()
		app.open_team();await settle();var page=app.team_page;page.set_process(false)
		var selected:Array=[];app.hero_selected.connect(func(id):selected.append(id))
		check(not page.cards[3].disabled,"empty is an actual drag target/source")
		var at:Vector2=center(page,0)
		touch(viewport,at,true);page.gesture.advance(.449);page._update_drag_visual()
		check(not page.gesture.dragging and page.drag_preview==null,"no drag before 450 ms")
		page.gesture.advance(.0011);page._update_drag_visual()
		check(page.gesture.dragging and page.drag_preview!=null,"hold starts lightweight preview")
		check(page.find_children("*","SubViewport",true,false).size()==3,"drag adds no rendering context")
		move(viewport,center(page,1))
		check(page.drop_outline.visible and page.drop_outline.global_position==page.cards[1].global_position,"gold outline follows destination")
		touch(viewport,center(page,1),false);await settle()
		check(app.composition.slots==[&"anne",&"mako",&"nassau",&""] and selected.is_empty(),"touch swaps once, without opening sheet or emulated mouse click")
		check(page.names.map(func(n):return n.text)==["Anne","Mako","Nassau","Vide"] and page.drag_preview==null and not page.drop_outline.visible,"cards rebuilt with correct identity and no residual selection")
		var reload:=Composition.new(path);reload.load_or_create()
		check(reload.slots==app.composition.slots,"swap saved immediately")
		await swap(viewport,page,3,0)
		check(app.composition.slots==[&"",&"mako",&"nassau",&"anne"],"empty source swaps with hero")
		await swap(viewport,page,2,0,true)
		check(app.composition.slots==[&"nassau",&"mako",&"",&"anne"],"physical mouse swaps hero with empty")
		check(page.illustrations.size()==3 and page.portraits.size()==3 and page.empty_frames.has(2),"three unchanged Idle models follow moved portraits")
		var unchanged:Array=app.composition.slots.duplicate()
		at=center(page,0);touch(viewport,at,true);move(viewport,at+Vector2(20,0));page.gesture.advance(1)
		touch(viewport,center(page,1),false);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"early swipe never clicks or swaps")
		touch(viewport,at,true);page.gesture.advance(.5);move(viewport,Vector2(5,5));touch(viewport,Vector2(5,5),false);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"drop outside cancels")
		touch(viewport,at,true);page.gesture.advance(.5);touch(viewport,at,false);await settle()
		check(selected.is_empty() and app.composition.slots==unchanged,"long hold released on source is not a click")
		touch(viewport,at,true);page.gesture.advance(.5);touch(viewport,center(page,1),true,1)
		touch(viewport,center(page,1),false);touch(viewport,center(page,1),false,1);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"second finger cancels captured gesture")
		touch(viewport,at,true);page.gesture.advance(.5);touch(viewport,at,false,0,true);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"OS canceled touch never activates card")
		touch(viewport,at,true);page.gesture.advance(.5);page._update_drag_visual()
		app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);app.notification(NOTIFICATION_APPLICATION_PAUSED)
		check(page.gesture.source<0 and page.drag_preview==null,"focus loss clears preview and capture")
		app.notification(NOTIFICATION_APPLICATION_RESUMED);app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
		touch(viewport,center(page,1),false);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"old release after resume does nothing")
		touch(viewport,at,true);page._process(12)
		check(not page.gesture.dragging,"first return delta cannot turn a fresh touch into a long hold")
		page.cancel_drag();touch(viewport,at,false)
		touch(viewport,at,true);page.gesture.advance(.5);page._layout();touch(viewport,at,false);await settle()
		check(app.composition.slots==unchanged and selected.is_empty(),"layout change cancels capture")
		touch(viewport,at,true);page.gesture.advance(.5);app.go_back();touch(viewport,at,false);await settle()
		check(app.route==&"team" and page.gesture.source<0 and selected.is_empty(),"Android Back first cancels drag without navigating or opening sheet")
		app.composition.path="user://missing-team002-folder/team.json"
		await swap(viewport,page,0,1)
		check(app.composition.slots==unchanged and page.team_slots==unchanged and page.feedback.visible,"save failure keeps old composition and shows concise feedback")
		app.composition.path=path
		touch(viewport,center(page,0),true);touch(viewport,center(page,0),false);await settle()
		check(app.route==&"hero" and selected==[&"nassau"] and app.hero_page.hero_id==&"nassau","short tap on moved hero opens correct sheet exactly once")
		app.return_team();await settle();page.set_process(false)
		check(page.cards.all(func(c):return not c.button_pressed) and not page.drop_outline.visible,"return from sheet keeps no selection")
		mouse(viewport,center(page,1),true);mouse(viewport,center(page,1),false);await settle()
		check(selected==[&"nassau",&"mako"] and app.hero_page.hero_id==&"mako","short physical click opens correct moved hero")
		app.return_team();await settle();app.return_home();await settle();app.open_arena()
		var combat=app.combat;combat.set_process(false);combat.set_physics_process(false);await settle()
		check(combat.hero_panels.map(func(p):return p.hero_id)==unchanged,"combat panels use saved order and middle hole")
		for unit in combat.simulation.heroes:
			check(unit.mover.ground_position==Formation.hero_position(unit.team_slot),"initial actor position matches fixed slot")
		var nassau=combat.simulation.hero(&"nassau")
		check(Orders.evaluate(combat.simulation.rules.nassau,combat.simulation.snapshot(nassau)).target_id==nassau.combat_id,"Allié now follows changed roster order, Nassau first")
		var panel=combat.hero_panels[0]
		check(panel.bars.cast_color==Color("8befff") and combat.overhead[nassau.combat_id].cast_color==Color("8befff"),"both panels and world bars inherit light cyan")
		viewport.queue_free();await settle()
		var next_view:=SubViewport.new();next_view.size=resolution;add_child(next_view)
		var next_app=App.instantiate();next_app.save_path="user://team002-unused-rules.json";next_app.team_path=path;next_app.combat_settings_path=""
		next_view.add_child(next_app);await settle();next_app.open_team();await settle()
		check(next_app.composition.slots==unchanged and next_app.team_page.names[0].text=="Nassau","new app instance restores swapped composition")
		next_view.queue_free();await settle();DirAccess.remove_absolute(path)
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan portraits or preview nodes")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
