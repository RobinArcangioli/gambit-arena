extends "res://scripts/arena/arena.gd"
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const AttackAction = preload("res://scripts/combat/attack_action.gd")
const HERO_PROFILE = preload("res://data/actors/hero.tres")
const ENEMY_PROFILE = preload("res://data/actors/enemy.tres")
const MODES: Array[String] = ["Impact", "Hors portee", "Mort cible", "Mort heros", "Retrait cible"]
var actors: Array[StatsActor] = []
var controls: Array[Button] = []
var readout: Label
var action := AttackAction.new()
var selected: int = 1
var mode_index: int = 0
var intervention_done: bool = false
var setup_complete: bool = false
var target_name: String = "-"
var command_status: String = "Pret"

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-011 / IMPACT"
	$HUD/Description.text = "Preparation 0.6 s / recuperation 0.4 s\nPortee 1.0 u / cible verrouillee"
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	for caption in ["Attaquer", "Cible : A", "Eloigner A", "Tuer cible", "Tuer heros", "Rejouer"]:
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
	action.cancel()
	action = AttackAction.new()
	for actor in actors:
		if is_instance_valid(actor):
			actor.hide()
			actor.queue_free()
	actors.clear()
	var points: Array[Vector2] = [Vector2.ZERO, Vector2(0.6, -0.6), Vector2(-0.6, -0.6)]
	for index in range(3):
		var actor := StatsActor.new()
		actor.enemy = index > 0
		actor.configure(HERO_PROFILE if index == 0 else ENEMY_PROFILE)
		world.add_child(actor)
		actor.position = Vector3(points[index].x, 0, points[index].y)
		actor.pose(0.0, false, Vector2(1, 1))
		actors.append(actor)
	selected = 1
	target_name = "-"
	command_status = "Pret"
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
		0:
			var started: int = action.begin(actors[0], actors[selected])
			command_status = "Acceptee" if started > 0 else "Refusee"
			if started > 0:
				target_name = "A" if selected == 1 else "B"
				intervention_done = false
		1: selected = 3 - selected
		2:
			if is_instance_valid(actors[1]):
				actors[1].position = Vector3(2.0, 0, -2.0)
		3:
			if is_instance_valid(actors[selected]):
				actors[selected].state.damage(1000000)
		4: actors[0].state.damage(1000000)
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete or paused:
		return
	if action.active and not intervention_done and mode_index > 0:
		# Split at 0.3 s so even a long frame intervenes before the impact.
		var before: float = maxf(0.0, 0.3 - action.elapsed)
		if delta >= before:
			action.advance(before)
			intervention_done = true
			var victim: int = 1 if target_name == "A" else 2
			match mode_index:
				1: actors[victim].position = Vector3(2, 0, -2)
				2: actors[victim].state.damage(1000000)
				3: actors[0].state.damage(1000000)
				4:
					actors[victim].hide()
					actors[victim].queue_free()
			action.advance(delta - before)
		else:
			action.advance(delta)
	else:
		action.advance(delta)
	_present()

func _present() -> void:
	var hp: PackedStringArray = []
	floor_canvas.feet.clear()
	for index in range(actors.size()):
		var actor = actors[index]
		if not is_instance_valid(actor) or actor.is_queued_for_deletion():
			hp.append("retire")
			continue
		hp.append(str(actor.state.health))
		actor.visible = actor.state.alive
		if actor.visible:
			floor_canvas.feet.append(actor.position)
	readout.text = "PV Heros %s | A %s | B %s\nAction #%d > %s | %s %.2f s\n%s | degats %d | %s" % [hp[0], hp[1], hp[2], action.action_id, target_name, action.phase, action.elapsed, action.outcome, action.applied_damage, command_status]
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
	position_button.text = "%d/5 %s" % [mode_index + 1, MODES[mode_index]]
	controls[1].text = "Cible : " + ("A" if selected == 1 else "B")
	for index in range(5):
		controls[index].disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			match key_event.keycode:
				KEY_A: _command(0)
				KEY_T: _command(1)
				KEY_E: _command(2)
				KEY_K: _command(3)
				KEY_H: _command(4)
				KEY_R: _command(5)
				_:
					super._unhandled_key_input(event)
					return
			get_viewport().set_input_as_handled()
