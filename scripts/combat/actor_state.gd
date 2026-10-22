extends RefCounted
## Runtime state owned by exactly one actor. No scene or rendering dependency.
const ActorProfile = preload("res://scripts/combat/actor_profile.gd")
signal health_changed(current: int, maximum: int)
signal died
signal stats_changed
var _max_health: int = 1
var _health: int = 1
var _attack: int = 0
var _defense: int = 0
var _move_speed: float = 0.0
var max_health: int:
	get: return _max_health
var health: int:
	get: return _health
var attack: int:
	get: return _attack
var defense: int:
	get: return _defense
var move_speed: float:
	get: return _move_speed
var alive: bool:
	get: return _health > 0

func _init(profile: ActorProfile = null) -> void:
	if profile == null:
		profile = ActorProfile.new()
	_max_health = clampi(profile.max_health, 1, 1000000)
	_health = _max_health
	_attack = clampi(profile.attack, 0, 1000000)
	_defense = clampi(profile.defense, 0, 1000000)
	_move_speed = clampf(profile.move_speed, 0.0, 100.0) if is_finite(profile.move_speed) else 0.0

func damage(amount: int) -> int:
	# Receives final damage. Defense/action formulas belong to STEP-011.
	if amount <= 0 or not alive:
		return 0
	var applied: int = mini(amount, _health)
	_health -= applied
	health_changed.emit(_health, _max_health)
	if _health == 0:
		died.emit()
	return applied

func heal(amount: int) -> int:
	# A heal cannot resurrect. A reset constructs a fresh ActorState.
	if amount <= 0 or not alive:
		return 0
	var applied: int = mini(amount, _max_health - _health)
	if applied > 0:
		_health += applied
		health_changed.emit(_health, _max_health)
	return applied

func set_attack(value: int) -> void:
	var bounded: int = clampi(value, 0, 1000000)
	if _attack != bounded:
		_attack = bounded
		stats_changed.emit()
