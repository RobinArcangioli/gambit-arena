extends RefCounted
## Conservative ground disks: bounded depenetration, then swept movement.
## No pathfinding, force impulses, random jitter or teleporting out of congestion.
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const RADIUS: float = 0.35
const DIAMETER: float = RADIUS * 2.0
const SEPARATION_SPEED: float = 0.6
const MAX_DELTA: float = 1.0 / 30.0
const SKIN: float = 0.0001
const EPSILON: float = 0.000001

static func safe_delta(delta: float) -> float:
	return clampf(delta, 0.0, MAX_DELTA)

static func solve(points: Array[Vector2], requests: Array[Vector2],
		correction_enabled: Array[bool], delta: float) -> Array[Vector2]:
	assert(points.size() == requests.size() and points.size() == correction_enabled.size())
	var result: Array[Vector2] = points.duplicate()
	var dt: float = safe_delta(delta)
	if dt <= 0.0:
		return result
	# Stable order: hero first, then enemies in insertion order.
	for index in range(result.size()):
		if correction_enabled[index]:
			var correction := Vector2.ZERO
			for other in range(result.size()):
				if other == index:
					continue
				var difference: Vector2 = result[index] - result[other]
				var distance: float = difference.length()
				if distance < DIAMETER:
					var normal: Vector2 = difference / distance if distance > EPSILON else _tie_normal(index, other)
					correction += normal * (DIAMETER - distance) * 0.5
			correction = correction.limit_length(SEPARATION_SPEED * dt)
			result[index] = _sweep(index, result, correction)
		result[index] = _sweep(index, result, requests[index].limit_length(1.2 * dt))
	return result

static func _tie_normal(index: int, other: int) -> Vector2:
	# Antisymmetric and reproducible for exactly coincident centers.
	var angle: float = float((mini(index, other) * 31 + maxi(index, other) * 17) % 360) * PI / 180.0
	var normal := Vector2(cos(angle), sin(angle))
	return normal if index < other else -normal

static func _sweep(index: int, points: Array[Vector2], requested: Vector2) -> Vector2:
	var start: Vector2 = points[index]
	var movement: Vector2 = Bounds.clamp_ground(start + requested) - start
	var length_squared: float = movement.length_squared()
	if length_squared <= EPSILON * EPSILON:
		return start
	var fraction: float = 1.0
	for other in range(points.size()):
		if other == index:
			continue
		var offset: Vector2 = start - points[other]
		var along: float = offset.dot(movement)
		var clearance: float = offset.length_squared() - DIAMETER * DIAMETER
		if clearance < -EPSILON:
			# Existing overlaps may open, but are never deliberately deepened.
			if along < -EPSILON:
				fraction = 0.0
			continue
		if along >= 0.0:
			continue
		var discriminant: float = along * along - length_squared * maxf(0.0, clearance)
		if discriminant < 0.0:
			continue
		var impact: float = (-along - sqrt(discriminant)) / length_squared
		if impact >= 0.0 and impact <= 1.0:
			fraction = minf(fraction, maxf(0.0, impact - SKIN / sqrt(length_squared)))
	return start + movement * fraction

static func minimum_distance(points: Array[Vector2]) -> float:
	var minimum: float = INF
	for index in range(points.size()):
		for other in range(index + 1, points.size()):
			minimum = minf(minimum, points[index].distance_to(points[other]))
	return minimum
