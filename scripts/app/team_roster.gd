extends RefCounted
## Presentation order is independent of simulation/solver order.
const SLOTS: Array[StringName] = [&"mako", &"anne", &"", &""]
const PROFILES = {&"mako": preload("res://data/party/mako.tres"), &"anne": preload("res://data/party/anne.tres")}
const APPEARANCES = {&"mako": preload("res://resources/presentation/characters/mako.tres"), &"anne": preload("res://resources/presentation/characters/anne.tres")}
static func caption(id: StringName) -> String:
	return PROFILES[id].display_name if PROFILES.has(id) else "Vide"
