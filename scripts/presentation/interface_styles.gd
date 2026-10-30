extends RefCounted
const PROFILES={&"arcane":preload("res://resources/ui/styles/arcane.tres"),&"berserk":preload("res://resources/ui/styles/berserk.tres")}
static func get_style(id:StringName) -> Resource:return PROFILES.get(id,PROFILES[&"arcane"])
