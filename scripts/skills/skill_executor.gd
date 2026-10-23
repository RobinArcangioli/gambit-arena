extends "res://scripts/combat/attack_action.gd"
## Shared execution gate. One instance per actor, used by manual and automatic callers.
## Basic, self-heal and special share validation, commitment, timing and impact guard.
const CAPACITY: int = 60
const PAID_COST: int = 20
const PAID_COOLDOWN: float = 3.0
const HEAL_COST: int = 20
const HEAL_COOLDOWN: float = 4.0
const HEAL_AMOUNT: int = 30
const SPECIAL_COST: int = 30
const SPECIAL_COOLDOWN: float = 6.0
const RECOVERY_RATE: float = 5.0
var _owner: StatsActor
var _bound_state: ActorState
var _energy: int = CAPACITY
var _cooldowns: Dictionary = {}
var _retired: bool = false
var _pending_skill: StringName = &""
var _recovery_enabled: bool = false
var _recovery_credit: float = 0.0
var recovered: int = 0
var applied_healing: int = 0
var accepted: int = 0
var spent: int = 0
var cooldown_starts: int = 0
var last_skill: StringName = &""
var last_rejection: String = ""
var energy: int:
	get: return _energy

func _init(owner_actor: StatsActor = null, recover_resource: bool = false, initial_energy: int = CAPACITY) -> void:
	_owner = owner_actor
	_recovery_enabled = recover_resource
	_energy = clampi(initial_energy, 0, CAPACITY)

func remaining(skill: StringName) -> float:
	return float(_cooldowns.get(skill, 0.0))

func begin(source: Variant, target: Variant) -> int:
	# Existing combat callers enter exactly the same gate with the free basic attack.
	if source != _owner:
		last_rejection = "source incorrecte"
		return 0
	return request(&"basic", target)

func request(skill: StringName, target: Variant, paused: bool = false) -> int:
	last_rejection = ""
	if paused:
		return _reject("pause")
	if _retired or not living(_owner):
		return _reject("acteur indisponible")
	if _bound_state != null and _owner.state != _bound_state:
		retire()
		return _reject("etat remplace")
	if skill not in [&"basic", &"paid_test", &"heal", &"special"]:
		return _reject("action inconnue")
	if active:
		return _reject("occupe")
	if remaining(skill) > 0.0:
		return _reject("cooldown")
	if skill == &"heal":
		if target != _owner or _owner.state.health >= _owner.state.max_health:
			return _reject("soin inutile / cible invalide")
	var cost: int = _cost(skill)
	if _energy < cost:
		return _reject("ressource insuffisante")
	_pending_skill = skill
	var id: int = super.begin(_owner, target)
	_pending_skill = &""
	if id == 0:
		return _reject("cible / portee invalide")
	# No signals/callbacks between validation and commitment. Only this path debits.
	_bound_state = _owner.state
	_energy -= cost
	spent += cost
	accepted += 1
	last_skill = skill
	applied_healing = 0
	var duration: float = _cooldown(skill)
	if duration > 0.0:
		_cooldowns[skill] = duration
		cooldown_starts += 1
	return id

func _reject(reason: String) -> int:
	last_rejection = reason
	return 0

func advance(delta: float, paused: bool = false) -> void:
	if paused or _retired or not is_finite(delta) or delta <= 0.0:
		return
	if not living(_owner) or (_bound_state != null and _owner.state != _bound_state):
		retire()
		return
	for skill in _cooldowns.keys():
		var value: float = maxf(0.0, float(_cooldowns[skill]) - delta)
		_cooldowns[skill] = 0.0 if value < 0.000001 else value
	_recover(delta)
	super.advance(delta)

func retire() -> void:
	# Reset/destruction must invalidate old executors even if a caller retained one.
	cancel()
	_retired = true

func _valid_pair(source: StatsActor, target: StatsActor) -> bool:
	if _pending_skill == &"heal":
		return source == target
	return super._valid_pair(source, target)

func _apply_effect() -> int:
	if last_skill == &"heal":
		outcome = "soin"
		applied_healing = _target_state.heal(HEAL_AMOUNT)
		return 0
	if last_skill == &"special":
		return _target_state.damage(maxi(1, 2 * _attack - _target_state.defense))
	return super._apply_effect()

func _cost(skill: StringName) -> int:
	match skill:
		&"paid_test": return PAID_COST
		&"heal": return HEAL_COST
		&"special": return SPECIAL_COST
	return 0

func _cooldown(skill: StringName) -> float:
	match skill:
		&"paid_test": return PAID_COOLDOWN
		&"heal": return HEAL_COOLDOWN
		&"special": return SPECIAL_COOLDOWN
	return 0.0

func _recover(delta: float) -> void:
	if not _recovery_enabled:
		return
	if _energy >= CAPACITY:
		_recovery_credit = 0.0
		return
	var missing: int = CAPACITY - _energy
	# Avoid overflow on a large finite delta, and never bank recovery above capacity.
	if delta >= float(missing) / RECOVERY_RATE:
		_energy = CAPACITY
		recovered += missing
		_recovery_credit = 0.0
		return
	_recovery_credit += delta * RECOVERY_RATE
	var gain: int = mini(missing, floori(_recovery_credit + 0.000001))
	_energy += gain
	recovered += gain
	_recovery_credit = maxf(0.0, _recovery_credit - float(gain))
	if _energy == CAPACITY:
		_recovery_credit = 0.0
