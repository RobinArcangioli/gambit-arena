extends "res://scripts/arena/arena.gd"
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const MODES: Array[String] = ["Competences", "Ressource vide", "Mort avant effet"]
var actors: Array[StatsActor] = []
var executor: Executor
var controls: Array[Button] = []
var readout: Label
var mode_index: int = 0
var setup_complete: bool = false
var intervention_done: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-014 / SKILLS"
	$HUD/Description.text = "Attaque / soin personnel / frappe speciale\nEnergie : +5/s, plafond 60"
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	for caption in ["Attaque 0", "Soin 20", "Speciale 30", "Blesser 30", "Eloigner", "Rejouer"]:
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
	if executor != null:
		executor.retire()
	for actor in actors:
		actor.hide()
		actor.queue_free()
	actors.clear()
	for index in range(2):
		var actor := StatsActor.new()
		actor.enemy = index == 1
		var profile = (HERO if index == 0 else ENEMY).duplicate()
		if index == 1:
			profile.max_health = 600
		actor.configure(profile)
		world.add_child(actor)
		actor.position = Vector3.ZERO if index == 0 else Vector3(0.6, 0, -0.6)
		actor.pose(0.0, false, Vector2(1, 1))
		actors.append(actor)
	actors[0].state.damage(40)
	executor = Executor.new(actors[0], true, 0 if mode_index == 1 else 60)
	intervention_done = false
	_present()
	_update_buttons()

func _command(index: int) -> void:
	if index == 5:
		_reset()
		return
	if paused or not setup_complete:
		return
	match index:
		0: executor.request(&"basic", actors[1], paused)
		1: executor.request(&"heal", actors[0], paused)
		2: executor.request(&"special", actors[1], paused)
		3: actors[0].state.damage(30)
		4: actors[1].position = Vector3(0.6, 0, -0.6) if actors[1].position.z < -1.0 else Vector3(2, 0, -2)
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete or paused or not is_finite(delta) or delta <= 0.0:
		return
	var dt: float = minf(delta, 1.0 / 30.0)
	if mode_index == 2 and executor.active and not intervention_done:
		var before: float = maxf(0.0, 0.3 - executor.elapsed)
		if dt >= before:
			executor.advance(before)
			actors[0].state.damage(1000000)
			intervention_done = true
			executor.advance(dt - before)
		else:
			executor.advance(dt)
	else:
		executor.advance(dt)
	_present()

func _present() -> void:
	readout.text = "Heros %d/100 PV | Ennemi %d/600\nEnergie %d/60 | depense %d | recupere %d\nCD soin %.1f | speciale %.1f | #%d\n%s | degats %d | soin %d\n%s" % [actors[0].state.health, actors[1].state.health, executor.energy, executor.spent, executor.recovered, executor.remaining(&"heal"), executor.remaining(&"special"), executor.action_id, executor.phase, executor.applied_damage, executor.applied_healing, executor.last_rejection if not executor.last_rejection.is_empty() else executor.outcome]
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
	controls[4].text = "Rapprocher" if actors.size() == 2 and actors[1].position.z < -1.0 else "Eloigner"
	for index in range(5):
		controls[index].disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_A: _command(0)
			KEY_H: _command(1)
			KEY_S: _command(2)
			KEY_D: _command(3)
			KEY_E: _command(4)
			KEY_R: _command(5)
			_:
				super._unhandled_key_input(event)
				return
		get_viewport().set_input_as_handled()
