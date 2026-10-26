extends "res://scripts/arena/arena.gd"
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Marks = preload("res://scripts/crowd/crowd_marks.gd")
const MODES: Array[String] = ["Victoire", "Defaite", "Groupe 20"]
var simulation := Simulation.new()
var rings := Marks.new()
var replay: Button
var readout: Label
var mode_index: int = 0
var setup_complete: bool = false
# Opt-in timing only; historical labs retain their original execution path.
var measure_simulation: bool = false
var last_simulation_usec: int = 0

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-012 / COMBAT"
	$HUD/Description.text = "Ciblage, approche et attaques automatiques\nProfils de test / pas encore de vagues"
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	add_child(simulation)
	simulation.configure(world)
	rings.camera = camera
	add_child(rings)
	move_child(rings, render_box.get_index())
	replay = Button.new()
	replay.text = "Rejouer"
	replay.focus_mode = Control.FOCUS_NONE
	replay.pressed.connect(_reset)
	hud.add_child(replay)
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
	replay.position = Vector2(28, 124)
	replay.size = Vector2(160, 44)
	readout.position = Vector2(28, 180)
	rings.position = render_box.position

func _reset() -> void:
	simulation.reset(mode_index)
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	if measure_simulation:
		var before_usec: int = Time.get_ticks_usec()
		simulation.advance(delta, paused)
		last_simulation_usec = Time.get_ticks_usec() - before_usec
	else:
		simulation.advance(delta, paused)
	_present()

func _present() -> void:
	var fighter = simulation.hero
	var target_text: String = "-"
	if is_instance_valid(fighter.mover.target) and not fighter.mover.target.is_queued_for_deletion():
		target_text = "E%d PV %d" % [fighter.mover.target.serial, fighter.mover.target.state.health]
	readout.text = "%s | %.1f s | Heros %d/%d PV\nEnnemis %d | apparus %d/%d | vaincus %d\nCible %s | %s\nImpacts %d | pas max %.3f u" % [simulation.result, simulation.elapsed, fighter.state.health, fighter.state.max_health, simulation.enemies.size(), simulation.spawned, simulation.budget, simulation.defeated, target_text, fighter.action.phase, simulation.hits, simulation.max_step]
	floor_canvas.feet.clear()
	rings.points.clear()
	if fighter.state.alive:
		floor_canvas.feet.append(fighter.position)
		rings.points.append(fighter.mover.ground_position)
	for unit in simulation.enemies:
		floor_canvas.feet.append(unit.position)
		rings.points.append(unit.mover.ground_position)
	rings.visible = floor_canvas.show_marks
	rings.queue_redraw()
	floor_canvas.queue_redraw()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % MODES.size()
	_reset()

func _update_buttons() -> void:
	simulation.clock.paused = paused
	super._update_buttons()
	if setup_complete:
		position_button.text = "%d/3 %s" % [mode_index + 1, MODES[mode_index]]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reset()
		get_viewport().set_input_as_handled()
	else:
		super._unhandled_key_input(event)
