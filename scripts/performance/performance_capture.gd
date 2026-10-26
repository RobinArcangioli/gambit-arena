extends RefCounted
## Value-only, bounded capture. All timestamps are monotonic microseconds, never GameClock.
const MAX_FRAMES: int = 32768
const MAX_TICKS: int = 16384
const MAX_TELEMETRY: int = 128
const MAX_EVENTS: int = 64
var phase: String = "idle"
var reason: String = ""
var metadata: Dictionary = {}
var frames_ms := PackedFloat64Array()
var tick_ms := PackedFloat64Array()
var simulation_ms := PackedFloat64Array()
var game_step_ms := PackedFloat64Array()
var telemetry: Array[Dictionary] = []
var events: Array[Dictionary] = []
var warmup_usec: int = 30000000
var duration_usec: int = 60000000
var started_usec: int = 0
var capture_usec: int = 0
var last_frame_usec: int = 0
var ended_usec: int = 0
var _last_telemetry_usec: int = -1000000

func busy() -> bool:
	return phase in ["warmup", "capture"]

func start(now_usec: int, details: Dictionary, warm_seconds: float = 30.0, seconds: float = 60.0) -> bool:
	if busy() or now_usec < 0 or not is_finite(warm_seconds) or not is_finite(seconds) or warm_seconds < 0.0 or warm_seconds > 60.0 or seconds <= 0.0 or seconds > 120.0:
		return false
	frames_ms.clear()
	tick_ms.clear()
	simulation_ms.clear()
	game_step_ms.clear()
	telemetry.clear()
	events.clear()
	metadata = details.duplicate(true)
	metadata["warmup_seconds"] = warm_seconds
	metadata["capture_seconds"] = seconds
	warmup_usec = roundi(warm_seconds * 1000000.0)
	duration_usec = roundi(seconds * 1000000.0)
	started_usec = now_usec
	capture_usec = 0
	last_frame_usec = 0
	ended_usec = 0
	_last_telemetry_usec = -1000000
	phase = "warmup"
	reason = ""
	return true

func frame(now_usec: int) -> void:
	if not busy():
		return
	if now_usec < started_usec or (phase == "capture" and now_usec <= last_frame_usec):
		interrupt("invalid_monotonic_time", now_usec)
		return
	if phase == "warmup":
		if now_usec - started_usec >= warmup_usec:
			phase = "capture"
			capture_usec = now_usec
			last_frame_usec = now_usec
		return
	if frames_ms.size() >= MAX_FRAMES:
		interrupt("frame_capacity", now_usec)
		return
	frames_ms.append(float(now_usec - last_frame_usec) / 1000.0)
	last_frame_usec = now_usec
	if now_usec - capture_usec >= duration_usec:
		phase = "complete"
		ended_usec = now_usec

func tick(cpu_usec: int, sim_usec: int, game_seconds: float) -> void:
	if phase != "capture":
		return
	if cpu_usec < 0 or sim_usec < 0 or sim_usec > cpu_usec or not is_finite(game_seconds) or game_seconds < 0.0:
		interrupt("invalid_tick", last_frame_usec)
		return
	if tick_ms.size() >= MAX_TICKS:
		interrupt("tick_capacity", last_frame_usec)
		return
	tick_ms.append(float(cpu_usec) / 1000.0)
	simulation_ms.append(float(sim_usec) / 1000.0)
	game_step_ms.append(game_seconds * 1000.0)

func add_telemetry(now_usec: int, row: Dictionary) -> void:
	if phase != "capture" or now_usec - _last_telemetry_usec < 1000000:
		return
	if telemetry.size() >= MAX_TELEMETRY:
		interrupt("telemetry_capacity", now_usec)
		return
	_last_telemetry_usec = now_usec
	var sample: Dictionary = row.duplicate(true)
	sample["seconds"] = float(now_usec - capture_usec) / 1000000.0
	telemetry.append(sample)

func event(now_usec: int, kind: String, run_id: int) -> void:
	if not busy():
		return
	if events.size() >= MAX_EVENTS:
		interrupt("event_capacity", now_usec)
		return
	events.append({"seconds_from_start": float(now_usec - started_usec) / 1000000.0, "kind": kind.left(32), "run_id": run_id})

func interrupt(why: String, now_usec: int) -> void:
	if busy():
		phase = "interrupted"
		reason = why.left(64)
		ended_usec = now_usec

static func distribution(values: PackedFloat64Array) -> Dictionary:
	if values.is_empty():
		return {"count": 0}
	var ordered: PackedFloat64Array = values.duplicate()
	ordered.sort()
	var total: float = 0.0
	var over_budget: int = 0
	var over_50: int = 0
	var over_100: int = 0
	for value in values:
		total += value
		over_budget += int(value > 1000.0 / 30.0)
		over_50 += int(value > 50.0)
		over_100 += int(value > 100.0)
	return {"count": values.size(), "mean_ms": total / values.size(), "p50_ms": ordered[ceili(values.size() * 0.50) - 1], "p95_ms": ordered[ceili(values.size() * 0.95) - 1], "p99_ms": ordered[ceili(values.size() * 0.99) - 1], "max_ms": ordered[-1], "over_33_333_ms": over_budget, "over_50_ms": over_50, "over_100_ms": over_100}

func report() -> Dictionary:
	var wall_ms: float = 0.0
	for value in frames_ms:
		wall_ms += value
	var game_ms: float = 0.0
	for value in game_step_ms:
		game_ms += value
	# Count interval endpoints in fixed one-second wall-time windows, including empty ones.
	var seconds: int = mini(MAX_TELEMETRY, floori(wall_ms / 1000.0))
	var per_second := PackedInt32Array()
	per_second.resize(seconds)
	var endpoint_ms: float = 0.0
	for value in frames_ms:
		endpoint_ms += value
		var bucket: int = ceili(endpoint_ms / 1000.0) - 1
		if bucket >= 0 and bucket < seconds:
			per_second[bucket] += 1
	return {"schema": 1, "phase": phase, "reason": reason, "metadata": metadata.duplicate(true), "summary": {"wall_seconds": wall_ms / 1000.0, "game_seconds": game_ms / 1000.0, "mean_fps": frames_ms.size() * 1000.0 / wall_ms if wall_ms > 0.0 else 0.0, "frames_per_full_second": Array(per_second), "frame_interval": distribution(frames_ms), "tick_cpu_including_hud": distribution(tick_ms), "simulation_cpu_including_actor_presentation": distribution(simulation_ms), "game_step": distribution(game_step_ms)}, "raw": {"frame_interval_ms": Array(frames_ms), "tick_cpu_ms": Array(tick_ms), "simulation_cpu_ms": Array(simulation_ms), "game_step_ms": Array(game_step_ms), "telemetry": telemetry.duplicate(true), "events": events.duplicate(true)}}
