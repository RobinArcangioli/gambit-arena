extends RefCounted
## Immutable value definition, independent of skills, actors, artwork and persistence.
static func create(id: StringName, duration: float, time_multiplier: float = 1.0) -> Dictionary:
	if id == &"" or not is_finite(duration) or duration <= 0.0 or not is_finite(time_multiplier) or time_multiplier <= 0.0:
		return {}
	var definition: Dictionary = {"id": id, "duration": duration, "time_multiplier": time_multiplier, "stacking": &"reject_active"}
	definition.make_read_only()
	return definition
