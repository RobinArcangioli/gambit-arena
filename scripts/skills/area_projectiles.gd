extends RefCounted
## Combat-owned released spells. No presentation resources or caster lifetime dependency.
const Actor=preload("res://scripts/combat/attack_action.gd")
const Area=preload("res://scripts/skills/area_skills.gd")
var pending:Array[Dictionary]=[]
var events:Array[Dictionary]=[]
var generation:int=0
var _advancing:bool=false
func launch(values:Dictionary,team:int) -> void:
	var flight:Dictionary=values.duplicate(true)
	flight.source_team=team
	flight.remaining=float(Area.DEFINITIONS[StringName(values.skill)].flight)
	pending.append(flight)
func clear() -> void:
	generation+=1;pending.clear();events.clear()
func advance(dt:float,units:Array,time:float) -> void:
	if _advancing or not is_finite(dt) or dt<=0:return
	_advancing=true
	_advance(dt,units,time)
	_advancing=false
func _advance(dt:float,units:Array,time:float) -> void:
	var epoch:int=generation
	for flight in pending.duplicate():
		flight.remaining=maxf(0,float(flight.remaining)-dt)
		if float(flight.remaining)>.000001:continue
		# Remove before health callbacks: no second impact through reentry.
		pending.erase(flight)
		var impact:Dictionary=flight.duplicate(true)
		impact.kind="area_impact";impact.game_time=time;impact.mana_paid=0
		impact.area_count=0;impact.area_total=0
		var center:Vector3=impact.target_position
		var radius:float=impact.area_radius
		var victims:Array=[]
		for unit in units:
			if Actor.living(unit) and unit.team!=flight.source_team and Area.overlaps(Vector2(center.x,center.z),Vector2(unit.position.x,unit.position.z),radius):
				victims.append({"actor":unit,"state":unit.state})
		for victim in victims:
			if generation!=epoch:return
			var target=victim.actor
			if not Actor.living(target) or target.state!=victim.state:continue
			var hit:Dictionary=impact.duplicate(true)
			hit.kind="area_hit";hit.target_id=target.combat_id;hit.target_position=target.position;hit.target_team=target.team
			hit.damage=target.state.damage(int(Area.DEFINITIONS[StringName(flight.skill)].damage))
			if generation!=epoch:return
			impact.area_count+=1;impact.area_total+=int(hit.damage);events.append(hit)
		events.append(impact)
func take_events() -> Array[Dictionary]:
	var result:Array[Dictionary]=events;events=[];return result
