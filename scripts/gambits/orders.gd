extends RefCounted
## Value-only orders, independent target criterion and available capability.
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const PROFILES = {&"anne":preload("res://data/party/anne.tres"),&"mako":preload("res://data/party/mako.tres")}
const MAX_ORDERS: int = 100
static func create() -> Dictionary:return {"enabled":true,"criterion":"enemy_near","skill":"basic"}
static func defaults() -> Dictionary:
	var result: Dictionary = {}
	for hero in PROFILES:
		result[String(hero)] = [{"enabled":true,"criterion":"ally_hp_lt_50" if hero==&"anne" else "enemy_near","skill":"heal" if hero==&"anne" else "lightning"},create(),{"enabled":false,"criterion":"enemy_near","skill":"basic"}]
	return result
static func valid_order(order: Variant, hero: StringName) -> bool:
	return PROFILES.has(hero) and order is Dictionary and order.size()==3 and order.has_all(["enabled","criterion","skill"]) and typeof(order.enabled)==TYPE_BOOL and typeof(order.criterion)==TYPE_STRING and Criteria.has(order.criterion) and typeof(order.skill)==TYPE_STRING and StringName(order.skill) in PROFILES[hero].abilities
static func valid_rows(rows: Variant, hero: StringName) -> bool:
	if not PROFILES.has(hero) or not rows is Array or rows.size()>MAX_ORDERS:return false
	for row in rows:
		if not valid_order(row,hero):return false
	return true
static func valid_configuration(config: Variant) -> bool:
	return config is Dictionary and config.size()==2 and config.has_all(["anne","mako"]) and valid_rows(config.anne,&"anne") and valid_rows(config.mako,&"mako")
static func evaluate(rows: Array, view: Dictionary) -> Dictionary:
	if rows.size()>MAX_ORDERS:return {}
	var mana: float = view.get("mana",0.0)
	if not is_finite(mana):return {}
	for index in range(rows.size()):
		var order = rows[index]
		if not valid_order(order,view.get("key",&"")) or not order.enabled or StringName(order.skill) not in view.get("abilities",[]):continue
		if mana+0.000001<Executor.cost(order.skill) or float(view.get("cooldowns",{}).get(order.skill,0.0))>0.0:continue
		var ranked: Array[Dictionary] = Criteria.candidates(order.criterion,view)
		if ranked.is_empty():continue
		var target: Dictionary = ranked[0]
		# Capability availability cannot reorder the criterion's candidate ranking.
		if order.skill=="heal" and target.health>=target.max_health:continue
		return {"skill":order.skill,"target_id":target.id,"rule_index":index,"criterion":order.criterion}
	return {}
