extends RefCounted
## Immutable catalogue; no condition value belongs to an editable order.
const IDS: Array[StringName] = [&"self",&"ally_hp_lt_90",&"ally_hp_lt_70",&"ally_hp_lt_50",&"ally_hp_lt_30",&"ally_hp_lt_10",&"enemy_hp_max",&"enemy_hp_min",&"enemy_near",&"enemy_far"]
const LABELS = {&"self":"Soi-même",&"ally_hp_lt_90":"Allié — PV < 90 %",&"ally_hp_lt_70":"Allié — PV < 70 %",&"ally_hp_lt_50":"Allié — PV < 50 %",&"ally_hp_lt_30":"Allié — PV < 30 %",&"ally_hp_lt_10":"Allié — PV < 10 %",&"enemy_hp_max":"Ennemi — le plus de PV",&"enemy_hp_min":"Ennemi — le moins de PV",&"enemy_near":"Ennemi proche",&"enemy_far":"Ennemi lointain"}
const THRESHOLDS = {&"ally_hp_lt_90":90,&"ally_hp_lt_70":70,&"ally_hp_lt_50":50,&"ally_hp_lt_30":30,&"ally_hp_lt_10":10}
static func has(id: StringName) -> bool:return id in IDS
static func label(id: StringName) -> String:return LABELS.get(id,"")
static func threshold(id: StringName) -> int:return THRESHOLDS.get(id,0)
static func living(row: Variant) -> bool:
	return row is Dictionary and typeof(row.get("id"))==TYPE_INT and typeof(row.get("health"))==TYPE_INT and typeof(row.get("max_health"))==TYPE_INT and row.health>0 and row.max_health>0 and row.get("position") is Vector2 and row.position.is_finite()
static func choose(id: StringName, view: Dictionary) -> Dictionary:
	var source = view.get("source",{})
	if not has(id) or not living(source):return {}
	if id==&"self":return source.duplicate(true)
	var allies: bool = THRESHOLDS.has(id)
	var pool: Array = view.get("allies",[]).duplicate() if allies else view.get("enemies",[]).duplicate()
	if allies:pool.append(source)
	var best: Dictionary = {}
	for candidate in pool:
		if not living(candidate):continue
		if allies and candidate.health*100>=candidate.max_health*threshold(id):continue
		if _prefer(id,candidate,best,source):best = candidate
	return best.duplicate(true)
static func _prefer(id: StringName, candidate: Dictionary, current: Dictionary, source: Dictionary) -> bool:
	if current.is_empty():return true
	if THRESHOLDS.has(id):
		var left = candidate.health*current.max_health
		var right = current.health*candidate.max_health
		if left!=right:return left<right
	elif id in [&"enemy_hp_max",&"enemy_hp_min"] and candidate.health!=current.health:
		return candidate.health>current.health if id==&"enemy_hp_max" else candidate.health<current.health
	var distance: float = source.position.distance_squared_to(candidate.position)
	var previous: float = source.position.distance_squared_to(current.position)
	if distance!=previous:return distance>previous if id==&"enemy_far" else distance<previous
	return candidate.id<current.id
