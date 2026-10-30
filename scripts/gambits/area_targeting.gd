extends RefCounted
## Exact fixed-radius coverage and deterministic minimum enclosing disks, on ground values.
const EPS:float=.000001
static func solve(rows:Array,radius:float,origin:Vector2,preferred:Array=[]) -> Dictionary:
	if not is_finite(radius) or radius<=0 or not origin.is_finite():return {}
	var points:Array[Dictionary]=[];var seen:Dictionary={}
	for row in rows:
		if not row is Dictionary or not row.get("position") is Vector2 or not row.position.is_finite() or typeof(row.get("id"))!=TYPE_INT:continue
		if seen.has(row.id):continue
		seen[row.id]=true;points.append({"id":row.id,"position":row.position})
	points.sort_custom(func(a:Dictionary,b:Dictionary)->bool:return a.id<b.id)
	var candidates:Array[Vector2]=[]
	for point in points:candidates.append(point.position)
	for i in range(points.size()):
		for j in range(i):
			var delta:Vector2=points[i].position-points[j].position
			var distance_squared:float=delta.length_squared()
			if distance_squared<=EPS*EPS or distance_squared>4*radius*radius+EPS:continue
			var middle:Vector2=(points[i].position+points[j].position)*.5
			var height:float=sqrt(maxf(0,radius*radius-distance_squared*.25))
			var normal:=Vector2(-delta.y,delta.x)/sqrt(distance_squared)
			candidates.append(middle+normal*height);candidates.append(middle-normal*height)
	var count:int=0;var groups:Dictionary={}
	for center in candidates:
		var group:Array[Dictionary]=[];var ids:Array[int]=[]
		for point in points:
			if center.distance_squared_to(point.position)<=radius*radius+EPS:group.append(point);ids.append(point.id)
		if group.size()<count:continue
		if group.size()>count:count=group.size();groups.clear()
		groups[str(ids)]={"points":group,"ids":ids}
	var best:Dictionary={}
	for group in groups.values():
		var positions:Array[Vector2]=[]
		for point in group.points:positions.append(point.position)
		var circle:Dictionary=minimum_circle(positions)
		if circle.is_empty() or circle.radius>radius+EPS:continue
		var choice:Dictionary={"center":circle.center,"count":count,"ids":group.ids,"enclosing_radius":circle.radius}
		if _prefer(choice,best,origin,preferred):best=choice
	return best
static func _prefer(candidate:Dictionary,current:Dictionary,origin:Vector2,preferred:Array) -> bool:
	if current.is_empty():return true
	var kept:bool=candidate.ids==preferred;var previous:bool=current.ids==preferred
	if kept!=previous:return kept
	var distance:float=origin.distance_squared_to(candidate.center);var old_distance:float=origin.distance_squared_to(current.center)
	if absf(distance-old_distance)>EPS:return distance<old_distance
	for i in range(candidate.ids.size()):
		if candidate.ids[i]!=current.ids[i]:return candidate.ids[i]<current.ids[i]
	return false
static func minimum_circle(input:Array[Vector2]) -> Dictionary:
	if input.is_empty():return {}
	var points:Array[Vector2]=input.duplicate()
	# Local fixed seed: repeatable tie-breaking without consuming gameplay randomness.
	var rng:=RandomNumberGenerator.new();rng.seed=73129
	for i in range(points.size()-1,0,-1):
		var j:int=rng.randi_range(0,i);var swap:Vector2=points[i];points[i]=points[j];points[j]=swap
	var circle:Dictionary={}
	for i in range(points.size()):
		if _contains(circle,points[i]):continue
		circle={"center":points[i],"radius":0.0}
		for j in range(i):
			if _contains(circle,points[j]):continue
			circle=_diameter(points[i],points[j])
			for k in range(j):
				if not _contains(circle,points[k]):circle=_through_three(points[i],points[j],points[k])
	return circle
static func _contains(circle:Dictionary,point:Vector2) -> bool:
	return not circle.is_empty() and point.distance_squared_to(circle.center)<=circle.radius*circle.radius+EPS
static func _diameter(a:Vector2,b:Vector2) -> Dictionary:return {"center":(a+b)*.5,"radius":a.distance_to(b)*.5}
static func _through_three(a:Vector2,b:Vector2,c:Vector2) -> Dictionary:
	var u:Vector2=b-a;var v:Vector2=c-a;var cross:float=2*u.cross(v)
	if absf(cross)<=EPS:
		var circle:Dictionary=_diameter(a,b)
		for pair in [[a,c],[b,c]]:
			var other:Dictionary=_diameter(pair[0],pair[1])
			if other.radius>circle.radius:circle=other
		return circle
	var center:Vector2=a+Vector2(v.y*u.length_squared()-u.y*v.length_squared(),u.x*v.length_squared()-v.x*u.length_squared())/cross
	return {"center":center,"radius":center.distance_to(a)}
