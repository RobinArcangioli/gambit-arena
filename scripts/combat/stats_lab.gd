extends "res://scripts/arena/arena.gd"
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const HERO_PROFILE = preload("res://data/actors/hero.tres")
const ENEMY_PROFILE = preload("res://data/actors/enemy.tres")
const NAMES: Array[String] = ["Heros", "Ennemi A", "Ennemi B"]
var actors: Array[StatsActor] = []
var controls: Array[Button] = []
var readout: Label
var selected: int = 0
var setup_complete: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-010 / PV"
	$HUD/Description.text = "Deux ennemis, un profil partage
PV et statistiques propres a chacun"
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	for caption in ["Degats 15", "Soin 10", "ATQ +5", "Fatal", "Rejouer"]:
		var button := Button.new()
		button.text = caption
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_size_override("font_size", 17)
		hud.add_child(button)
		controls.append(button)
	for index in range(4):
		controls[index].pressed.connect(_apply.bind(index))
	controls[4].pressed.connect(_reset)
	readout = Label.new()
	readout.add_theme_font_size_override("font_size", 17)
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
	for actor in actors:
		actor.hide()
		actor.queue_free()
	actors.clear()
	var points: Array[Vector2] = [Vector2(-1.5, 1.5), Vector2.ZERO, Vector2(1.5, -1.5)]
	for index in range(3):
		var actor := StatsActor.new()
		actor.enemy = index > 0
		actor.configure(HERO_PROFILE if index == 0 else ENEMY_PROFILE)
		world.add_child(actor)
		actor.position = Vector3(points[index].x, 0, points[index].y)
		actor.pose(0.0, false, Vector2(1, 1))
		actors.append(actor)
	selected = 0
	_present()
	_update_buttons()

func _apply(action: int) -> void:
	if paused or not setup_complete:
		return
	var state = actors[selected].state
	match action:
		0: state.damage(15)
		1: state.heal(10)
		2: state.set_attack(state.attack + 5)
		3: state.damage(state.max_health)
	_present()

func _present() -> void:
	var lines: PackedStringArray = []
	floor_canvas.feet.clear()
	for index in range(actors.size()):
		var actor = actors[index]
		var state = actor.state
		lines.append("%s%s : PV %d/%d | ATQ %d DEF %d%s" % ["> " if index == selected else "  ", NAMES[index], state.health, state.max_health, state.attack, state.defense, " / MORT" if not state.alive else ""])
		actor.visible = state.alive
		if state.alive:
			floor_canvas.feet.append(actor.position)
	readout.text = "\n".join(lines)
	floor_canvas.queue_redraw()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	selected = (selected + 1) % actors.size()
	_present()
	_update_buttons()

func _update_buttons() -> void:
	super._update_buttons()
	if not setup_complete:
		return
	position_button.text = "Cible : " + NAMES[selected]
	for index in range(4):
		controls[index].disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo:
			match key_event.keycode:
				KEY_D: _apply(0)
				KEY_H: _apply(1)
				KEY_T: _apply(2)
				KEY_K: _apply(3)
				KEY_R: _reset()
				_:
					super._unhandled_key_input(event)
					return
			get_viewport().set_input_as_handled()
