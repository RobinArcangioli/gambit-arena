extends RefCounted
## Logical chain rules; presentation never chooses targets or damage.
const ID: StringName = &"chain_lightning"
const COUNT: int = 4
const MULTI_REACH: float = 2.5
const INTERVAL: float = .1
const Actor = preload("res://scripts/combat/attack_action.gd")
static func has(skill: StringName) -> bool: return skill == ID
static func damage(index: int) -> int: return roundi(30.0 * pow(.8, index))
static func next_target(at: Vector3, units: Array, source_team: int, visited: Array):
	var best = null
	var nearest: float = INF
	for unit in units:
		if not Actor.living(unit) or unit.team == source_team or unit.combat_id in visited: continue
		var distance: float = Vector2(at.x,at.z).distance_squared_to(Vector2(unit.position.x,unit.position.z))
		if distance > MULTI_REACH * MULTI_REACH + .000001: continue
		if best == null or distance < nearest or (distance == nearest and unit.combat_id < best.combat_id):
			best = unit; nearest = distance
	return best
