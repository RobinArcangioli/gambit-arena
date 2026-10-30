extends RefCounted
## Logical metadata only. Art and targeting algorithms do not own these values.
const DEFINITIONS={&"meteor":{"radius":1.4,"damage":40,"cost":40,"cast":3.0,"cooldown":4.0,"flight":1.0}}
static func has(skill:StringName) -> bool:return DEFINITIONS.has(skill)
static func radius(skill:StringName) -> float:return float(DEFINITIONS.get(skill,{}).get("radius",0.0))
