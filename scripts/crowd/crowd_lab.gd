extends "res://scripts/arena/arena.gd"
const CrowdSimulation = preload("res://scripts/crowd/crowd_simulation.gd")
const CrowdMarks = preload("res://scripts/crowd/crowd_marks.gd")
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const MODES: Array[String] = ["Encerclement", "Poursuite", "Blocage", "Bordure"]
const ROUTE: Array[Vector2] = [Vector2(1.6, -1.6), Vector2(1.6, 1.6), Vector2(-1.6, 1.6), Vector2(-1.6, -1.6)]
var simulation := CrowdSimulation.new()
var rings := CrowdMarks.new()
var waypoint := Node3D.new()
var controls: Array[Button] = []
var status_label: Label
var setup_complete: bool = false
var mode_index: int = 0
var route_index: int = 0
var gap_open: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-009 / CONTACTS"
	$HUD/Description.text = "Disques au sol : rayon 0.35 u\nSeparation progressive / aucun combat"
	enemy.hide()
	enemy.queue_free()
	world.add_child(waypoint)
	add_child(simulation)
	simulation.configure(world, hero)
	rings.camera = camera
	add_child(rings)
	move_child(rings, render_box.get_index())
	for caption in ["Apparitions", "Rejouer"]:
		var button := Button.new()
		button.text = caption
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 17)
		hud.add_child(button)
		controls.append(button)
	controls[0].pressed.connect(_action)
	controls[1].pressed.connect(_reset_scenario)
	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 16)
	status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(status_label)
	setup_complete = true
	floor_canvas.show_marks = true
	_update_layout()
	_reset_scenario()

func _update_layout() -> void:
	super._update_layout()
	if not setup_complete:
		return
	var button_width: float = (safe_rect.size.x - 64) / 2.0
	for index in range(controls.size()):
		controls[index].position = Vector2(28 + index * (button_width + 8), 136)
		controls[index].size = Vector2(button_width, 44)
	status_label.position = Vector2(28, 188)
	rings.position = render_box.position

func _reset_scenario() -> void:
	if not setup_complete:
		return
	var start := Vector2.ZERO
	if mode_index == 1:
		start = Vector2(-1.6, -1.6)
	elif mode_index == 3:
		start = Vector2(2.3, 2.3)
	simulation.reset(start)
	route_index = 0
	gap_open = false
	if mode_index == 1:
		_set_waypoint(ROUTE[0])
		simulation.hero_mover.set_target(waypoint)
	elif mode_index == 2:
		simulation.spawning = false
		simulation.freeze_enemies = true
		for index in range(6):
			var angle: float = TAU * float(index) / 6.0
			simulation.add_enemy(Vector2(cos(angle), sin(angle)) * 0.95)
		_set_waypoint(Vector2(2.3, 0))
		simulation.hero_mover.set_target(waypoint)
	elif mode_index == 3:
		# Deliberate invalid initial overlap: visibly resolves over multiple ticks.
		simulation.add_enemy(Vector2(-2.65, -2.65), true)
		simulation.add_enemy(Vector2(-2.65, -2.65), true)
	_present()
	_update_buttons()

func _set_waypoint(point: Vector2) -> void:
	waypoint.position = Vector3(point.x, 0, point.y)

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	simulation.advance(delta, paused)
	if not paused and mode_index == 1 and simulation.hero_mover.state == GroundMover.State.ARRIVED:
		route_index = (route_index + 1) % ROUTE.size()
		_set_waypoint(ROUTE[route_index])
	_present()

func _present() -> void:
	hero.pose(simulation.hero_gait, simulation.hero_mover.velocity.length_squared() > 0.000001, simulation.hero_mover.facing)
	floor_canvas.feet = [hero.position]
	rings.points = [simulation.hero_mover.ground_position]
	for actor in simulation.actors:
		if is_instance_valid(actor) and not actor.is_queued_for_deletion():
			floor_canvas.feet.append(actor.position)
			rings.points.append(actor.mover.ground_position)
	floor_canvas.queue_redraw()
	rings.visible = floor_canvas.show_marks
	rings.queue_redraw()
	var states: Array[String] = ["sans cible", "avance", "arrive", "BLOQUE"]
	var state_name: String = "PAUSE" if paused else states[simulation.hero_mover.state]
	status_label.text = "%.1f s | ennemis %d/20 | bloques %d\nHeros %s | pas max %.3f u" % [simulation.elapsed, simulation.actors.size(), simulation.blocked_count, state_name, simulation.max_step]

func _action() -> void:
	if paused:
		return
	if mode_index == 2:
		if not gap_open and not simulation.actors.is_empty():
			var gate = simulation.actors[0]
			simulation.actors.remove_at(0)
			gate.hide()
			gate.queue_free()
			gap_open = true
	else:
		simulation.spawning = not simulation.spawning
		simulation.spawn_clock = 0.0
	_update_buttons()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % MODES.size()
	_reset_scenario()

func _update_buttons() -> void:
	super._update_buttons()
	if not setup_complete:
		return
	position_button.text = "%d/4 %s" % [mode_index + 1, MODES[mode_index]]
	controls[0].text = ("Passage ouvert" if gap_open else "Ouvrir passage") if mode_index == 2 else ("Apparitions : oui" if simulation.spawning else "Apparitions : non")
	controls[0].disabled = paused or (mode_index == 2 and gap_open)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			match key_event.keycode:
				KEY_S: _action()
				KEY_R: _reset_scenario()
				_:
					super._unhandled_key_input(event)
					return
			get_viewport().set_input_as_handled()
