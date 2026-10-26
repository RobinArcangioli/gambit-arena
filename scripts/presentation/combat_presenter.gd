extends Node3D
## One-way adapter. Bindings own presentation values/views, never ActorState or executors.
const View = preload("res://scripts/presentation/character_view.gd")
const MAX_GHOSTS: int = 12
var enabled: bool = true
var run_id: int = -1
var bindings: Dictionary = {}
var ghosts: Array[Dictionary] = []
var _sequences: Dictionary = {}
var _dead_ids: Dictionary = {}
var reactions_played: int = 0
var deaths_played: int = 0

func reset_run(id: int) -> void:
	if run_id == id: return
	for ghost in ghosts: _release_ghost(ghost)
	ghosts.clear()
	bindings.clear()
	_sequences.clear()
	_dead_ids.clear()
	reactions_played = 0
	deaths_played = 0
	run_id = id

func capture(units: Array, id: int) -> void:
	reset_run(id)
	for unit in units:
		if not is_instance_valid(unit.visual): continue
		bindings[unit.combat_id] = {"view": unit.visual, "transform": unit.visual.global_transform,
			"definition": unit.appearance, "position": unit.position, "facing": unit.mover.facing}

func present(units: Array, values: Array[Dictionary], dt: float, id: int, terminal: bool = false) -> void:
	reset_run(id)
	# Advance previously existing visuals first. New impacts/deaths begin at this tick's end.
	for ghost in ghosts.duplicate():
		ghost.age += dt
		var view: Node3D = ghost.view
		if is_instance_valid(view):
			if view is View: view.advance_visual(dt)
			else:
				view.transform = ghost.transform
				view.rotate_x(minf(1.0, ghost.age / 0.75) * PI * 0.5)
		if ghost.age >= ghost.duration or not is_instance_valid(view):
			_release_ghost(ghost)
			ghosts.erase(ghost)
	capture(units, id)
	# Latch the current authoritative action BEFORE receiving this tick's impacts.
	# HitReact must never decide priority using the previous tick's action state.
	var current: Dictionary = {}
	for unit in units:
		if not unit.state.alive or not is_instance_valid(unit.visual): continue
		current[unit.combat_id] = true
		unit.advance_visual(dt)
		if unit.visual is View:
			var action = unit.action
			unit.visual.sync_action(enabled and action.active, action.last_skill, action.action_id, action.elapsed, action._windup(), action._recovery(), enabled and terminal)
	if enabled:
		for event in values: consume(event)
	else:
		for ghost in ghosts: _release_ghost(ghost)
		ghosts.clear()
	for actor_id in bindings.keys():
		if not current.has(actor_id): bindings.erase(actor_id)

func consume(event: Dictionary) -> void:
	if int(event.get("run_id", -1)) != run_id: return
	var kind: String = event.get("kind", "")
	if kind == "death":
		_death(int(event.actor_id))
		return
	var source_id: int = int(event.get("source_id", 0))
	var sequence: int = int(event.get("sequence", 0))
	if sequence <= int(_sequences.get(source_id, 0)): return
	_sequences[source_id] = sequence
	if kind == "resolve" and int(event.get("damage", 0)) > 0:
		var target_id: int = int(event.get("target_id", 0))
		if _dead_ids.has(target_id) or not bindings.has(target_id): return
		var view = bindings[target_id].view
		if is_instance_valid(view) and view is View:
			view.react_hit()
			reactions_played += 1

func _death(actor_id: int) -> void:
	if _dead_ids.has(actor_id): return
	_dead_ids[actor_id] = true
	if not bindings.has(actor_id): return
	var snapshot: Dictionary = bindings[actor_id]
	var view: Node3D = snapshot.view
	if not is_instance_valid(view): return
	# Detach only the graphical child; the logical enemy is already removed from combat.
	var host: Node = view.get_parent()
	if host == null or not host.has_method("release_visual"): return
	host.release_visual()
	add_child(view)
	view.global_transform = snapshot.transform
	view.name = "Death_%d" % actor_id
	view.show()
	var duration: float = 1.0
	if view is View:
		view.start_death()
		duration = maxf(0.001, view.definition.death_duration + view.definition.death_hold)
	if ghosts.size() >= MAX_GHOSTS:
		var oldest: Dictionary = ghosts.pop_front()
		_release_ghost(oldest)
	ghosts.append({"view": view, "age": 0.0, "duration": duration, "transform": view.transform, "actor_id": actor_id})
	bindings.erase(actor_id)
	deaths_played += 1

func _release_ghost(ghost: Dictionary) -> void:
	var view = ghost.view
	if not is_instance_valid(view): return
	view.hide()
	if view.get_parent() == self: remove_child(view)
	view.queue_free()
