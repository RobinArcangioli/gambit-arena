extends RefCounted
## Display preferences only, in a separate file from party orders.
var hero_bars: bool = true
var enemy_bars: bool = true
var path: String
func _init(file_path: String = "user://combat_settings.cfg") -> void:path = file_path
func load_preferences() -> void:
	hero_bars=true;enemy_bars=true
	if path.is_empty():return
	var config:=ConfigFile.new()
	if config.load(path)!=OK:return
	var value: Variant=config.get_value("display","hero_bars",true)
	if value is bool:hero_bars=value
	value=config.get_value("display","enemy_bars",true)
	if value is bool:enemy_bars=value
func save_preferences() -> Error:
	if path.is_empty():return OK
	var config:=ConfigFile.new()
	config.set_value("display","hero_bars",hero_bars)
	config.set_value("display","enemy_bars",enemy_bars)
	return config.save(path)
