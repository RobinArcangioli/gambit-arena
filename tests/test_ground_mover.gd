extends Node
## Run scenes/tests/ground_mover_tests.tscn with F6. Exercises real mover code.
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
var checks: int = 0
var failures: int = 0
var targets: Array[Node3D] = []

func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("GroundMover: " + message)

func _target(at: Vector2) -> Node3D:
	var node := Node3D.new()
	add_child(node)
	node.position = Vector3(at.x, 0, at.y)
	targets.append(node)
	return node

func _ready() -> void:
	var a: Node3D = _target(Vector2(2, 0))
	var b: Node3D = _target(Vector2(-2, 0))
	var diagonal: Node3D = _target(Vector2(2, 2))
	for hz in [30, 60, 120]:
		for destination in [a, diagonal]:
			var candidate := GroundMover.new()
			candidate.reset(Vector2.ZERO)
			candidate.set_target(destination)
			for frame in range(int(hz / 2.0)):
				candidate.step(1.0 / float(hz))
			_check(absf(candidate.ground_position.length() - 0.6) < 0.0001, "speed depends on axis or tick rate")
	var mover := GroundMover.new()
	mover.reset(Vector2.ZERO)
	mover.set_target(a)
	mover.step(10.0)
	_check(mover.ground_position.is_equal_approx(Vector2(1.2, 0)), "overshoot on long tick")
	_check(mover.state == GroundMover.State.ARRIVED, "arrival state missing")
	var stopped: Vector2 = mover.ground_position
	for frame in range(120):
		mover.step(1.0 / 60.0)
	_check(mover.ground_position.is_equal_approx(stopped), "arrival oscillation")
	a.position.x = 2.5
	mover.step(0.1)
	_check(mover.ground_position.x > stopped.x, "moving target not re-read")
	a.position.x = 2.0
	mover.reset(Vector2.ZERO)
	mover.set_target(a)
	mover.step(0.25)
	var before: Vector2 = mover.ground_position
	mover.set_target(b)
	_check(mover.ground_position == before, "retarget teleports")
	mover.step(0.1)
	_check(mover.ground_position.x < before.x and mover.ground_position.distance_to(before) <= 0.12001, "retarget not applied on next tick")
	before = mover.ground_position
	mover.clear_target()
	mover.step(5.0)
	_check(mover.ground_position == before and mover.velocity == Vector2.ZERO, "clear target does not stop")
	var outside: Node3D = _target(Vector2(4.5, 4.5))
	mover.reset(Vector2.ZERO)
	mover.set_target(outside)
	for frame in range(600):
		mover.step(1.0 / 60.0)
	_check(mover.ground_position.is_equal_approx(preload("res://scripts/arena/arena_bounds.gd").clamp_ground(Vector2(4.5,4.5))), "arena boundary violated")
	_check(mover.state == GroundMover.State.BLOCKED, "outside target reported as arrived")
	var lost: Node3D = _target(Vector2(2, 0))
	mover.reset(Vector2.ZERO)
	mover.set_target(lost)
	mover.step(0.1)
	before = mover.ground_position
	lost.queue_free()
	mover.step(0.1)
	_check(mover.state == GroundMover.State.NO_TARGET and mover.ground_position == before, "queued target not rejected")
	var freed: Node3D = _target(Vector2(2, 0))
	mover.set_target(freed)
	targets.erase(freed)
	freed.free()
	mover.step(0.1)
	_check(mover.state == GroundMover.State.NO_TARGET, "freed target not rejected")
	var detached: Node3D = _target(Vector2(2, 0))
	mover.set_target(detached)
	remove_child(detached)
	mover.step(0.1)
	_check(mover.state == GroundMover.State.NO_TARGET, "detached target not rejected")
	for node in targets:
		if is_instance_valid(node) and not node.is_queued_for_deletion():
			node.free()
	var result: String = "OK" if failures == 0 else "ECHEC"
	var report: String = "STEP-007 / tests de deplacement\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % [result, checks, failures]
	print(report)
	var canvas := CanvasLayer.new()
	add_child(canvas)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	canvas.add_child(label)
