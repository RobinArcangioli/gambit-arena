extends "res://scripts/skills/skills_lab.gd"
const GameClock = preload("res://scripts/core/game_clock.gd")
const SCENARIOS: Array[String] = ["Pause libre", "Mort cible", "Mort heros"]
var clock := GameClock.new()

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-015 / PAUSE"
	$HUD/Description.text = "Pause commune / annulation a la mort\nScenarios d'interruption a 0.3 s"
	_update_buttons()

func _reset() -> void:
	clock.reset()
	super._reset()
	# Every scenario starts with full resource, unlike historical STEP-014 mode 1.
	executor.retire()
	executor = Executor.new(actors[0], true, 60)
	executor.bind_clock(clock)
	clock.paused = paused
	_present()
	_update_buttons()

func _command(index: int) -> void:
	if index == 5:
		_reset()
		return
	if paused or not clock.permits_gameplay():
		return
	if index == 3:
		actors[0].state.damage(1000000)
	elif index == 4:
		actors[1].state.damage(1000000)
	else:
		super._command(index)
	_present()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	clock.paused = paused
	var dt: float = clock.step(delta)
	if dt <= 0.0:
		return
	if mode_index > 0 and executor.active and not intervention_done:
		var before: float = maxf(0.0, 0.3 - executor.elapsed)
		if dt >= before:
			executor.advance(before)
			actors[1 if mode_index == 1 else 0].state.damage(1000000)
			intervention_done = true
			executor.advance(dt - before)
		else:
			executor.advance(dt)
	else:
		executor.advance(dt)
	_present()

func _update_buttons() -> void:
	clock.paused = paused
	super._update_buttons()
	if not setup_complete:
		return
	position_button.text = "%d/3 %s" % [mode_index + 1, SCENARIOS[mode_index]]
	controls[3].text = "Mort heros"
	controls[4].text = "Mort cible"
