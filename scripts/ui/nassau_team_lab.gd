extends "res://scripts/app/app_root.gd"
## Product pages with isolated configuration; no player files are read or written.
var toolbar:HBoxContainer
func _ready() -> void:
	save_path="";combat_settings_path="";team_path="";super._ready()
	get_window().title="Gambit Arena · Cadres d’origine · Nassau"
	toolbar=HBoxContainer.new();toolbar.z_index=50;toolbar.position=Vector2(160,16);add_child(toolbar)
	for tab in ["Équipe","Formation","Combat"]:
		var button:=Button.new();button.text=tab;button.add_theme_font_size_override("font_size",13)
		button.custom_minimum_size=Vector2(102,44);toolbar.add_child(button);button.pressed.connect(show_preview.bind(tab))
	call_deferred("show_preview","Équipe")
func show_preview(tab:String) -> void:
	if guard.blocked or transitioning:return
	if route!=&"home":
		return_home();await get_tree().process_frame;await get_tree().process_frame
	if tab=="Équipe":
		open_team();await get_tree().process_frame;await get_tree().process_frame
		team_page.title.hide()
	else:
		open_arena();await get_tree().process_frame;await get_tree().process_frame
		if tab=="Formation":
			combat.set_process(false);combat.set_physics_process(false);combat._reset()
			combat.paused=false;combat.simulation.clock.paused=false;combat.pause_layer.hide()
			combat._present()
		combat.pause_button.hide()
	print("NASSAU_PREVIEW "+tab)
