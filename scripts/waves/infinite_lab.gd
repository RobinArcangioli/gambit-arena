extends "res://scripts/app/arena_page.gd"
## Explicit test controls, isolated from player saves and the product route.
var lab_panel: PanelContainer
var controls: Array[Button] = []
var running: bool = false
func _ready() -> void:
	infinite_mode=true;save_path="user://infinite001-lab.json"
	super._ready();set_physics_process(false)
	lab_panel=PanelContainer.new();add_child(lab_panel)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182ff0");paint.border_color=Color("d9a64c")
	paint.set_border_width_all(1);paint.set_content_margin_all(12);lab_panel.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();lab_panel.add_child(column)
	var caption:=_label(column,15);caption.text="Mode Infini · Laboratoire (départ figé)"
	var row:=HBoxContainer.new();column.add_child(row)
	controls.append(_button(row,"Jouer / figer",toggle_motion))
	controls.append(_button(row,"Fin de vague",finish_wave))
	controls.append(_button(row,"10 → 11",test_rotation))
	_update_layout();_present()
func toggle_motion() -> void:
	if paused or application_guard.blocked:return
	running=not running;set_physics_process(running)
func finish_wave() -> void:
	if paused or application_guard.blocked or simulation.infinite.waiting:return
	for enemy_unit in simulation.enemies:enemy_unit.state.damage(100000)
	_physics_process(1.0/60)
func test_rotation() -> void:
	if paused or application_guard.blocked:return
	simulation.wave_number=10;_present();finish_wave()
func _update_layout() -> void:
	super._update_layout()
	if lab_panel!=null:
		lab_panel.position=Vector2(12,get_viewport_rect().size.y-104);lab_panel.size=Vector2(get_viewport_rect().size.x-24,92)
func _process(delta: float) -> void:
	super._process(delta)
	for button in controls:button.disabled=paused or application_guard.blocked or simulation.result!="EN COURS"
