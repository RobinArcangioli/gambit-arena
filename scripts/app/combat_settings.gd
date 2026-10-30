extends RefCounted
## Display preferences only, in a separate file from party orders.
var grid:bool=false
var aoe_zone:bool=true
var hero_bars: bool = true
var enemy_bars: bool = true
var damage_dealt_text:bool=true
var damage_received_text:bool=true
var healing_text:bool=true
var path: String
func _init(file_path: String = "user://combat_settings.cfg") -> void:path = file_path
func load_preferences() -> void:
	grid=false;aoe_zone=true;hero_bars=true;enemy_bars=true;damage_dealt_text=true;damage_received_text=true;healing_text=true
	if path.is_empty():return
	var config:=ConfigFile.new()
	if config.load(path)!=OK:return
	var value: Variant=config.get_value("display","grid",false)
	if value is bool:grid=value
	value=config.get_value("display","aoe_zone",true)
	if value is bool:aoe_zone=value
	value=config.get_value("display","hero_bars",true)
	if value is bool:hero_bars=value
	value=config.get_value("display","enemy_bars",true)
	if value is bool:enemy_bars=value
	for key in ["damage_dealt_text","damage_received_text","healing_text"]:
		value=config.get_value("floating_text",key,true)
		if value is bool:set(key,value)
func save_preferences() -> Error:
	if path.is_empty():return OK
	var config:=ConfigFile.new()
	config.set_value("display","grid",grid)
	config.set_value("display","aoe_zone",aoe_zone)
	config.set_value("display","hero_bars",hero_bars)
	config.set_value("display","enemy_bars",enemy_bars)
	for key in ["damage_dealt_text","damage_received_text","healing_text"]:config.set_value("floating_text",key,get(key))
	return config.save(path)
