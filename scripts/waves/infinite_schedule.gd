extends RefCounted
## Combat-time intermission and camera-relative NE formation; no art or scene ownership.
const SIZE: int = 6
const DELAY: float = 3.0
var waiting: bool = false
var remaining: float = 0.0
func reset() -> void:
	waiting = false; remaining = 0.0
func begin_wait() -> void:
	if waiting: return
	waiting = true; remaining = DELAY
func advance(dt: float) -> bool:
	if not waiting or not is_finite(dt) or dt <= 0: return false
	remaining = maxf(0.0, remaining - dt)
	if remaining > 0.000001: return false
	reset(); return true
static func formation(occupied: Array[Vector2]) -> Array[Vector2]:
	# All slots are mutually 0.85 apart, inside the ground bounds. At most two
	# heroes can block eight of these sixteen slots; six arrivals always fit.
	var pool: Array[Vector2] = []
	for z in [-2.55, -1.7]:
		for x in [-0.85, 0.0, 0.85]: pool.append(Vector2(x, z))
	for z in [-2.55, -1.7, -0.85, 0.0]:
		for x in [-2.55, -1.7, -0.85, 0.0, 0.85, 1.7, 2.55]:
			var at := Vector2(x, z)
			if x >= z and x + z <= 0.00001 and not at in pool: pool.append(at)
	var result: Array[Vector2] = []
	for at in pool:
		var free: bool = true
		for other in occupied:
			if at.distance_to(other) < 0.71: free = false; break
		if free: result.append(at)
		if result.size() == SIZE: return result
	return []
