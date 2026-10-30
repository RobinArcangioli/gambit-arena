extends RefCounted
## Combat-time intermission and camera-relative north formation; no art or scene ownership.
const Bounds=preload("res://scripts/arena/arena_bounds.gd")
const SIZE: int = 10
const DELAY: float = 3.0
var waiting: bool = false
var remaining: float = 0.0
func reset() -> void:
	waiting = false; remaining = 0.0
func begin_wait() -> void:
	if waiting: return
	waiting = true; remaining = DELAY
func advance(dt: float) -> bool:
	if not waiting or not is_finite(dt) or dt <= 0: return false
	remaining = maxf(0.0, remaining - dt)
	if remaining > 0.000001: return false
	reset(); return true
static func hero_position(slot:int) -> Vector2:
	var south:float=(Bounds.HALF_EXTENT-Bounds.ACTOR_MARGIN)*Bounds.ROOT_TWO-.35
	# Constant depth and four screen-left-to-right places; holes are never compacted.
	var lateral:float=(clampi(slot,0,3)-1.5)*1.1*Bounds.ROOT_TWO
	return Vector2((south+lateral)*.5,(south-lateral)*.5)
static func formation(occupied:Array[Vector2],amount:int=SIZE) -> Array[Vector2]:
	var north:float=-(Bounds.HALF_EXTENT-Bounds.ACTOR_MARGIN)*Bounds.ROOT_TWO
	var spacing:float=1.1;var pool:Array[Vector2]=[]
	# Prefer two centered rows of five; complete the northern half for occupied arrivals.
	for row in range(2):
		for column in [0,-1,1,-2,2]:pool.append(Vector2((north+row*spacing+column*spacing)*.5,(north+row*spacing-column*spacing)*.5))
	for row in range(ceili(-north/spacing)):
		for magnitude in range(ceili(-north/spacing)+1):
			for sign_value in ([1] if magnitude==0 else [-1,1]):
				var column:int=magnitude*sign_value
				var at:=Vector2((north+row*spacing+column*spacing)*.5,(north+row*spacing-column*spacing)*.5)
				if Bounds.contains_ground(at) and not at in pool:pool.append(at)
	var result:Array[Vector2]=[]
	for at in pool:
		var free:bool=Bounds.contains_ground(at)
		for other in occupied:
			if at.distance_to(other)<.71:free=false;break
		if free:result.append(at)
		if result.size()==amount:return result
	return []
