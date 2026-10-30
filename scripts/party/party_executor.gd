extends "res://scripts/combat/attack_action.gd"
## Single commitment and impact path for party manual commands and gambits.
const BuffCatalog = preload("res://scripts/buffs/buff_catalog.gd")
const BuffState = preload("res://scripts/buffs/buff_state.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Multi=preload("res://scripts/skills/multi_skills.gd")
const Area=preload("res://scripts/skills/area_skills.gd")
const Projectiles=preload("res://scripts/skills/area_projectiles.gd")
var projectiles:=Projectiles.new()
var external_projectiles:bool=false
var area_targets:Callable
var ground_point:=Vector2.ZERO
var _ground_cast:bool=false
var _ground_check_time:float=0.0
const GROUND_CHECK_INTERVAL:float=0.5
const SPELL_REACH: float = 4.0
const HEAL_CAST: float = 1.5
const LIGHTNING_CAST: float = 2.0
const BOOSTER_CAST: float = 1.5
var applied_buff: StringName
var _target_buffs: BuffState
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
# Legacy laboratories keep their original contracts; product orders choose any living target.
var unrestricted_targets: bool = false
var _engaging: StringName
const MAX_VISUAL_EVENTS: int = 64
var _visual_events: Array[Dictionary] = []
var _visual_sequence: int = 0
var _bound_state

func _init(owner_actor = null) -> void:
	actor = owner_actor

static func cost(skill: StringName) -> int:
	if Multi.has(skill):return 20
	if Area.has(skill):return Area.DEFINITIONS[skill].cost
	return 20 if skill in [&"heal", &"booster"] else 30 if skill == &"lightning" else 0

static func cast_duration(skill: StringName) -> float:
	if Multi.has(skill):return 1.5
	if Area.has(skill):return Area.DEFINITIONS[skill].cast
	return BOOSTER_CAST if skill == &"booster" else HEAL_CAST if skill == &"heal" else LIGHTNING_CAST if skill == &"lightning" else WINDUP

static func skill_reach(skill: StringName) -> float:
	return SPELL_REACH if skill in [&"heal", &"lightning", &"booster"] or Area.has(skill) or Multi.has(skill) else REACH

static func cooldown(skill: StringName) -> float:
	if Multi.has(skill):return 3.0
	if Area.has(skill):return Area.DEFINITIONS[skill].cooldown
	return 4.0 if skill == &"heal" else 6.0 if skill == &"lightning" else 0.0

func remaining(skill: StringName) -> float:
	return float(cooldowns.get(skill, 0.0))

func available(skill: StringName) -> bool:
	return not retired and living(actor) and skill in actor.abilities and mana + 0.000001 >= cost(skill) and remaining(skill) <= 0.0

func request(skill: StringName, target) -> int:
	if Area.has(skill):
		if not living(target):return _reject("cible absente")
		return request_ground(skill,Vector2(target.position.x,target.position.z))
	last_rejection = ""
	if clock == null or not clock.permits_gameplay() or retired or not living(actor):
		return _reject("indisponible")
	if _bound_state != null and actor.state != _bound_state:
		retire()
		return _reject("etat remplace")
	if skill not in [&"basic", &"heal", &"lightning", &"booster", &"ice_bolts"] or skill not in actor.abilities:
		return _reject("competence indisponible")
	if active: return _reject("occupe")
	if not available(skill): return _reject("mana / delai")
	_ground_cast=false
	if not living(target): return _reject("cible absente")
	if skill == &"heal" and target.state.health >= target.state.max_health:
		return _reject("PV pleins")
	if BuffCatalog.is_buff(skill):
		var target_buffs = target.get("buffs")
		if not target_buffs is BuffState or not BuffCatalog.eligible(skill, target_buffs.snapshot()):
			return _reject("buff indisponible")
	_engaging = skill
	var id: int = super.begin(actor, target)
	_engaging = &""
	if id == 0: return _reject("cible / portee invalide")
	last_skill = skill
	_bound_state = actor.state
	accepted += 1
	applied_healing = 0
	applied_buff = &""
	_target_buffs = target.get("buffs") if BuffCatalog.is_buff(skill) else null
	cooldowns[skill] = 0.0 if Multi.has(skill) else cooldown(skill)
	_record_visual(_visual_values("start"))
	return id

func request_ground(skill:StringName,point:Vector2) -> int:
	last_rejection=""
	if not Area.has(skill) or not point.is_finite() or not area_targets.is_valid():return _reject("zone invalide")
	if clock==null or not clock.permits_gameplay() or retired or not living(actor):return _reject("indisponible")
	if _bound_state!=null and actor.state!=_bound_state:retire();return _reject("etat remplace")
	if active:return _reject("occupe")
	if not available(skill):return _reject("mana / delai")
	if Vector2(actor.position.x,actor.position.z).distance_to(point)>skill_reach(skill)+.000001:return _reject("hors portee")
	_disconnect_lifecycle();_next_id+=1;action_id=_next_id
	_source=actor;_source_state=actor.state;_target=null;_target_state=null;_attack=actor.state.attack
	_ground_check_time=0
	_ground_cast=true;ground_point=point;last_skill=skill;_bound_state=actor.state;_target_buffs=null
	active=true;elapsed=0;resolved=false;applied_damage=0;applied_healing=0;applied_buff=&""
	phase="PREPARATION";outcome="en attente";accepted+=1
	_connect_lifecycle();_record_visual(_visual_values("start"));return action_id

func _connect_lifecycle() -> void:
	if not _ground_cast:super._connect_lifecycle();return
	_source_state.died.connect(_on_source_lost);_source.tree_exiting.connect(_on_source_lost)

func _reject(reason: String) -> int:
	last_rejection = reason
	return 0

func advance(dt: float, paused: bool = false, personal_dt: float = -1.0) -> void:
	if not external_projectiles and not paused and clock!=null and clock.permits_gameplay() and area_targets.is_valid():
		projectiles.advance(dt,area_targets.call(),clock.elapsed)
		for event in projectiles.take_events():_record_visual(event)
	if retired or paused or clock == null or not clock.permits_gameplay() or not is_finite(dt) or dt <= 0.0:
		return
	if not living(actor) or (_bound_state != null and actor.state != _bound_state):
		retire()
		return
	# Coordinators prepare all personal clocks before any actor resolves an effect.
	# Direct executor laboratories can still supply combat time through this adapter.
	var local_dt: float = actor.advance_time(dt) if personal_dt < 0.0 else personal_dt
	if not is_finite(local_dt) or local_dt < 0.0: return
	for skill in cooldowns.keys():
		var left: float = maxf(0.0, cooldowns[skill] - local_dt)
		cooldowns[skill] = 0.0 if left < 0.000001 else left
	mana = minf(actor.mana_capacity, mana + actor.mana_regeneration * dt)
	# Fixed combat-time checks, independent of Booster and the personal cast clock.
	if casting() and _ground_cast:
		var cast_step:float=minf(dt,dt*maxf(0,_windup()-elapsed)/maxf(.000001,local_dt))
		_ground_check_time+=cast_step
		if _ground_check_time+.000001>=GROUND_CHECK_INTERVAL:
			_ground_check_time=maxf(0,_ground_check_time-GROUND_CHECK_INTERVAL*floori((_ground_check_time+.000001)/GROUND_CHECK_INTERVAL))
			if not _ground_has_enemy():
				outcome="zone vide";cancel();return
	if casting() and Multi.has(last_skill) and living(_target) and distance_between(actor, _target) > SPELL_REACH + .000001:
		outcome = "hors portee"; cancel(); return
	var was_active: bool = active
	super.advance(local_dt)
	if was_active and not active and phase == "TERMINEE": _record_visual(_visual_values("end"))

func _ground_has_enemy() -> bool:
	if not area_targets.is_valid():return false
	var radius:float=Area.radius(last_skill)
	for target in area_targets.call():
		if living(target) and target.team!=actor.team and Area.overlaps(ground_point,Vector2(target.position.x,target.position.z),radius):return true
	return false

func _valid_pair(source: StatsActor, target: StatsActor) -> bool:
	if unrestricted_targets:return true
	var skill: StringName = _engaging if _engaging != &"" else last_skill
	if skill == &"booster": return true
	if skill == &"heal":
		return source.get("team") == target.get("team")
	return source != target and source.get("team") != target.get("team")

func _participants_valid() -> bool:
	if _ground_cast:return living(_source) and _source.state==_source_state
	return (not Multi.has(last_skill) or (living(_target) and distance_between(actor, _target) <= SPELL_REACH + .000001)) and super._participants_valid() and _valid_pair(_source, _target) and (not BuffCatalog.is_buff(last_skill) or _target.get("buffs") == _target_buffs)

func _apply_effect() -> int:
	# AttackAction already latched this impact and revalidated participants and reach.
	# Commit before health signals: a callback cannot resolve or debit the action twice.
	if mana + 0.000001 < cost(last_skill):
		outcome = "mana insuffisante"
		return 0
	if last_skill == &"heal" and _target_state.health >= _target_state.max_health:
		outcome = "PV pleins"
		return 0
	if BuffCatalog.is_buff(last_skill):
		# No callback between applying this value-only state and committing the debit.
		if _target_buffs == null or not BuffCatalog.eligible(last_skill, _target_buffs.snapshot()) or not _target_buffs.apply(BuffCatalog.definition(last_skill)):
			outcome = "buff deja actif"
			return 0
		applied_buff = last_skill
	mana = maxf(0.0, mana - cost(last_skill))
	spent += cost(last_skill)
	if applied_buff != &"":
		outcome = "booster"
		return 0
	if last_skill == &"heal":
		applied_healing = _target_state.heal(30)
		outcome = "soin" if applied_healing > 0 else "PV pleins"
		return 0
	if Multi.has(last_skill):
		cooldowns[last_skill] = cooldown(last_skill)
		outcome = "lancement"
		return 0
	var multiplier: int = 2 if last_skill == &"lightning" else 1
	return _target_state.damage(maxi(1, multiplier * _attack - _target_state.defense))

func _windup() -> float:
	return cast_duration(_engaging if _engaging != &"" else last_skill)

func _reach() -> float:
	return skill_reach(_engaging if _engaging != &"" else last_skill)

func casting() -> bool:
	return active and not resolved and (last_skill in [&"heal", &"lightning", &"booster"] or Area.has(last_skill) or Multi.has(last_skill))

func area_radius() -> float:return Area.radius(last_skill) if _ground_cast else 0.0

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
	if _ground_cast:return _try_area_impact(expected_id)
	var pending: bool = not resolved
	var values: Dictionary = _visual_values("resolve")
	var spent_before:int=spent
	var success: bool = super.try_impact(expected_id)
	if pending and resolved and phase == "RECUPERATION":
		values["outcome"] = outcome
		values["damage"] = applied_damage
		values["healing"] = applied_healing
		values["elapsed"] = elapsed
		values["mana_paid"] = spent-spent_before
		values["mana_after"] = mana
		if Multi.has(last_skill) and outcome == "lancement":
			values.kind = "multi_launch"
			var victims: Array = Multi.choose(_target, area_targets.call() if area_targets.is_valid() else [_target])
			values = projectiles.launch_multi(values, victims)
		_record_visual(values)
		if applied_buff != &"":
			var applied: Dictionary = _visual_values("buff_applied")
			applied["buff_id"] = String(applied_buff)
			applied["buff_duration"] = BuffCatalog.BOOSTER_DURATION
			applied["time_multiplier"] = BuffCatalog.BOOSTER_RATE
			_record_visual(applied)
	return success

func _try_area_impact(expected_id:int) -> bool:
	if not _effects_allowed() or not active or resolved or expected_id!=action_id or elapsed<_windup():return false
	resolved=true;phase="RECUPERATION"
	if not _participants_valid():cancel();return false
	var values:Dictionary=_visual_values("resolve")
	if mana+.000001<cost(last_skill):
		outcome="mana insuffisante";values.outcome=outcome;_record_visual(values);return true
	# Payment and cooldown at release; victims are chosen by the combat queue at impact.
	var paid:int=cost(last_skill)
	mana=maxf(0,mana-paid);spent+=paid;cooldowns[last_skill]=cooldown(last_skill);outcome="lancement"
	values.kind="area_launch";values.outcome=outcome;values.mana_paid=paid;values.mana_after=mana
	values.flight_duration=float(Area.DEFINITIONS[last_skill].flight)
	projectiles.launch(values,actor.team)
	_record_visual(values);return true

func cancel() -> void:
	var was_active: bool = active
	var values: Dictionary = _visual_values("cancel")
	# Refund only the current unspent commitment. A lethal impact has already
	# resolved and must keep its ordinary cooldown and recovery.
	var refund_pending: bool = was_active and not resolved
	super.cancel()
	if refund_pending: cooldowns[last_skill] = 0.0
	if was_active:
		values["outcome"] = outcome
		_record_visual(values)

func _visual_values(kind: String) -> Dictionary:
	return {"ground_target":_ground_cast,"area_radius":Area.radius(last_skill),"was_preparing":not resolved,"source_alive":living(actor),"target_alive":true if _ground_cast else living(_target),
		"kind": kind, "source_id": actor.get("combat_id") if is_instance_valid(actor) else 0,
		"target_id": _target.get("combat_id") if is_instance_valid(_target) else 0,
		"action_id": action_id, "skill": String(last_skill), "elapsed": elapsed,
		"windup": _windup(), "recovery": _recovery(), "outcome": outcome,
		"source_position": actor.position if is_instance_valid(actor) else Vector3.ZERO,
		"target_position": Vector3(ground_point.x,0,ground_point.y) if _ground_cast else _target.position if is_instance_valid(_target) else Vector3.ZERO,
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
