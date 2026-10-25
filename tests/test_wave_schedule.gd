extends Node
const Schedule = preload("res://scripts/waves/wave_schedule.gd")
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const HERO = preload("res://data/actors/hero.tres")
const Lab = preload("res://scenes/waves/wave_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("WaveSchedule: " + message)

func freeze_enemies(sim: Simulation) -> void:
	for actor in sim.enemies:
		actor.action.retire()
		actor.mover.speed = 0.0

func disable_rules(sim: Simulation) -> void:
	sim.controller.rules = Controller.standard_rules()
	for rule in sim.controller.rules:
		rule.enabled = false

func state(sim: Simulation) -> Array:
	return [sim.elapsed, sim.spawned, sim.defeated, sim.removed, sim.result, sim.enemies.size(), sim.hero.state.health, sim.wave.issued, sim.wave.credit, sim.manual.snapshot()]

func _ready() -> void:
	var schedule := Schedule.new()
	schedule.reset(-10, 200)
	check(schedule.total == 1 and schedule.cap == 20, "configuration bounded")
	for hz in [30, 60, 120]:
		schedule.reset()
		var arrivals: Array[float] = []
		for tick in range(hz * 30):
			if schedule.advance(1.0 / float(hz), 0):
				arrivals.append(float(tick + 1) / float(hz))
				schedule.confirm_spawn()
		check(arrivals.size() == 12 and is_equal_approx(arrivals[0], 1.0), "twelve arrivals, first at one game second / %d Hz" % hz)
		check(is_equal_approx(arrivals[3], 7.0) and is_equal_approx(arrivals[7], 13.0) and is_equal_approx(arrivals[11], 17.0), "progressive cadence 2 / 1.5 / 1 seconds / %d Hz" % hz)
		check(not schedule.advance(100.0, 0) and schedule.issued == 12, "no arrivals beyond budget")
	schedule.reset(24, 20)
	check(not schedule.advance(NAN, 0) and not schedule.advance(-1, 0) and schedule.credit == 0, "invalid time rejected")
	check(not schedule.advance(100, 20) and schedule.credit == 1.0 and schedule.issued == 0, "cap holds one due arrival, no consumed budget")
	check(schedule.advance(0.01, 19), "one released slot allows pending arrival")
	# A blocked position is not confirmed: retry preserves budget and bounded credit.
	for repeat in range(100):
		schedule.advance(1, 19)
	check(schedule.issued == 0 and schedule.credit == 1.0, "blocked arrival remains bounded and unpaid")
	schedule.confirm_spawn()
	check(not schedule.advance(0.01, 0) and schedule.issued == 1, "successful retry clears backlog")
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.wave_enabled = true
	sim.manual_enabled = true
	disable_rules(sim)
	sim.reset(0)
	check(sim.enemies.is_empty() and sim.result == "EN COURS" and sim.budget == 12, "empty arena before first arrival is not victory")
	for tick in range(59):
		sim.advance(1.0 / 60.0)
	check(sim.spawned == 0, "no premature arrival")
	sim.advance(1.0 / 60.0)
	check(sim.spawned == 1 and sim.wave.issued == 1 and sim.enemies[0].mover.ground_position == Pattern.spawn_position(0), "first arrival on edge, no movement in birth tick")
	check(not sim.add_enemy(sim.enemies[0].mover.ground_position) and sim.wave.issued == 1 and sim.spawned == 1, "occupied spawn point does not consume wave budget")
	freeze_enemies(sim)
	sim.enemies[0].state.damage(1000000)
	sim.advance(1.0 / 60.0)
	check(sim.result == "EN COURS" and sim.defeated == 1 and sim.spawned == 1, "empty inter-arrival gap does not finish wave")
	sim.request_manual(&"heal")
	sim.clock.paused = true
	var frozen: Array = state(sim)
	for repeat in range(30):
		sim.advance(100)
	check(state(sim) == frozen, "pause freezes arrival timer and manual command")
	sim.clock.paused = false
	var previous_credit: float = sim.wave.credit
	sim.advance(100)
	check(sim.wave.credit <= previous_credit + 1.0 / 30.0 + 0.000001, "large frame remains bounded by game clock")
	# Real world cap: more total arrivals than simultaneous places.
	sim.reset(2)
	for x in range(-3, 4):
		for y in range(-3, 4):
			if sim.spawned < 20:
				sim.add_enemy(Vector2(x, y))
	freeze_enemies(sim)
	check(sim.enemies.size() == 20 and sim.spawned == 20 and sim.wave.issued == 20, "twenty actors really admitted under 24 budget")
	check(not sim.add_enemy(Vector2(2.65, 0)) and sim.spawned == 20, "twenty-first live actor refused")
	for tick in range(180):
		sim.advance(1.0 / 60.0)
	check(sim.spawned == 20 and sim.enemies.size() == 20 and sim.wave.credit <= sim.wave.interval(), "full cap never accumulates multiple arrivals")
	sim.enemies[0].state.damage(1000000)
	sim.advance(1.0 / 60.0)
	check(sim.spawned == 21 and sim.enemies.size() == 20 and sim.defeated == 1, "freed place admits exactly one waiting enemy")
	freeze_enemies(sim)
	sim.enemies[0].state.damage(1000000)
	sim.advance(1.0 / 60.0)
	check(sim.spawned == 21 and sim.enemies.size() == 19, "second place does not trigger catch-up burst")
	# Complete all arrivals and deaths deterministically, no enemy attacks in this fixture.
	var identities: Dictionary = {}
	var bounded: bool = true
	for tick in range(600):
		for actor in sim.enemies:
			identities[actor.combat_id] = true
			actor.state.damage(1000000)
		var before: int = sim.spawned
		sim.advance(1.0 / 60.0)
		bounded = bounded and sim.spawned - before <= 1 and sim.peak_alive <= 20 and sim.wave.issued == sim.spawned
		if sim.result != "EN COURS":
			break
	check(bounded and sim.result == "VICTOIRE" and sim.spawned == 24 and sim.defeated == 24 and sim.enemies.is_empty(), "victory only after complete budget and last death")
	frozen = state(sim)
	sim.advance(100)
	check(state(sim) == frozen and not sim.request_manual(&"heal"), "terminal wave frozen and rejects command")
	# Lost actors do not count as kills or grant a false victory.
	sim.reset(0)
	sim.budget = 1
	sim.wave.reset(1, 1)
	sim.add_enemy(Pattern.spawn_position(0))
	sim.enemies[0].queue_free()
	sim.advance(0.02)
	check(sim.result == "INTERROMPU" and sim.removed == 1 and sim.defeated == 0, "external removal cannot grant victory")
	sim.reset(0)
	sim.request_manual(&"heal")
	sim.hero.state.damage(1000000)
	sim.advance(0.02)
	check(sim.result == "DEFAITE" and sim.spawned == 0 and not sim.manual.pending, "death before first arrival ends wave and clears command")
	# Full combat uses the normal actions; durable hero isolates wave completeness from balance.
	sim.controller.rules = Controller.standard_rules()
	sim.reset(0)
	var durable = HERO.duplicate()
	durable.max_health = 1000000
	durable.attack = 30
	sim.hero.configure(durable)
	var coherent: bool = true
	for tick in range(60 * 180):
		sim.advance(1.0 / 60.0)
		coherent = coherent and sim.enemies.size() <= 6 and sim.spawned == sim.defeated + sim.removed + sim.enemies.size() and sim.wave.issued == sim.spawned
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(coherent and sim.result == "VICTOIRE" and sim.defeated == 12 and sim.hits > 0, "real gambit combat completes a single progressive wave")
	sim.clock.paused = true
	for repeat in range(10):
		sim.reset(0)
		await get_tree().process_frame
	check(world.get_child_count() == 1 and sim.wave.issued == 0 and sim.wave.credit == 0 and sim.clock.paused, "ten paused resets leave only fresh hero and fresh schedule")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	check(lab.simulation.wave_enabled and lab.simulation.manual_enabled and lab.simulation.budget == 12, "main lab enables wave and manual commands")
	lab.paused = false
	lab._update_buttons()
	lab._next_placement()
	check(lab.mode_index == 1 and lab.simulation.hero.state.health == 40 and lab.simulation.spawned == 0, "heal diagnostic retains wounded hero with progressive wave")
	lab._next_placement()
	check(lab.mode_index == 2 and lab.simulation.budget == 24 and lab.simulation.wave.cap == 20, "charge diagnostic has 24 arrivals and cap twenty")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	frozen = state(lab.simulation)
	lab._physics_process(100)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and state(lab.simulation) == frozen, "background freezes actual wave lab")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-024 / vague progressive\n%s : %d controles, %d echecs\nCadence, plafond, fins et cycle de vie.\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	label.add_theme_font_size_override("font_size", 19)
	add_child(label)
