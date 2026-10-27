extends RefCounted
## Runtime copies only. Advance once per accepted combat step, never on rendering time.
const Definition = preload("res://scripts/buffs/buff_definition.gd")
var _active: Dictionary = {}

func apply(definition: Dictionary) -> bool:
	if not definition.get("id") is StringName or not definition.get("duration") is float or not definition.get("time_multiplier") is float or definition.get("stacking") != &"reject_active": return false
	var values: Dictionary = Definition.create(definition.id, definition.duration, definition.time_multiplier)
	if values.is_empty() or has(values.id): return false
	var combined: float = multiplier() * float(values.time_multiplier)
	if not is_finite(combined) or combined <= 0.0: return false
	_active[values.id] = {"remaining": values.duration, "time_multiplier": values.time_multiplier}
	return true

func has(id: StringName) -> bool:
	return _active.has(id)

func remaining(id: StringName) -> float:
	return float(_active[id].remaining) if has(id) else 0.0

func multiplier() -> float:
	var value: float = 1.0
	var ids: Array = _active.keys()
	ids.sort()
	for id in ids: value *= float(_active[id].time_multiplier)
	return value

func snapshot() -> Dictionary:
	return _active.duplicate(true)

func advance(combat_dt: float) -> float:
	if not is_finite(combat_dt) or combat_dt <= 0.0: return 0.0
	var left: float = combat_dt
	var personal: float = 0.0
	# Split exactly at each expiry: no accelerated time beyond a buff's lifetime.
	while left > 0.0:
		var segment: float = left
		for values in _active.values(): segment = minf(segment, float(values.remaining))
		personal += segment * multiplier()
		for id in _active.keys():
			_active[id].remaining = maxf(0.0, float(_active[id].remaining) - segment)
			if _active[id].remaining <= 0.000000001: _active.erase(id)
		left = maxf(0.0, left - segment)
	return personal

func clear() -> void:
	_active.clear()
