extends RefCounted
## One wave, bounded pacing. No actors, timers or scene ownership.
const MAX_ALIVE: int = 20
const FIRST_DELAY: float = 1.0
var total: int = 12
var cap: int = 6
var issued: int = 0
var credit: float = 0.0

func reset(count: int = 12, simultaneous: int = 6) -> void:
	total = clampi(count, 1, 100)
	cap = clampi(simultaneous, 1, MAX_ALIVE)
	issued = 0
	credit = 0.0

func interval() -> float:
	if issued == 0:
		return FIRST_DELAY
	if issued * 3 < total:
		return 2.0
	if issued * 3 < total * 2:
		return 1.5
	return 1.0

func advance(delta: float, alive: int) -> bool:
	if issued >= total or not is_finite(delta) or delta <= 0.0:
		return false
	# At most one pending arrival; saturation/blocked edges never bank a burst.
	credit = minf(interval(), credit + delta)
	return alive < cap and credit >= interval() - 0.000001

func confirm_spawn() -> void:
	# Called only after CombatSimulation.add_enemy succeeded.
	if issued < total:
		issued += 1
		credit = 0.0
