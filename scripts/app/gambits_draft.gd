extends RefCounted
## Detached edit transaction; persistence uses the same codec as the arena.
const Rules = preload("res://scripts/party/party_rules.gd")
var hero_id: StringName
var save_path: String
var rows: Array = []
var configuration: Dictionary = {}
var readable: bool = true
func open(id: StringName, path: String) -> void:
	hero_id = id;save_path = path
	configuration = _read()
	rows = configuration.get(String(id),[]).duplicate(true)
func _read() -> Dictionary:
	readable = true
	if not save_path.is_empty() and FileAccess.file_exists(save_path):
		var stored: Dictionary = Rules.load_configuration(save_path)
		if stored.is_empty():readable = false
		else:return stored
	return {"anne":Rules.defaults(&"anne"),"mako":Rules.defaults(&"mako")}
func apply() -> Error:
	if hero_id not in [&"anne",&"mako"] or rows.size()!=3:return ERR_INVALID_DATA
	for row in rows:
		if not Rules.valid_rule(row,hero_id):return ERR_INVALID_DATA
	# Reload immediately before writing: changes to the other hero remain intact.
	var latest: Dictionary = _read() if not save_path.is_empty() else configuration.duplicate(true)
	if not readable:return ERR_FILE_CORRUPT
	latest[String(hero_id)] = rows.duplicate(true)
	var result: Error = OK if save_path.is_empty() else Rules.save_configuration(save_path,latest)
	if result==OK:configuration = latest
	return result
