extends "res://scripts/arena/arena.gd"
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const MODES: Array[String] = ["Manuel", "Auto", "Deux acteurs"]
var actors: Array[StatsActor] = []
var executors: Array[Executor] = []
var controls: Array[Button] = []
var readout: Label
var mode_index: int = 0
var selected: int = 0
var auto_clock: float = 0.0
var auto_enabled: bool = false
var setup_complete: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-013 / COUTS"
	$HUD/Description.text = "Essai : 20 energie / cooldown 3 s\nCout et cooldown engages une seule fois"
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	for caption in ["Essai 20", "Base 0", "Acteur : H", "Eloigner", "Auto : non", "Rejouer"]:
		var button := Button.new()
		button.text = caption
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 17)
		hud.add_child(button)
		controls.append(button)
	for index in range(6):
		controls[index].pressed.connect(_command.bind(index))
	readout = Label.new()
	readout.add_theme_font_size_override("font_size", 16)
	readout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(readout)
	setup_complete = true
	_update_layout()
	_reset()

func _update_layout() -> void:
	super._update_layout()
	if not setup_complete:
		return
	var cell: float = (safe_rect.size.x - 64) / 3.0
	for index in range(controls.size()):
		controls[index].position = Vector2(28 + (index % 3) * (cell + 4), 124 + int(index / 3.0) * 48)
		controls[index].size = Vector2(cell, 44)
	readout.position = Vector2(28, 224)

func _reset() -> void:
	for executor in executors:
		executor.retire()
	executors.clear()
	for actor in actors:
		actor.hide()
		actor.queue_free()
	actors.clear()
	var points: Array[Vector2] = [Vector2(0.6, 0.0), Vector2(-0.6, 0.0), Vector2(0.0, -0.6)]
	for index in range(3):
		var actor := StatsActor.new()
		actor.enemy = index > 0
		var profile = (HERO if index == 0 else ENEMY).duplicate()
		profile.max_health = 1000
		actor.configure(profile)
		world.add_child(actor)
		actor.position = Vector3(points[index].x, 0, points[index].y)
		actor.pose(0.0, false, Vector2(1, 1))
		actors.append(actor)
		if index < 2:
			executors.append(Executor.new(actor))
	selected = 0
	auto_clock = 0.0
	auto_enabled = mode_index > 0
	_present()
	_update_buttons()

func _command(index: int) -> void:
	if index == 5:
		_reset()
		return
	if paused or not setup_complete:
		return
	match index:
		0: executors[selected].request(&"paid_test", actors[2], paused)
		1: executors[selected].request(&"basic", actors[2], paused)
		2: selected = 1 - selected
		3:
			actors[2].position = Vector3(0, 0, -0.6) if actors[2].position.z < -1.0 else Vector3(0, 0, -2.6)
		4:
			auto_enabled = not auto_enabled
			auto_clock = 0.0
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete or paused or not is_finite(delta) or delta <= 0.0:
		return
	var dt: float = minf(delta, 1.0 / 30.0)
	for executor in executors:
		executor.advance(dt)
	if auto_enabled:
		auto_clock += dt
		if auto_clock >= 0.1:
			auto_clock = 0.0
			executors[0].request(&"paid_test", actors[2])
			if mode_index == 2:
				executors[1].request(&"paid_test", actors[2])
	_present()

func _present() -> void:
	var lines: PackedStringArray = []
	for index in range(2):
		var executor: Executor = executors[index]
		lines.append("%s E %d/60 | CD %.2f | acceptees %d | cout %d" % ["H" if index == 0 else "A", executor.energy, executor.remaining(&"paid_test"), executor.accepted, executor.spent])
	var current: Executor = executors[selected]
	lines.append("Cible PV %d | #%d %s" % [actors[2].state.health, current.action_id, current.phase])
	lines.append("CD lances %d | %s" % [current.cooldown_starts, current.last_rejection if not current.last_rejection.is_empty() else current.outcome])
	readout.text = "\n".join(lines)
	floor_canvas.feet.clear()
	for actor in actors:
		actor.visible = actor.state.alive
		if actor.visible:
			floor_canvas.feet.append(actor.position)
	floor_canvas.queue_redraw()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % MODES.size()
	_reset()

func _update_buttons() -> void:
	super._update_buttons()
	if not setup_complete:
		return
	position_button.text = "%d/3 %s" % [mode_index + 1, MODES[mode_index]]
	controls[2].text = "Acteur : " + ("H" if selected == 0 else "A")
	controls[3].text = "Rapprocher" if actors.size() == 3 and actors[2].position.z < -1.0 else "Eloigner"
	controls[4].text = "Auto : oui" if auto_enabled else "Auto : non"
	for index in range(5):
		controls[index].disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_A: _command(0)
			KEY_B: _command(1)
			KEY_T: _command(2)
			KEY_E: _command(3)
			KEY_U: _command(4)
			KEY_R: _command(5)
			_:
				super._unhandled_key_input(event)
				return
		get_viewport().set_input_as_handled()
