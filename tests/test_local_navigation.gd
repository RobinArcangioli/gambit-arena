extends Node
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Unit = preload("res://scripts/party/party_unit.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const ANNE = preload("res://data/party/anne.tres")
const MAKO = preload("res://data/party/mako.tres")
const SKELETON = preload("res://data/party/skeleton.tres")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("LocalNavigation: " + message)

func fixture(profile = ANNE) -> Dictionary:
	var world := Node3D.new()
	add_child(world)
	var simulation := Simulation.new()
	add_child(simulation)
	simulation.configure(world)
	simulation.clock.reset()
	var source = actor(simulation, world, profile, Vector2(-2, 0))
	var target = actor(simulation, world, SKELETON if profile.team == 0 else ANNE, Vector2(2, 0))
	var blocker = actor(simulation, world, MAKO, Vector2.ZERO)
	source.desired_target = target
	source.desired_skill = &"basic"
	source.mover.set_target(target)
	return {"world": world, "sim": simulation, "source": source, "target": target, "blocker": blocker}

func actor(simulation, world, profile, position: Vector2):
	var unit := Unit.new()
	unit.configure_party(profile)
	unit.action.clock = simulation.clock
	unit.presentation_enabled = false
	world.add_child(unit)
	unit.place(position)
	if unit.team == 0: simulation.heroes.append(unit)
	else: simulation.enemies.append(unit)
	return unit

func exercise(f: Dictionary, hz: int = 60, seconds: float = 8.0) -> Dictionary:
	var safe: bool = true
	var max_y: float = 0
	var arrived: bool = false
	var arrival: float = -1
	var positions: Array[Vector2] = []
	for tick in range(roundi(seconds * hz)):
		var before: Vector2 = f.source.mover.ground_position
		f.sim._move(1.0/hz)
		var at: Vector2 = f.source.mover.ground_position
		positions.append(at)
		max_y = maxf(max_y, absf(at.y))
		var points: Array[Vector2] = f.sim.navigation_obstacles.duplicate()
		for unit in f.sim.all_units(): points.append(unit.mover.ground_position)
		safe = safe and Crowd.minimum_distance(points) >= 0.6998 and Bounds.contains_ground(at)
		safe = safe and at.distance_to(before) <= f.source.mover.speed / hz + 0.00001
		safe = safe and f.sim.navigation_searches_last_tick <= f.sim.MAX_NAV_SEARCHES_PER_TICK
		if f.source.mover.distance_to_target <= 1.00001:
			if not arrived: arrival = float(tick + 1)/hz
			arrived = true
	return {"safe": safe, "arrived": arrived, "max_y": max_y, "positions": positions, "arrival": arrival}

func dispose(f: Dictionary) -> void:
	f.sim.queue_free()
	f.world.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame

func _ready() -> void:
	check(is_equal_approx(Crowd.RADIUS, 0.35), "current body radius is preserved")
	for profile in [ANNE, MAKO, SKELETON]:
		for hz in [30, 60, 120]:
			var f: Dictionary = fixture(profile)
			var report: Dictionary = exercise(f, hz)
			print(profile.actor_key, " ", hz, " ", report.arrived, " ", report.arrival, " searches ",f.source.navigation.searches, " status ",f.source.navigation.status)
			check(report.arrived and report.max_y > 0.65, "detour around fixed body for %s at %d Hz" % [profile.actor_key, hz])
			check(report.safe, "no penetration, teleport, budget overflow or boundary escape")
			var before: Vector2 = f.source.mover.ground_position
			for tick in range(30): f.sim._move(1.0/hz)
			check(f.source.mover.ground_position == before, "arrival holds still at actual action range")
			await dispose(f)
	var f: Dictionary = fixture()
	f.blocker.place(Vector2(0, -0.4))
	f.sim.navigation_obstacles.append(Vector2(0, 0.4))
	var report: Dictionary = exercise(f)
	check(report.arrived and report.safe and report.max_y > 1.0, "two-body screen is bypassed")
	await dispose(f)
	f = fixture()
	f.source.place(Vector2(-2.25, -2.2))
	f.target.place(Vector2(2.25, -2.2))
	f.blocker.place(Vector2(0, -2.2))
	report = exercise(f)
	check(report.arrived and report.safe, "edge obstacle is bypassed on the available inner side")
	await dispose(f)
	for hz in [30, 60, 120]:
		f = fixture()
		f.source.place(Vector2(2.65, 0))
		f.target.place(Vector2(-2, 0))
		f.blocker.place(Vector2(1.95, 0))
		report = exercise(f, hz)
		check(report.arrived and report.safe, "touching body against boundary can slide sideways at %d Hz" % hz)
		await dispose(f)
	f = fixture()
	f.source.place(Vector2.ZERO)
	f.target.place(Vector2(2.3, 0))
	f.blocker.place(Vector2(-2, -2))
	for i in range(6): f.sim.navigation_obstacles.append(Vector2(cos(TAU*i/6), sin(TAU*i/6)) * 0.95)
	report = exercise(f, 60, 3)
	check(not report.arrived and report.safe and f.source.navigation.status == "WAITING", "closed ring waits safely without tunneling")
	check(f.source.navigation.searches <= 10 and f.source.mover.state == Unit.Mover.State.BLOCKED, "closed ring has bounded retries and effective BLOCKED state")
	var frozen: Array = [f.source.position, f.source.navigation.cooldown, f.source.navigation.searches, f.source.navigation.path.duplicate()]
	f.sim.advance(10, true)
	check(frozen == [f.source.position, f.source.navigation.cooldown, f.source.navigation.searches, f.source.navigation.path], "pause freezes route and retry timer")
	f.sim.navigation_obstacles.remove_at(0)
	report = exercise(f)
	check(report.arrived and report.safe, "opening gate resumes original target without teleport")
	await dispose(f)
	f = fixture()
	for i in range(30): f.sim._move(1.0/60.0)
	f.target.place(Vector2(2, 1.2))
	report = exercise(f)
	check(report.arrived and report.safe, "moving target invalidates route and is reached")
	f.target.state.damage(100000)
	f.sim._move(1.0/60.0)
	check(f.source.navigation.path.is_empty() and f.source.navigation.status == "IDLE", "dead target invalidates previous route")
	await dispose(f)
	f = fixture()
	f.source.place(Vector2(-0.7, 0))
	report = exercise(f)
	check(report.arrived and report.safe, "touching start can step temporarily away and find a detour")
	await dispose(f)
	f = fixture()
	f.source.place(Vector2(-1.8, 0))
	f.target.place(Vector2(2.6, 0))
	f.blocker.place(Vector2(1.8, 0))
	var other_target = actor(f.sim, f.world, SKELETON, Vector2(-2.6, 0))
	f.blocker.desired_target = other_target
	f.blocker.desired_skill = &"basic"
	f.blocker.mover.set_target(other_target)
	report = exercise(f, 60, 10)
	check(report.arrived and f.blocker.mover.distance_to_target <= 1.0001 and report.safe, "opposite intentions pass each other without reciprocal deadlock")
	check(f.source.navigation.searches > 0 and f.blocker.navigation.searches > 0, "shared staggered search budget serves both actors")
	await dispose(f)
	f = fixture()
	f.source.place(Vector2(-2, 0))
	f.target.place(Vector2(2, 0))
	f.blocker.place(Vector2(0, -2))
	other_target = actor(f.sim, f.world, SKELETON, Vector2(0, 2))
	f.blocker.desired_target = other_target
	f.blocker.desired_skill = &"basic"
	f.blocker.mover.set_target(other_target)
	report = exercise(f, 60, 10)
	check(report.arrived and f.blocker.mover.distance_to_target <= 1.0001 and report.safe, "crossing allies reach separate targets without penetration")
	await dispose(f)
	f = fixture()
	f.source.place(Vector2(1.1, 0))
	check(f.source.action.request(&"basic", f.target) > 0, "actual attack can engage at range")
	var fixed: Vector2 = f.source.mover.ground_position
	var searches: int = f.source.navigation.searches
	for tick in range(90): f.sim._move(1.0/60.0)
	check(f.source.mover.ground_position == fixed and f.source.navigation.searches == searches, "active action owns immobility and does not replan")
	await dispose(f)
	var paths: Array = []
	for i in range(2):
		f = fixture()
		report = exercise(f, 60, 5)
		paths.append(report.positions)
		await dispose(f)
	check(paths[0] == paths[1], "fresh runs produce deterministic routes independent of model or actor identity counters")
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "all navigation actors and routes are released")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
