extends "res://scripts/hybrid/proxy_actor.gd"
## One independent movement state per enemy; presentation follows simulation.
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
var mover := GroundMover.new()
var gait_time: float = 0.0

func initialize(at: Vector2, target_node: Node3D) -> void:
	mover.reset(at)
	mover.speed = 0.9
	mover.stopping_distance = 0.8
	mover.set_target(target_node)
	gait_time = 0.0
	_present()

func advance(delta: float) -> void:
	mover.step(delta)
	if mover.velocity.length_squared() > 0.000001:
		gait_time += delta
	_present()

func _present() -> void:
	position = Vector3(mover.ground_position.x, 0, mover.ground_position.y)
	pose(gait_time, mover.velocity.length_squared() > 0.000001, mover.facing)
