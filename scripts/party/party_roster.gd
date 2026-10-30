extends RefCounted
## Shared logical roster: UI order and targeting order, independent of simulation ticks.
const SLOTS: Array[StringName] = [&"mako",&"anne",&"nassau",&""]
const PROFILES = {&"mako":preload("res://data/party/mako.tres"),&"anne":preload("res://data/party/anne.tres"),&"nassau":preload("res://data/party/nassau.tres")}
static func valid_slots(value:Variant) -> bool:
	if not value is Array or value.size()!=4:return false
	var seen:Array=[]
	for id in value:
		if typeof(id) not in [TYPE_STRING,TYPE_STRING_NAME]:return false
		if id=="" or id==&"":continue
		if not PROFILES.has(StringName(id)) or StringName(id) in seen:return false
		seen.append(StringName(id))
	return seen.size()==PROFILES.size()
static func rank(key: StringName) -> int:
	return -1 if key==&"" else SLOTS.find(key)
