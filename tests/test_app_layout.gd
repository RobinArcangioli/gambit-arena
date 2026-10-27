extends Node
const App = preload("res://scenes/app/app_root.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:failures += 1;push_error("AppLayout: "+message)
func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
func enclosed(outer: Rect2, inner: Rect2) -> bool:
	return outer.grow(0.1).encloses(inner)
func mouse(viewport: Viewport, at: Vector2, pressed: bool) -> void:
	var event:=InputEventMouseButton.new();event.device=-1;event.position=at;event.global_position=at
	event.button_index=MOUSE_BUTTON_LEFT;event.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0;event.pressed=pressed
	viewport.push_input(event,true)
func tap(viewport: Viewport, at: Vector2) -> void:
	for pressed in [true,false]:
		var event:=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=pressed
		viewport.push_input(event,true);mouse(viewport,at,pressed)
func _ready() -> void:
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,800)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";viewport.add_child(app)
		await settle()
		var view:=Rect2(Vector2.ZERO,Vector2(resolution))
		check(enclosed(view,app.arena_button.get_global_rect()) and enclosed(view,app.team_button.get_global_rect()),"Home buttons fit portrait viewport")
		viewport.notify_mouse_entered()
		tap(viewport,app.arena_button.get_global_rect().get_center());await settle()
		check(app.combat!=null and app.arena_choice.draws==1,"real touch and mouse copy open exactly one arena")
		if app.combat==null:app.open_arena();await settle()
		var game=app.combat;game.set_process(false);game.set_physics_process(false)
		for id in app.arena_choice.choices:
			game.chooser=func():return id
			game._reset();await settle();game._sync_projection()
			check(enclosed(game.floor_canvas.active_view.image_rect,view),"calibrated illustration covers every control at %s / %s"%[resolution,id])
			var safe: bool=true
			for x in [-2.65,2.65]:
				for z in [-2.65,2.65]:
					for angle in range(8):
						var offset:=Vector3(cos(TAU*angle/8)*0.35,0,sin(TAU*angle/8)*0.35)
						safe=safe and view.has_point(game.camera.unproject_position(Vector3(x,0,z)+offset))
			check(safe,"logical body at all four bounds remains visible")
		check(enclosed(view,game.back_button.get_global_rect()) and enclosed(view,game.pause_button.get_global_rect()),"navigation and resume fit without clipped text")
		game._show_tab('rules');await settle()
		var before: int=app.arena_choice.draws
		game.orders_editor.controls[0].criterion.show_popup();app.go_back()
		check(app.combat==game and not game.orders_editor.popup_open() and app.arena_choice.draws==before,"modal back neither abandons nor redraws")
		tap(viewport,game.back_button.get_global_rect().get_center());await settle()
		check(app.route==&"home" and app.combat==null,"real touch returns home and releases arena")
		viewport.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"all viewport and route nodes freed")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
