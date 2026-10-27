extends RefCounted
## Shared value-only buff rules, used by both planning and resolution.
const Definition = preload("res://scripts/buffs/buff_definition.gd")
const BOOSTER: StringName = &"booster"
const BOOSTER_DURATION: float = 60.0
const BOOSTER_RATE: float = 1.30
static func is_buff(skill: StringName) -> bool:
	return skill == BOOSTER
static func definition(skill: StringName) -> Dictionary:
	return Definition.create(BOOSTER, BOOSTER_DURATION, BOOSTER_RATE) if is_buff(skill) else {}
static func eligible(skill: StringName, active: Dictionary) -> bool:
	return not is_buff(skill) or not active.has(BOOSTER)
