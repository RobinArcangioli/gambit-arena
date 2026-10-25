extends RefCounted
## One replaceable intent. Only SkillExecutor commits costs, cooldowns and effects.
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const State = preload("res://scripts/combat/actor_state.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const LIFETIME: float = 3.0
var _source: Unit
var _target: Unit
var _source_state: State
var _target_state: State
var _clock: Clock
var _skill: StringName = &""
var _deadline: float = 0.0
var last_event: String = "none"
var last_rejection: String = ""
var waiting_reason: String = ""
var submitted: int = 0
var replaced: int = 0
var launched: int = 0
var expired: int = 0
var last_action_id: int = 0
var pending: bool:
	get: return _skill != &""

static func nearest(hero: Unit, enemies: Array[Unit]) -> Unit:
	var chosen: Unit = null
	var distance: float = INF
	for unit in enemies:
		if not Action.living(unit):
			continue
		var candidate: float = Action.distance_between(hero, unit)
		if candidate < distance or (candidate == distance and (chosen == null or unit.combat_id < chosen.combat_id)):
			chosen = unit
			distance = candidate
	return chosen

func submit(skill: StringName, hero: Unit, enemies: Array[Unit], clock: Clock) -> bool:
	last_rejection = ""
	if skill not in [&"basic", &"heal", &"special"]:
		return _reject("unknown")
	if clock == null or clock.stopped or not Action.living(hero):
		return _reject("finished")
	if clock.paused:
		return _reject("paused")
	var chosen: Unit = hero
	if skill != &"heal":
		chosen = hero.focused_enemy(enemies)
		if chosen == null:
			chosen = nearest(hero, enemies)
	if not Action.living(chosen):
		return _reject("no_target")
	# A rejected click never replaces a valid pending command.
	var replacing: bool = pending
	clear("replaced" if replacing else "queued")
	if chosen != hero:
		hero.remember_enemy(chosen)
	_source = hero
	_target = chosen
	_source_state = hero.state
	_target_state = chosen.state
	_clock = clock
	_skill = skill
	_deadline = clock.elapsed + LIFETIME
	_source_state.died.connect(_on_source_lost)
	_source.tree_exiting.connect(_on_source_lost)
	if _target != _source:
		_target_state.died.connect(_on_target_lost)
		_target.tree_exiting.connect(_on_target_lost)
	submitted += 1
	if replacing:
		replaced += 1
	waiting_reason = "next_tick"
	return true

func _reject(reason: String) -> bool:
	last_rejection = reason
	return false

func snapshot() -> Dictionary:
	if not pending:
		return {}
	return {"skill": String(_skill), "target_id": _target.combat_id if is_instance_valid(_target) else 0, "remaining": maxf(0.0, _deadline - _clock.elapsed), "reason": waiting_reason}

func prepare(hero: Unit, enemies: Array[Unit], clock: Clock, set_movement: bool = true) -> bool:
	if not pending:
		return false
	if clock != _clock or clock.stopped or hero != _source or not Action.living(_source) or _source.state != _source_state:
		clear("source_lost")
		return false
	if not Action.living(_target) or _target.state != _target_state or (_target != hero and _target not in enemies):
		clear("target_lost")
		return false
	# Inclusive expiry, before commitment, measured only by the shared game clock.
	if clock.elapsed >= _deadline - 0.000001:
		expired += 1
		clear("expired")
		return false
	if clock.paused:
		waiting_reason = "paused"
		return true
	if hero.action.active:
		waiting_reason = "busy"
		return true
	if set_movement:
		hero.mover.clear_target()
		if _target != hero:
			hero.mover.set_target(_target)
	waiting_reason = _blocker()
	return true

func _blocker() -> String:
	if _source.action.remaining(_skill) > 0.0:
		return "cooldown"
	if _skill == &"heal" and _source.state.health >= _source.state.max_health:
		return "full_health"
	var cost: int = Executor.HEAL_COST if _skill == &"heal" else Executor.SPECIAL_COST if _skill == &"special" else 0
	if _source.action.energy < cost:
		return "energy"
	if Action.distance_between(_source, _target) > Action.REACH:
		return "out_of_range"
	return "ready"

func execute(hero: Unit, enemies: Array[Unit], clock: Clock) -> int:
	if not prepare(hero, enemies, clock, false) or not clock.permits_gameplay() or waiting_reason != "ready":
		return 0
	# Revalidation above uses current actors/states. The shared executor is final authority.
	var id: int = hero.action.request(_skill, _target)
	if id <= 0:
		waiting_reason = "executor_rejected"
		return 0
	if _target != hero:
		var offset: Vector3 = _target.position - hero.position
		hero.mover.facing = Vector2(offset.x, offset.z).normalized()
	launched += 1
	last_action_id = id
	clear("launched")
	return id

func clear(event: String = "cleared") -> void:
	if _source_state != null and _source_state.died.is_connected(_on_source_lost):
		_source_state.died.disconnect(_on_source_lost)
	if is_instance_valid(_source):
		if _source.tree_exiting.is_connected(_on_source_lost):
			_source.tree_exiting.disconnect(_on_source_lost)
		_source.mover.clear_target()
	if _target_state != null and _target_state.died.is_connected(_on_target_lost):
		_target_state.died.disconnect(_on_target_lost)
	if is_instance_valid(_target) and _target.tree_exiting.is_connected(_on_target_lost):
		_target.tree_exiting.disconnect(_on_target_lost)
	_source = null
	_target = null
	_source_state = null
	_target_state = null
	_clock = null
	_skill = &""
	_deadline = 0.0
	waiting_reason = ""
	last_event = event

func reset() -> void:
	clear("none")
	last_rejection = ""
	submitted = 0
	replaced = 0
	launched = 0
	expired = 0
	last_action_id = 0

func _on_source_lost() -> void:
	clear("source_lost")

func _on_target_lost() -> void:
	clear("target_lost")
