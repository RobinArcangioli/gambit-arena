extends RefCounted
## Stable IDs and lightweight metadata. Full backgrounds load only when selected.
const Definition = preload("res://scripts/presentation/arena_definition.gd")
const ENTRIES: Dictionary = {
	&"colisee_solaire": "Colisee solaire",
	&"sanctuaire_polaire": "Sanctuaire polaire",
	&"forteresse_volcanique": "Forteresse volcanique",
	&"temple_sylvestre": "Temple sylvestre",
	&"arcane_bleu_sombre": "Arcane bleu sombre",
	&"chaos_vert_toxique": "Chaos vert toxique",
	&"lumiere_angelique": "Lumiere angelique",
	&"pirates_fantomes": "Pirates fantomes",
	&"reference": "Terrain de reference",
}

static func ids() -> Array[StringName]:
	var result: Array[StringName] = []
	result.assign(ENTRIES.keys())
	return result

static func title(arena_id: StringName) -> String:
	return ENTRIES.get(arena_id, ENTRIES[&"reference"])

static func definition(arena_id: StringName) -> Definition:
	var chosen: StringName = arena_id if ENTRIES.has(arena_id) else &"reference"
	var path: String = "res://resources/presentation/arenas/%s.tres" % chosen
	var resource = load(path) if ResourceLoader.exists(path) else null
	if resource is Definition and resource.view_scene != null:
		return resource
	return load("res://resources/presentation/arenas/reference.tres")

static func preview(arena_id: StringName) -> Texture2D:
	if not ENTRIES.has(arena_id) or arena_id == &"reference":
		return null
	var path: String = "res://assets/art/arenas/previews/%s.png" % arena_id
	return load(path) if ResourceLoader.exists(path) else null
