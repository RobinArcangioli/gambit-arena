extends Node3D
## One-way adapter. Bindings own presentation values/views, never ActorState or executors.
const View = preload("res://scripts/presentation/character_view.gd")
const AreaZone=preload("res://scripts/presentation/area_zone.gd")
var area_zones:Dictionary={}
var area_zones_enabled:bool=true
const Lightning = preload("res://scripts/presentation/lightning_presenter.gd")
const Booster = preload("res://scripts/presentation/booster_presenter.gd")
const Meteor=preload("res://scripts/presentation/meteor_presenter.gd")
var meteor:=Meteor.new()
var booster := Booster.new()
var lightning := Lightning.new()
const CastingEnergy = preload("res://scripts/presentation/casting_energy.gd")
var casting_effects: Dictionary = {}
var casting_strength: float = 0.65
const FloatingText=preload("res://scripts/presentation/floating_combat_text.gd")
const TextProfile=preload("res://resources/presentation/effects/heal.tres")
const MAX_DAMAGE_TEXTS:int=48
var damage_texts:Array[Dictionary]=[]
var outgoing_text:bool=true
var incoming_text:bool=true
var healing_text:bool=true
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
	meteor.name="MeteorPresentation";add_child(meteor)
	lightning.name = "LightningPresentation"
	add_child(lightning)
	booster.name = "BoosterPresentation"
	add_child(booster)

func reset_run(id: int) -> void:
	if run_id == id: return
	_clear_casting()
	_clear_area_zones()
	lightning.reset_run(id)
	booster.reset_run(id)
	meteor.reset_run(id)
	for ghost in ghosts: _release_ghost(ghost)
	ghosts.clear()
	_clear_heals()
	_clear_damage_texts()
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
			"team": unit.team, "time_scale": unit.buffs.multiplier(), "alive": unit.state.alive, "casting": unit.action.casting(), "action_id": unit.action.action_id,
			"area_radius":unit.action.area_radius(),"ground_point":unit.action.ground_point,
			"skill": String(unit.action.last_skill), "elapsed": unit.action.elapsed, "windup": unit.action._windup()}

func present(units: Array, values: Array[Dictionary], dt: float, id: int, terminal: bool = false) -> void:
	reset_run(id)
	capture(units, id)
	_sync_area_zones()
	_sync_casting(units, dt, terminal)
	_advance_heals(dt)
	_advance_damage_texts(dt)
	lightning.advance_visual(bindings, dt)
	booster.advance_visual(bindings, dt)
	meteor.advance_visual(dt)
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
		_clear_damage_texts()
		_clear_area_zones()
		lightning.clear_visuals()
		booster.clear_visuals()
		meteor.clear_visuals()
	if terminal:
		for key in meteor.effects.keys():
			if not meteor.effects[key].exploding:meteor._release(key)
	for actor_id in bindings.keys():
		if not current.has(actor_id): bindings.erase(actor_id)

func consume(event: Dictionary) -> void:
	if not enabled or int(event.get("run_id", -1)) != run_id: return
	var kind: String = event.get("kind", "")
	if kind == "death":
		lightning.consume(event)
		booster.consume(event)
		_death(int(event.actor_id), float(event.get("time_scale", 1.0)))
		return
	var source_id: int = int(event.get("source_id", 0))
	var sequence: int = int(event.get("sequence", 0))
	if sequence <= int(_sequences.get(source_id, 0)): return
	_sequences[source_id] = sequence
	if kind in ["cancel","resolve","end","area_launch"] and bool(event.get("ground_target",false)):_release_area_zone(source_id)
	lightning.consume(event)
	booster.consume(event)
	meteor.consume(event)
	if kind == "resolve" and event.get("skill", "") == "heal" and int(event.get("healing", 0)) > 0:
		_heal(event)
	if kind in ["resolve","area_hit"] and int(event.get("damage", 0)) > 0:
		_damage_text(event)
		var target_id: int = int(event.get("target_id", 0))
		if _dead_ids.has(target_id) or not bindings.has(target_id): return
		var view = bindings[target_id].view
		if is_instance_valid(view) and view is View:
			view.react_hit()
			reactions_played += 1

func _death(actor_id: int, time_scale: float = 1.0) -> void:
	_release_area_zone(actor_id)
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
	view.amount_label.visible=healing_text
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

func prune_history(retained: Dictionary) -> void:
	# Actor IDs never repeat. Only finished lifetimes are forgotten, without
	# resetting ongoing hero animations, effects or their deduplication state.
	for actor_id in _sequences.keys():
		if not retained.has(actor_id): _sequences.erase(actor_id)
	for actor_id in _dead_ids.keys():
		if not retained.has(actor_id): _dead_ids.erase(actor_id)
	booster.prune_history(retained)

