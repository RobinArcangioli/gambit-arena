extends RefCounted
## Value-only local routing. Chooses a route to the supplied target, never the target.
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const CELL: float = 0.2
const SIDE: int = 27
const OFFSET := Vector2(-2.6, -2.6)
const GRID_PADDING: float = 0.025
const SEGMENT_PADDING: float = 0.006
const REPLAN_INTERVAL: float = 0.35
const TARGET_SHIFT: float = 0.25
const MAX_GOALS: int = 8
var path: Array[Vector2] = []
var status: String = "IDLE"
var target_id: int = -1
var planned_target := Vector2.ZERO
var cooldown: float = 0.0
var blocked_time: float = 0.0
var searches: int = 0
var failed_searches: int = 0
var last_search_usec: int = 0
var max_search_usec: int = 0
var queries: int = 0
var distance_travelled: float = 0.0
var waiting_seconds: float = 0.0
var preferred_side: float = 1.0
var _grid: AStarGrid2D

func reset() -> void:
	clear()
	searches = 0
	failed_searches = 0
	max_search_usec = 0
	queries = 0
	distance_travelled = 0
	waiting_seconds = 0

func clear() -> void:
	path.clear()
	status = "IDLE"
	target_id = -1
	cooldown = 0
	blocked_time = 0
	preferred_side = 1.0

func tick(dt: float) -> void:
	cooldown = maxf(0, cooldown - maxf(0, dt))

func hold() -> void:
	path.clear()
	blocked_time = 0
	status = "HELD"

func request(origin: Vector2, destination: Vector2, identity: int, reach: float,
		speed: float, dt: float, obstacles: Array[Vector2], can_search: bool) -> Vector2:
	if not is_finite(dt) or not is_finite(speed) or dt <= 0 or speed <= 0: return Vector2.ZERO
	if identity != target_id:
		clear()
		target_id = identity
	var offset: Vector2 = destination - origin
	var distance: float = offset.length()
	if distance <= reach + 0.000001:
		hold()
		return Vector2.ZERO
	var stop: float = maxf(0.1, reach - 0.2)
	var direct_goal: Vector2 = destination - offset.normalized() * stop
	if segment_clear(origin, direct_goal, obstacles):
		path.clear()
		blocked_time = 0
		status = "DIRECT"
		return offset.normalized() * minf(speed * dt, distance - stop)
	while not path.is_empty() and origin.distance_to(path[0]) <= 0.045: path.pop_front()
	var stale: bool = destination.distance_to(planned_target) > TARGET_SHIFT
	var blocked: bool = not path.is_empty() and not segment_clear(origin, path[0], obstacles)
	if stale or blocked or blocked_time > 0.25: path.clear()
	if path.is_empty() and cooldown <= 0 and can_search:
		var started: int = Time.get_ticks_usec()
		path = _search(origin, destination, reach, obstacles)
		last_search_usec = Time.get_ticks_usec() - started
		max_search_usec = maxi(max_search_usec, last_search_usec)
		searches += 1
		cooldown = REPLAN_INTERVAL
		planned_target = destination
		blocked_time = 0
		if path.is_empty(): failed_searches += 1
	if path.is_empty():
		status = "WAITING"
		return Vector2.ZERO
	# Revalidate every shortcut against the current disk positions.
	for i in range(path.size() - 1, 0, -1):
		if segment_clear(origin, path[i], obstacles):
			for unused in range(i): path.pop_front()
			break
	if not segment_clear(origin, path[0], obstacles):
		path.clear()
		status = "WAITING"
		return Vector2.ZERO
	var toward: Vector2 = path[0] - origin
	status = "FOLLOWING"
	return toward.normalized() * minf(speed * dt, toward.length())

func observe(before: Vector2, after: Vector2, requested: Vector2, dt: float) -> void:
	var moved: float = before.distance_to(after)
	distance_travelled += moved
	var blocked: bool = requested.length_squared() > 0.00000001 and moved < requested.length() * 0.15
	if status == "WAITING" or blocked: waiting_seconds += dt
	if blocked:
		blocked_time += dt
	else: blocked_time = 0

static func segment_clear(start: Vector2, finish: Vector2, obstacles: Array[Vector2]) -> bool:
	if not Bounds.contains_ground(finish): return false
	var movement: Vector2 = finish - start
	var length_squared: float = movement.length_squared()
	var clearance: float = Crowd.DIAMETER + SEGMENT_PADDING
	for point in obstacles:
		var from: Vector2 = start - point
		if from.length_squared() < clearance * clearance:
			# A touching/overlapped starting pose may move outward, never deepen contact.
			if from.dot(movement) < -0.000001: return false
			continue
		var fraction: float = clampf((point - start).dot(movement) / maxf(0.000000001, length_squared), 0, 1)
		if (start + movement * fraction).distance_squared_to(point) < clearance * clearance: return false
	return true

