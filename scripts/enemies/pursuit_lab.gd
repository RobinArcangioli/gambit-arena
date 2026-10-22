extends "res://scripts/arena/arena.gd"
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const EnemyDirector = preload("res://scripts/enemies/enemy_director.gd")
const MODES: Array[String] = ["Heros fixe", "Heros mobile", "Plafond 20"]
const ROUTE: Array[Vector2] = [Vector2(1.6, -1.6), Vector2(1.6, 1.6), Vector2(-1.6, 1.6), Vector2(-1.6, -1.6)]
var director := EnemyDirector.new()
var hero_mover := GroundMover.new()
var waypoint := Node3D.new()
var controls: Array[Button] = []
var status_label: Label
var setup_complete: bool = false
var mode_index: int = 0
var route_index: int = 0
var hero_present: bool = true
var gait_time: float = 0.0

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-008 / POURSUITE"
	$HUD/Description.text = "Ennemis : 0.9 u/s / arret : 0.8 u\nApparitions aux quatre cotes, toutes les 1 s"
	enemy.hide()
	enemy.queue_free()
	world.add_child(waypoint)
	add_child(director)
	director.configure(world, hero)
	for caption in ["Apparitions", "Retirer heros", "Rejouer"]:
		var button := Button.new()
		button.text = caption
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 16)
		hud.add_child(button)
		controls.append(button)
	controls[0].pressed.connect(_toggle_spawning)
	controls[1].pressed.connect(_toggle_hero)
	controls[2].pressed.connect(_reset_scenario)
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
	var button_width: float = (safe_rect.size.x - 72) / 3.0
	for index in range(controls.size()):
		controls[index].position = Vector2(28 + index * (button_width + 8), 136)
		controls[index].size = Vector2(button_width, 44)
	status_label.position = Vector2(28, 188)

func _reset_scenario() -> void:
	if not setup_complete:
		return
	director.reset(20 if mode_index == 2 else 4)
	hero_present = true
	hero.show()
	director.set_hero(hero)
	route_index = 0
	gait_time = 0.0
	hero_mover.reset(Vector2.ZERO if mode_index == 0 else Vector2(-1.6, -1.6))
	hero_mover.stopping_distance = 0.0
	_set_waypoint()
	if mode_index != 0:
		hero_mover.set_target(waypoint)
	_present()
	_update_buttons()

func _set_waypoint() -> void:
	var point: Vector2 = ROUTE[route_index]
	waypoint.position = Vector3(point.x, 0, point.y)

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	if not paused:
		if hero_present and mode_index != 0:
			hero_mover.step(delta)
			if hero_mover.velocity.length_squared() > 0.000001:
				gait_time += delta
			if hero_mover.state == GroundMover.State.ARRIVED:
				route_index = (route_index + 1) % ROUTE.size()
				_set_waypoint()
		hero.position = Vector3(hero_mover.ground_position.x, 0, hero_mover.ground_position.y)
		director.advance(delta)
	_present()

func _present() -> void:
	hero.position = Vector3(hero_mover.ground_position.x, 0, hero_mover.ground_position.y)
	hero.pose(gait_time, hero_mover.velocity.length_squared() > 0.000001, hero_mover.facing)
	floor_canvas.feet = []
	if hero_present:
		floor_canvas.feet.append(hero.position)
	for actor in director.actors:
		floor_canvas.feet.append(actor.position)
	floor_canvas.queue_redraw()
	status_label.text = "%s | presents %d/20 | emis %d/%d\nTemps %.1f s | heros %s" % ["PAUSE" if paused else "ACTIF", director.actors.size(), director.spawned, director.budget, director.elapsed, "present" if hero_present else "absent"]

func _toggle_spawning() -> void:
	if paused:
		return
	director.spawning = not director.spawning
	director.spawn_clock = 0.0
	_update_buttons()

func _toggle_hero() -> void:
	if paused:
		return
	hero_present = not hero_present
	hero.visible = hero_present
	director.set_hero(hero if hero_present else null)
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
	position_button.text = "%d/3 %s" % [mode_index + 1, MODES[mode_index]]
	controls[0].text = "Apparitions : %s" % ("oui" if director.spawning else "non")
	controls[1].text = "Retirer heros" if hero_present else "Rendre heros"
	controls[0].disabled = paused
	controls[1].disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			match key_event.keycode:
				KEY_S: _toggle_spawning()
				KEY_H: _toggle_hero()
				KEY_R: _reset_scenario()
				_:
					super._unhandled_key_input(event)
					return
			get_viewport().set_input_as_handled()