func _sync_casting(units: Array, dt: float, terminal: bool) -> void:
	var retained: Dictionary = {}
	for unit in units:
		var active: bool = enabled and not terminal and unit.team == 0 and unit.state.alive and unit.action.casting()
		if is_instance_valid(unit.visual) and unit.visual is View:
			unit.visual.set_casting_energy(active, casting_strength)
		if not active:continue
		var actor_id: int = unit.combat_id
		retained[actor_id] = true
		if not casting_effects.has(actor_id):
			var effect := CastingEnergy.new();add_child(effect);casting_effects[actor_id] = effect
		var effect: Node3D = casting_effects[actor_id]
		effect.position = unit.position
		effect.strength = casting_strength
		effect.advance_visual(dt * unit.personal_step_scale)
	for actor_id in casting_effects.keys():
		if not retained.has(actor_id):_release_casting(actor_id)

func _release_casting(actor_id: int) -> void:
	var effect: Node3D = casting_effects[actor_id]
	effect.hide();remove_child(effect);effect.queue_free();casting_effects.erase(actor_id)

func _clear_casting() -> void:
	for actor_id in casting_effects.keys():_release_casting(actor_id)
	for snapshot in bindings.values():
		if is_instance_valid(snapshot.view) and snapshot.view is View:snapshot.view.set_casting_energy(false)

func set_text_preferences(outgoing:bool,incoming:bool,healing:bool) -> void:
	if [outgoing_text,incoming_text,healing_text]==[outgoing,incoming,healing]:return
	outgoing_text=outgoing;incoming_text=incoming;healing_text=healing
	for effect in damage_texts:
		if is_instance_valid(effect.view):effect.view.visible=incoming if effect.team==0 else outgoing
	for effect in heal_effects:
		if is_instance_valid(effect.view):effect.view.amount_label.visible=healing

func _damage_text(event:Dictionary) -> void:
	var target_id:int=int(event.get("target_id",0))
	if _dead_ids.has(target_id):return
	var team:int=int(bindings[target_id].get("team",event.get("target_team",1))) if bindings.has(target_id) else int(event.get("target_team",1))
	if not (incoming_text if team==0 else outgoing_text):return
	if damage_texts.size()>=MAX_DAMAGE_TEXTS:_release_damage_text(damage_texts[0])
	var count:int=0
	for previous in damage_texts:
		if previous.target_id==target_id:count+=1
	# A small fan separates successive hits; the upward/fade animation stays identical.
	var offset:=Vector3([0.0,.22,-.22][count%3],.12*count,0)
	var view:=FloatingText.new();add_child(view)
	var profile:Resource=heal_definition if heal_definition!=null else TextProfile
	view.origin=_heal_origin(target_id,event.get("target_position",Vector3.ZERO))+offset
	view.setup(str(int(event.damage)),Color("e44949") if team==0 else Color.WHITE,Color("10182f"),profile.duration,profile.amount_height,profile.fade)
	damage_texts.append({"view":view,"target_id":target_id,"team":team,"offset":offset})
func _advance_damage_texts(dt:float) -> void:
	for effect in damage_texts.duplicate():
		if not is_instance_valid(effect.view):_release_damage_text(effect);continue
		if bindings.has(effect.target_id):effect.view.origin=_heal_origin(effect.target_id,bindings[effect.target_id].position)+effect.offset
		effect.view.advance_visual(dt)
		if effect.view.age>=effect.view.duration:_release_damage_text(effect)
func _release_damage_text(effect:Dictionary) -> void:
	if is_instance_valid(effect.view):
		effect.view.hide();remove_child(effect.view);effect.view.queue_free()
	damage_texts.erase(effect)
func _clear_damage_texts() -> void:
	for effect in damage_texts.duplicate():_release_damage_text(effect)

func set_area_visibility(value:bool) -> void:
	area_zones_enabled=value;_sync_area_zones()
func _sync_area_zones() -> void:
	var retained:Dictionary={}
	if enabled and area_zones_enabled:
		for actor_id in bindings:
			var values:Dictionary=bindings[actor_id]
			if not values.alive or not values.casting or float(values.area_radius)<=0:continue
			retained[actor_id]=true
			if not area_zones.has(actor_id):
				var zone:=AreaZone.new();add_child(zone);area_zones[actor_id]=zone
			var zone:AreaZone=area_zones[actor_id]
			zone.set_radius(float(values.area_radius))
			var point:Vector2=values.ground_point;zone.position=Vector3(point.x,.035,point.y)
	for actor_id in area_zones.keys():
		if not retained.has(actor_id):_release_area_zone(actor_id)
func _release_area_zone(actor_id:int) -> void:
	if not area_zones.has(actor_id):return
	var zone:Node3D=area_zones[actor_id];zone.hide();remove_child(zone);zone.queue_free();area_zones.erase(actor_id)
func _clear_area_zones() -> void:
	for actor_id in area_zones.keys():_release_area_zone(actor_id)
