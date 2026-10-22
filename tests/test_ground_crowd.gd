extends Node
const GroundCrowd = preload("res://scripts/crowd/ground_crowd.gd")
const CrowdSimulation = preload("res://scripts/crowd/crowd_simulation.gd")
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
var checks: int = 0
var failures: int = 0

func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("GroundCrowd: " + message)

func _ready() -> void:
	for hz in [30, 60, 120]:
		var single: Array[Vector2] = [Vector2.ZERO]
		var request: Array[Vector2] = [Vector2(1.2 / float(hz), 0)]
		var no_correction: Array[bool] = [false]
		for tick in range(int(hz / 2.0)):
			single = GroundCrowd.solve(single, request, no_correction, 1.0 / float(hz))
		_check(absf(single[0].x - 0.6) < 0.0001, "free speed at %d Hz" % hz)
	var pile: Array[Vector2] = [Vector2(2, 2), Vector2(-2.65, -2.65), Vector2(-2.65, -2.65)]
	var zeros: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
	var recover: Array[bool] = [false, true, true]
	var within_budget: bool = true
	for tick in range(240):
		var before: Array[Vector2] = pile.duplicate()
		pile = GroundCrowd.solve(pile, zeros, recover, 1.0 / 60.0)
		for index in range(pile.size()):
			within_budget = within_budget and pile[index].distance_to(before[index]) <= 0.01001 and Bounds.contains_ground(pile[index])
	_check(within_budget, "depenetration exceeds 0.6 u/s or boundary")
	_check(pile[1].distance_to(pile[2]) >= 0.699, "coincident pair not recovered")
	_check(pile[0] == Vector2(2, 2), "stationary hero pushed")
	var pair: Array[Vector2] = [Vector2(-0.6, 0), Vector2(0.6, 0)]
	var opposing: Array[Vector2] = [Vector2(0.02, 0), Vector2(-0.015, 0)]
	var pair_flags: Array[bool] = [false, true]
	var no_crossing: bool = true
	for tick in range(120):
		pair = GroundCrowd.solve(pair, opposing, pair_flags, 1.0 / 60.0)
		no_crossing = no_crossing and pair[0].x < pair[1].x and pair[0].distance_to(pair[1]) >= 0.6999
	_check(no_crossing, "opposing actors crossed or penetrated")
	var frozen: Array[Vector2] = GroundCrowd.solve(pair, opposing, pair_flags, 0.0)
	_check(frozen == pair, "zero delta moves actors")
	var huge_request: Array[Vector2] = [Vector2(100, 0), Vector2.ZERO]
	var long_tick: Array[Vector2] = GroundCrowd.solve(pair, huge_request, pair_flags, 10.0)
	_check(long_tick[0].distance_to(pair[0]) <= 0.04001 and long_tick[0].distance_to(long_tick[1]) >= 0.6999, "large delta or request bypasses cap/contact")
	var world := Node3D.new()
	add_child(world)
	var hero := Node3D.new()
	world.add_child(hero)
	var waypoint := Node3D.new()
	world.add_child(waypoint)
	waypoint.position = Vector3(2.3, 0, 0)
	var simulation := CrowdSimulation.new()
	add_child(simulation)
	simulation.configure(world, hero)
	simulation.reset(Vector2.ZERO)
	simulation.spawning = false
	simulation.freeze_enemies = true
	for index in range(6):
		var angle: float = TAU * float(index) / 6.0
		_check(simulation.add_enemy(Vector2(cos(angle), sin(angle)) * 0.95), "ring spawn")
	simulation.hero_mover.set_target(waypoint)
	for tick in range(180):
		simulation.advance(1.0 / 60.0)
	_check(simulation.hero_mover.state == GroundMover.State.BLOCKED and hero.position.x < 0.251, "hero escaped closed ring")
	_check(simulation.max_step <= 0.02001, "ring hero teleported")
	var stopped := Vector2(hero.position.x, hero.position.z)
	var paused_time: float = simulation.elapsed
	var paused_gait: float = simulation.hero_gait
	simulation.advance(10.0, true)
	_check(simulation.elapsed == paused_time and simulation.hero_gait == paused_gait and simulation.hero_mover.ground_position == stopped, "pause changes simulation")
	simulation.actors[0].queue_free()
	for tick in range(180):
		simulation.advance(1.0 / 60.0)
	_check(simulation.actors.size() == 5, "removed gate not pruned")
	_check(simulation.hero_mover.state == GroundMover.State.ARRIVED and absf(hero.position.x - 2.3) < 0.001, "hero does not resume through open gate")
	simulation.reset(Vector2.ZERO)
	await get_tree().process_frame
	_check(world.get_child_count() == 2, "reset leaves enemies")
	var crowd_valid: bool = true
	var bounded: bool = true
	for tick in range(900):
		var before: Array[Vector2] = []
		for actor in simulation.actors:
			before.append(actor.mover.ground_position)
		simulation.advance(1.0 / 30.0)
		var positions: Array[Vector2] = [simulation.hero_mover.ground_position]
		for index in range(simulation.actors.size()):
			var at: Vector2 = simulation.actors[index].mover.ground_position
			positions.append(at)
			crowd_valid = crowd_valid and Bounds.contains_ground(at)
			if index < before.size():
				bounded = bounded and at.distance_to(before[index]) <= 0.05001
		crowd_valid = crowd_valid and GroundCrowd.minimum_distance(positions) >= 0.6999
		if tick % 60 == 0:
			await get_tree().process_frame
	_check(simulation.spawned == 20 and simulation.actors.size() == 20, "20 actor scenario incomplete")
	_check(crowd_valid, "spawn or pursuit violates spacing/bounds")
	_check(bounded, "crowd exceeds combined speed budget")
	_check(not simulation.add_enemy(simulation.actors[0].mover.ground_position), "occupied/full spawn accepted")
	var last: Vector2 = simulation.actors[0].mover.ground_position
	hero.queue_free()
	simulation.advance(1.0 / 60.0)
	_check(simulation.actors[0].mover.ground_position == last, "lost hero does not stop crowd")
	await get_tree().process_frame
	simulation.advance(1.0 / 60.0)
	world.queue_free()
	simulation.queue_free()
	var report: String = "STEP-009 / tests de foule\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	canvas.add_child(label)
