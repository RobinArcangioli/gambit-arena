extends Node
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const Lab = preload("res://scenes/combat/battle_lab.tscn")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("CombatSimulation: " + message)

func snapshot(sim: Simulation) -> Array:
	var values: Array = [sim.elapsed, sim.spawn_clock, sim.spawned, sim.defeated, sim.hits, sim.result]
	var units: Array[Unit] = [sim.hero]
	units.append_array(sim.enemies)
	for unit in units:
		values.append([unit.position, unit.state.health, unit.gait, unit.action.action_id, unit.action.elapsed, unit.action.phase])
	return values

func run_scenario(sim: Simulation, mode: int, hz: int, max_seconds: int) -> void:
	sim.reset(mode)
	var invariant_ok: bool = true
	var locked_ok: bool = true
	for tick in range(hz * max_seconds):
		var positions: Dictionary = {}
		var units: Array[Unit] = [sim.hero]
		units.append_array(sim.enemies)
		for unit in units:
			if unit.action.active:
				positions[unit.get_instance_id()] = unit.position
		sim.advance(1.0 / float(hz))
		units.assign([sim.hero])
		units.append_array(sim.enemies)
		var points: Array[Vector2] = []
		for unit in units:
			if positions.has(unit.get_instance_id()):
				locked_ok = locked_ok and unit.position == positions[unit.get_instance_id()]
			invariant_ok = invariant_ok and Bounds.contains_ground(unit.mover.ground_position) and unit.state.health >= 0 and unit.state.health <= unit.state.max_health
			if unit.state.alive:
				points.append(unit.mover.ground_position)
		invariant_ok = invariant_ok and Crowd.minimum_distance(points) >= 0.6998
		invariant_ok = invariant_ok and sim.enemies.size() <= 20 and sim.spawned == sim.defeated + sim.removed + sim.enemies.size()
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(sim.result == ("DEFAITE" if mode == 1 else "VICTOIRE"), "scenario termination %d at %d Hz" % [mode, hz])
	check(invariant_ok, "bounds, health, contacts and exact counters")
	check(locked_ok, "actors immobile during committed actions")
	check(sim.max_step <= 0.05001, "bounded movement")
	check(sim.hits > 0 and sim.spawned == sim.budget, "real combat and complete spawn budget")
	if mode != 1:
		check(sim.defeated == sim.budget and sim.hero.state.alive, "victory kills all enemies")
	else:
		check(sim.hero.state.health == 0 and not sim.hero.visible, "defeat hides dead hero")
	var terminal: Array = snapshot(sim)
	for tick in range(120):
		sim.advance(1.0)
	check(snapshot(sim) == terminal, "terminal state has no late movement, spawn or impact")
	check(not sim.hero.action.active, "hero action cancelled on terminal state")
	for unit in sim.enemies:
		check(not unit.action.active, "enemy action cancelled on terminal state")

func _ready() -> void:
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	for hz in [30, 60, 120]:
		await run_scenario(sim, 0, hz, 40)
		await run_scenario(sim, 1, hz, 40)
	await run_scenario(sim, 2, 60, 200)
	check(sim.peak_alive <= 20, "cap across full 20-enemy combat")
	check(HERO.max_health == 100 and HERO.attack == 12 and ENEMY.max_health == 60, "shared profiles unmodified by diagnostic modes")
	sim.reset(0)
	for tick in range(300):
		sim.advance(1.0 / 60.0)
		if sim.hero.action.active:
			break
	check(sim.hero.action.active, "pending action fixture")
	var paused_state: Array = snapshot(sim)
	sim.advance(100.0, true)
	sim.advance(NAN)
	sim.advance(INF)
	sim.advance(-1.0)
	check(snapshot(sim) == paused_state, "pause and invalid delta freeze all systems")
	var before_time: float = sim.elapsed
	sim.advance(100.0)
	check(absf(sim.elapsed - before_time - 1.0 / 30.0) < 0.000001, "large frame bounded common time")
	# Killing a target removes its disk and requires a new living selection.
	sim.reset(0)
	sim.advance(1.0 / 60.0)
	var dead_target = sim.hero.mover.target
	var dead_id: int = dead_target.get_instance_id()
	dead_target.state.damage(1000000)
	sim.advance(1.0 / 60.0)
	check(sim.defeated == 1 and sim.enemies.size() == 2 and dead_target.is_queued_for_deletion(), "dead enemy counted once and queued for cleanup")
	check(Action.living(sim.hero.mover.target) and sim.hero.mover.target.get_instance_id() != dead_id, "automatic retarget after death")
	sim.advance(1.0 / 60.0)
	check(sim.defeated == 1, "no duplicate kill counting")
	await get_tree().process_frame
	check(world.get_child_count() == 3, "dead body removed from scene")
	# Actual source death, pending enemy actions cancelled with no later effects.
	sim.hero.state.damage(1000000)
	sim.advance(1.0 / 60.0)
	check(sim.result == "DEFAITE", "source death stops common simulation")
	var stopped: Array = snapshot(sim)
	sim.advance(10.0)
	check(stopped == snapshot(sim), "no posthumous hits")
	# A removed enemy is not falsely counted as killed.
	sim.reset(0)
	sim.enemies[0].queue_free()
	await get_tree().process_frame
	sim.advance(1.0 / 60.0)
	check(sim.removed == 1 and sim.defeated == 0 and sim.enemies.size() == 2, "freed enemy reference pruned without false kill")
	# Reset while an action is preparing cannot damage new instances.
	sim.reset(0)
	for tick in range(300):
		sim.advance(1.0 / 60.0)
		if sim.hero.action.active:
			break
	var old_action = sim.hero.action
	sim.reset(0)
	old_action.advance(100.0)
	check(not old_action.active and sim.hero.state.health == 250 and sim.enemies[0].state.health == 60, "reset cancels old action")
	for index in range(10):
		sim.reset(0)
		await get_tree().process_frame
	check(world.get_child_count() == 4, "ten resets without actor residues")
	sim.reset(2)
	check(not sim.add_enemy(sim.hero.mover.ground_position) and not sim.add_enemy(Vector2(99, 99)), "occupied and out-of-bounds spawn refused")
	# The real lab inherits explicit resume and preserves pause on replay.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._physics_process(0.02)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	var background: Array = snapshot(lab.simulation)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and snapshot(lab.simulation) == background, "background requires explicit resume")
	lab._reset()
	check(lab.paused and lab.simulation.elapsed == 0.0 and lab.simulation.hero.state.health == 250, "replay keeps pause")
	lab._toggle_pause()
	lab._physics_process(0.02)
	check(lab.simulation.elapsed > 0.0, "explicit resume restarts simulation")
	lab.queue_free()
	sim.clear()
	world.queue_free()
	sim.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-012 / tests combat autonome\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
