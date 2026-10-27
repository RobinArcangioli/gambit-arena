extends Node3D
## Success-fact adapter. No actors, mana, buff state or gameplay clocks are held here.
const MAX_EFFECTS: int = 8
@export var definition: Resource = preload("res://resources/presentation/effects/booster.tres")
var effects: Array[Dictionary] = []
var snapshots: Dictionary = {}
var played: int = 0
var run_id: int = -1
var _sequences: Dictionary = {}
var _dead: Dictionary = {}

func reset_run(id: int) -> void:
	if run_id == id:return
	clear_visuals();snapshots.clear();_sequences.clear();_dead.clear();played=0;run_id=id

func advance_visual(values: Dictionary, dt: float) -> void:
	snapshots.clear()
	for id in values:
		snapshots[id] = {"position": values[id].position, "alive": values[id].get("alive",true)}
	for effect in effects.duplicate():
		if not snapshots.has(effect.target_id) or not snapshots[effect.target_id].alive or not is_instance_valid(effect.view):
			_release(effect);continue
		effect.view.position = snapshots[effect.target_id].position + effect.origin
		if is_finite(dt) and dt > 0:
			effect.age += dt;effect.view.advance_visual(dt)
		if effect.age >= effect.duration:_release(effect)

func consume(event: Dictionary) -> void:
	if int(event.get("run_id",-1)) != run_id:return
	if event.get("kind","") == "death":
		_dead[int(event.actor_id)] = true
		for effect in effects.duplicate():
			if effect.target_id == int(event.actor_id):_release(effect)
		return
	if event.get("kind","") != "buff_applied" or event.get("buff_id","") != "booster" or event.get("outcome","") != "booster":return
	var source: int = int(event.get("source_id",0))
	var sequence: int = int(event.get("sequence",0))
	if sequence <= int(_sequences.get(source,0)):return
	_sequences[source] = sequence
	var target: int = int(event.get("target_id",0))
	if _dead.has(target) or not snapshots.has(target) or not snapshots[target].alive or definition == null or definition.scene == null:return
	var view: Node = definition.scene.instantiate()
	if not view is Node3D or not view.has_method("setup") or not view.has_method("advance_visual"):
		view.free();return
	if effects.size() >= MAX_EFFECTS:_release(effects[0])
	add_child(view);view.position = snapshots[target].position + definition.origin;view.setup(definition)
	effects.append({"view":view,"target_id":target,"age":0.0,"duration":maxf(0.1,definition.duration),"origin":definition.origin})
	played+=1

func _release(effect: Dictionary) -> void:
	if is_instance_valid(effect.view):
		effect.view.hide()
		if effect.view.get_parent() == self:remove_child(effect.view)
		effect.view.queue_free()
	effects.erase(effect)

func clear_visuals() -> void:
	for effect in effects.duplicate():_release(effect)

func prune_history(retained: Dictionary) -> void:
	for id in _sequences.keys():
		if not retained.has(id): _sequences.erase(id)
	for id in _dead.keys():
		if not retained.has(id): _dead.erase(id)
