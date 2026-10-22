extends "res://scripts/arena/arena.gd"
## Temporary intention source, to be replaced by gameplay decisions later.
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const SCENARIOS: Array[String] = ["A puis B", "Axes", "Bordure", "Disparition"]
var mover := GroundMover.new()
var target_b: ProxyActor
var target_buttons: Array[Button] = []
var replay_button: Button
var movement_status: Label
var label_a: Label
var label_b: Label
var setup_complete: bool = false
var scenario_index: int = 0
var automatic: bool = true
var phase_index: int = 0
var phase_hold: float = 0.0
var scenario_time: float = 0.0
var gait_time: float = 0.0
var selected_name: String = "A"

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-007 / APPROCHE"
	$HUD/Description.text = "Heros cyan / cibles A et B orange\nVitesse au sol : 1.2 u/s / arret : 0.8 u"
	target_b = ProxyActor.new()
	target_b.enemy = true
	target_b.name = "TargetB"
	world.add_child(target_b)
	for caption in ["Cible A", "Cible B", "Aucune"]:
		var button := Button.new()
		button.text = caption
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 18)
		hud.add_child(button)
		target_buttons.append(button)
	target_buttons[0].pressed.connect(_choose_a)
	target_buttons[1].pressed.connect(_choose_b)
	target_buttons[2].pressed.connect(_choose_none)
	replay_button = Button.new()
	replay_button.text = "Rejouer"
	replay_button.focus_mode = Control.FOCUS_NONE
	replay_button.add_theme_font_size_override("font_size", 18)
	hud.add_child(replay_button)
	replay_button.pressed.connect(_reset_scenario)
	movement_status = Label.new()
	movement_status.add_theme_font_size_override("font_size", 16)
	hud.add_child(movement_status)
	label_a = _make_target_label("A")
	label_b = _make_target_label("B")
	setup_complete = true
	floor_canvas.show_marks = true
	_update_layout()
	_reset_scenario()

func _make_target_label(caption: String) -> Label:
	var label := Label.new()
	label.text = caption
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("ffe0a6"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(label)
	return label

func _update_layout() -> void:
	super._update_layout()
	if not setup_complete:
		return
	var width: float = safe_rect.size.x
	var buttons: Array[Button] = [target_buttons[0], target_buttons[1], target_buttons[2], replay_button]
	var button_width: float = (width - 80) / 4.0
	for index in range(4):
		buttons[index].position = Vector2(28 + index * (button_width + 8), 136)
		buttons[index].size = Vector2(button_width, 44)
	movement_status.position = Vector2(28, 188)

func _reset_scenario() -> void:
	if not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
		enemy = ProxyActor.new()
		enemy.enemy = true
		enemy.name = "TargetA"
		world.add_child(enemy)
	enemy.visible = true
	scenario_time = 0.0
	gait_time = 0.0
	phase_hold = 0.0
	phase_index = 0
	automatic = true
	selected_name = "A"
	var start := Vector2(-1.8, 0)
	enemy.position = Vector3(1.6, 0, -1.3)
	target_b.position = Vector3(-1.6, 0, 1.6)
	if scenario_index == 1:
		start = Vector2.ZERO
		enemy.position = Vector3(2, 0, 0)
		target_b.position = Vector3(0, 0, 2)
	elif scenario_index == 2:
		start = Vector2.ZERO
		enemy.position = Vector3(4.5, 0, 4.5)
	elif scenario_index == 3:
		start = Vector2(-1.6, -1.6)
		enemy.position = Vector3(1.6, 0, 1.6)
	mover.reset(start)
	mover.set_target(enemy)
	enemy.pose(0.0, false, Vector2(-1, -1))
	target_b.pose(0.0, false, Vector2(1, -1))
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	if not paused:
		scenario_time += delta
		if automatic and scenario_index == 3 and scenario_time >= 0.75 and is_instance_valid(enemy) and not enemy.is_queued_for_deletion():
			enemy.hide()
			enemy.queue_free()
			selected_name = "A retiree"
		# The mover itself detects the invalid target; the source does not clear it.
		mover.step(delta)
		if mover.velocity.length_squared() > 0.000001:
			gait_time += delta
		if automatic and scenario_index < 2:
			_advance_sequence(delta)
	_present()

func _advance_sequence(delta: float) -> void:
	if mover.state != GroundMover.State.ARRIVED:
		phase_hold = 0.0
		return
	phase_hold += delta
	if phase_hold < 0.5:
		return
	phase_hold = 0.0
	if phase_index == 0:
		phase_index = 1
		selected_name = "B"
		mover.set_target(target_b)
	elif phase_index == 1:
		phase_index = 2
		selected_name = "aucune"
		mover.clear_target()

func _present() -> void:
	hero.position = Vector3(mover.ground_position.x, 0, mover.ground_position.y)
	var moving: bool = mover.velocity.length_squared() > 0.000001
	hero.pose(gait_time, moving, mover.facing)
	floor_canvas.feet = [hero.position, target_b.position]
	if is_instance_valid(enemy) and not enemy.is_queued_for_deletion():
		floor_canvas.feet.append(enemy.position)
		label_a.visible = true
		label_a.text = "A (hors limite)" if scenario_index == 2 else "A"
		label_a.position = render_box.position - hud.position + camera.unproject_position(enemy.position) + Vector2(-8, 10)
	else:
		label_a.visible = false
	label_b.position = render_box.position - hud.position + camera.unproject_position(target_b.position) + Vector2(-8, 10)
	floor_canvas.queue_redraw()
	var states: Array[String] = ["SANS CIBLE", "APPROCHE", "A DISTANCE", "LIMITE"]
	var state_name: String = "PAUSE" if paused else states[mover.state]
	var shown_speed: float = 0.0 if paused else mover.velocity.length()
	var distance_text: String = "--" if mover.distance_to_target < 0 else "%.2f" % mover.distance_to_target
	movement_status.text = "%s | cible %s | %.2f u/s\nDistance %s u | temps %.1f s | %s" % [state_name, selected_name, shown_speed, distance_text, scenario_time, "AUTO" if automatic else "TEST CIBLE"]

func _choose_a() -> void:
	if paused:
		return
	automatic = false
	if is_instance_valid(enemy) and not enemy.is_queued_for_deletion():
		mover.set_target(enemy)
		selected_name = "A"
	else:
		mover.clear_target()
		selected_name = "A absente"

func _choose_b() -> void:
	if paused:
		return
	automatic = false
	mover.set_target(target_b)
	selected_name = "B"

func _choose_none() -> void:
	if paused:
		return
	automatic = false
	selected_name = "aucune"
	mover.clear_target()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	scenario_index = (scenario_index + 1) % SCENARIOS.size()
	_reset_scenario()

func _update_buttons() -> void:
	super._update_buttons()
	if not setup_complete:
		return
	position_button.text = "%d/4 %s" % [scenario_index + 1, SCENARIOS[scenario_index]]
	for button in target_buttons:
		button.disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			match key_event.keycode:
				KEY_A: _choose_a()
				KEY_B: _choose_b()
				KEY_N: _choose_none()
				KEY_R: _reset_scenario()
				_:
					super._unhandled_key_input(event)
					return
			get_viewport().set_input_as_handled()
