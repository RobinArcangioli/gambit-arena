extends RefCounted
## One shared convex octagon. No arena artwork, scene, or camera dependencies.
# Inradius preserves the former square's projected width/height at the fixed azimuth.
const HALF_EXTENT:float=4.242640687119285
const ACTOR_MARGIN:float=.35
const ROOT_TWO:float=1.4142135623730951
const EPSILON:float=.00001
const NORMALS:Array[Vector2]=[Vector2(1,0),Vector2(.7071067811865476,.7071067811865476),Vector2(0,1),Vector2(-.7071067811865476,.7071067811865476),Vector2(-1,0),Vector2(-.7071067811865476,-.7071067811865476),Vector2(0,-1),Vector2(.7071067811865476,-.7071067811865476)]
static func polygon(margin:float=0) -> PackedVector2Array:
	var a:float=maxf(0,HALF_EXTENT-margin);var b:float=a*(ROOT_TWO-1)
	return PackedVector2Array([Vector2(-a,-b),Vector2(-b,-a),Vector2(b,-a),Vector2(a,-b),Vector2(a,b),Vector2(b,a),Vector2(-b,a),Vector2(-a,b)])
static func contains_ground(point:Vector2,margin:float=ACTOR_MARGIN) -> bool:
	if not point.is_finite():return false
	var a:float=maxf(0,HALF_EXTENT-maxf(0,margin))
	return absf(point.x)<=a+EPSILON and absf(point.y)<=a+EPSILON and absf(point.x)+absf(point.y)<=a*ROOT_TWO+EPSILON
static func clamp_ground(point:Vector2,margin:float=ACTOR_MARGIN) -> Vector2:
	if not point.is_finite():return Vector2.ZERO
	if contains_ground(point,margin):return point
	var vertices:PackedVector2Array=polygon(maxf(0,margin));var best:=Vector2.ZERO;var distance:float=INF
	for index in range(8):
		var candidate:Vector2=Geometry2D.get_closest_point_to_segment(point,vertices[index],vertices[(index+1)%8])
		var value:float=candidate.distance_squared_to(point)
		if value<distance:best=candidate;distance=value
	return best
static func clip_segment(start:Vector2,finish:Vector2,margin:float=0) -> PackedVector2Array:
	var low:float=0;var high:float=1;var direction:Vector2=finish-start
	var limit:float=maxf(0,HALF_EXTENT-maxf(0,margin))
	for normal in NORMALS:
		var denominator:float=normal.dot(direction);var room:float=limit-normal.dot(start)
		if absf(denominator)<.00000001:
			if room<0:return PackedVector2Array()
			continue
		if denominator>0:high=minf(high,room/denominator)
		else:low=maxf(low,room/denominator)
		if low>high:return PackedVector2Array()
	return PackedVector2Array([start+direction*low,start+direction*high])
static func grid_segments(divisions:int=8) -> Array[PackedVector2Array]:
	var result:Array[PackedVector2Array]=[]
	for index in range(divisions+1):
		var value:float=-HALF_EXTENT+2*HALF_EXTENT*index/float(divisions)
		for ends in [[Vector2(value,-HALF_EXTENT),Vector2(value,HALF_EXTENT)],[Vector2(-HALF_EXTENT,value),Vector2(HALF_EXTENT,value)]]:
			var segment:PackedVector2Array=clip_segment(ends[0],ends[1])
			if segment.size()==2:result.append(segment)
	return result
