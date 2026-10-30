extends RefCounted
## Four stable logical slots, separate from gambits and artistic resources.
const Roster=preload("res://scripts/party/party_roster.gd")
var slots:Array[StringName]=Roster.SLOTS.duplicate()
var path:String
func _init(saved_path:String="") -> void:path=saved_path
func load_or_create() -> Error:
	if path.is_empty():return OK
	if not FileAccess.file_exists(path):return save_slots(slots)
	var file:=FileAccess.open(path,FileAccess.READ)
	if file==null:return FileAccess.get_open_error()
	if file.get_length()>4096:return ERR_INVALID_DATA
	var data=JSON.parse_string(file.get_as_text())
	if not data is Dictionary or data.size()!=2 or data.get("version")!=1 or not Roster.valid_slots(data.get("slots")):return ERR_INVALID_DATA
	slots.assign(data.slots);return OK
func save_slots(value:Array) -> Error:
	if not Roster.valid_slots(value):return ERR_INVALID_DATA
	if path.is_empty():slots.assign(value);return OK
	var temporary:String=path+".tmp-%d"%Time.get_ticks_usec()
	var file:=FileAccess.open(temporary,FileAccess.WRITE)
	if file==null:return FileAccess.get_open_error()
	file.store_string(JSON.stringify({"version":1,"slots":value}));file.flush()
	var error:Error=file.get_error();file.close()
	if error==OK:error=DirAccess.rename_absolute(temporary,path)
	if error!=OK:DirAccess.remove_absolute(temporary)
	else:slots.assign(value)
	return error
