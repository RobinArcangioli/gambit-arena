extends Node
## One deterministic coordinator. No unit ticks itself.
const GameClock = preload("res://scripts/core/game_clock.gd")
var clock := GameClock.new()
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
var controller := Controller.new()
const Manual = preload("res://scripts/manual/manual_commands.gd")
var manual := Manual.new()
# Historical labs remain automatic; the STEP-023 lab opts into manual commands.
var manual_enabled: bool = false
const Wave = preload("res://scripts/waves/wave_schedule.gd")
var wave := Wave.new()
var wave_enabled: bool = false
# Opt-in: historical single-wave labs retain their original behavior.
var sequence_enabled: bool = false
var wave_number: int = 1
var wave_count: int = 1
var wave_start_defeated: int = 0
var wave_start_removed: int = 0
var completed_waves: Array[Dictionary] = []
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
var run_id: int = 0
var terminal_count: int = 0
var _final_report: Dictionary = {}
var final_report: Dictionary:
	get: return _final_report.duplicate(true)

func configure(parent_world: Node3D) -> void:
	world = parent_world

func clear() -> void:
	clock.stopped = true
	manual.clear()
	controller.stop(hero, "clear", clock.elapsed)
	for unit in enemies:
		_dispose(unit)
	enemies.clear()
	_dispose(hero)
	hero = null

func _dispose(unit: Variant) -> void:
	if is_instance_valid(unit):
		unit.action.retire()
		unit.mover.clear_target()
		unit.clear_enemy_focus()
		unit.hide()
		if not unit.is_queued_for_deletion():
			unit.queue_free()

func reset(mode: int = 0) -> void:
	clear()
	run_id += 1
	terminal_count = 0
	_final_report.clear()
	clock.reset()
	controller.reset()
	manual.reset()
	elapsed = 0.0
	spawn_clock = 0.0
	spawned = 0
	defeated = 0
	removed = 0
	hits = 0
	peak_alive = 0
	max_step = 0.0
	wave.reset(24 if mode == 2 else 12, 20 if mode == 2 else 6)
	wave_count = 3 if sequence_enabled and wave_enabled else 1
	wave_number = 1
	wave_start_defeated = 0
	wave_start_removed = 0
	completed_waves.clear()
	budget = wave.total * wave_count if wave_enabled else (20 if mode == 2 else 3)
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
	if not wave_enabled and mode != 2:
		for index in range(3):
			add_enemy(Pattern.spawn_position(index))
	_present()

func add_enemy(at: Vector2) -> bool:
	if wave_enabled and wave.issued >= wave.total:
		return false
	if result != "EN COURS" or not Action.living(hero) or spawned >= budget or enemies.size() >= (wave.cap if wave_enabled else 20) or not Bounds.contains_ground(at):
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
	if wave_enabled:
		wave.confirm_spawn()
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
	if result != "EN COURS":
		return true
	var outcome: String = ""
	if not Action.living(hero):
		outcome = "DEFAITE"
	elif wave_enabled and wave.issued >= wave.total and enemies.is_empty():
		if removed > 0:
			outcome = "INTERROMPU"
		else:
			# Archive once, after pruning, before resetting only the arrival schedule.
			if completed_waves.size() < wave_number:
				completed_waves.append(wave_snapshot())
			if wave_number < wave_count:
				wave_number += 1
				wave_start_defeated = defeated
				wave_start_removed = removed
				wave.reset(wave.total, wave.cap)
				controller.stop(hero, "wave", clock.elapsed)
				return false
			outcome = "VICTOIRE"
	elif spawned >= budget and enemies.is_empty():
		outcome = "VICTOIRE" if removed == 0 else "INTERROMPU"
	else:
		return false
	return _end_run(outcome)

func _end_run(outcome: String) -> bool:
	# Only one terminal transition, even if callbacks or later ticks observe death again.
	if result != "EN COURS":
		return true
	result = outcome
	terminal_count += 1
	clock.stopped = true
	manual.clear("terminal")
	controller.stop(hero, "terminal", clock.elapsed)
	for unit in enemies:
		unit.action.retire()
		unit.mover.clear_target()
		unit.clear_enemy_focus()
	if is_instance_valid(hero):
		hero.action.retire()
		hero.mover.clear_target()
		hero.clear_enemy_focus()
	_final_report = {"run_id": run_id, "result": result, "elapsed": elapsed,
		"wave": wave_number, "waves": wave_count, "completed": completed_waves.size(),
		"spawned": spawned, "budget": budget, "defeated": defeated, "removed": removed,
		"alive": enemies.size(), "hits": hits, "peak_alive": peak_alive}
	_present()
	return true

