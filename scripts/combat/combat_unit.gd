extends "res://scripts/combat/stats_actor.gd"
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const SkillExecutor = preload("res://scripts/skills/skill_executor.gd")
static var _next_combat_id: int = 0
var combat_id: int = 0
var mover := GroundMover.new()
var action := SkillExecutor.new(self, true)
var gait: float = 0.0
var serial: int = 0

func _init() -> void:
	_next_combat_id += 1
	combat_id = _next_combat_id

func place(at: Vector2) -> void:
	mover.reset(at)
	mover.speed = state.move_speed
	mover.stopping_distance = 0.8
	position = Vector3(at.x, 0, at.y)

func present() -> void:
	visible = state.alive
	pose(gait, mover.velocity.length_squared() > 0.000001, mover.facing)
