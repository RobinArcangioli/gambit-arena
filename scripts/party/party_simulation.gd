extends Node
## Party coordinator: no artistic resources and no UI callbacks during a tick.
const Unit = preload("res://scripts/party/party_unit.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Rules = preload("res://scripts/party/party_rules.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Wave = preload("res://scripts/waves/wave_schedule.gd")
const ANNE = preload("res://data/party/anne.tres")
const MAKO = preload("res://data/party/mako.tres")
const ENEMY = preload("res://data/party/skeleton.tres")
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
var events: Array[Dictionary] = []

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
	wave.reset(total_per_wave, max_alive)
	for profile in [ANNE, MAKO]:
		var unit := Unit.new()
		unit.configure_party(profile)
		unit.action.clock = clock
		unit.name = profile.display_name
		world.add_child(unit)
		unit.place(Vector2(-0.65, 0.65) if profile == ANNE else Vector2(0.65, -0.65))
		heroes.append(unit)

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
	unit.name = "Skeleton%d" % (spawned + 1)
	unit.action.clock = clock
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
			unit.hide()

func advance(delta: float, paused: bool = false) -> void:
	events.clear()
	if result != "EN COURS": return
	_prune()
	if living_heroes().is_empty():
		_finish("DEFAITE")
		return
	if paused or not clock.permits_gameplay() or not is_finite(delta) or delta <= 0.0: return
	var dt: float = clock.step(delta)
	# Stable order: Anne, Mako, then enemy creation order. Dead actors never retaliate.
	for unit in all_units():
		if not Executor.living(unit): continue
		var resolved_before: bool = unit.action.resolved
		unit.action.advance(dt)
		if not resolved_before and unit.action.resolved and unit.action.outcome in ["impact", "soin", "PV pleins", "hors portee"]:
			var action = unit.action
			events.append({"run_id": run_id, "source_id": unit.combat_id, "target_id": action._target.combat_id if is_instance_valid(action._target) else 0, "action_id": action.action_id, "skill": String(action.last_skill), "outcome": action.outcome, "damage": action.applied_damage, "healing": action.applied_healing, "source_position": unit.position, "target_position": action._target.position if is_instance_valid(action._target) else Vector3.ZERO})
			if action.applied_damage > 0: hits += 1
	_prune()
	if living_heroes().is_empty():
		_finish("DEFAITE")
		return
	if wave.issued >= wave.total and enemies.is_empty():
		if wave_number >= wave_count:
			_finish("VICTOIRE")
			return
		wave_number += 1
		wave.reset(total_per_wave, max_alive)
	for unit in all_units():
		if Executor.living(unit): _plan(unit)
	_move(dt)
	for unit in all_units():
		if not Executor.living(unit) or unit.action.active or not Executor.living(unit.desired_target): continue
		if Executor.distance_between(unit, unit.desired_target) > Executor.skill_reach(unit.desired_skill): continue
		var id: int = unit.action.request(unit.desired_skill, unit.desired_target)
		if id > 0:
			var offset: Vector3 = unit.desired_target.position - unit.position
			if offset.length_squared() > 0.000001: unit.mover.facing = Vector2(offset.x, offset.z).normalized()
			if unit.desired_skill != &"heal":
				unit.offensive_focus = unit.desired_target
				unit.focus_state = unit.desired_target.state
			if not unit.pending.is_empty(): feedback = "%s : %s lancee." % [unit.display_name, "Soin" if unit.desired_skill == &"heal" else "Foudre" if unit.desired_skill == &"lightning" else "Attaque"]
			unit.pending.clear()
	if wave.advance(dt, enemies.size()):
		for attempt in range(20):
			if add_enemy(Pattern.spawn_position((spawned + attempt) % 20)): break
	for unit in all_units():
		unit.present()

static func _row(unit: Unit) -> Dictionary:
	return {"id": unit.combat_id, "health": unit.state.health, "max_health": unit.state.max_health, "position": unit.mover.ground_position}

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
		var choice: Dictionary = Rules.evaluate(rules[String(unit.actor_key)], snapshot(unit))
		if choice.is_empty(): return
		unit.desired_skill = choice.skill
		unit.desired_target = _find(choice.target_id)
	else:
		unit.desired_skill = &"basic"
		unit.desired_target = _nearest(unit, opposite)
	# Preserve live offensive focus at attack range, including across an allied heal.
	if unit.desired_skill != &"heal" and Executor.living(unit.offensive_focus) and unit.offensive_focus in opposite and unit.offensive_focus.state == unit.focus_state and Executor.distance_between(unit, unit.offensive_focus) <= Executor.REACH:
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
	feedback = "%s : %s en attente." % [unit.display_name, "Soin" if skill == &"heal" else "Foudre" if skill == &"lightning" else "Attaque"]
	return true

func _move(dt: float) -> void:
	var units: Array[Unit] = []
	for unit in all_units():
		if Executor.living(unit): units.append(unit)
	var points: Array[Vector2] = []
	var requests: Array[Vector2] = []
	var corrections: Array[bool] = []
	for unit in units:
		var start: Vector2 = unit.mover.ground_position
		points.append(start)
		unit.mover.velocity = Vector2.ZERO
		var reach: float = Executor.skill_reach(unit.desired_skill)
		var hold: bool = unit.action.active or (Executor.living(unit.desired_target) and Executor.distance_between(unit, unit.desired_target) <= reach)
		if not hold:
			unit.mover.stopping_distance = maxf(0.1, reach - 0.2)
			unit.mover.step(dt)
		requests.append(unit.mover.ground_position - start)
		unit.mover.ground_position = start
		corrections.append(unit.team != 0 and not unit.action.active)
	var positions: Array[Vector2] = Crowd.solve(points, requests, corrections, dt)
	for i in range(units.size()):
		var unit: Unit = units[i]
		var movement: Vector2 = positions[i] - points[i]
		unit.mover.ground_position = positions[i]
		unit.mover.velocity = movement / dt
		if movement.length_squared() > 0.00000001:
			unit.gait += dt
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
		unit.present()

func _dispose(unit) -> void:
	if not is_instance_valid(unit): return
	unit.action.retire()
	unit.pending.clear()
	unit.clear_intention()
	unit.hide()
	unit.queue_free()

func clear() -> void:
	clock.stopped = true
	for unit in all_units(): _dispose(unit)
	heroes.clear()
	enemies.clear()
	events.clear()

func _exit_tree() -> void:
	clear()
