extends RefCounted
## Shared game-time gate. Coordinators advance it once; executors only read its state.
const MAX_STEP: float = 1.0 / 30.0
var paused: bool = false
var stopped: bool = false
var elapsed: float = 0.0

func permits_gameplay() -> bool:
	return not paused and not stopped

func step(delta: float) -> float:
	if not permits_gameplay() or not is_finite(delta) or delta <= 0.0:
		return 0.0
	var dt: float = minf(delta, MAX_STEP)
	elapsed += dt
	return dt

func reset() -> void:
	elapsed = 0.0
	stopped = false
	# A replay is not an explicit resume.
