extends Node
const EnemyDirector = preload("res://scripts/enemies/enemy_director.gd")
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
var checks: int = 0
var failures: int = 0

func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("EnemyDirector: " + message)

func _ready() -> void:
	var world := Node3D.new()
	add_child(world)
	var hero := Node3D.new()
	world.add_child(hero)
	var director := EnemyDirector.new()
	add_child(director)
	director.configure(world, hero)
	var edge:float=Bounds.HALF_EXTENT-Bounds.ACTOR_MARGIN
	var expected: Array[Vector2] = [Vector2(-edge, 0), Vector2(0, -edge), Vector2(edge, 0), Vector2(0, edge)]
	for index in range(4):
		director.advance(1.0)
		_check(director.actors.size() == index + 1, "spawn count")
		_check(director.actors[index].mover.ground_position.is_equal_approx(expected[index]), "spawn side")
	_check(director.actors[0].mover != director.actors[1].mover, "shared mover")
	for index in range(20):
		_check(Bounds.contains_ground(EnemyDirector.spawn_position(index)), "spawn outside bounds")
	director.reset(20)
	director.advance(1.0)
	var actor = director.actors[0]
	var before: Vector2 = actor.mover.ground_position
	director.advance(0.5)
	_check(absf(actor.mover.ground_position.distance_to(before) - 0.45) < 0.0001, "enemy speed")
	before = actor.mover.ground_position
	var clock: float = director.spawn_clock
	var elapsed: float = director.elapsed
	var gait: float = actor.gait_time
	director.advance(10.0, true)
	_check(actor.mover.ground_position == before and actor.gait_time == gait, "pause movement or pose")
	_check(director.spawn_clock == clock and director.elapsed == elapsed and director.spawned == 1, "pause spawn clock")
	director.advance(0.25)
	_check(director.spawned == 1, "spawn burst on resume")
	hero.position = Vector3(-2.5, 0, 2)
	before = actor.mover.ground_position
	director.advance(0.1)
	_check(actor.mover.ground_position.y > before.y and actor.mover.ground_position.distance_to(before) <= 0.09001, "moving hero not tracked")
	director.set_hero(null)
	before = actor.mover.ground_position
	var count: int = director.spawned
	director.advance(5.0)
	_check(actor.mover.ground_position == before and actor.mover.state == GroundMover.State.NO_TARGET, "absent hero not stopped")
	_check(director.spawned == count, "spawn without hero")
	director.set_hero(hero)
	director.advance(0.1)
	_check(actor.mover.ground_position != before, "hero return not tracked")
	hero.queue_free()
	before = actor.mover.ground_position
	director.advance(1.0)
	_check(actor.mover.ground_position == before and director.spawned == count, "queued hero not rejected")
	await get_tree().process_frame
	director.advance(1.0)
	_check(actor.mover.state == GroundMover.State.NO_TARGET, "freed hero not rejected")
	var replacement := Node3D.new()
	world.add_child(replacement)
	director.set_hero(replacement)
	director.reset(999)
	_check(director.budget == 20 and director.actors.is_empty() and director.elapsed == 0.0, "reset or budget clamp")
	await get_tree().process_frame
	_check(world.get_child_count() == 1, "reset leaves actor nodes")
	for tick in range(120):
		director.advance(0.25)
	_check(director.actors.size() == 20 and director.spawned == 20, "cap 20")
	for candidate in director.actors:
		_check(Bounds.contains_ground(candidate.mover.ground_position), "chase outside arena")
		_check(candidate.mover.state == GroundMover.State.ARRIVED and absf(candidate.mover.distance_to_target - 0.8) < 0.0001, "stationary arrival distance")
	director.actors[0].queue_free()
	director.advance(0.1)
	_check(director.actors.size() == 19, "queued enemy not pruned")
	director.reset()
	director.spawning = false
	director.advance(10.0)
	_check(director.spawned == 0 and director.spawn_clock == 0.0, "disabled spawn accumulates time")
	director.spawning = true
	director.advance(0.5)
	_check(director.spawned == 0, "early spawn after enable")
	director.advance(0.5)
	_check(director.spawned == 1, "spawn not resumed")
	director.reset()
	director.advance(10.0)
	_check(director.spawned == 1, "long tick causes spawn burst")
	director.reset()
	await get_tree().process_frame
	world.queue_free()
	director.queue_free()
	var result: String = "OK" if failures == 0 else "ECHEC"
	var report: String = "STEP-008 / tests de poursuite\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % [result, checks, failures]
	print(report)
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	canvas.add_child(label)
