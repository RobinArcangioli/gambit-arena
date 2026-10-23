extends Node
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const Lab = preload("res://scenes/gambits/gambit_battle_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("GambitController: " + message)

func unit(profile: Resource, at: Vector2, clock: Clock) -> Unit:
	var actor := Unit.new()
	actor.configure(profile)
	add_child(actor)
	actor.place(at)
	actor.action.bind_clock(clock)
	return actor

func dispose(actor: Unit) -> void:
	actor.action.retire()
	actor.free()

func snapshot(sim: Simulation) -> Array:
	var values: Array = [sim.elapsed, sim.spawn_clock, sim.spawned, sim.defeated, sim.hits, sim.result, sim.controller.evaluations, sim.controller.launched, sim.controller.decision]
	var actors: Array[Unit] = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		values.append([actor.position, actor.state.health, actor.gait, actor.action.action_id, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return values

func full_combat(sim: Simulation, mode: int, hz: int, seconds: int) -> void:
	sim.controller.rules = Controller.standard_rules()
	sim.reset(mode)
	var invariants: bool = true
	var locked: bool = true
	for tick in range(hz * seconds):
		var positions: Dictionary = {}
		var actors: Array[Unit] = [sim.hero]
		actors.append_array(sim.enemies)
		for actor in actors:
			if actor.action.active:
				positions[actor.combat_id] = actor.position
		sim.advance(1.0 / float(hz))
		actors.assign([sim.hero])
		actors.append_array(sim.enemies)
		var points: Array[Vector2] = []
		for actor in actors:
			if positions.has(actor.combat_id):
				locked = locked and positions[actor.combat_id] == actor.position
			invariants = invariants and Bounds.contains_ground(actor.mover.ground_position) and actor.state.health >= 0 and actor.state.health <= actor.state.max_health
			if actor.state.alive:
				points.append(actor.mover.ground_position)
		invariants = invariants and Crowd.minimum_distance(points) >= 0.6998 and sim.enemies.size() <= 20
		invariants = invariants and sim.hero.action.accepted == sim.controller.launched
		invariants = invariants and sim.hero.action.spent == 20 * sim.controller.heal_starts + 30 * sim.controller.special_starts
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(sim.result == "VICTOIRE" and sim.defeated == sim.budget, "gambit victory mode %d at %d Hz" % [mode, hz])
	check(invariants and locked and sim.max_step <= 0.05001, "contacts, costs, bounds and committed-action lock")
	check(sim.controller.special_starts > 0 and sim.controller.basic_starts > 0, "special and free fallback really executed")
	var terminal: Array = snapshot(sim)
	sim.advance(100.0)
	check(snapshot(sim) == terminal and sim.controller.decision.is_empty(), "terminal has no pending intention or late changes")

func _ready() -> void:
	var clock := Clock.new()
	var hero := unit(HERO, Vector2.ZERO, clock)
	var enemy := unit(ENEMY, Vector2(0.8, 0), clock)
	var enemies: Array[Unit] = [enemy]
	var pilot := Controller.new()
	pilot.rules = Controller.standard_rules()
	hero.state.damage(60)
	pilot.plan(1.0 / 60.0, hero, enemies, clock)
	check(pilot.decision["skill"] == "heal" and hero.action.accepted == 0 and hero.action.energy == 60 and hero.state.health == 40, "planning has no skill effect or cost")
	check(hero.mover.target == null, "self heal supplies no movement target")
	var id: int = pilot.execute(hero, enemies, clock)
	check(id > 0 and hero.action.energy == 40 and pilot.heal_starts == 1, "intention commits through executor once")
	for repeat in range(50):
		pilot.plan(1.0 / 60.0, hero, enemies, clock)
		pilot.execute(hero, enemies, clock)
	check(hero.action.action_id == id and hero.action.spent == 20 and hero.action.accepted == 1, "busy action never relaunched")
	hero.action.advance(0.6)
	check(hero.state.health == 70 and hero.action.applied_healing == 30, "real heal from intention")
	check(not hero.action.try_impact(id), "executor still rejects duplicate effect")
	hero.action.advance(0.4)
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision["skill"] == "special", "next available rule after heal")
	id = pilot.execute(hero, enemies, clock)
	check(id > 0 and hero.action.spent == 50 and pilot.special_starts == 1, "special committed with exact total cost")
	hero.action.advance(0.6)
	check(enemy.state.health == 37, "real special damage")
	hero.action.advance(0.4)
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision["skill"] == "basic", "cooldowns select free fallback")
	id = pilot.execute(hero, enemies, clock)
	hero.action.advance(1.0)
	check(id > 0 and enemy.state.health == 26 and hero.action.spent == 50, "real basic and no added cost")
	pilot.stop(hero)
	dispose(hero)
	dispose(enemy)
	# Approach is supplied only by a chosen gambit; no spend before reaching range.
	hero = unit(HERO, Vector2.ZERO, clock)
	enemy = unit(ENEMY, Vector2(2, 0), clock)
	enemies.assign([enemy])
	pilot.reset()
	pilot.rules = Controller.standard_rules()
	pilot.plan(0.01, hero, enemies, clock)
	check(hero.mover.target == enemy and pilot.execute(hero, enemies, clock) == 0 and hero.action.spent == 0, "far target starts approach without paying")
	var captured = Controller.capture(hero, enemies, clock)
	captured.source["health"] = 0
	captured.enemies[0]["health"] = 0
	check(hero.state.health == 100 and enemy.state.health == 60, "adapter copies runtime values")
	var exported: Dictionary = pilot.decision
	exported["skill"] = "heal"
	check(pilot.decision["skill"] == "special", "decision getter cannot redirect internal plan")
	# Revalidate availability and conditions after planning, before commitment.
	enemy.place(Vector2(0.8, 0))
	pilot.rules[1].enabled = false
	check(pilot.execute(hero, enemies, clock) == 0 and hero.action.spent == 0, "edited pending rule invalidates plan")
	pilot.plan(0.01, hero, enemies, clock)
	check(pilot.decision["skill"] == "basic", "fresh plan uses changed rules")
	clock.paused = true
	var read_count: int = pilot.evaluations
	pilot.plan(10.0, hero, enemies, clock)
	check(pilot.execute(hero, enemies, clock) == 0 and pilot.evaluations == read_count, "pause gates plan and commit")
	clock.paused = false
	enemy.configure(ENEMY)
	check(pilot.execute(hero, enemies, clock) == 0, "replaced target state cannot consume stale intention")
	pilot.plan(0.01, hero, enemies, clock)
	enemy.queue_free()
	check(pilot.execute(hero, enemies, clock) == 0 and hero.action.accepted == 0, "queued target cannot receive commitment")
	await get_tree().process_frame
	pilot.plan(0.01, hero, enemies, clock)
	check(hero.mover.target == null and pilot.decision["kind"] == "none", "freed target leaves no movement")
	enemies.clear()
	# A valid heal can become useless between planning and engagement.
	hero.state.damage(60)
	pilot.plan(0.1, hero, enemies, clock)
	hero.state.heal(100)
	check(pilot.execute(hero, enemies, clock) == 0 and hero.action.spent == 0, "current health revalidated before heal")
	hero.state.damage(60)
	pilot.plan(0.01, hero, enemies, clock)
	hero.configure(HERO)
	check(pilot.execute(hero, enemies, clock) == 0, "replaced source state invalidates plan")
	hero.state.damage(60)
	pilot.plan(0.01, hero, enemies, clock)
	hero.action.retire()
	hero.action = Executor.new(hero, true, 0)
	hero.action.bind_clock(clock)
	check(pilot.execute(hero, enemies, clock) == 0 and hero.action.accepted == 0, "current resource revalidated before commitment")
	pilot.stop(hero)
	dispose(hero)
	# Stable IDs, independent of array order, and no identity reuse after reset.
	hero = unit(HERO, Vector2.ZERO, clock)
	var left := unit(ENEMY, Vector2(-0.8, 0), clock)
	var right := unit(ENEMY, Vector2(0.8, 0), clock)
	enemies.assign([right, left])
	pilot.reset()
	pilot.rules = Controller.standard_rules()
	pilot.plan(0.01, hero, enemies, clock)
	check(hero.mover.target == left and pilot.decision["target_id"] == left.combat_id, "stable ID wins equal distances")
	var retained_id: int = hero.combat_id
	# Changing priorities during an engaged special does not interrupt it.
	id = pilot.execute(hero, enemies, clock)
	pilot.rules[1].enabled = false
	pilot.plan(0.2, hero, enemies, clock)
	check(hero.action.active and hero.action.action_id == id and pilot.execute(hero, enemies, clock) == 0, "rule edit preserves committed action")
	left.state.damage(1000000)
	check(not hero.action.active, "target death still cancels executor")
	pilot.plan(0.01, hero, enemies, clock)
	check(hero.mover.target == right, "dead target retargeted at next simulation tick")
	pilot.stop(hero)
	dispose(hero)
	dispose(left)
	dispose(right)
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.controller.rules = Controller.standard_rules()
	for rule in sim.controller.rules:
		rule.enabled = false
	sim.reset(0)
	check(sim.hero.combat_id > retained_id, "new combat has fresh identities")
	for tick in range(120):
		sim.advance(1.0 / 60.0)
	check(sim.hero.position == Vector3.ZERO and sim.hero.action.accepted == 0 and sim.controller.launched == 0, "disabled gambits have no legacy movement or attack fallback")
	check(sim.controller.evaluations == 20, "idle planning at 10 Hz")
	for tick in range(3600):
		sim.advance(1.0 / 60.0)
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(sim.result == "DEFAITE" and sim.hero.action.accepted == 0, "enemy AI remains autonomous without hero rules")
	sim.reset(0)
	check(not sim.controller.rules[0].enabled and not sim.controller.rules[1].enabled and not sim.controller.rules[2].enabled, "replay preserves configured rules")
	for hz in [30, 60, 120]:
		await full_combat(sim, 0, hz, 40)
	await full_combat(sim, 2, 60, 240)
	sim.controller.rules = Controller.standard_rules()
	sim.reset(1)
	sim.hero.state.damage(60)
	sim.advance(1.0 / 60.0)
	check(sim.hero.action.last_skill == &"heal" and sim.controller.heal_starts == 1, "real coordinator prioritizes injured self")
	var frozen: Array = snapshot(sim)
	sim.clock.paused = true
	sim.advance(100.0)
	check(snapshot(sim) == frozen, "shared pause freezes entire gambit combat")
	var old_executor = sim.hero.action
	var old_id: int = sim.hero.combat_id
	sim.reset(1)
	old_executor.advance(100.0)
	check(sim.clock.paused and not old_executor.active and sim.hero.combat_id != old_id and sim.controller.decision.is_empty(), "paused reset invalidates old action and intentions")
	sim.clock.paused = false
	for repeat in range(10):
		sim.reset(0)
		await get_tree().process_frame
	check(world.get_child_count() == 4, "ten combat resets without residues")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._update_buttons()
	lab._next_placement()
	lab._physics_process(0.02)
	check(lab.mode_index == 1 and lab.simulation.hero.action.last_skill == &"heal", "real lab heal scenario")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	frozen = snapshot(lab.simulation)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and snapshot(lab.simulation) == frozen, "background requires explicit resume")
	lab._reset()
	check(lab.paused and lab.simulation.controller.launched == 0, "lab replay keeps pause")
	lab._toggle_pause()
	lab._next_placement()
	lab._next_placement()
	lab._physics_process(0.02)
	check(lab.mode_index == 3 and lab.simulation.hero.action.accepted == 0, "fourth scenario disables all hero gambits")
	lab.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-017 / tests pilotage gambits\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
