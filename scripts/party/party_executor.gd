extends "res://scripts/combat/attack_action.gd"
## Single commitment and impact path for party manual commands and gambits.
const Clock = preload("res://scripts/core/game_clock.gd")
const SPELL_REACH: float = 4.0
const HEAL_CAST: float = 1.5
const LIGHTNING_CAST: float = 2.0
var clock: Clock
var actor
var mana: float = 60.0
var spent: int = 0
var accepted: int = 0
var applied_healing: int = 0
var last_skill: StringName
var last_rejection: String
var cooldowns: Dictionary = {}
var retired: bool = false
var _engaging: StringName
const MAX_VISUAL_EVENTS: int = 16
var _visual_events: Array[Dictionary] = []
var _visual_sequence: int = 0
var _bound_state

func _init(owner_actor = null) -> void:
	actor = owner_actor

static func cost(skill: StringName) -> int:
	return 20 if skill == &"heal" else 30 if skill == &"lightning" else 0

static func cast_duration(skill: StringName) -> float:
	return HEAL_CAST if skill == &"heal" else LIGHTNING_CAST if skill == &"lightning" else WINDUP

static func skill_reach(skill: StringName) -> float:
	return SPELL_REACH if skill in [&"heal", &"lightning"] else REACH

static func cooldown(skill: StringName) -> float:
	return 4.0 if skill == &"heal" else 6.0 if skill == &"lightning" else 0.0

func remaining(skill: StringName) -> float:
	return float(cooldowns.get(skill, 0.0))

func available(skill: StringName) -> bool:
	return not retired and living(actor) and skill in actor.abilities and mana + 0.000001 >= cost(skill) and remaining(skill) <= 0.0

func request(skill: StringName, target) -> int:
	last_rejection = ""
	if clock == null or not clock.permits_gameplay() or retired or not living(actor):
		return _reject("indisponible")
	if _bound_state != null and actor.state != _bound_state:
		retire()
		return _reject("etat remplace")
	if skill not in [&"basic", &"heal", &"lightning"] or skill not in actor.abilities:
		return _reject("competence indisponible")
	if active: return _reject("occupe")
	if not available(skill): return _reject("mana / delai")
	if not living(target): return _reject("cible absente")
	if skill == &"heal" and target.state.health >= target.state.max_health:
		return _reject("PV pleins")
	_engaging = skill
	var id: int = super.begin(actor, target)
	_engaging = &""
	if id == 0: return _reject("cible / portee invalide")
	last_skill = skill
	_bound_state = actor.state
	accepted += 1
	applied_healing = 0
	cooldowns[skill] = cooldown(skill)
	_record_visual(_visual_values("start"))
	return id

func _reject(reason: String) -> int:
	last_rejection = reason
	return 0

func advance(dt: float, paused: bool = false) -> void:
	if retired or paused or clock == null or not clock.permits_gameplay() or not is_finite(dt) or dt <= 0.0:
		return
	if not living(actor) or (_bound_state != null and actor.state != _bound_state):
		retire()
		return
	for skill in cooldowns.keys():
		var left: float = maxf(0.0, cooldowns[skill] - dt)
		cooldowns[skill] = 0.0 if left < 0.000001 else left
	mana = minf(actor.mana_capacity, mana + actor.mana_regeneration * dt)
	var was_active: bool = active
	super.advance(dt)
	if was_active and not active and phase == "TERMINEE": _record_visual(_visual_values("end"))

func _valid_pair(source: StatsActor, target: StatsActor) -> bool:
	var skill: StringName = _engaging if _engaging != &"" else last_skill
	if skill == &"heal":
		return source.get("team") == target.get("team")
	return source != target and source.get("team") != target.get("team")

func _participants_valid() -> bool:
	return super._participants_valid() and _valid_pair(_source, _target)

func _apply_effect() -> int:
	# AttackAction already latched this impact and revalidated participants and reach.
	# Commit before health signals: a callback cannot resolve or debit the action twice.
	if mana + 0.000001 < cost(last_skill):
		outcome = "mana insuffisante"
		return 0
	if last_skill == &"heal" and _target_state.health >= _target_state.max_health:
		outcome = "PV pleins"
		return 0
	mana = maxf(0.0, mana - cost(last_skill))
	spent += cost(last_skill)
	if last_skill == &"heal":
		applied_healing = _target_state.heal(30)
		outcome = "soin" if applied_healing > 0 else "PV pleins"
		return 0
	var multiplier: int = 2 if last_skill == &"lightning" else 1
	return _target_state.damage(maxi(1, multiplier * _attack - _target_state.defense))

func _windup() -> float:
	return cast_duration(_engaging if _engaging != &"" else last_skill)

func _reach() -> float:
	return skill_reach(_engaging if _engaging != &"" else last_skill)

func casting() -> bool:
	return active and not resolved and last_skill in [&"heal", &"lightning"]

func cast_progress() -> float:
	return clampf(elapsed / cast_duration(last_skill), 0.0, 1.0) if casting() else 0.0

func retire() -> void:
	cancel()
	retired = true

func _effects_allowed() -> bool:
	return not retired and clock != null and clock.permits_gameplay()

func _on_source_lost() -> void:
	retire()

func try_impact(expected_id: int) -> bool:
	var pending: bool = not resolved
	var values: Dictionary = _visual_values("resolve")
	var success: bool = super.try_impact(expected_id)
	if pending and resolved and phase == "RECUPERATION":
		values["outcome"] = outcome
		values["damage"] = applied_damage
		values["healing"] = applied_healing
		values["elapsed"] = elapsed
		_record_visual(values)
	return success

func cancel() -> void:
	var was_active: bool = active
	var values: Dictionary = _visual_values("cancel")
	super.cancel()
	if was_active:
		values["outcome"] = outcome
		_record_visual(values)

func _visual_values(kind: String) -> Dictionary:
	return {"kind": kind, "source_id": actor.get("combat_id") if is_instance_valid(actor) else 0,
		"target_id": _target.get("combat_id") if is_instance_valid(_target) else 0,
		"action_id": action_id, "skill": String(last_skill), "elapsed": elapsed,
		"windup": _windup(), "recovery": _recovery(), "outcome": outcome,
		"source_position": actor.position if is_instance_valid(actor) else Vector3.ZERO,
		"target_position": _target.position if is_instance_valid(_target) else Vector3.ZERO,
		"damage": 0, "healing": 0, "game_time": clock.elapsed if clock != null else 0.0}

func _record_visual(values: Dictionary) -> void:
	_visual_sequence += 1
	values["sequence"] = _visual_sequence
	if _visual_events.size() >= MAX_VISUAL_EVENTS: _visual_events.pop_front()
	_visual_events.append(values)

func take_visual_events() -> Array[Dictionary]:
	var values: Array[Dictionary] = _visual_events
	_visual_events = []
	return values
