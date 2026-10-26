extends Node3D
## Receives copied presentation snapshots and deduplicated facts, never logical actors.
const MAX_PREPARATIONS: int = 4
const MAX_STRIKES: int = 8
@export var definition: Resource = preload("res://resources/presentation/effects/lightning.tres")
var preparations: Dictionary = {}
var strikes: Array[Dictionary] = []
var strikes_played: int = 0
var run_id: int = -1
var snapshots: Dictionary = {}

func reset_run(id: int) -> void:
	if id == run_id: return
	clear_visuals()
	strikes_played = 0
	snapshots.clear()
	run_id = id

func advance_visual(values: Dictionary, dt: float) -> void:
	snapshots = values.duplicate()
	for strike in strikes.duplicate():
		strike.age += maxf(0, dt)
		if is_instance_valid(strike.view): strike.view.advance_visual(dt)
		if strike.age >= strike.duration or not is_instance_valid(strike.view):
			_release(strike.view)
			strikes.erase(strike)
	for key in preparations.keys():
		var item: Dictionary = preparations[key]
		if not _living_snapshot(item.source_id) or not _living_snapshot(item.target_id):
			_remove_preparation(key)
			continue
		var source: Dictionary = snapshots[item.source_id]
		if not source.get("casting", false) or source.get("skill", "") != "lightning" or source.get("action_id", 0) != item.action_id:
			_remove_preparation(key)
			continue
		if not is_instance_valid(item.view):
			_remove_preparation(key)
			continue
		_set_anchors(item, float(source.get("elapsed", 0)) / maxf(0.001, float(source.get("windup", 2.0))))
		item.view.advance_visual(dt)

func consume(event: Dictionary) -> void:
	if int(event.get("run_id", -1)) != run_id: return
	var kind: String = event.get("kind", "")
	if kind == "death":
		for key in preparations.keys():
			var item: Dictionary = preparations[key]
			if item.source_id == event.actor_id or item.target_id == event.actor_id: _remove_preparation(key)
		return
	if event.get("skill", "") != "lightning": return
	var key: String = "%d:%d" % [int(event.get("source_id", 0)), int(event.get("action_id", 0))]
	if kind in ["resolve", "cancel", "end"]: _remove_preparation(key)
	if kind == "start":
		_start(key, event)
	elif kind == "resolve" and int(event.get("damage", 0)) > 0:
		_strike(event)

func _start(key: String, event: Dictionary) -> void:
	if definition == null: return
	var view := _instantiate(definition.cast_scene, ["setup", "set_anchors", "advance_visual"])
	if view == null: return
	_remove_preparation(key)
	if preparations.size() >= MAX_PREPARATIONS: _remove_preparation(preparations.keys()[0])
	add_child(view)
	view.setup(definition)
	var item: Dictionary = {"view": view, "source_id": int(event.source_id), "target_id": int(event.target_id),
		"action_id": int(event.action_id), "source_position": event.get("source_position", Vector3.ZERO),
		"target_position": event.get("target_position", Vector3.ZERO)}
	preparations[key] = item
	_set_anchors(item, 0.0)

func _set_anchors(item: Dictionary, progress: float) -> void:
	var source: Vector3 = item.source_position + Vector3(0, 0.7, 0)
	var target: Vector3 = item.target_position
	if snapshots.has(item.source_id):
		var snapshot: Dictionary = snapshots[item.source_id]
		source = snapshot.position + Vector3(0, 0.7, 0)
		if snapshot.definition != null:
			source = snapshot.position + snapshot.transform.basis * snapshot.definition.lightning_cast_origin
	if snapshots.has(item.target_id): target = snapshots[item.target_id].position
	item.view.set_anchors(source, target, progress)

func _strike(event: Dictionary) -> void:
	if definition == null: return
	var view := _instantiate(definition.strike_scene, ["setup", "advance_visual"])
	if view == null: return
	if strikes.size() >= MAX_STRIKES:
		var oldest: Dictionary = strikes.pop_front()
		_release(oldest.view)
	add_child(view)
	# Damage is already applied. A killed/freed target must still get its real impact.
	view.position = event.get("target_position", Vector3.ZERO)
	view.setup(definition, int(event.get("source_id", 0)) * 4099 + int(event.get("action_id", 0)))
	strikes.append({"view": view, "age": 0.0, "duration": maxf(0.1, definition.duration)})
	strikes_played += 1

func _living_snapshot(id: int) -> bool:
	return snapshots.has(id) and snapshots[id].get("alive", true)

func _instantiate(scene: PackedScene, methods: Array) -> Node3D:
	if scene == null: return null
	var node: Node = scene.instantiate()
	var valid: bool = node is Node3D
	for method in methods: valid = valid and node.has_method(method)
	if not valid:
		node.free()
		return null
	return node as Node3D

func _remove_preparation(key: String) -> void:
	if not preparations.has(key): return
	_release(preparations[key].view)
	preparations.erase(key)

func _release(view: Node) -> void:
	if not is_instance_valid(view): return
	if view is Node3D: view.hide()
	if view.get_parent() == self: remove_child(view)
	view.queue_free()

func clear_visuals() -> void:
	for key in preparations.keys(): _remove_preparation(key)
	for strike in strikes: _release(strike.view)
	strikes.clear()
