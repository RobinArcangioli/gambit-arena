extends Node3D
## One-way adapter. Bindings own presentation values/views, never ActorState or executors.
const View = preload("res://scripts/presentation/character_view.gd")
const Lightning = preload("res://scripts/presentation/lightning_presenter.gd")
var lightning := Lightning.new()
const MAX_GHOSTS: int = 12
const MAX_HEAL_EFFECTS: int = 8
@export var heal_definition: Resource = preload("res://resources/presentation/effects/heal.tres")
var heal_effects: Array[Dictionary] = []
var heals_played: int = 0
var enabled: bool = true
var run_id: int = -1
var bindings: Dictionary = {}
var ghosts: Array[Dictionary] = []
var _sequences: Dictionary = {}
var _dead_ids: Dictionary = {}
var reactions_played: int = 0
var deaths_played: int = 0

func _init() -> void:
	lightning.name = "LightningPresentation"
	add_child(lightning)

func reset_run(id: int) -> void:
	if run_id == id: return
	lightning.reset_run(id)
	for ghost in ghosts: _release_ghost(ghost)
	ghosts.clear()
	_clear_heals()
	heals_played = 0
	bindings.clear()
	_sequences.clear()
	_dead_ids.clear()
	reactions_played = 0
	deaths_played = 0
	run_id = id

func capture(units: Array, id: int) -> void:
	reset_run(id)
	for unit in units:
		bindings[unit.combat_id] = {"view": unit.visual,
			"transform": unit.visual.global_transform if is_instance_valid(unit.visual) else unit.global_transform,
			"definition": unit.appearance, "position": unit.position, "facing": unit.mover.facing,
			"time_scale": unit.buffs.multiplier(), "alive": unit.state.alive, "casting": unit.action.casting(), "action_id": unit.action.action_id,
			"skill": String(unit.action.last_skill), "elapsed": unit.action.elapsed, "windup": unit.action._windup()}

func present(units: Array, values: Array[Dictionary], dt: float, id: int, terminal: bool = false) -> void:
	reset_run(id)
	capture(units, id)
	_advance_heals(dt)
	lightning.advance_visual(bindings, dt)
	# Advance previously existing visuals first. New impacts/deaths begin at this tick's end.
	for ghost in ghosts.duplicate():
		var personal_dt: float = dt * float(ghost.get("time_scale", 1.0))
		ghost.age += personal_dt
		var view: Node3D = ghost.view
		if is_instance_valid(view):
			if view is View: view.advance_visual(personal_dt)
			else:
				view.transform = ghost.transform
				view.rotate_x(minf(1.0, ghost.age / 0.75) * PI * 0.5)
		if ghost.age >= ghost.duration or not is_instance_valid(view):
			_release_ghost(ghost)
			ghosts.erase(ghost)
	# Latch the current authoritative action BEFORE receiving this tick's impacts.
	# HitReact must never decide priority using the previous tick's action state.
	var current: Dictionary = {}
	for unit in units:
		if not unit.state.alive or not is_instance_valid(unit.visual): continue
		current[unit.combat_id] = true
		unit.advance_visual(dt * unit.personal_step_scale)
		if unit.visual is View:
			var action = unit.action
			unit.visual.sync_action(enabled and action.active, action.last_skill, action.action_id, action.elapsed, action._windup(), action._recovery(), enabled and terminal)
	if enabled:
		for event in values: consume(event)
	else:
		for ghost in ghosts: _release_ghost(ghost)
		ghosts.clear()
		_clear_heals()
		lightning.clear_visuals()
	for actor_id in bindings.keys():
		if not current.has(actor_id): bindings.erase(actor_id)

func consume(event: Dictionary) -> void:
	if not enabled or int(event.get("run_id", -1)) != run_id: return
	var kind: String = event.get("kind", "")
	if kind == "death":
		lightning.consume(event)
		_death(int(event.actor_id), float(event.get("time_scale", 1.0)))
		return
	var source_id: int = int(event.get("source_id", 0))
	var sequence: int = int(event.get("sequence", 0))
	if sequence <= int(_sequences.get(source_id, 0)): return
	_sequences[source_id] = sequence
	lightning.consume(event)
	if kind == "resolve" and event.get("skill", "") == "heal" and int(event.get("healing", 0)) > 0:
		_heal(event)
	if kind == "resolve" and int(event.get("damage", 0)) > 0:
		var target_id: int = int(event.get("target_id", 0))
		if _dead_ids.has(target_id) or not bindings.has(target_id): return
		var view = bindings[target_id].view
		if is_instance_valid(view) and view is View:
			view.react_hit()
			reactions_played += 1

func _death(actor_id: int, time_scale: float = 1.0) -> void:
	if _dead_ids.has(actor_id): return
	_dead_ids[actor_id] = true
	for effect in heal_effects.duplicate():
		if effect.target_id == actor_id: _release_heal(effect)
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
	ghosts.append({"view": view, "age": 0.0, "duration": duration, "transform": view.transform, "actor_id": actor_id, "time_scale": time_scale})
	bindings.erase(actor_id)
	deaths_played += 1

func _release_ghost(ghost: Dictionary) -> void:
	var view = ghost.view
	if not is_instance_valid(view): return
	view.hide()
	if view.get_parent() == self: remove_child(view)
	view.queue_free()

func _heal(event: Dictionary) -> void:
	var target_id: int = int(event.get("target_id", 0))
	if _dead_ids.has(target_id) or heal_definition == null or heal_definition.scene == null: return
	var view: Node = heal_definition.scene.instantiate()
	if not view is Node3D or not view.has_method("setup") or not view.has_method("advance_visual"):
		view.free()
		return
	var origin: Vector3 = event.get("target_position", Vector3.ZERO)
	origin = _heal_origin(target_id, origin)
	if heal_effects.size() >= MAX_HEAL_EFFECTS: _release_heal(heal_effects[0])
	add_child(view)
	view.position = origin
	view.setup(heal_definition, int(event.healing))
	heal_effects.append({"view": view, "age": 0.0, "duration": maxf(0.1, heal_definition.duration), "target_id": target_id})
	heals_played += 1

func _advance_heals(dt: float) -> void:
	for effect in heal_effects.duplicate():
		effect.age += maxf(0, dt)
		if is_instance_valid(effect.view):
			if bindings.has(effect.target_id):
				effect.view.position = _heal_origin(effect.target_id, bindings[effect.target_id].position)
			effect.view.advance_visual(dt)
		if effect.age >= effect.duration or not is_instance_valid(effect.view): _release_heal(effect)

func _release_heal(effect: Dictionary) -> void:
	var view = effect.view
	if is_instance_valid(view):
		view.hide()
		if view.get_parent() == self: remove_child(view)
		view.queue_free()
	heal_effects.erase(effect)

func _clear_heals() -> void:
	for effect in heal_effects.duplicate(): _release_heal(effect)

func _heal_origin(target_id: int, at: Vector3) -> Vector3:
	if bindings.has(target_id):
		var snapshot: Dictionary = bindings[target_id]
		if snapshot.definition != null:
			return at + snapshot.transform.basis * snapshot.definition.heal_effect_origin
	return at
