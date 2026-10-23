extends "res://scripts/combat/battle_lab.gd"
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const SCENARIOS: Array[String] = ["Combat", "Soin", "Groupe 20", "Sans regle"]

func _ready() -> void:
	simulation.controller.rules = Controller.standard_rules()
	super._ready()
	$HUD/Title.text = "STEP-017 / PILOTAGE"
	$HUD/Description.text = "Soin si PV < 50%, speciale, puis attaque\nLe heros suit uniquement les gambits"
	_update_buttons()

func _reset() -> void:
	# Replay keeps the current rule configuration. Scenario changes load a preset.
	simulation.reset(0 if mode_index == 3 else mode_index)
	if mode_index == 1:
		simulation.hero.state.damage(60)
	_present()
	_update_buttons()

func _present() -> void:
	super._present()
	var fighter = simulation.hero
	var pilot = simulation.controller
	var intent: Dictionary = pilot.decision
	var target_text: String = "-"
	if intent.get("kind", "none") == "intent":
		target_text = "R%d %s -> #%d" % [intent["rule_index"] + 1, intent["skill"], intent["target_id"]]
	readout.text = "%s | %.1f s | PV %d/%d\nEnnemis %d | apparus %d/%d | vaincus %d\nEnergie %d | CD soin %.1f / spec %.1f\n%s | %s\nLances A%d H%d S%d | lectures %d\nDepense %d | impacts %d" % [simulation.result, simulation.elapsed, fighter.state.health, fighter.state.max_health, simulation.enemies.size(), simulation.spawned, simulation.budget, simulation.defeated, fighter.action.energy, fighter.action.remaining(&"heal"), fighter.action.remaining(&"special"), target_text, fighter.action.phase, pilot.basic_starts, pilot.heal_starts, pilot.special_starts, pilot.evaluations, fighter.action.spent, simulation.hits]

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % SCENARIOS.size()
	simulation.controller.rules = Controller.standard_rules()
	if mode_index == 3:
		for rule in simulation.controller.rules:
			rule.enabled = false
	_reset()

func _update_buttons() -> void:
	simulation.clock.paused = paused
	pause_button.text = "Reprendre" if paused else "Pause"
	position_button.disabled = paused
	marks_button.text = "Reperes : oui" if floor_canvas.show_marks else "Reperes : non"
	if setup_complete:
		position_button.text = "%d/4 %s" % [mode_index + 1, SCENARIOS[mode_index]]
