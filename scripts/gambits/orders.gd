extends RefCounted
## Value-only orders, independent target criterion and available capability.
const BuffCatalog = preload("res://scripts/buffs/buff_catalog.gd")
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Multi=preload("res://scripts/skills/multi_skills.gd")
const Area=preload("res://scripts/skills/area_skills.gd")
const Targeting=preload("res://scripts/gambits/area_targeting.gd")
const PROFILES = preload("res://scripts/party/party_roster.gd").PROFILES
const MAX_ORDERS: int = 100
static func create() -> Dictionary:return {"enabled":true,"criterion":"enemy_near","skill":"basic"}
static func defaults() -> Dictionary:
	var result: Dictionary = {}
	for hero in PROFILES:
		result[String(hero)] = [{"enabled":true,"criterion":"ally_roster" if hero==&"nassau" else "ally_hp_lt_50" if hero==&"anne" else "enemy_near","skill":"booster" if hero==&"nassau" else "heal" if hero==&"anne" else "lightning"},create(),{"enabled":false,"criterion":"enemy_near","skill":"basic"}]
	result.mako.insert(0,{"enabled":true,"criterion":"enemy_group_2","skill":"ice_bolts"})
	return result
static func valid_order(order: Variant, hero: StringName) -> bool:
	return PROFILES.has(hero) and order is Dictionary and order.size()==3 and order.has_all(["enabled","criterion","skill"]) and typeof(order.enabled)==TYPE_BOOL and typeof(order.criterion)==TYPE_STRING and Criteria.has(order.criterion) and typeof(order.skill)==TYPE_STRING and StringName(order.skill) in PROFILES[hero].abilities
static func valid_rows(rows: Variant, hero: StringName) -> bool:
	if not PROFILES.has(hero) or not rows is Array or rows.size()>MAX_ORDERS:return false
	for row in rows:
		if not valid_order(row,hero):return false
	return true
static func valid_configuration(config: Variant) -> bool:
	if not config is Dictionary or config.size()!=PROFILES.size():return false
	for id in PROFILES:
		if not config.has(String(id)) or not valid_rows(config[String(id)],id):return false
	return true
static func evaluate(rows: Array, view: Dictionary) -> Dictionary:
	if rows.size()>MAX_ORDERS:return {}
	var mana: float = view.get("mana",0.0)
	var area_choices:Dictionary={}
	if not is_finite(mana):return {}
	for index in range(rows.size()):
		var order = rows[index]
		if not valid_order(order,view.get("key",&"")) or not order.enabled or StringName(order.skill) not in view.get("abilities",[]):continue
		if mana+0.000001<Executor.cost(order.skill) or float(view.get("cooldowns",{}).get(order.skill,0.0))>0.0:continue
		var minimum: int = Criteria.group_minimum(order.criterion)
		if minimum > 0 and Multi.has(order.skill):
			var enemies: Array = view.get("enemies", []).filter(func(row): return Criteria.living(row))
			if enemies.size() < minimum: continue
			var required: int = mini(Multi.COUNT, minimum)
			var ranked: Array = Criteria.candidates(&"enemy_near", view)
			for candidate in ranked:
				var count: int = 0
				for other in enemies:
					if candidate.position.distance_squared_to(other.position) <= Multi.MULTI_REACH * Multi.MULTI_REACH + .000001: count += 1
				if count >= required:
					return {"skill":order.skill,"target_id":candidate.id,"rule_index":index,"criterion":order.criterion}
			continue
		if minimum > 0:
			var radius:float=Area.radius(order.skill)
			if radius<=0:continue
			if not area_choices.has(radius):
				var living:Array=view.get("enemies",[]).filter(func(row):return Criteria.living(row))
				area_choices[radius]=Targeting.solve(living,Area.coverage_radius(radius),view.source.position,view.get("area_preferred",[]))
			var area:Dictionary=area_choices[radius]
			if area.is_empty() or area.count<minimum:continue
			return {"skill":order.skill,"target_point":area.center,"target_ids":area.ids,"rule_index":index,"criterion":order.criterion}
		var ranked: Array[Dictionary] = Criteria.candidates(order.criterion,view)
		# Buff eligibility filters candidates without changing their criterion ranking.
		if BuffCatalog.is_buff(order.skill):
			ranked = ranked.filter(func(candidate): return BuffCatalog.eligible(order.skill, candidate.get("buffs", {})))
		if ranked.is_empty():continue
		var target: Dictionary = ranked[0]
		# Heal keeps its existing first-candidate semantics; only buffs filter above.
		if order.skill=="heal" and target.health>=target.max_health:continue
		if Area.has(order.skill):return {"skill":order.skill,"target_point":target.position,"target_ids":[target.id],"rule_index":index,"criterion":order.criterion}
		return {"skill":order.skill,"target_id":target.id,"rule_index":index,"criterion":order.criterion}
	return {}
