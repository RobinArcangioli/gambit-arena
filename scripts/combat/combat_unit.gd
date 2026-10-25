extends "res://scripts/combat/stats_actor.gd"
const FocusActor = preload("res://scripts/combat/stats_actor.gd")
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const SkillExecutor = preload("res://scripts/skills/skill_executor.gd")
static var _next_combat_id: int = 0
var combat_id: int = 0
var mover := GroundMover.new()
var action := SkillExecutor.new(self, true)
var gait: float = 0.0
var serial: int = 0
# Independent from an action/intention: a self-heal must not lose enemy focus.
var _enemy_focus: FocusActor = null
var _enemy_focus_state: ActorState = null
var _focus_owner_state: ActorState = null

func focused_enemy(enemies: Array) -> Variant:
	if not SkillExecutor.living(self) or state != _focus_owner_state or not SkillExecutor.living(_enemy_focus) or _enemy_focus not in enemies:
		clear_enemy_focus()
		return null
	if _enemy_focus.state != _enemy_focus_state or SkillExecutor.distance_between(self, _enemy_focus) > SkillExecutor.REACH:
		clear_enemy_focus()
		return null
	return _enemy_focus

func remember_enemy(target: FocusActor) -> void:
	if target == self or not SkillExecutor.living(target):
		return
	_enemy_focus = target
	_enemy_focus_state = target.state
	_focus_owner_state = state

func clear_enemy_focus() -> void:
	_enemy_focus = null
	_enemy_focus_state = null
	_focus_owner_state = null

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
