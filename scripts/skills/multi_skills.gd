extends RefCounted
## Multi-target metadata and deterministic final selection, independent of art.
const ID: StringName = &"ice_bolts"
const COUNT: int = 3
const MULTI_REACH: float = 2.5
const DAMAGE: int = 30
const ORBIT: float = .34
const FLIGHT: float = .24
const Actor = preload("res://scripts/combat/attack_action.gd")
static func has(skill: StringName) -> bool: return skill == ID
static func choose(primary, units: Array) -> Array:
	var result: Array = [primary]
	var others: Array = []
	for unit in units:
		if unit == primary or not Actor.living(unit) or unit.team != primary.team: continue
		if Actor.distance_between(primary, unit) <= MULTI_REACH + .000001: others.append(unit)
	others.sort_custom(func(a, b):
		var da: float = Actor.distance_between(primary, a)
		var db: float = Actor.distance_between(primary, b)
		return a.combat_id < b.combat_id if da == db else da < db)
	result.append_array(others.slice(0, COUNT - 1))
	return result
