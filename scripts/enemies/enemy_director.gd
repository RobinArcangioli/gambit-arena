extends Node
## Deterministic diagnostic spawns. This is not the future wave system.
const EnemyUnit = preload("res://scripts/enemies/enemy_unit.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const MAX_ALIVE: int = 20
const SPAWN_INTERVAL: float = 1.0
var actors: Array[EnemyUnit] = []
var actor_world: Node3D
var hero_target: Node3D
var spawning: bool = true
var budget: int = 4
var spawned: int = 0
var elapsed: float = 0.0
var spawn_clock: float = 0.0

static func spawn_position(index: int) -> Vector2:
	var edge: float = Bounds.HALF_EXTENT - Bounds.ACTOR_MARGIN
	var offsets: Array[float] = [0.0, -1.4, 1.4, -0.7, 0.7]
	var offset: float = offsets[int(index / 4.0) % offsets.size()]
	match index % 4:
		0: return Vector2(-edge, offset)
		1: return Vector2(offset, -edge)
		2: return Vector2(edge, offset)
		_: return Vector2(offset, edge)

func configure(parent_world: Node3D, target_node: Node3D) -> void:
	actor_world = parent_world
	set_hero(target_node)

func set_hero(target_node: Node3D) -> void:
	hero_target = target_node
	_prune()
	for actor in actors:
		actor.mover.set_target(target_node)

func _valid_hero() -> bool:
	return is_instance_valid(hero_target) and not hero_target.is_queued_for_deletion() and hero_target.is_inside_tree()

func _prune() -> void:
	for index in range(actors.size() - 1, -1, -1):
		var actor: EnemyUnit = actors[index]
		if not is_instance_valid(actor) or actor.is_queued_for_deletion() or not actor.is_inside_tree():
			actors.remove_at(index)

func advance(delta: float, is_paused: bool = false) -> void:
	if is_paused or delta <= 0.0:
		return
	_prune()
	elapsed += delta
	# Existing actors move first: a new arrival is visible on its spawn edge.
	for actor in actors:
		actor.advance(delta)
	if not spawning or not _valid_hero() or spawned >= budget or actors.size() >= MAX_ALIVE:
		spawn_clock = 0.0
		return
	spawn_clock += delta
	if spawn_clock >= SPAWN_INTERVAL:
		# At most one spawn per tick; no burst after a long frame.
		spawn_clock = fmod(spawn_clock, SPAWN_INTERVAL)
		var actor := EnemyUnit.new()
		actor.enemy = true
		actor.name = "Pursuer%d" % (spawned + 1)
		actor_world.add_child(actor)
		actor.initialize(spawn_position(spawned), hero_target)
		actors.append(actor)
		spawned += 1

func reset(new_budget: int = 4) -> void:
	for actor in actors:
		if is_instance_valid(actor) and not actor.is_queued_for_deletion():
			actor.hide()
			actor.queue_free()
	actors.clear()
	budget = clampi(new_budget, 0, MAX_ALIVE)
	spawned = 0
	elapsed = 0.0
	spawn_clock = 0.0
	spawning = true
