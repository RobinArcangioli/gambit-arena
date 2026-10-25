extends Node
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const HERO = preload("res://data/actors/hero.tres")
const Lab = preload("res://scenes/waves/wave_sequence_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("WaveSequence: " + message)

func counters(sim: Simulation) -> Array:
	return [sim.elapsed, sim.wave_number, sim.wave.issued, sim.wave.credit, sim.spawned, sim.defeated, sim.removed, sim.enemies.size(), sim.completed_waves.duplicate(true)]

func coherent(sim: Simulation) -> bool:
	var current: Dictionary = sim.wave_snapshot()
	return sim.spawned == sim.defeated + sim.removed + sim.enemies.size() and current.spawned == current.defeated + current.removed + current.alive and sim.spawned == (sim.wave_number - 1) * sim.wave.total + sim.wave.issued and sim.enemies.size() <= sim.wave.cap

func _ready() -> void:
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.wave_enabled = true
	sim.sequence_enabled = true
	sim.manual_enabled = true
	sim.controller.rules = Controller.standard_rules()
	for rule in sim.controller.rules:
		rule.enabled = false
	for hz in [30, 60, 120]:
		sim.reset()
		var original_hero = sim.hero
		var original_action = sim.hero.action
		sim.hero.state.damage(10)
		var identities: Dictionary = {}
		var valid: bool = true
		var transitions: int = 0
		for tick in range(hz * 70):
			for actor in sim.enemies:
				identities[actor.serial] = true
				actor.state.damage(1000000)
			var previous_wave: int = sim.wave_number
			var previous_spawned: int = sim.spawned
			sim.advance(1.0 / float(hz))
			valid = valid and coherent(sim) and sim.spawned - previous_spawned <= 1
			if sim.wave_number != previous_wave:
				transitions += 1
				check(sim.wave.issued == 0 and sim.result == "EN COURS" and not sim.clock.stopped, "transition is not victory / %d Hz" % hz)
				check(sim.hero == original_hero and sim.hero.action == original_action and sim.hero.state.health == 240, "hero and executor preserved without healing")
				check(sim.completed_waves.size() == transitions and sim.completed_waves[-1].defeated == 12, "one exact completed-wave record")
				sim.clock.paused = true
				var frozen: Array = counters(sim)
				for repeat in range(10):
					sim.advance(100)
				check(counters(sim) == frozen, "pause freezes the transition and all counters")
				sim.clock.paused = false
			if sim.result != "EN COURS":
				break
			if tick % 120 == 0:
				await get_tree().process_frame
		check(valid and transitions == 2 and sim.result == "VICTOIRE", "three waves complete with coherent ledgers / %d Hz" % hz)
		check(sim.spawned == 36 and sim.defeated == 36 and identities.size() == 36 and sim.completed_waves.size() == 3, "36 unique serials and exactly 36 kills")
		var terminal: Array = counters(sim)
		sim.advance(10)
		check(counters(sim) == terminal and not sim.request_manual(&"heal"), "terminal has no fourth wave or commands")
		await get_tree().process_frame
	# The final kill and hero death in the same tick must favor defeat.
	sim.reset()
	sim.wave.reset(1, 1)
	sim.budget = 3
	sim.add_enemy(Vector2(2.5, 0))
	sim.enemies[0].state.damage(10000)
	sim.hero.state.damage(10000)
	sim.advance(0.02)
	check(sim.result == "DEFAITE" and sim.wave_number == 1 and sim.completed_waves.is_empty(), "simultaneous hero death cannot advance wave")
	sim.reset()
	sim.wave.reset(1, 1)
	sim.budget = 3
	sim.add_enemy(Vector2(2.5, 0))
	sim.enemies[0].queue_free()
	sim.advance(0.02)
	check(sim.result == "INTERROMPU" and sim.removed == 1 and sim.defeated == 0 and sim.wave_number == 1, "removed actor is not a kill or a completed wave")
	# Transition keeps a committed heal and its cost/cooldown; no fresh executor.
	sim.reset()
	sim.wave.reset(1, 1)
	sim.budget = 3
	sim.hero.state.damage(50)
	check(sim.hero.action.request(&"heal", sim.hero) > 0, "heal engaged before transition")
	var executor = sim.hero.action
	sim.add_enemy(Vector2(2.5, 0))
	sim.enemies[0].state.damage(10000)
	sim.advance(0.02)
	check(sim.wave_number == 2 and sim.hero.action == executor and executor.active and executor.spent == 20 and executor.remaining(&"heal") > 3.9, "transition preserves active heal, cost and cooldown")
	for tick in range(35):
		sim.advance(0.02)
	check(sim.hero.state.health == 230 and executor.spent == 20 and executor.accepted == 1, "preserved heal applies once across transition")
	# Real combat, durable fixture separates sequencing from unfinished balance.
	sim.controller.rules = Controller.standard_rules()
	sim.reset()
	var durable = HERO.duplicate()
	durable.max_health = 1000000
	durable.attack = 30
	sim.hero.configure(durable)
	var real_coherent: bool = true
	for tick in range(60 * 360):
		sim.advance(1.0 / 60.0)
		real_coherent = real_coherent and coherent(sim)
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(real_coherent and sim.result == "VICTOIRE" and sim.defeated == 36 and sim.hits > 0, "real gambit combat completes three waves")
	sim.clock.paused = true
	sim.reset()
	await get_tree().process_frame
	check(sim.wave_number == 1 and sim.completed_waves.is_empty() and sim.spawned == 0 and sim.defeated == 0 and sim.clock.paused and world.get_child_count() == 1, "replay clears sequence and preserves pause")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	check(lab.simulation.budget == 36 and lab.simulation.wave_count == 3 and lab.simulation.manual_enabled, "main lab enables three waves and manual commands")
	lab.paused = false
	lab._update_buttons()
	lab._next_placement()
	check(lab.simulation.hero.state.health == 40 and lab.simulation.budget == 36, "wounded diagnostic preserved")
	lab._next_placement()
	check(lab.simulation.budget == 72 and lab.simulation.wave.cap == 20, "stress diagnostic has three waves of 24, cap twenty")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-025 / trois vagues\n%s : %d controles, %d echecs\nTransitions et compteurs exacts. F8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	add_child(label)
