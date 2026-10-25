extends Node
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const Lab = preload("res://scenes/waves/run_lifecycle_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("RunLifecycle: " + message)

func rule_values(rules: Array) -> Array:
	var values: Array = []
	for rule in rules:
		values.append([rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill])
	return values

func frozen_state(sim: Simulation) -> Array:
	var values: Array = [sim.elapsed, sim.wave_number, sim.wave.issued, sim.wave.credit, sim.spawned, sim.defeated, sim.removed, sim.hits, sim.final_report, sim.terminal_count, sim.manual.snapshot(), sim.controller.trace.total]
	var actors: Array[Unit] = [sim.hero]
	actors.append_array(sim.enemies)
	for unit in actors:
		values.append([unit.position, unit.gait, unit.state.health, unit.action.energy, unit.action.remaining(&"special"), unit.action.active, unit.action.elapsed])
	return values

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func click(at: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = at
		event.global_position = at
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = down
		event.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
		get_viewport().push_input(event, true)

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
	sim.controller.rules[0].threshold = 37
	var configured: Array = rule_values(sim.controller.rules)
	sim.reset()
	# Ten consecutive real resets on the same coordinator, alternating active/terminal/paused.
	for cycle in range(10):
		sim.clock.paused = false
		check(sim.add_enemy(Vector2(0.8, 0)) and sim.add_enemy(Vector2(-0.8, 0)), "fixture actors admitted / %d" % cycle)
		var old_hero = sim.hero
		var old_state = old_hero.state
		var old_executor = old_hero.action
		var old_enemy = sim.enemies[0]
		var enemy_state = old_enemy.state
		var enemy_executor = sim.enemies[1].action
		var references: Array[WeakRef] = [weakref(old_hero)]
		for unit in sim.enemies:
			references.append(weakref(unit))
		sim.controller.plan(0.1, sim.hero, sim.enemies, sim.clock)
		sim.hero.remember_enemy(old_enemy)
		var old_action_id: int = old_executor.request(&"special", old_enemy)
		check(old_action_id > 0 and enemy_executor.begin(sim.enemies[1], old_hero) > 0, "both sides have committed actions")
		old_executor.advance(0.65 if cycle % 3 == 1 else 0.2)
		check(sim.request_manual(&"heal") and sim.manual.pending, "manual command pending behind active attack")
		var keep_pause: bool = cycle % 2 == 0
		sim.clock.paused = keep_pause
		if cycle % 3 != 1:
			old_state.damage(1000000)
			sim.advance(1.0 / 60.0, keep_pause)
			check(sim.result == "DEFAITE" and sim.clock.stopped and sim.terminal_count == 1 and not sim.manual.pending, "defeat committed once, even while paused")
			check(not old_executor.active and not enemy_executor.active and sim.hero.mover.target == null, "terminal retires actions and movement")
			var frozen: Array = frozen_state(sim)
			for repeat in range(30):
				sim.advance(100)
				old_executor.advance(100)
				enemy_executor.advance(100)
			check(frozen_state(sim) == frozen and not sim.request_manual(&"heal") and not sim.add_enemy(Vector2(2, 0)), "terminal blocks effects, time, commands and arrivals")
			var external_report: Dictionary = sim.final_report
			external_report["defeated"] = 99999
			check(sim.final_report.defeated != 99999, "final report is an isolated copy")
		var previous_run: int = sim.run_id
		sim.reset()
		check(sim.run_id == previous_run + 1 and sim.result == "EN COURS" and not sim.clock.stopped and sim.clock.paused == keep_pause, "one reset creates one run, preserving pause")
		check(sim.hero != old_hero and sim.hero.state != old_state and sim.hero.action != old_executor, "fresh hero, state and executor")
		check(sim.hero.state.health == 250 and sim.hero.action.energy == 60 and sim.hero.action.remaining(&"special") == 0 and sim.hero.action.spent == 0 and sim.hero.action.accepted == 0, "fresh health, resource, cooldown and action counters")
		check(sim.elapsed == 0 and sim.spawned == 0 and sim.defeated == 0 and sim.removed == 0 and sim.hits == 0 and sim.peak_alive == 0 and sim.max_step == 0, "all combat counters cleared")
		check(sim.wave_number == 1 and sim.wave.issued == 0 and sim.wave.credit == 0 and sim.completed_waves.is_empty() and sim.final_report.is_empty() and sim.terminal_count == 0, "wave and final report cleared")
		check(sim.manual.snapshot().is_empty() and sim.manual.submitted == 0 and sim.manual.launched == 0 and sim.manual.expired == 0 and sim.manual.last_action_id == 0, "manual queue and diagnostics cleared")
		check(sim.controller.decision.is_empty() and sim.controller.explanation.is_empty() and sim.controller.trace.size() == 0 and sim.controller.trace.total == 0 and sim.controller.evaluations == 0 and sim.controller.launched == 0, "intent and bounded trace cleared")
		check(rule_values(sim.controller.rules) == configured and sim.hero.focused_enemy(sim.enemies) == null, "gambits preserved, offensive focus cleared")
		check(old_state.died.get_connections().is_empty() and enemy_state.died.get_connections().is_empty(), "old state subscriptions disconnected")
		check(old_hero.mover.target == null and old_hero.focused_enemy(sim.enemies) == null and not old_executor.active and not enemy_executor.active, "queued actors have no action or target residues")
		var fresh_health: int = sim.hero.state.health
		old_executor.advance(100)
		enemy_executor.advance(100)
		check(not old_executor.try_impact(old_action_id) and old_executor.request(&"heal", sim.hero) == 0 and sim.hero.state.health == fresh_health, "retained old executor cannot affect new run")
		await settle()
		var gone: bool = true
		for reference in references:
			gone = gone and reference.get_ref() == null
		check(gone and world.get_child_count() == 1 and sim.enemies.is_empty(), "all old nodes freed, exactly one fresh hero / %d" % cycle)
	# Fresh timing after the tenth replay, without spawning from an old due timer.
	sim.clock.paused = false
	for tick in range(59):
		sim.advance(1.0 / 60.0)
	check(sim.spawned == 0, "no residual arrival before one second")
	sim.advance(1.0 / 60.0)
	check(sim.spawned == 1 and sim.wave.issued == 1, "exactly one fresh arrival after ten replays")
	# Natural enemy impact, not injected lethal damage: result includes the final hit.
	sim.reset()
	sim.add_enemy(Vector2(0.8, 0))
	sim.hero.state.damage(sim.hero.state.health - 1)
	for tick in range(90):
		sim.advance(1.0 / 60.0)
		if sim.result != "EN COURS":
			break
	check(sim.result == "DEFAITE" and sim.hits == 1 and sim.final_report.hits == 1 and sim.terminal_count == 1, "lethal enemy action produces one accurate frozen report")
	# Three complete real schedules; the report is also correct on victory.
	sim.reset()
	for tick in range(60 * 70):
		for unit in sim.enemies:
			unit.state.damage(1000000)
		sim.advance(1.0 / 60.0)
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(sim.result == "VICTOIRE" and sim.final_report.completed == 3 and sim.final_report.defeated == 36 and sim.final_report.alive == 0 and sim.terminal_count == 1, "victory report accounts for all three waves")
	# A full twenty-enemy stress run is also torn down, not only the two-actor fixture.
	sim.reset(2)
	for x in range(-3, 4):
		for y in range(-3, 4):
			if sim.spawned < 20:
				sim.add_enemy(Vector2(x, y))
	check(sim.enemies.size() == 20, "stress fixture reaches global actor cap")
	sim.reset(2)
	await settle()
	check(world.get_child_count() == 1 and sim.budget == 72 and sim.enemies.is_empty(), "full stress replay clears twenty actors and retains scenario")
	# Disposing the coordinator must retire actors even when their world outlives it.
	sim.add_enemy(Pattern.spawn_position(0))
	var detached_executor = sim.hero.action
	sim.queue_free()
	await settle()
	check(world.get_child_count() == 0 and not detached_executor.active, "coordinator exit cleans independently owned actor world")
	world.queue_free()
	# Exercise the real replay button and customized editor in the new main lab.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await settle()
	lab.editor.toggle(1)
	lab.editor.move(2, -1)
	lab.editor.update_fields(0, {"target": "self", "condition": "hp_below", "threshold": 43, "skill": "heal"})
	var ui_rules: Array = rule_values(lab.editor.snapshot())
	get_viewport().notify_mouse_entered()
	for cycle in range(10):
		lab.paused = cycle % 2 == 0
		lab._update_buttons()
		lab.simulation.hero.state.damage(1000000)
		lab._physics_process(0.02)
		check(lab.simulation.result == "DEFAITE" and lab.get_node("HUD/Description").text == "DEFAITE", "defeat remains visible even when paused")
		var before: int = lab.simulation.run_id
		var previous_pause: bool = lab.paused
		click(lab.replay.get_global_rect().get_center())
		await settle()
		check(lab.simulation.run_id == before + 1 and lab.simulation.final_report.is_empty() and lab.simulation.result == "EN COURS", "one actual replay click starts exactly one run / %d" % cycle)
		check(lab.paused == previous_pause and lab.simulation.clock.paused == previous_pause and rule_values(lab.editor.snapshot()) == ui_rules and rule_values(lab.simulation.controller.rules) == ui_rules, "UI replay keeps edited fields, order, enable flags and pause")
		var actor_count: int = 0
		for child in lab.world.get_children():
			if child is Unit:
				actor_count += 1
		check(actor_count == 1 and not lab.simulation.manual.pending and lab.simulation.controller.trace.size() == 0, "real UI replay has no duplicate actors, queue or trace")
	lab.queue_free()
	await settle()
	var summary_text: String = "STEP-026 / defaite et redemarrages\n%s : %d controles, %d echecs\n10 resets simulation + 10 clics Rejouer.\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	add_child(label)
