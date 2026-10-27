extends RefCounted
## Shared logical roster: UI order and targeting order, independent of simulation ticks.
const SLOTS: Array[StringName] = [&"mako",&"anne",&"",&""]
static func rank(key: StringName) -> int:
	return -1 if key==&"" else SLOTS.find(key)
