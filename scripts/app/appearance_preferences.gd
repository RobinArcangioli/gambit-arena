extends RefCounted
## Independent cosmetic preference. Missing files do not trigger writes.
const IDS=[&"arcane",&"berserk"]
var style_id:StringName=&"arcane"
var path:String
func _init(file_path:String="user://appearance.cfg") -> void:path=file_path
func load_preferences() -> Error:
	style_id=&"arcane"
	if path.is_empty():return OK
	var config:=ConfigFile.new();var result:Error=config.load(path)
	if result==ERR_FILE_NOT_FOUND:return OK
	if result!=OK:return result
	var saved:Variant=config.get_value("appearance","style","arcane")
	if not saved is String or StringName(saved) not in IDS:return ERR_INVALID_DATA
	style_id=StringName(saved);return OK
func save_style(value:StringName) -> Error:
	if value not in IDS:return ERR_INVALID_PARAMETER
	if not path.is_empty():
		var config:=ConfigFile.new();config.set_value("appearance","style",String(value))
		var result:Error=config.save(path)
		if result!=OK:return result
	style_id=value;return OK
