extends "res://scripts/combat/stats_actor.gd"
const Navigator = preload("res://scripts/movement/local_navigator.gd")
var navigation := Navigator.new()
const BuffState = preload("res://scripts/buffs/buff_state.gd")
var buffs := BuffState.new()
var personal_elapsed: float = 0.0
var personal_delta: float = 0.0
var personal_step_scale: float = 1.0
var death_time_scale: float = 1.0
var _buff_actor_state

func advance_time(combat_dt: float) -> float:
	personal_delta = 0.0
	if not is_finite(combat_dt) or combat_dt <= 0.0: return 0.0
	if state != _buff_actor_state:
		buffs.clear()
		_buff_actor_state = state
	if not state.alive:
		buffs.clear()
		return 0.0
	personal_delta = buffs.advance(combat_dt)
	personal_step_scale = personal_delta / combat_dt
	personal_elapsed += personal_delta
	return personal_delta

func _clear_buffs_on_death() -> void:
	death_time_scale = buffs.multiplier()
	buffs.clear()
const Mover = preload("res://scripts/movement/ground_mover.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Profile = preload("res://scripts/party/party_profile.gd")
static var _next_identity: int = 0
var combat_id: int
var actor_key: StringName
var display_name: String
var team: int
var team_slot: int = -1
var abilities: Array[StringName] = []
var mana_capacity: int = 60
var mana_regeneration: float = 5.0
var mover := Mover.new()
var action := Executor.new(self)
var gait: float = 0.0
var offensive_focus
var focus_state
var desired_target
var desired_point:=Vector2.ZERO
var ground_intention:bool=false
var area_preferred:Array=[]
var desired_skill: StringName
var pending: Dictionary = {}

func _init() -> void:
	_next_identity += 1
	combat_id = _next_identity

func configure_party(profile: Profile) -> void:
	configure(profile)
	buffs.clear()
	_buff_actor_state = state
	state.died.connect(_clear_buffs_on_death)
	personal_elapsed = 0.0
	personal_delta = 0.0
	personal_step_scale = 1.0
	death_time_scale = 1.0
	actor_key = profile.actor_key
	display_name = profile.display_name
	team = profile.team
	enemy = team != 0
	abilities.assign(profile.abilities)
	mana_capacity = profile.mana_capacity
	mana_regeneration = profile.mana_regeneration
	action.mana = mana_capacity
	mover.speed = state.move_speed

func place(at: Vector2) -> void:
	navigation.reset()
	mover.reset(at)
	position = Vector3(at.x, 0, at.y)

func present() -> void:
	visible = state.alive
	pose(gait, mover.velocity.length_squared() > 0.000001 and not action.active, mover.facing)

func clear_intention() -> void:
	ground_intention=false
	desired_target = null
	desired_skill = &""
	mover.clear_target()
