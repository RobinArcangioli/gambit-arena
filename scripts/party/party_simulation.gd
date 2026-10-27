extends Node
## Party coordinator: no artistic resources and no UI callbacks during a tick.
const Roster = preload("res://scripts/party/party_roster.gd")
const Unit = preload("res://scripts/party/party_unit.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
var orders_enabled: bool = false
const Rules = preload("res://scripts/party/party_rules.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Wave = preload("res://scripts/waves/wave_schedule.gd")
const InfiniteSchedule = preload("res://scripts/waves/infinite_schedule.gd")
var infinite_mode: bool = false
var infinite := InfiniteSchedule.new()
const ANNE = preload("res://data/party/anne.tres")
const MAKO = preload("res://data/party/mako.tres")
const ENEMY = preload("res://data/party/skeleton.tres")
const MAX_NAV_SEARCHES_PER_TICK: int = 1
var navigation_enabled: bool = true
var navigation_obstacles: Array[Vector2] = []
var navigation_cursor: int = 0
var navigation_searches_last_tick: int = 0
var world: Node3D
var clock := Clock.new()
var wave := Wave.new()
var heroes: Array[Unit] = []
var enemies: Array[Unit] = []
var rules: Dictionary = {"anne": Rules.defaults(&"anne"), "mako": Rules.defaults(&"mako")}
var result: String = "EN COURS"
var run_id: int = 0
var spawned: int = 0
var defeated: int = 0
var wave_number: int = 1
var wave_count: int = 3
var total_per_wave: int = 12
var max_alive: int = 6
var hits: int = 0
var terminal_count: int = 0
var feedback: String = ""
# Value-only resolutions for later presentation stages. Bounded per accepted tick.
var _events: Array[Dictionary] = []
var events: Array[Dictionary]:
	get: return _events.duplicate(true)
const MAX_VISUAL_EVENTS: int = 384
var _pending_deaths: Array[Dictionary] = []
var _death_ids: Dictionary = {}

func configure(parent_world: Node3D) -> void:
	world = parent_world

func reset() -> void:
	clear()
	run_id += 1
	result = "EN COURS"
	clock.reset()
	spawned = 0
	defeated = 0
	hits = 0
	terminal_count = 0
	wave_number = 1
	feedback = ""
	infinite.reset()
	wave.reset(InfiniteSchedule.SIZE if infinite_mode else total_per_wave, InfiniteSchedule.SIZE if infinite_mode else max_alive)
	for profile in [ANNE, MAKO]:
		var unit := Unit.new()
		unit.configure_party(profile)
		unit.team_slot = Roster.rank(profile.actor_key)
		unit.action.clock = clock
		unit.action.unrestricted_targets = orders_enabled
		unit.state.died.connect(_record_death.bind(unit))
		unit.name = profile.display_name
		world.add_child(unit)
		unit.place(Vector2(-0.65, 0.65) if profile == ANNE else Vector2(0.65, -0.65))
		heroes.append(unit)
		if infinite_mode: unit.place(Vector2(-0.425 if profile == ANNE else 0.425, 1.7))
	if infinite_mode: _spawn_infinite_wave()

func living_heroes() -> Array[Unit]:
	var alive: Array[Unit] = []
	for unit in heroes:
		if Executor.living(unit): alive.append(unit)
	return alive

func all_units() -> Array[Unit]:
	var units: Array[Unit] = []
	units.append_array(heroes)
	units.append_array(enemies)
	return units

func hero(key: StringName) -> Unit:
	for unit in heroes:
		if unit.actor_key == key: return unit
	return null

func add_enemy(at: Vector2) -> bool:
	if result != "EN COURS" or wave.issued >= wave.total or enemies.size() >= wave.cap or not Bounds.contains_ground(at): return false
	for unit in all_units():
		if Executor.living(unit) and at.distance_to(unit.mover.ground_position) < Crowd.DIAMETER + 0.01: return false
	var unit := Unit.new()
	unit.configure_party(ENEMY)
	unit.team_slot = spawned
	unit.name = "Skeleton%d" % (spawned + 1)
	unit.action.clock = clock
	unit.action.unrestricted_targets = orders_enabled
	unit.state.died.connect(_record_death.bind(unit))
	world.add_child(unit)
	unit.place(at)
	enemies.append(unit)
	spawned += 1
	wave.confirm_spawn()
	return true

func _prune() -> void:
	for i in range(enemies.size() - 1, -1, -1):
		if not Executor.living(enemies[i]):
			if is_instance_valid(enemies[i]) and not enemies[i].state.alive: defeated += 1
			_dispose(enemies[i])
			enemies.remove_at(i)
	for unit in heroes:
		if not Executor.living(unit):
			unit.pending.clear()
			unit.clear_intention()
			unit.action.retire()
			unit.navigation.clear()
			unit.hide()

func advance(delta: float, paused: bool = false) -> void:
	_events.clear()
	_collect_visual_events(all_units())
	if result != "EN COURS": return
	_prune()
	if living_heroes().is_empty():
		_finish("DEFAITE")
		return
	if paused or not clock.permits_gameplay() or not is_finite(delta) or delta <= 0.0: return
	var dt: float = clock.step(delta)
	# Freeze the accepted personal steps before effects: a buff received during this
	# tick starts affecting the next tick, independent of actor processing order.
	for unit in all_units():
		if Executor.living(unit): unit.advance_time(dt)
	# Stable order: Anne, Mako, then enemy creation order. Dead actors never retaliate.
	for unit in all_units():
		if not Executor.living(unit): continue
		var resolved_before: bool = unit.action.resolved
		unit.action.advance(dt, false, unit.personal_delta)
		if not resolved_before and unit.action.resolved and unit.action.outcome in ["impact", "soin", "PV pleins", "hors portee"]:
			if unit.action.applied_damage > 0: hits += 1
	_collect_visual_events(all_units())
	_prune()
	if living_heroes().is_empty():
		_finish("DEFAITE")
		return
	if infinite_mode:
		if not infinite.waiting and wave.issued >= wave.total and enemies.is_empty():
			infinite.begin_wait()
		elif infinite.waiting and infinite.advance(dt):
			wave_number += 1
			wave.reset(InfiniteSchedule.SIZE, InfiniteSchedule.SIZE)
			_spawn_infinite_wave()
			# Completed enemy lifetimes must not accumulate in an endless run.
			var keep: Dictionary = {}
			for unit in heroes:
				if _death_ids.has(unit.combat_id): keep[unit.combat_id] = true
			_death_ids = keep
	elif wave.issued >= wave.total and enemies.is_empty():
		if wave_number >= wave_count:
			_finish("VICTOIRE")
			return
		wave_number += 1
		wave.reset(total_per_wave, max_alive)
	for unit in all_units():
		if Executor.living(unit): _plan(unit)
	_move(dt, true)
	for unit in all_units():
		if not Executor.living(unit) or unit.action.active or not Executor.living(unit.desired_target): continue
		if Executor.distance_between(unit, unit.desired_target) > Executor.skill_reach(unit.desired_skill): continue
		var id: int = unit.action.request(unit.desired_skill, unit.desired_target)
		if id > 0:
			var offset: Vector3 = unit.desired_target.position - unit.position
			if offset.length_squared() > 0.000001: unit.mover.facing = Vector2(offset.x, offset.z).normalized()
			if unit.desired_skill not in [&"heal", &"booster"]:
				unit.offensive_focus = unit.desired_target
				unit.focus_state = unit.desired_target.state
			if not unit.pending.is_empty(): feedback = "%s : %s lancee." % [unit.display_name, "Booster" if unit.desired_skill == &"booster" else "Soin" if unit.desired_skill == &"heal" else "Foudre" if unit.desired_skill == &"lightning" else "Attaque"]
			unit.pending.clear()
	if not infinite_mode and wave.advance(dt, enemies.size()):
		for attempt in range(20):
			if add_enemy(Pattern.spawn_position((spawned + attempt) % 20)): break
	_collect_visual_events(all_units())
	for unit in all_units():
		unit.present()

static func _row(unit: Unit) -> Dictionary:
	return {"id": unit.combat_id, "team_slot": unit.team_slot, "buffs": unit.buffs.snapshot(), "time_scale": unit.buffs.multiplier(), "health": unit.state.health, "max_health": unit.state.max_health, "position": unit.mover.ground_position}

func snapshot(unit: Unit) -> Dictionary:
	var allies: Array = []
	var foes: Array = []
	for other in all_units():
		if other == unit or not Executor.living(other): continue
		if other.team == unit.team: allies.append(_row(other))
		else: foes.append(_row(other))
	return {"key": unit.actor_key, "source": _row(unit), "allies": allies, "enemies": foes, "mana": unit.action.mana, "cooldowns": unit.action.cooldowns.duplicate(), "abilities": unit.abilities.duplicate()}

func _find(id: int) -> Unit:
	for unit in all_units():
		if unit.combat_id == id and Executor.living(unit): return unit
	return null

func _nearest(unit: Unit, pool: Array[Unit]) -> Unit:
	var chosen: Unit
	var distance: float = INF
	for candidate in pool:
		if not Executor.living(candidate): continue
		var value: float = Executor.distance_between(unit, candidate)
		if chosen == null or value < distance or (value == distance and candidate.combat_id < chosen.combat_id):
			chosen = candidate
			distance = value
	return chosen

func _plan(unit: Unit) -> void:
	if unit.action.active: return
	unit.clear_intention()
	if not unit.pending.is_empty():
		var target = _find(unit.pending.target_id)
		if target == null or target.state != unit.pending.target_state or clock.elapsed >= unit.pending.deadline - 0.000001:
			feedback = "%s : commande expiree ou cible perdue." % unit.display_name
			unit.pending.clear()
		else:
			unit.desired_skill = unit.pending.skill
			unit.desired_target = target
			unit.mover.set_target(target)
			return
	var opposite: Array[Unit] = enemies if unit.team == 0 else living_heroes()
	if unit.team == 0:
		var choice: Dictionary = Orders.evaluate(rules[String(unit.actor_key)], snapshot(unit)) if orders_enabled else Rules.evaluate(rules[String(unit.actor_key)], snapshot(unit))
		if choice.is_empty(): return
		unit.desired_skill = choice.skill
		unit.desired_target = _find(choice.target_id)
	else:
		unit.desired_skill = &"basic"
		unit.desired_target = _nearest(unit, opposite)
	# Preserve live offensive focus at attack range, including across an allied heal.
	if (not orders_enabled or unit.team != 0) and unit.desired_skill != &"heal" and Executor.living(unit.offensive_focus) and unit.offensive_focus in opposite and unit.offensive_focus.state == unit.focus_state and Executor.distance_between(unit, unit.offensive_focus) <= Executor.REACH:
		unit.desired_target = unit.offensive_focus
	if Executor.living(unit.desired_target): unit.mover.set_target(unit.desired_target)

func request_manual(key: StringName, skill: StringName) -> bool:
	var unit := hero(key)
	if not clock.permits_gameplay() or result != "EN COURS" or not Executor.living(unit) or skill not in unit.abilities:
		feedback = "Commande indisponible."
		return false
	var pool: Array[Unit] = enemies
	var target: Unit
	if skill == &"heal":
		for other in living_heroes():
			if other.state.health >= other.state.max_health: continue
			if Rules.prefer_heal(_row(other), _row(target) if target != null else {}, _row(unit)): target = other
	else:
		target = _nearest(unit, pool)
	if target == null:
		feedback = "Aucune cible valide."
		return false
	if skill != &"heal" and Executor.living(unit.offensive_focus) and unit.offensive_focus in pool and unit.offensive_focus.state == unit.focus_state and Executor.distance_between(unit, unit.offensive_focus) <= Executor.REACH:
		target = unit.offensive_focus
	unit.pending = {"skill": skill, "target_id": target.combat_id, "target_state": target.state, "deadline": clock.elapsed + 3.0}
	feedback = "%s : %s en attente." % [unit.display_name, "Booster" if skill == &"booster" else "Soin" if skill == &"heal" else "Foudre" if skill == &"lightning" else "Attaque"]
	return true

func _move(dt: float, time_prepared: bool = false) -> void:
	if not is_finite(dt) or dt <= 0: return
	var units: Array[Unit] = []
	for unit in all_units():
		if Executor.living(unit):
			if not time_prepared: unit.advance_time(dt)
			units.append(unit)
	var points: Array[Vector2] = []
	var requests: Array[Vector2] = []
	var corrections: Array[bool] = []
	var movement_limits: Array[float] = []
	for unit in units:
		points.append(unit.mover.ground_position)
		requests.append(Vector2.ZERO)
		corrections.append(unit.team != 0 and not unit.action.active)
		movement_limits.append(unit.mover.speed * unit.personal_delta)
	for point in navigation_obstacles:
		points.append(point)
		requests.append(Vector2.ZERO)
		corrections.append(false)
		movement_limits.append(0.0)
	navigation_searches_last_tick = 0
	for order in range(units.size()):
		var index: int = (order + navigation_cursor) % units.size()
		var unit: Unit = units[index]
		var start: Vector2 = points[index]
		unit.mover.velocity = Vector2.ZERO
		unit.navigation.tick(dt)
		var reach: float = Executor.skill_reach(unit.desired_skill)
		var valid: bool = Executor.living(unit.desired_target)
		var hold: bool = unit.action.active or (valid and Executor.distance_between(unit, unit.desired_target) <= reach)
		if hold:
			unit.navigation.hold()
		elif not valid:
			unit.navigation.clear()
		elif navigation_enabled:
			var obstacles: Array[Vector2] = points.duplicate()
			obstacles.remove_at(index)
			var destination := Vector2(unit.desired_target.position.x, unit.desired_target.position.z)
			var before_searches: int = unit.navigation.searches
			requests[index] = unit.navigation.request(start, destination, unit.desired_target.combat_id,
				reach, unit.mover.speed, unit.personal_delta, obstacles, navigation_searches_last_tick < MAX_NAV_SEARCHES_PER_TICK)
			navigation_searches_last_tick += unit.navigation.searches - before_searches
		else:
			unit.mover.stopping_distance = maxf(0.1, reach - 0.2)
			unit.mover.step(unit.personal_delta)
			requests[index] = unit.mover.ground_position - start
			unit.mover.ground_position = start
	if not units.is_empty(): navigation_cursor = (navigation_cursor + 1) % units.size()
	var positions: Array[Vector2] = Crowd.solve(points, requests, corrections, dt, movement_limits)
	for i in range(units.size()):
		var unit: Unit = units[i]
		var movement: Vector2 = positions[i] - points[i]
		unit.navigation.observe(points[i], positions[i], requests[i], dt)
		unit.mover.ground_position = positions[i]
		unit.mover.velocity = movement / dt
		if Executor.living(unit.desired_target):
			var destination := Vector2(unit.desired_target.position.x, unit.desired_target.position.z)
			unit.mover.distance_to_target = positions[i].distance_to(destination)
			if unit.action.active or unit.mover.distance_to_target <= Executor.skill_reach(unit.desired_skill):
				unit.mover.state = unit.Mover.State.ARRIVED
			else:
				unit.mover.state = unit.Mover.State.MOVING if movement.length_squared() > 0.0000000001 else unit.Mover.State.BLOCKED
		else: unit.mover.state = unit.Mover.State.NO_TARGET
		if movement.length_squared() > 0.00000001:
			unit.gait += unit.personal_delta
			unit.mover.facing = movement.normalized()
		unit.position = Vector3(positions[i].x, 0, positions[i].y)

func _finish(outcome: String) -> void:
	if result != "EN COURS": return
	result = outcome
	terminal_count += 1
	clock.stopped = true
	for unit in all_units():
		unit.action.retire()
		unit.pending.clear()
		unit.clear_intention()
		unit.navigation.clear()
		unit.present()
	_collect_visual_events(all_units())

func _dispose(unit) -> void:
	if not is_instance_valid(unit): return
	unit.action.retire()
	unit.buffs.clear()
	_collect_visual_events([unit])
	unit.pending.clear()
	unit.clear_intention()
	unit.navigation.clear()
	unit.hide()
	unit.queue_free()

func clear() -> void:
	navigation_obstacles.clear()
	navigation_cursor = 0
	navigation_searches_last_tick = 0
	clock.stopped = true
	for unit in all_units(): _dispose(unit)
	heroes.clear()
	enemies.clear()
	_events.clear()
	_pending_deaths.clear()
	_death_ids.clear()

func _exit_tree() -> void:
	clear()

func _record_death(unit: Unit) -> void:
	if _death_ids.has(unit.combat_id): return
	_death_ids[unit.combat_id] = true
	_pending_deaths.append({"kind": "death", "run_id": run_id, "actor_id": unit.combat_id,
		"source_id": unit.combat_id, "target_id": unit.combat_id, "action_id": 0,
		"skill": "", "outcome": "death", "damage": 0, "healing": 0,
		"position": unit.position, "facing": unit.mover.facing, "game_time": clock.elapsed,
		"time_scale": unit.death_time_scale})

func _append_visual_event(values: Dictionary) -> void:
	if _events.size() >= MAX_VISUAL_EVENTS: _events.pop_front()
	values["run_id"] = run_id
	values.make_read_only()
	_events.append(values)

func _collect_visual_events(units: Array[Unit]) -> void:
	for unit in units:
		if is_instance_valid(unit):
			for values in unit.action.take_visual_events(): _append_visual_event(values)
	for values in _pending_deaths: _append_visual_event(values)
	_pending_deaths.clear()

func _spawn_infinite_wave() -> void:
	var occupied: Array[Vector2] = []
	for unit in all_units():
		if Executor.living(unit): occupied.append(unit.mover.ground_position)
	var positions: Array[Vector2] = InfiniteSchedule.formation(occupied)
	assert(positions.size() == InfiniteSchedule.SIZE, "Infinite wave needs six free NE slots")
	for at in positions:
		var accepted: bool = add_enemy(at)
		assert(accepted, "Prevalidated infinite formation must spawn atomically")
