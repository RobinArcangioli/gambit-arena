extends RefCounted
## Versioned value codec. Reading never writes or modifies a legacy source.
const Orders = preload("res://scripts/gambits/orders.gd")
const Legacy = preload("res://scripts/party/party_rules.gd")
const VERSION: int = 3
const MAX_BYTES: int = 262144
static func decode(text: String) -> Dictionary:
	if text.to_utf8_buffer().size()>MAX_BYTES:return {"error":ERR_INVALID_DATA}
	var parser := JSON.new()
	if parser.parse(text)!=OK:return {"error":ERR_PARSE_ERROR}
	var data = parser.data
	if not data is Dictionary or data.size()!=2 or not data.has_all(["version","heroes"]):return {"error":ERR_INVALID_DATA}
	if data.version==VERSION and Orders.valid_configuration(data.heroes):
		return {"error":OK,"configuration":data.heroes.duplicate(true),"source_version":VERSION,"notes":[]}
	if data.version!=2:return {"error":ERR_INVALID_DATA}
	var heroes = data.heroes
	if not heroes is Dictionary:return {"error":ERR_INVALID_DATA}
	for hero in ["anne","mako"]:
		if not heroes.get(hero) is Array:return {"error":ERR_INVALID_DATA}
		for row in heroes[hero]:
			if not row is Dictionary:return {"error":ERR_INVALID_DATA}
			var value = row.get("threshold")
			if typeof(value) not in [TYPE_INT,TYPE_FLOAT] or not is_finite(value) or value!=floor(value):return {"error":ERR_INVALID_DATA}
			row.threshold = int(value)
	return migrate(heroes)
static func migrate(legacy: Dictionary) -> Dictionary:
	if not Legacy.validate_configuration(legacy):return {"error":ERR_INVALID_DATA}
	var config: Dictionary = {};var notes: Array[Dictionary] = []
	for hero in ["anne","mako"]:
		config[hero] = []
		for index in range(legacy[hero].size()):
			var previous: Dictionary = legacy[hero][index]
			var order: Dictionary = {"enabled":previous.enabled,"criterion":"enemy_near","skill":previous.skill}
			var converted: bool = previous.target=="enemy" and previous.condition=="always"
			if previous.target=="ally" and previous.condition=="hp_below":
				for limit in [90,70,50,30,10]:
					if limit<=previous.threshold:
						order.criterion = "ally_hp_lt_%d" % limit;converted = true
						if limit!=previous.threshold:notes.append({"hero":hero,"index":index,"kind":"threshold_lowered","from":previous.duplicate(true),"criterion":order.criterion})
						break
			if not converted:
				order.enabled = false
				notes.append({"hero":hero,"index":index,"kind":"needs_review","from":previous.duplicate(true),"criterion":order.criterion})
			config[hero].append(order)
	return {"error":OK,"configuration":config,"source_version":2,"notes":notes}
static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):return {"error":ERR_FILE_NOT_FOUND}
	var file := FileAccess.open(path,FileAccess.READ)
	if file==null:return {"error":FileAccess.get_open_error()}
	if file.get_length()>MAX_BYTES:return {"error":ERR_INVALID_DATA}
	return decode(file.get_as_text())
static func save(path: String, config: Dictionary) -> Error:
	if path.is_empty() or not Orders.valid_configuration(config):return ERR_INVALID_DATA
	var text: String = JSON.stringify({"version":VERSION,"heroes":config},"	")
	if text.to_utf8_buffer().size()>MAX_BYTES:return ERR_INVALID_DATA
	var temporary: String = path+".tmp-%d" % Time.get_ticks_usec()
	var file := FileAccess.open(temporary,FileAccess.WRITE)
	if file==null:return FileAccess.get_open_error()
	file.store_string(text);file.flush();var result: Error = file.get_error();file.close()
	if result==OK:result = DirAccess.rename_absolute(temporary,path)
	if result!=OK:DirAccess.remove_absolute(temporary)
	return result
