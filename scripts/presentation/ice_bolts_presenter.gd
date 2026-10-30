extends Node3D
## Consumes detached combat facts; visuals never decide victims or apply damage.
const Effect = preload("res://scripts/presentation/ice_bolts_effect.gd")
var effects: Dictionary = {}
var strength: float = .8
var run_id: int = -1
func reset_run(id: int) -> void:
	if run_id == id: return
	clear_visuals(); run_id = id
func consume(event: Dictionary) -> void:
	if int(event.get("run_id",-1)) != run_id or event.get("skill","") != "ice_bolts": return
	var key: int = int(event.get("action_id",0))
	if event.kind == "multi_launch":
		if effects.has(key): return
		if effects.size() >= 8: _release(effects.keys()[0])
		var view := Effect.new(); add_child(view); view.setup(event, strength); effects[key] = view
	elif event.kind in ["multi_hit","multi_miss"] and effects.has(key):
		effects[key].impact(int(event.projectile_index),event.target_position,event.kind == "multi_hit")
func advance_visual(bindings: Dictionary, dt: float) -> void:
	for key in effects.keys():
		var view = effects[key]; view.advance_visual(bindings, dt)
		if view.age >= view.orbit + view.flight + .45: _release(key)
func _release(key: int) -> void:
	var view = effects[key]; view.hide(); remove_child(view); view.queue_free(); effects.erase(key)
func clear_visuals() -> void:
	for key in effects.keys(): _release(key)
