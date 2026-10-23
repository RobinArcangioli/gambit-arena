extends RefCounted
## Value-only input. No Node, ActorState, executor or clock references.
## Actor row: {id: positive int, health: int, max_health: int, position: Vector2}.
var source: Dictionary = {}
var enemies: Array[Dictionary] = []
var energy: int = 60
var heal_cooldown: float = 0.0
var special_cooldown: float = 0.0
var busy: bool = false
var paused: bool = false
var stopped: bool = false

func valid() -> bool:
	if not _valid_actor(source) or energy < 0 or energy > 60 or enemies.size() > 20:
		return false
	if not is_finite(heal_cooldown) or not is_finite(special_cooldown) or heal_cooldown < 0.0 or special_cooldown < 0.0:
		return false
	var ids: Dictionary = {source["id"]: true}
	for row in enemies:
		if not _valid_actor(row) or ids.has(row["id"]):
			return false
		ids[row["id"]] = true
	return true

static func _valid_actor(row: Dictionary) -> bool:
	# Reject extra fields as well: snapshots cannot smuggle live references.
	if row.size() != 4:
		return false
	for key in ["id", "health", "max_health"]:
		if not row.has(key) or typeof(row[key]) != TYPE_INT:
			return false
	if not row.has("position") or typeof(row["position"]) != TYPE_VECTOR2:
		return false
	var position: Vector2 = row["position"]
	return row["id"] > 0 and row["max_health"] > 0 and row["max_health"] <= 1000000 and row["health"] >= 0 and row["health"] <= row["max_health"] and position.is_finite() and absf(position.x) <= 1000000.0 and absf(position.y) <= 1000000.0
