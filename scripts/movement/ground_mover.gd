extends RefCounted
## Executes a supplied target intention; never searches for or selects a target.
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
enum State { NO_TARGET, MOVING, ARRIVED, BLOCKED }
const EPSILON: float = 0.00001
var ground_position := Vector2.ZERO
var velocity := Vector2.ZERO
var facing := Vector2(1, 1).normalized()
var speed: float = 1.2
var stopping_distance: float = 0.8
var target: Node3D
var state: int = State.NO_TARGET
var distance_to_target: float = -1.0

func reset(start: Vector2) -> void:
	ground_position = Bounds.clamp_ground(start)
	velocity = Vector2.ZERO
	facing = Vector2(1, 1).normalized()
	target = null
	state = State.NO_TARGET
	distance_to_target = -1.0

func set_target(new_target: Node3D) -> void:
	target = new_target
	velocity = Vector2.ZERO

func clear_target() -> void:
	target = null
	velocity = Vector2.ZERO
	state = State.NO_TARGET
	distance_to_target = -1.0

func has_valid_target() -> bool:
	return is_instance_valid(target) and not target.is_queued_for_deletion() and target.is_inside_tree()

func step(delta: float) -> void:
	velocity = Vector2.ZERO
	if not has_valid_target():
		clear_target()
		return
	var destination := Vector2(target.position.x, target.position.z)
	var offset: Vector2 = destination - ground_position
	distance_to_target = offset.length()
	var stop: float = maxf(0.0, stopping_distance)
	if distance_to_target <= stop + EPSILON:
		state = State.ARRIVED
		return
	if delta <= 0.0:
		return
	var step_length: float = minf(maxf(0.0, speed) * delta, distance_to_target - stop)
	var previous: Vector2 = ground_position
	ground_position = Bounds.clamp_ground(previous + offset / distance_to_target * step_length)
	velocity = (ground_position - previous) / delta
	distance_to_target = ground_position.distance_to(destination)
	if velocity.length_squared() <= EPSILON * EPSILON:
		state = State.BLOCKED
	elif distance_to_target <= stop + EPSILON:
		facing = velocity.normalized()
		state = State.ARRIVED
	else:
		facing = velocity.normalized()
		state = State.MOVING
