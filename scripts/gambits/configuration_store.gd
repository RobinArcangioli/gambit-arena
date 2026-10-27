extends RefCounted
## Immediate per-change persistence. Callers publish a changed row list only after success.
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
var path: String
var configuration: Dictionary = {}
var migration_notes: Array = []
func _init(saved_path: String) -> void:path = saved_path
func load_configuration() -> Error:
	var result: Dictionary = Codec.read(path)
	if result.error==ERR_FILE_NOT_FOUND:configuration = Orders.defaults();migration_notes = [];return OK
	if result.error!=OK:return result.error
	configuration = result.configuration.duplicate(true);migration_notes = result.notes.duplicate(true)
	return OK
func save_hero(hero: StringName, rows: Array) -> Error:
	if path.is_empty() or not Orders.valid_rows(rows,hero):return ERR_INVALID_DATA
	var latest: Dictionary = Codec.read(path)
	if latest.error!=OK and latest.error!=ERR_FILE_NOT_FOUND:return latest.error
	var next: Dictionary = latest.configuration.duplicate(true) if latest.error==OK else Orders.defaults()
	next[String(hero)] = rows.duplicate(true)
	if not Orders.valid_configuration(next):return ERR_INVALID_DATA
	if latest.error==OK and latest.source_version==2:
		var backup_error: Error = _backup_original()
		if backup_error!=OK:return backup_error
	var result: Error = Codec.save(path,next)
	if result==OK:
		configuration = next
		migration_notes = latest.notes.duplicate(true) if latest.error==OK else []
	return result
func _backup_original() -> Error:
	var original: PackedByteArray = FileAccess.get_file_as_bytes(path)
	var backup: String = path+".v2.bak"
	if FileAccess.file_exists(backup):return OK if FileAccess.get_file_as_bytes(backup)==original else ERR_ALREADY_EXISTS
	var file := FileAccess.open(backup,FileAccess.WRITE)
	if file==null:return FileAccess.get_open_error()
	file.store_buffer(original);file.flush();var result: Error = file.get_error();file.close()
	return result
