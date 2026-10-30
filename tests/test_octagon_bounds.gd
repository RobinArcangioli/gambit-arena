extends Node
const Bounds=preload("res://scripts/arena/arena_bounds.gd")
const Navigator=preload("res://scripts/movement/local_navigator.gd")
const Mover=preload("res://scripts/movement/ground_mover.gd")
const Schedule=preload("res://scripts/waves/infinite_schedule.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,message:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("Octagon: "+message)
func _ready() -> void:
	check(Bounds.polygon().size()==8,"one shared eight-sided domain")
	check(Bounds.contains_ground(Vector2.ZERO) and not Bounds.contains_ground(Vector2(4,4)),"center accepted and former bounding-box corners excluded")
	for index in range(64):
		var angle:float=index*TAU/64;var point:=Vector2(cos(angle),sin(angle))*20
		var at:Vector2=Bounds.clamp_ground(point)
		check(Bounds.contains_ground(at) and Bounds.clamp_ground(at).is_equal_approx(at),"clamp is stable and remains inset at bearing %d"%index)
		var inside:bool=true
		for normal in Bounds.NORMALS:inside=inside and normal.dot(at)<=Bounds.HALF_EXTENT-Bounds.ACTOR_MARGIN+.00001
		check(inside,"full actor radius remains inside all eight planes %d"%index)
	check(not Bounds.contains_ground(Vector2(INF,0)) and Bounds.clamp_ground(Vector2(NAN,0))==Vector2.ZERO,"invalid positions cannot escape domain")
	for segment in Bounds.grid_segments():
		check(Bounds.contains_ground(segment[0],0) and Bounds.contains_ground(segment[1],0),"display grid segments are clipped to actual octagon")
	var nav:=Navigator.new();var obstacles:Array[Vector2]=[Vector2.ZERO]
	nav.request(Vector2(-3.7,-.8),Vector2(3.7,.8),1,.8,1.5,1.0/60,obstacles,true)
	check(nav._grid!=null and not nav.path.is_empty(),"real route goes around an obstacle inside octagon")
	var masked:bool=true
	for y in range(nav.SIDE):
		for x in range(nav.SIDE):
			var cell:=Vector2i(x,y)
			if not Bounds.contains_ground(nav._world(cell)):masked=masked and nav._grid.is_point_solid(cell)
	check(masked,"all navigation cells outside octagon are blocked")
	check(nav.path.all(func(point):return Bounds.contains_ground(point)),"all real route waypoints obey shared boundary")
	check(not Navigator.segment_clear(Vector2.ZERO,Vector2(4,4),[]),"shortcuts cannot pass through clipped corners")
	var target:=Node3D.new();add_child(target);target.position=Vector3(8,0,8)
	var mover:=Mover.new();mover.reset(Vector2.ZERO);mover.set_target(target)
	var safe:bool=true
	for frame in range(600):mover.step(1.0/60);safe=safe and Bounds.contains_ground(mover.ground_position)
	check(safe and mover.state==Mover.State.BLOCKED,"actual movement stops at octagonal edge without crossing it")
	for slot in range(4):
		var at:Vector2=Schedule.hero_position(slot)
		check(Bounds.contains_ground(at) and is_equal_approx(at.x+at.y,Schedule.hero_position(0).x+Schedule.hero_position(0).y),"four hero slots share a safe southern line")
	var rng:=RandomNumberGenerator.new();rng.seed=421
	for sample in range(100):
		var occupied:Array[Vector2]=[]
		for actor in range(2):occupied.append(Bounds.clamp_ground(Vector2(rng.randf_range(-5,5),rng.randf_range(-5,5))))
		var group:Array[Vector2]=Schedule.formation(occupied);var valid:bool=group.size()==10
		for point in group:
			valid=valid and Bounds.contains_ground(point) and point.x+point.y<0
			for other in occupied:valid=valid and point.distance_to(other)>=.71
			for other in group:
				if other!=point:valid=valid and point.distance_to(other)>=.71
		check(valid,"ten free northern arrivals in shared octagon %d"%sample)
	target.queue_free();await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"bounds and routes retain no actor nodes")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
