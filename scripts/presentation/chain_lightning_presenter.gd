extends Node3D
## All path selection lives in combat; only a detached segment fact reaches this adapter.
const Segment = preload("res://scripts/presentation/chain_lightning_segment.gd")
var profile: Resource = preload("res://resources/presentation/effects/chain_lightning.tres")
var effects: Array[Dictionary] = []
var played: Dictionary = {}
var run_id: int = -1
func reset_run(id: int) -> void:
	if run_id==id:return
	clear_visuals();run_id=id
func consume(event: Dictionary) -> void:
	if int(event.get("run_id",-1))!=run_id or event.get("kind","")!="chain_hit":return
	var key: String = "%d:%d"%[int(event.action_id),int(event.bounce_index)]
	if played.has(key):return
	played[key]=true
	if effects.size()>=24:_release(effects[0])
	var view:=Segment.new();add_child(view);view.setup(profile,event)
	effects.append({"view":view,"action_id":int(event.action_id)})
func advance_visual(dt: float) -> void:
	for effect in effects.duplicate():
		effect.view.advance_visual(dt)
		if effect.view.age>=profile.duration:_release(effect)
	# Only unfinished actions need deduplication history in an infinite combat.
	var keep: Dictionary = {}
	for effect in effects:keep[effect.action_id]=true
	for key in played.keys():
		if not keep.has(int(key.get_slice(":",0))):played.erase(key)
func _release(effect: Dictionary) -> void:
	var view=effect.view;view.hide();remove_child(view);view.queue_free();effects.erase(effect)
func clear_visuals() -> void:
	for effect in effects.duplicate():_release(effect)
	played.clear()
