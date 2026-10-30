extends RefCounted
## Presentation order is independent of simulation/solver order.
const Roster = preload("res://scripts/party/party_roster.gd")
const SLOTS: Array[StringName] = Roster.SLOTS
const PROFILES = Roster.PROFILES
const APPEARANCES = {&"mako": preload("res://resources/presentation/characters/mako.tres"), &"anne": preload("res://resources/presentation/characters/anne.tres"), &"nassau":preload("res://resources/presentation/characters/nassau.tres")}
static func caption(id: StringName) -> String:
	return PROFILES[id].display_name if PROFILES.has(id) else "Vide"
