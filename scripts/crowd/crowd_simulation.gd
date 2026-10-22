extends Node
## Shared tick orchestrator. Legacy STEP-007/008 scripts remain unchanged.
const GroundMover = preload("res://scripts/movement/ground_mover.gd")
const GroundCrowd = preload("res://scripts/crowd/ground_crowd.gd")
const EnemyUnit = preload("res://scripts/enemies/enemy_unit.gd")
const SpawnPattern = preload("res://scripts/enemies/enemy_director.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
var actors: Array[EnemyUnit] = []
var hero: Node3D
var actor_world: Node3D
var hero_mover := GroundMover.new()
var hero_gait: float = 0.0
var elapsed: float = 0.0
var spawn_clock: float = 0.0
var spawned: int = 0
var spawning: bool = true
var freeze_enemies: bool = false
var blocked_count: int = 0
var max_step: float = 0.0
var minimum_gap: float = INF

func configure(world_node: Node3D, hero_node: Node3D) -> void:
	actor_world = world_node
	hero = hero_node

func reset(start: Vector2) -> void:
	for actor in actors:
		if is_instance_valid(actor) and not actor.is_queued_for_deletion():
			actor.hide()
			actor.queue_free()
	actors.clear()
	hero_mover.reset(start)
	hero_mover.stopping_distance = 0.0
	hero.position = Vector3(start.x, 0, start.y)
	hero_gait = 0.0
	elapsed = 0.0
	spawn_clock = 0.0
	spawned = 0
	spawning = true
	freeze_enemies = false
	blocked_count = 0
	max_step = 0.0
	minimum_gap = INF

func add_enemy(at: Vector2, allow_overlap: bool = false) -> bool:
	# allow_overlap is only used by the explicit depenetration fixture.
	_prune()
	if actors.size() >= 20 or not Bounds.contains_ground(at):
		return false
	if not allow_overlap:
		if at.distance_to(Vector2(hero.position.x, hero.position.z)) < GroundCrowd.DIAMETER + 0.01:
			return false
		for actor in actors:
			if at.distance_to(actor.mover.ground_position) < GroundCrowd.DIAMETER + 0.01:
				return false
	var actor := EnemyUnit.new()
	actor.enemy = true
	actor.name = "CrowdEnemy%d" % spawned
	actor_world.add_child(actor)
	actor.initialize(at, hero)
	actors.append(actor)
	spawned += 1
	return true

func _prune() -> void:
	for index in range(actors.size() - 1, -1, -1):
		if not is_instance_valid(actors[index]) or actors[index].is_queued_for_deletion() or not actors[index].is_inside_tree():
			actors.remove_at(index)

func advance(delta: float, is_paused: bool = false) -> void:
	if is_paused or delta <= 0.0:
		return
	_prune()
	if not is_instance_valid(hero) or hero.is_queued_for_deletion() or not hero.is_inside_tree():
		for actor in actors:
			actor.mover.clear_target()
			actor.pose(actor.gait_time, false, actor.mover.facing)
		return
	var dt: float = GroundCrowd.safe_delta(delta)
	elapsed += dt
	var points: Array[Vector2] = [hero_mover.ground_position]
	var movers: Array[GroundMover] = [hero_mover]
	for actor in actors:
		points.append(actor.mover.ground_position)
		movers.append(actor.mover)
	var requests: Array[Vector2] = []
	var corrections: Array[bool] = []
	for index in range(movers.size()):
		var mover: GroundMover = movers[index]
		if index == 0 or not freeze_enemies:
			mover.step(dt)
		requests.append(mover.ground_position - points[index])
		mover.ground_position = points[index]
		# Hero is never passively pushed; stationary ring actors are fixtures.
		corrections.append(index > 0 and not freeze_enemies)
	var resolved: Array[Vector2] = GroundCrowd.solve(points, requests, corrections, dt)
	hero.position = Vector3(resolved[0].x, 0, resolved[0].y)
	blocked_count = 0
	for index in range(movers.size()):
		var mover: GroundMover = movers[index]
		var displacement: Vector2 = resolved[index] - points[index]
		mover.ground_position = resolved[index]
		mover.velocity = displacement / dt
		max_step = maxf(max_step, displacement.length())
		if mover.velocity.length_squared() > 0.000001:
			mover.facing = mover.velocity.normalized()
		_update_state(mover)
		if mover.state == GroundMover.State.BLOCKED and (index == 0 or not freeze_enemies):
			blocked_count += 1
	hero.position = Vector3(resolved[0].x, 0, resolved[0].y)
	if hero_mover.velocity.length_squared() > 0.000001:
		hero_gait += dt
	for index in range(actors.size()):
		var actor: EnemyUnit = actors[index]
		actor.position = Vector3(resolved[index + 1].x, 0, resolved[index + 1].y)
		var walking: bool = actor.mover.velocity.length_squared() > 0.000001
		if walking:
			actor.gait_time += dt
		actor.pose(actor.gait_time, walking, actor.mover.facing)
	minimum_gap = GroundCrowd.minimum_distance(resolved)
	if spawning and spawned < 20:
		spawn_clock += dt
		if spawn_clock >= 1.0:
			spawn_clock = 0.0
			# Try existing entry points; defer if all are busy, never force overlap.
			for attempt in range(20):
				if add_enemy(SpawnPattern.spawn_position((spawned + attempt) % 20)):
					break
	else:
		spawn_clock = 0.0

func _update_state(mover: GroundMover) -> void:
	if not mover.has_valid_target():
		mover.state = GroundMover.State.NO_TARGET
		mover.distance_to_target = -1.0
		return
	var target_ground := Vector2(mover.target.position.x, mover.target.position.z)
	mover.distance_to_target = mover.ground_position.distance_to(target_ground)
	if mover.distance_to_target <= mover.stopping_distance + 0.001:
		mover.state = GroundMover.State.ARRIVED
	elif mover.velocity.length_squared() < 0.000001:
		mover.state = GroundMover.State.BLOCKED
	else:
		mover.state = GroundMover.State.MOVING
