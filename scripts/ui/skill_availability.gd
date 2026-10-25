extends RefCounted
## Value-only presentation of immediate availability; never requests an action.
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const SKILLS: Array[String] = ["basic", "heal", "special"]
const NAMES: Array[String] = ["Attaque", "Soin", "Speciale"]

static func describe(view: Snapshot) -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for index in range(6):
		if index >= 3:
			rows.append({"slot": index, "skill": "", "name": "A venir", "cost": 0, "cooldown": 0.0, "remaining": 0.0, "state": "reserved", "target_id": 0})
			continue
		var skill: String = SKILLS[index]
		var cost: int = Executor.HEAL_COST if skill == "heal" else Executor.SPECIAL_COST if skill == "special" else 0
		var cooldown: float = Executor.HEAL_COOLDOWN if skill == "heal" else Executor.SPECIAL_COOLDOWN if skill == "special" else 0.0
		var row: Dictionary = {"slot": index, "skill": skill, "name": NAMES[index], "cost": cost, "cooldown": cooldown, "remaining": 0.0, "state": "invalid", "target_id": 0}
		if view != null and view.valid():
			row["remaining"] = view.heal_cooldown if skill == "heal" else view.special_cooldown if skill == "special" else 0.0
			row["state"] = _state(view, row)
		rows.append(row)
	return rows

static func _state(view: Snapshot, row: Dictionary) -> String:
	if view.source["health"] == 0:
		return "dead"
	if view.stopped:
		return "finished"
	if view.paused:
		return "paused"
	if view.busy:
		return "busy"
	if row["remaining"] > 0.0:
		return "cooldown"
	if row["skill"] == "heal" and view.source["health"] >= view.source["max_health"]:
		return "full_health"
	if view.energy < row["cost"]:
		return "energy"
	if row["skill"] == "heal":
		row["target_id"] = view.source["id"]
		return "ready"
	var nearest: float = INF
	var selected_id: int = 0
	var source_position: Vector2 = view.source["position"]
	for enemy in view.enemies:
		if enemy["health"] <= 0:
			continue
		var distance: float = source_position.distance_squared_to(enemy["position"])
		if distance < nearest or (distance == nearest and (selected_id == 0 or enemy["id"] < selected_id)):
			nearest = distance
			selected_id = enemy["id"]
	if selected_id == 0:
		return "no_target"
	row["target_id"] = selected_id
	return "ready" if nearest <= Executor.REACH * Executor.REACH else "out_of_range"

static func caption(state: String) -> String:
	match state:
		"ready": return "Pret"
		"paused": return "Pause"
		"busy": return "Occupe"
		"cooldown": return "Delai"
		"energy": return "Energie"
		"full_health": return "PV pleins"
		"no_target": return "Sans cible"
		"out_of_range": return "Hors portee"
		"dead": return "Mort"
		"finished": return "Termine"
		"reserved": return "A venir"
	return "Indisponible"

static func explanation(state: String) -> String:
	match state:
		"ready": return "Conditions immediates reunies."
		"paused": return "Reprendre le combat pour agir."
		"busy": return "Une action est deja engagee."
		"cooldown": return "Attendre la fin du delai."
		"energy": return "Energie insuffisante."
		"full_health": return "Le soin serait inutile : PV pleins."
		"no_target": return "Aucun ennemi vivant."
		"out_of_range": return "L'ennemi le plus proche est hors portee."
		"dead": return "Le heros est mort."
		"finished": return "Le combat est termine."
	return "Emplacement indisponible."
