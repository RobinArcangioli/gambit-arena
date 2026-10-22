extends RefCounted
## Ground units: Vector2.x -> world X, Vector2.y -> world Z.
const HALF_EXTENT: float = 3.0
const ACTOR_MARGIN: float = 0.35

static func clamp_ground(point: Vector2, margin: float = ACTOR_MARGIN) -> Vector2:
	var limit: float = maxf(0.0, HALF_EXTENT - maxf(0.0, margin))
	return Vector2(clampf(point.x, -limit, limit), clampf(point.y, -limit, limit))

static func contains_ground(point: Vector2, margin: float = ACTOR_MARGIN) -> bool:
	return point.is_equal_approx(clamp_ground(point, margin))
