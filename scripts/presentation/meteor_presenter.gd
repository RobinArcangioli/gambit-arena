extends Node3D
const Effect=preload("res://scripts/presentation/meteor_effect.gd")
const MAX_EFFECTS:int=8
var effects:Dictionary={}
var definition:Resource=preload("res://resources/presentation/effects/meteor.tres")
var strength:float=1
var explosion_variant:int=-1
var run_id:int=-1
func reset_run(id:int) -> void:
	if run_id==id:return
	clear_visuals();run_id=id
func consume(event:Dictionary) -> void:
	if int(event.get("run_id",-1))!=run_id or event.get("skill","")!="meteor":return
	var key:int=int(event.get("action_id",0))
	if event.kind=="area_launch":
		if effects.has(key):return
		if effects.size()>=MAX_EFFECTS:_release(effects.keys()[0])
		var view:=Effect.new();add_child(view);view.position=event.target_position
		view.profile=definition
		view.variant_override=explosion_variant
		view.setup(float(event.area_radius),strength,float(event.flight_duration));effects[key]=view
	elif event.kind=="area_impact":
		if effects.has(key):effects[key].impact()
func advance_visual(dt:float) -> void:
	for key in effects.keys():
		var view=effects[key];view.advance_visual(dt)
		if view.exploding and view.age>=1:_release(key)
func _release(key:int) -> void:
	var view=effects[key];view.hide();remove_child(view);view.queue_free();effects.erase(key)
func clear_visuals() -> void:
	for key in effects.keys():_release(key)
