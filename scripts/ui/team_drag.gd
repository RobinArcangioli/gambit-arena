extends RefCounted
## One captured pointer; canceled swipes and stale releases can never become clicks.
const HOLD_SECONDS:float=.45
const MOVE_TOLERANCE:float=12.0
var source:int=-1
var pointer:int=-2
var origin:=Vector2.ZERO
var position:=Vector2.ZERO
var elapsed:float=0.0
var dragging:bool=false
var canceled:bool=false
func begin(slot:int,at:Vector2,identity:int) -> void:
	cancel();source=slot;pointer=identity;origin=at;position=at
func advance(delta:float) -> void:
	if source<0 or canceled or not is_finite(delta) or delta<=0:return
	elapsed+=delta
	if elapsed>=HOLD_SECONDS:dragging=true
func move(at:Vector2,identity:int) -> void:
	if source<0 or identity!=pointer:return
	position=at
	if not dragging and origin.distance_to(at)>MOVE_TOLERANCE:canceled=true
func finish(slot:int,identity:int) -> Dictionary:
	if source<0 or identity!=pointer:return {}
	var result:Dictionary={}
	if not canceled:
		if dragging and slot>=0 and slot!=source:result={"from":source,"to":slot}
		elif not dragging and slot==source:result={"click":source}
	cancel();return result
func cancel() -> bool:
	var captured:bool=source>=0
	source=-1;pointer=-2;elapsed=0;dragging=false;canceled=false
	return captured
