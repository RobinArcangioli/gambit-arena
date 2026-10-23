extends "res://scripts/combat/attack_action.gd"
## Shared execution gate. One instance per actor, used by manual and automatic callers.
## Both diagnostic entries use the proven attack effect; actual skills follow in STEP-014.
const CAPACITY: int = 60
const PAID_COST: int = 20
const PAID_COOLDOWN: float = 3.0
var _owner: StatsActor
var _bound_state: ActorState
var _energy: int = CAPACITY
var _cooldowns: Dictionary = {}
var _retired: bool = false
var accepted: int = 0
var spent: int = 0
var cooldown_starts: int = 0
var last_skill: StringName = &""
var last_rejection: String = ""
var energy: int:
	get: return _energy

func _init(owner_actor: StatsActor = null) -> void:
	_owner = owner_actor

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
	if skill != &"basic" and skill != &"paid_test":
		return _reject("action inconnue")
	if active:
		return _reject("occupe")
	if remaining(skill) > 0.0:
		return _reject("cooldown")
	var cost: int = PAID_COST if skill == &"paid_test" else 0
	if _energy < cost:
		return _reject("ressource insuffisante")
	var id: int = super.begin(_owner, target)
	if id == 0:
		return _reject("cible / portee invalide")
	# No signals/callbacks between validation and commitment. Only this path debits.
	_bound_state = _owner.state
	_energy -= cost
	spent += cost
	accepted += 1
	last_skill = skill
	if skill == &"paid_test":
		_cooldowns[skill] = PAID_COOLDOWN
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
	super.advance(delta)

func retire() -> void:
	# Reset/destruction must invalidate old executors even if a caller retained one.
	cancel()
	_retired = true
