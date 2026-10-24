extends RefCounted
## Fixed-size, value-only diagnostic journal. No gameplay objects or snapshots.
const CAPACITY: int = 64
var total: int = 0
var dropped: int = 0
var _entries: Array[Dictionary] = []

func clear() -> void:
	_entries.clear()
	total = 0
	dropped = 0

func size() -> int:
	return _entries.size()

func record(event: String, at: float, decision: Dictionary, action_id: int = 0, reason: String = "", details: Array[Dictionary] = []) -> void:
	if not is_finite(at) or at < 0.0:
		return
	var rows: Array[Dictionary] = []
	for index in range(mini(3, details.size())):
		var row: Dictionary = details[index]
		rows.append({"rule_index": _integer(row, "rule_index", -1), "reason": _text(row, "reason", 32)})
	total += 1
	var entry: Dictionary = {"sequence": total, "time": at, "event": event.left(24), "rule_index": _integer(decision, "rule_index", -1), "skill": _text(decision, "skill", 16), "target_id": _integer(decision, "target_id", 0), "action_id": action_id, "reason": reason.left(32), "rules": rows}
	if _entries.size() == CAPACITY:
		_entries.pop_front()
		dropped += 1
	_entries.append(entry)

func latest(limit: int = CAPACITY) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var count: int = clampi(limit, 0, CAPACITY)
	for index in range(maxi(0, _entries.size() - count), _entries.size()):
		result.append(_entries[index].duplicate(true))
	return result

static func _integer(row: Dictionary, key: String, fallback: int) -> int:
	return int(row[key]) if row.has(key) and typeof(row[key]) == TYPE_INT else fallback

static func _text(row: Dictionary, key: String, limit: int) -> String:
	return String(row[key]).left(limit) if row.has(key) and typeof(row[key]) == TYPE_STRING else ""
