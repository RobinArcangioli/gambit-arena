extends RefCounted
## Immutable catalogue; no condition value belongs to an editable order.
const IDS: Array[StringName] = [&"self",&"ally_roster",&"ally_hp_lt_90",&"ally_hp_lt_70",&"ally_hp_lt_50",&"ally_hp_lt_30",&"ally_hp_lt_10",&"enemy_hp_max",&"enemy_hp_min",&"enemy_near",&"enemy_far",&"enemy_group_3",&"enemy_group_2",&"enemy_group_4"]
const LABELS = {&"self":"Soi-même",&"ally_roster":"Allié",&"ally_hp_lt_90":"Allié — PV < 90 %",&"ally_hp_lt_70":"Allié — PV < 70 %",&"ally_hp_lt_50":"Allié — PV < 50 %",&"ally_hp_lt_30":"Allié — PV < 30 %",&"ally_hp_lt_10":"Allié — PV < 10 %",&"enemy_hp_max":"Ennemi — le plus de PV",&"enemy_hp_min":"Ennemi — le moins de PV",&"enemy_near":"Ennemi proche",&"enemy_far":"Ennemi lointain"}
const THRESHOLDS = {&"ally_hp_lt_90":90,&"ally_hp_lt_70":70,&"ally_hp_lt_50":50,&"ally_hp_lt_30":30,&"ally_hp_lt_10":10}
static func has(id: StringName) -> bool:return id in IDS
static func group_minimum(id: StringName) -> int:
	return {&"enemy_group_2":2, &"enemy_group_3":3, &"enemy_group_4":4}.get(id, 0)
static func label(id: StringName) -> String:
	var count: int = group_minimum(id)
	return "%d ennemis ou plus" % count if count > 0 else LABELS.get(id, "")
static func threshold(id: StringName) -> int:return THRESHOLDS.get(id,0)
static func living(row: Variant) -> bool:
	return row is Dictionary and typeof(row.get("id"))==TYPE_INT and typeof(row.get("health"))==TYPE_INT and typeof(row.get("max_health"))==TYPE_INT and row.health>0 and row.max_health>0 and row.get("position") is Vector2 and row.position.is_finite()
static func choose(id: StringName, view: Dictionary) -> Dictionary:
	var ranked: Array[Dictionary] = candidates(id,view)
	return ranked[0] if not ranked.is_empty() else {}

static func candidates(id: StringName, view: Dictionary) -> Array[Dictionary]:
	# Detached, ranked values. A future capability filter can select from this list.
	var ranked: Array[Dictionary] = []
	var source = view.get("source",{})
	if not has(id) or not living(source):return ranked
	if group_minimum(id)>0:return ranked # Requires a skill radius; Orders evaluates the pair.
	if id==&"self":
		ranked.append(source.duplicate(true));return ranked
	var allies: bool = id==&"ally_roster" or THRESHOLDS.has(id)
	var pool: Array = view.get("allies",[]).duplicate() if allies else view.get("enemies",[]).duplicate()
	if allies:pool.append(source)
	for candidate in pool:
		if not living(candidate):continue
		if id==&"ally_roster" and (typeof(candidate.get("team_slot"))!=TYPE_INT or candidate.team_slot<0):continue
		if THRESHOLDS.has(id) and candidate.health*100>=candidate.max_health*threshold(id):continue
		ranked.append(candidate.duplicate(true))
	ranked.sort_custom(func(left: Dictionary, right: Dictionary) -> bool:return _prefer(id,left,right,source))
	return ranked
static func _prefer(id: StringName, candidate: Dictionary, current: Dictionary, source: Dictionary) -> bool:
	if current.is_empty():return true
	if id==&"ally_roster":
		return candidate.team_slot<current.team_slot if candidate.team_slot!=current.team_slot else candidate.id<current.id
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
