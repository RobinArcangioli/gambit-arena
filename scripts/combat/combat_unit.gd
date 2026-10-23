extends "res://scripts/combat/stats_actor.gd"
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const AttackAction = preload("res://scripts/combat/attack_action.gd")
var mover := GroundMover.new()
var action := AttackAction.new()
var gait: float = 0.0
var serial: int = 0

func place(at: Vector2) -> void:
	mover.reset(at)
	mover.speed = state.move_speed
	mover.stopping_distance = 0.8
	position = Vector3(at.x, 0, at.y)

func present() -> void:
	visible = state.alive
	pose(gait, mover.velocity.length_squared() > 0.000001, mover.facing)
