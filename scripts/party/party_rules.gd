extends RefCounted
## Detached values only. Team rules are separate from legacy single-hero lab resources.
const Executor = preload("res://scripts/party/party_executor.gd")
const VERSION: int = 2

static func defaults(key: StringName) -> Array:
	var spell: String = "heal" if key == &"anne" else "lightning"
	return [
		{"enabled": true, "target": "ally" if key == &"anne" else "enemy", "condition": "hp_below" if key == &"anne" else "always", "threshold": 50, "skill": spell},
		{"enabled": true, "target": "enemy", "condition": "always", "threshold": 50, "skill": "basic"},
		{"enabled": false, "target": "enemy", "condition": "always", "threshold": 50, "skill": "basic"}]

static func valid_rule(rule: Variant, key: StringName) -> bool:
	if not rule is Dictionary or rule.size() != 5 or not rule.has_all(["enabled", "target", "condition", "threshold", "skill"]): return false
	if typeof(rule.enabled) != TYPE_BOOL or typeof(rule.threshold) != TYPE_INT or rule.threshold < 0 or rule.threshold > 100: return false
	if rule.condition not in ["always", "hp_below"]: return false
	if rule.skill == "heal": return key == &"anne" and rule.target == "ally"
	if rule.skill == "lightning": return key == &"mako" and rule.target == "enemy"
	return rule.skill == "basic" and rule.target == "enemy"

static func evaluate(rules: Array, view: Dictionary) -> Dictionary:
	for index in range(rules.size()):
		var rule = rules[index]
		if not valid_rule(rule, view.key) or not rule.enabled or not rule.skill in view.abilities: continue
		if view.mana + 0.000001 < Executor.cost(rule.skill) or float(view.cooldowns.get(rule.skill, 0.0)) > 0.0: continue
		var candidates: Array = view.allies.duplicate() if rule.target == "ally" else view.enemies
		if rule.target == "ally": candidates.append(view.source)
		var chosen: Dictionary = {}
		var nearest: float = INF
		for row in candidates:
			if row.health <= 0: continue
			if rule.skill == "heal" and row.health >= row.max_health: continue
			if rule.condition == "hp_below" and row.health * 100 >= row.max_health * rule.threshold: continue
			var distance: float = view.source.position.distance_squared_to(row.position)
			var preferred: bool = prefer_heal(row, chosen, view.source) if rule.skill == "heal" else chosen.is_empty() or distance < nearest or (distance == nearest and row.id < chosen.id)
			if preferred:
				chosen = row
				nearest = distance
		if not chosen.is_empty():
			return {"skill": rule.skill, "target_id": chosen.id, "rule_index": index}
	return {}

static func prefer_heal(candidate: Dictionary, current: Dictionary, source: Dictionary) -> bool:
	if current.is_empty(): return true
	# Exact ratios; a larger maximum HP must not distort medical priority.
	var left: int = candidate.health * current.max_health
	var right: int = current.health * candidate.max_health
	if left != right: return left < right
	var distance: float = source.position.distance_squared_to(candidate.position)
	var previous: float = source.position.distance_squared_to(current.position)
	return distance < previous or (distance == previous and candidate.id < current.id)

static func validate_configuration(data: Variant) -> bool:
	if not data is Dictionary or data.size() != 2 or not data.has_all(["anne", "mako"]): return false
	for key in [&"anne", &"mako"]:
		if not data[String(key)] is Array or data[String(key)].size() != 3: return false
		for row in data[String(key)]:
			if not valid_rule(row, key): return false
	return true

static func save_configuration(path: String, data: Dictionary) -> Error:
	if not validate_configuration(data): return ERR_INVALID_DATA
	var file := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null: return FileAccess.get_open_error()
	file.store_string(JSON.stringify({"version": VERSION, "heroes": data}, "\t"))
	file.close()
	return DirAccess.rename_absolute(path + ".tmp", path)

static func load_configuration(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() > 65536: return {}
	var data = JSON.parse_string(file.get_as_text())
	if not data is Dictionary or data.get("version") != VERSION: return {}
	# JSON numbers parse as floats. Accept exact integers only, before rule validation.
	var heroes = data.get("heroes")
	if not heroes is Dictionary: return {}
	for key in ["anne", "mako"]:
		if not heroes.get(key) is Array: return {}
		for row in heroes[key]:
			if not row is Dictionary: return {}
			var value = row.get("threshold")
			if typeof(value) not in [TYPE_INT, TYPE_FLOAT] or not is_finite(value) or value != floor(value): return {}
			row.threshold = int(value)
	return heroes if validate_configuration(heroes) else {}

static func migrate_legacy(legacy: Array, key: StringName) -> Dictionary:
	var result: Array = []
	var notes: Array[String] = []
	if legacy.size() != 3: return {"rules": defaults(key), "notes": ["Configuration historique invalide : valeurs par defaut proposees."]}
	for previous in legacy:
		var row: Dictionary = previous.duplicate(true) if previous is Dictionary else {}
		if row.get("skill") == "special":
			row.skill = "lightning"
			notes.append("Speciale devient Foudre pour Mako ; regle desactivee pour Anne.")
		if row.get("skill") == "heal" and row.get("target") == "self":
			row.target = "ally"
			notes.append("Soin personnel devient Soin sur l'equipe, Anne comprise ; regle desactivee pour Mako.")
		if not valid_rule(row, key):
			row = {"enabled": false, "target": "enemy", "condition": "always", "threshold": 50, "skill": "basic"}
		result.append(row)
	return {"rules": result, "notes": notes}
