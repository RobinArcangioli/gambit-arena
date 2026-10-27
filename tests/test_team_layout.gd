extends Node
const App=preload("res://scenes/app/app_root.tscn")
var checks: int=0
var failures: int=0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("TeamLayout: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func tap(viewport: Viewport, at: Vector2) -> void:
	for pressed in [true,false]:
		var event:=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=pressed;viewport.push_input(event,true)
		var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.position=at;mouse.global_position=at;mouse.pressed=pressed;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0
		viewport.push_input(mouse,true)
func _ready() -> void:
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";viewport.add_child(app);await settle();viewport.notify_mouse_entered()
		tap(viewport,app.team_button.get_global_rect().get_center());await settle()
		check(app.route==&"team" and app.team_page!=null,"real touch opens Team exactly once")
		var page=app.team_page;page.set_process(false)
		var view:=Rect2(Vector2.ZERO,Vector2(resolution))
		check(page.background.get_rect()==view and view.encloses(page.back_button.get_global_rect()),"provided background fills page and return is safe")
		for card in page.cards:check(view.encloses(card.get_global_rect()),"each slot fits portrait screen")
		check(not page.cards[0].get_rect().intersects(page.cards[1].get_rect()) and not page.cards[0].get_rect().intersects(page.cards[2].get_rect()),"grid cells never overlap")
		check(view.encloses(page.feedback.get_global_rect()),"selection feedback fits screen")
		var selected: Array[StringName]=[];app.hero_selected.connect(func(id):selected.append(id))
		tap(viewport,page.portraits[0].get_global_rect().get_center());await settle()
		check(selected==[&"mako"] and app.selected_hero_id==&"mako","touch on rendered model passes through to Mako card once")
		app.return_team();await settle()
		tap(viewport,page.portraits[1].get_global_rect().get_center());await settle()
		check(selected==[&"mako",&"anne"] and app.selected_hero_id==&"anne","touch on Anne emits no duplicate mouse selection")
		app.return_team();await settle()
		tap(viewport,page.cards[2].get_global_rect().get_center());tap(viewport,page.cards[3].get_global_rect().get_center());await settle()
		check(selected.size()==2,"empty cells ignore taps")
		tap(viewport,page.back_button.get_global_rect().get_center());await settle()
		check(app.route==&"home" and app.team_page==null,"return button releases the Team scene")
		viewport.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"all portrait viewports released")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