func _choose_enemy_targets() -> void:
	for unit in enemies:
		unit.mover.set_target(hero)

func advance(delta: float, paused: bool = false) -> void:
	# Lifecycle death can be observed during pause without advancing any gameplay time.
	if result == "EN COURS" and is_instance_valid(hero) and not Action.living(hero):
		_prune()
		_end_run("DEFAITE")
		return
	if manual.pending and (not manual_enabled or clock.stopped or not Action.living(hero)):
		manual.clear("terminal")
	if paused or not clock.permits_gameplay() or result != "EN COURS" or not is_finite(delta) or delta <= 0.0:
		return
	_prune()
	if _finish_if_needed():
		return
	var dt: float = clock.step(delta)
	elapsed = clock.elapsed
	var manual_priority: bool = manual_enabled and manual.prepare(hero, enemies, clock)
	if not manual_priority:
		controller.plan(dt, hero, enemies, clock)
	_choose_enemy_targets()
	var units: Array[Unit] = [hero]
	units.append_array(enemies)
	var points: Array[Vector2] = []
	var requests: Array[Vector2] = []
	var corrections: Array[bool] = []
	for unit in units:
		var start: Vector2 = unit.mover.ground_position
		points.append(start)
		unit.mover.velocity = Vector2.ZERO
		# A selected target already in attack range needs no extra approach step.
		# Otherwise the 0.8 mover stop vs 1.0 attack reach makes the idle hero
		# creep forward between actions. Enemies keep their existing spacing.
		var hold_attack_position: bool = unit == hero and Action.living(unit.mover.target) and Action.distance_between(unit, unit.mover.target) <= Action.REACH
		if not unit.action.active and not hold_attack_position:
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
	_choose_enemy_targets()
	if manual_enabled and manual.prepare(hero, enemies, clock, false):
		manual.execute(hero, enemies, clock)
	else:
		# A target can die during existing impacts; resume gambits on this tick.
		if manual_priority:
			controller.plan(dt, hero, enemies, clock)
		controller.execute(hero, enemies, clock)
	units.assign(enemies)
	# Newly engaged actions receive no time until the next common tick.
	for unit in units:
		if not unit.action.active and Action.living(unit.mover.target):
			if unit.action.begin(unit, unit.mover.target) > 0:
				var offset: Vector3 = unit.mover.target.position - unit.position
				unit.mover.facing = Vector2(offset.x, offset.z).normalized()
	_advance_spawning(dt)
	_present()

func _advance_spawning(dt: float) -> void:
	if wave_enabled:
		if wave.advance(dt, enemies.size()):
			for attempt in range(20):
				if add_enemy(Pattern.spawn_position((spawned + attempt) % 20)):
					break
		return
	if spawned < budget:
		spawn_clock += dt
		if spawn_clock >= 1.0:
			spawn_clock = 0.0
			for attempt in range(20):
				if add_enemy(Pattern.spawn_position((spawned + attempt) % 20)):
					break

func _present() -> void:
	if is_instance_valid(hero):
		hero.present()
	for unit in enemies:
		unit.present()

func request_manual(skill: StringName) -> bool:
	if not manual_enabled or result != "EN COURS":
		return false
	if not manual.submit(skill, hero, enemies, clock):
		return false
	# Forget only the automatic intention, never interrupt the executor.
	controller.stop(hero, "manual", clock.elapsed)
	return true

func _exit_tree() -> void:
	clear()

func wave_snapshot() -> Dictionary:
	# Detached scalar values: callers cannot mutate the authoritative counters.
	return {"number": wave_number, "total": wave.total, "spawned": wave.issued,
		"defeated": defeated - wave_start_defeated, "removed": removed - wave_start_removed,
		"alive": enemies.size(), "remaining": wave.total - wave.issued}
