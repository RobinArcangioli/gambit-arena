extends Node
const Codec=preload("res://scripts/gambits/configuration_codec.gd")
const Orders=preload("res://scripts/gambits/orders.gd")
const Store=preload("res://scripts/gambits/configuration_store.gd")
const Legacy=preload("res://scripts/party/party_rules.gd")
var checks: int=0
var failures: int=0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("OrdersCodec: "+message)
func old_config() -> Dictionary:return {"anne":Legacy.defaults(&"anne"),"mako":Legacy.defaults(&"mako")}
func text(config: Dictionary) -> String:return JSON.stringify({"version":2,"heroes":config},"	")
func write(path: String, value: String) -> void:
	var file=FileAccess.open(path,FileAccess.WRITE);file.store_string(value);file.close()
func remove(path: String) -> void:
	if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
func _ready() -> void:
	for threshold in range(101):
		var legacy: Dictionary=old_config();legacy.anne[0].threshold=threshold
		var before: Dictionary=legacy.duplicate(true);var result: Dictionary=Codec.migrate(legacy)
		var expected: int=0
		for allowed in [90,70,50,30,10]:
			if allowed<=threshold:expected=allowed;break
		check(result.error==OK and Orders.valid_configuration(result.configuration),"all legal legacy thresholds produce valid v3")
		check(result.configuration.anne[0].criterion==("ally_hp_lt_%d"%expected if expected>0 else "enemy_near") and result.configuration.anne[0].enabled==bool(expected>0),"threshold rounds downward or disables impossible mapping")
		check(legacy==before,"migration never mutates input")
	var legacy: Dictionary=old_config();legacy.anne[0].threshold=80
	var result: Dictionary=Codec.decode(text(legacy))
	check(result.configuration.anne[0].criterion=="ally_hp_lt_70" and result.notes[0].kind=="threshold_lowered","Anne 80 becomes fixed 70 with report")
	legacy.anne[0].condition="always";legacy.mako[0].condition="hp_below"
	result=Codec.migrate(legacy)
	check(not result.configuration.anne[0].enabled and not result.configuration.mako[0].enabled and result.notes.size()==2,"unrepresentable old rules disabled with notes")
	check(result.configuration.anne[0].skill=="heal" and result.configuration.mako[0].skill=="lightning","disabled migration preserves capacity and position")
	for invalid in ["broken","{}",JSON.stringify({"version":4,"heroes":Orders.defaults()}),JSON.stringify({"version":3,"heroes":{"mako":[]}})]:check(Codec.decode(invalid).error!=OK,"invalid input rejected without fallback")
	check(Codec.decode(" ".repeat(Codec.MAX_BYTES+1)).error==ERR_INVALID_DATA,"oversized input rejected")
	var path: String="user://gambits001-codec.json";remove(path);remove(path+".v2.bak")
	var store=Store.new(path)
	check(store.load_configuration()==OK and not FileAccess.file_exists(path),"missing file yields defaults in memory only")
	var rows: Array=[Orders.create()]
	check(store.save_hero(&"mako",rows)==OK and Codec.read(path).configuration.mako.size()==1,"one edit saves immediately")
	rows[0].enabled=false
	check(store.configuration.mako[0].enabled,"caller cannot mutate saved store state through array")
	var external: Dictionary=Codec.read(path).configuration;external.anne=[];Codec.save(path,external)
	check(store.save_hero(&"mako",[])==OK and Codec.read(path).configuration.anne.is_empty(),"write reloads and preserves newer other hero changes")
	var fresh=Store.new(path);check(fresh.load_configuration()==OK and fresh.configuration.mako.is_empty(),"new store reloads empty lists")
	var largest: Dictionary={"anne":[],"mako":[]}
	for i in range(100):largest.anne.append(Orders.create());largest.mako.append(Orders.create())
	check(Codec.save(path,largest)==OK and Codec.read(path).configuration==largest and FileAccess.get_file_as_bytes(path).size()<Codec.MAX_BYTES,"two hundred orders round-trip within size limit")
	largest.mako.append(Orders.create());var saved: String=FileAccess.get_file_as_string(path)
	check(Codec.save(path,largest)==ERR_INVALID_DATA and FileAccess.get_file_as_string(path)==saved,"101st order cannot overwrite valid file")
	legacy=old_config();legacy.anne[0].threshold=80;var original: String=text(legacy);write(path,original)
	store=Store.new(path)
	check(store.load_configuration()==OK and store.configuration.anne[0].criterion=="ally_hp_lt_70" and FileAccess.get_file_as_string(path)==original and not FileAccess.file_exists(path+".v2.bak"),"reading migrates only in memory")
	var edited: Array=store.configuration.anne.duplicate(true);edited[0].criterion="self"
	check(store.save_hero(&"anne",edited)==OK and FileAccess.get_file_as_string(path+".v2.bak")==original and Codec.read(path).source_version==3,"first change protects original bytes and writes v3")
	edited[0].enabled=false
	check(store.save_hero(&"anne",edited)==OK and FileAccess.get_file_as_string(path+".v2.bak")==original,"later change preserves original backup")
	write(path,original);write(path+".v2.bak","other backup")
	check(store.save_hero(&"anne",edited)==ERR_ALREADY_EXISTS and FileAccess.get_file_as_string(path)==original,"conflicting backup blocks overwrite")
	write(path,"broken")
	check(store.load_configuration()==ERR_PARSE_ERROR and store.save_hero(&"anne",edited)==ERR_PARSE_ERROR and FileAccess.get_file_as_string(path)=="broken","malformed existing file never overwritten")
	var blocked=Store.new("user://gambits001-missing-directory/rules.json");blocked.load_configuration();var previous: Dictionary=blocked.configuration.duplicate(true)
	check(blocked.save_hero(&"mako",[])!=OK and blocked.configuration==previous,"failed save keeps last persisted model")
	remove(path);remove(path+".v2.bak")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