func _search(origin: Vector2, destination: Vector2, reach: float, obstacles: Array[Vector2]) -> Array[Vector2]:
	if _grid == null:
		_grid = AStarGrid2D.new()
		_grid.region = Rect2i(0, 0, SIDE, SIDE)
		_grid.cell_size = Vector2.ONE * CELL
		_grid.offset = OFFSET
		_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
		_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
		_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
		_grid.update()
	_grid.fill_solid_region(_grid.region, false)
	var direction: Vector2 = (destination - origin).normalized()
	for y in range(SIDE):
		for x in range(SIDE):
			var cell := Vector2i(x, y)
			var world: Vector2 = _world(cell)
			var penalty: float = clampf(-direction.cross(world - origin) * preferred_side, 0, 0.6) * 0.05
			_grid.set_point_weight_scale(cell, 1.0 + penalty)
	var radius: float = Crowd.DIAMETER + GRID_PADDING
	for point in obstacles:
		var center := Vector2i(roundi((point.x - OFFSET.x) / CELL), roundi((point.y - OFFSET.y) / CELL))
		for y in range(maxi(0, center.y - 4), mini(SIDE, center.y + 5)):
			for x in range(maxi(0, center.x - 4), mini(SIDE, center.x + 5)):
				var cell := Vector2i(x, y)
				if _world(cell).distance_squared_to(point) < radius * radius: _grid.set_point_solid(cell)
	var starts: Array[Dictionary] = []
	var goals: Array[Dictionary] = []
	for y in range(SIDE):
		for x in range(SIDE):
			var cell := Vector2i(x, y)
			if _grid.is_point_solid(cell): continue
			var point: Vector2 = _world(cell)
			if point.distance_squared_to(origin) <= 0.6 * 0.6:
				var prefix: Array[Vector2] = _anchor_route(origin, point, obstacles)
				if not prefix.is_empty():
					var length: float = 0
					var previous: Vector2 = origin
					for waypoint in prefix:
						length += previous.distance_to(waypoint)
						previous = waypoint
					starts.append({"cell": cell, "score": length, "prefix": prefix})
			if point.distance_to(destination) <= maxf(Crowd.DIAMETER + GRID_PADDING, reach - 0.03):
				goals.append({"cell": cell, "score": point.distance_to(origin)})
	starts.sort_custom(_score_less)
	goals.sort_custom(_score_less)
	if starts.is_empty() or goals.is_empty(): return []
	for start_index in range(mini(2, starts.size())):
		for goal_index in range(mini(MAX_GOALS, goals.size())):
			queries += 1
			var cells: Array[Vector2i] = _grid.get_id_path(starts[start_index].cell, goals[goal_index].cell)
			if cells.is_empty(): continue
			var result: Array[Vector2] = []
			result.append_array(starts[start_index].prefix)
			var previous: Vector2 = result[-1]
			var safe: bool = true
			for cell in cells:
				var point: Vector2 = _world(cell)
				if previous.distance_to(point) < 0.01: continue
				if not segment_clear(previous, point, obstacles):
					safe = false
					break
				result.append(point)
				previous = point
			if not safe or result.is_empty(): continue
			for point in result:
				var cross: float = direction.cross(point - origin)
				if absf(cross) > 0.15:
					preferred_side = signf(cross)
					break
			return result
	return []

static func _anchor_route(origin: Vector2, point: Vector2, obstacles: Array[Vector2]) -> Array[Vector2]:
	if segment_clear(origin, point, obstacles): return [point]
	# At contact against a boundary, first slide along the boundary before joining
	# the inset grid. Both legs use the same geometric safety check as every edge.
	for corner in [Vector2(origin.x, point.y), Vector2(point.x, origin.y)]:
		if segment_clear(origin, corner, obstacles) and segment_clear(corner, point, obstacles):
			return [corner, point]
	return []

static func _world(cell: Vector2i) -> Vector2:
	return OFFSET + Vector2(cell) * CELL

static func _score_less(a: Dictionary, b: Dictionary) -> bool:
	if not is_equal_approx(a.score, b.score): return a.score < b.score
	return a.cell.y < b.cell.y if a.cell.y != b.cell.y else a.cell.x < b.cell.x
