extends RefCounted
## Logical metadata only. Art and targeting algorithms do not own these values.
const GroundBody=preload("res://scripts/crowd/ground_crowd.gd")
const EPS:float=.000001
const DEFINITIONS={&"meteor":{"radius":1.4,"damage":40,"cost":40,"cast":3.0,"cooldown":4.0,"flight":1.0/1.3}}
static func has(skill:StringName) -> bool:return DEFINITIONS.has(skill)
static func radius(skill:StringName) -> float:return float(DEFINITIONS.get(skill,{}).get("radius",0.0))

## All current actors use GroundBody.RADIUS, also supplied to their footprint shadow.
## Minkowski sum: two closed disks intersect when distance <= the sum of radii.
static func coverage_radius(area_radius:float) -> float:
	return area_radius+GroundBody.RADIUS
static func overlaps(center:Vector2,position:Vector2,area_radius:float) -> bool:
	if not center.is_finite() or not position.is_finite() or not is_finite(area_radius) or area_radius<=0:return false
	var reach:float=coverage_radius(area_radius)
	return center.distance_squared_to(position)<=reach*reach+EPS
