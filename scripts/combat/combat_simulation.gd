extends Node
## One deterministic coordinator. No unit ticks itself.
const GameClock = preload("res://scripts/core/game_clock.gd")
var clock := GameClock.new()
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
var world: Node3D
var hero: Unit
var enemies: Array[Unit] = []
var elapsed: float = 0.0
var spawn_clock: float = 0.0
var spawned: int = 0
var defeated: int = 0
var removed: int = 0
var budget: int = 3
var hits: int = 0
var peak_alive: int = 0
var max_step: float = 0.0
var result: String = "EN COURS"

func configure(parent_world: Node3D) -> void:
	world = parent_world

func clear() -> void:
	for unit in enemies:
		_dispose(unit)
	enemies.clear()
	_dispose(hero)
	hero = null

func _dispose(unit: Variant) -> void:
	if is_instance_valid(unit):
		unit.action.retire()
		unit.hide()
		if not unit.is_queued_for_deletion():
			unit.queue_free()

func reset(mode: int = 0) -> void:
	clear()
	clock.reset()
	elapsed = 0.0
	spawn_clock = 0.0
	spawned = 0
	defeated = 0
	removed = 0
	hits = 0
	peak_alive = 0
	max_step = 0.0
	budget = 20 if mode == 2 else 3
	result = "EN COURS"
	hero = Unit.new()
	# Local diagnostic profiles; shipped .tres Resources remain untouched.
	var profile = HERO.duplicate()
	if mode == 0:
		profile.max_health = 250
		profile.attack = 30
	elif mode == 2:
		profile.max_health = 2500
	hero.configure(profile)
	hero.action.bind_clock(clock)
	hero.name = "CombatHero"
	world.add_child(hero)
	hero.place(Vector2.ZERO)
	if mode != 2:
		for index in range(3):
			add_enemy(Pattern.spawn_position(index))
	_present()

func add_enemy(at: Vector2) -> bool:
	if result != "EN COURS" or not Action.living(hero) or spawned >= budget or enemies.size() >= 20 or not Bounds.contains_ground(at):
		return false
	if at.distance_to(hero.mover.ground_position) < Crowd.DIAMETER + 0.01:
		return false
	for unit in enemies:
		if Action.living(unit) and at.distance_to(unit.mover.ground_position) < Crowd.DIAMETER + 0.01:
			return false
	var unit := Unit.new()
	unit.enemy = true
	unit.configure(ENEMY)
	unit.action.bind_clock(clock)
	unit.serial = spawned + 1
	unit.name = "CombatEnemy%d" % unit.serial
	world.add_child(unit)
	unit.place(at)
	enemies.append(unit)
	spawned += 1
	peak_alive = maxi(peak_alive, enemies.size())
	return true

func _prune() -> void:
	for index in range(enemies.size() - 1, -1, -1):
		var unit = enemies[index]
		if not Action.living(unit):
			if is_instance_valid(unit) and not unit.state.alive:
				defeated += 1
			else:
				removed += 1
			_dispose(unit)
			enemies.remove_at(index)

func _finish_if_needed() -> bool:
	if not Action.living(hero):
		result = "DEFAITE"
	elif spawned >= budget and enemies.is_empty():
		result = "VICTOIRE" if removed == 0 else "INTERROMPU"
	else:
		return false
	clock.stopped = true
	for unit in enemies:
		unit.action.retire()
		unit.mover.clear_target()
	if is_instance_valid(hero):
		hero.action.retire()
		hero.mover.clear_target()
	_present()
	return true

func _choose_targets() -> void:
	# Keep a living target until its death; nearest wins, insertion order breaks ties.
	if not Action.living(hero.mover.target):
		var nearest: Unit = null
		var distance: float = INF
		for unit in enemies:
			var candidate: float = hero.position.distance_squared_to(unit.position)
			if candidate < distance:
				nearest = unit
				distance = candidate
		hero.mover.set_target(nearest)
	for unit in enemies:
		unit.mover.set_target(hero)

func advance(delta: float, paused: bool = false) -> void:
	if paused or not clock.permits_gameplay() or result != "EN COURS" or not is_finite(delta) or delta <= 0.0:
		return
	_prune()
	if _finish_if_needed():
		return
	var dt: float = clock.step(delta)
	elapsed = clock.elapsed
	_choose_targets()
	var units: Array[Unit] = [hero]
	units.append_array(enemies)
	var points: Array[Vector2] = []
	var requests: Array[Vector2] = []
	var corrections: Array[bool] = []
	for unit in units:
		var start: Vector2 = unit.mover.ground_position
		points.append(start)
		unit.mover.velocity = Vector2.ZERO
		if not unit.action.active:
			unit.mover.step(dt)
		requests.append(unit.mover.ground_position - start)
		unit.mover.ground_position = start
		corrections.append(unit != hero and not unit.action.active)
	var resolved: Array[Vector2] = Crowd.solve(points, requests, corrections, dt)
	for index in range(units.size()):
		var unit: Unit = units[index]
		var movement: Vector2 = resolved[index] - points[index]
		unit.mover.ground_position = resolved[index]
		unit.mover.velocity = movement / dt
		max_step = maxf(max_step, movement.length())
		if movement.length_squared() > 0.00000001:
			unit.gait += dt
			unit.mover.facing = movement.normalized()
		unit.position = Vector3(resolved[index].x, 0, resolved[index].y)
	# Existing actions first, hero then stable enemy order. Dead units cannot retaliate.
	for unit in units:
		if not Action.living(hero):
			break
		if not Action.living(unit):
			unit.action.retire()
			continue
		var was_resolved: bool = unit.action.resolved
		unit.action.advance(dt)
		if not was_resolved and unit.action.resolved and unit.action.applied_damage > 0:
			hits += 1
	_prune()
	if _finish_if_needed():
		return
	_choose_targets()
	units.assign([hero])
	units.append_array(enemies)
	# Newly engaged actions receive no time until the next common tick.
	for unit in units:
		if not unit.action.active and Action.living(unit.mover.target):
			if unit.action.begin(unit, unit.mover.target) > 0:
				var offset: Vector3 = unit.mover.target.position - unit.position
				unit.mover.facing = Vector2(offset.x, offset.z).normalized()
	if spawned < budget:
		spawn_clock += dt
		if spawn_clock >= 1.0:
			spawn_clock = 0.0
			for attempt in range(20):
				if add_enemy(Pattern.spawn_position((spawned + attempt) % 20)):
					break
	_present()

func _present() -> void:
	if is_instance_valid(hero):
		hero.present()
	for unit in enemies:
		unit.present()
