extends Node
const Targeting=preload("res://scripts/gambits/area_targeting.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,text:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func rows(points:Array) -> Array:
	var result:Array=[]
	for i in range(points.size()):result.append({"id":i+1,"position":points[i]})
	return result
# Independent small-set oracle: enumerate subsets and every disk supported by 1/2/3 points.
func oracle(points:Array,radius:float) -> int:
	var best:int=0
	for mask in range(1,1<<points.size()):
		var group:Array=[]
		for i in range(points.size()):
			if mask&(1<<i):group.append(points[i])
		if group.size()<=best:continue
		var centers:Array=group.duplicate()
		for i in range(group.size()):
			for j in range(i):
				centers.append((group[i]+group[j])*.5)
				for k in range(j):
					var a:Vector2=group[i];var b:Vector2=group[j];var c:Vector2=group[k]
					var determinant:float=2*(a.x*(b.y-c.y)+b.x*(c.y-a.y)+c.x*(a.y-b.y))
					if absf(determinant)<.00000001:continue
					centers.append(Vector2(a.length_squared()*(b.y-c.y)+b.length_squared()*(c.y-a.y)+c.length_squared()*(a.y-b.y),a.length_squared()*(c.x-b.x)+b.length_squared()*(a.x-c.x)+c.length_squared()*(b.x-a.x))/determinant)
		for center in centers:
			if group.all(func(p):return p.distance_squared_to(center)<=radius*radius+.000001):best=group.size();break
	return best
func _ready() -> void:
	check(Targeting.solve([],1.4,Vector2.ZERO).is_empty(),"empty pool has no target")
	check(Targeting.solve(rows([Vector2.ZERO]),0,Vector2.ZERO).is_empty(),"zero radius is not an AOE")
	for fixture in [
		[[Vector2.ZERO,Vector2.ZERO,Vector2.ZERO],3,Vector2.ZERO],
		[[Vector2(-1.4,0),Vector2.ZERO,Vector2(1.4,0)],3,Vector2.ZERO],
		[[Vector2(-1,0),Vector2(1,0),Vector2(0,1)],3,Vector2.ZERO],
		[[Vector2(-1,0),Vector2(1,0),Vector2(0,sqrt(3.0))],3,Vector2(0,sqrt(3.0)/3)],
		[[Vector2(-1.4001,0),Vector2.ZERO,Vector2(1.4001,0)],2,Vector2(-.70005,0)]]:
		var result:Dictionary=Targeting.solve(rows(fixture[0]),1.4,Vector2(-3,0))
		check(result.count==fixture[1],"analytic maximum count including duplicates and exact boundary")
		check(result.center.distance_to(fixture[2])<.00001,"minimum disk centers collinear, right and equilateral triangles")
	var separated:Array=[Vector2(-3,0),Vector2(-3,.5),Vector2(-2.5,0),Vector2(2.5,0),Vector2(3,.5),Vector2(3,0)]
	var chosen:Dictionary=Targeting.solve(rows(separated),.6,Vector2(-4,0))
	check(chosen.ids==[1,2,3],"tie initially chooses closest maximum group")
	chosen=Targeting.solve(rows(separated),.6,Vector2(-4,0),[4,5,6])
	check(chosen.ids==[4,5,6],"currently pursued group is retained on equal maximum only")
	separated.append(Vector2(-2.7,.3))
	check(Targeting.solve(rows(separated),.6,Vector2(-4,0),[4,5,6]).count==4,"larger group overrides preferred group")
	var rng:=RandomNumberGenerator.new();rng.seed=51773
	for trial in range(60):
		var points:Array=[]
		for i in range(6):points.append(Vector2(rng.randf_range(-3,3),rng.randf_range(-3,3)))
		var pool:Array=rows(points);var radius:float=rng.randf_range(.25,2)
		var result:Dictionary=Targeting.solve(pool,radius,Vector2.ZERO)
		check(result.count==oracle(points,radius),"maximum agrees with exhaustive subset oracle %d"%trial)
		check(result.enclosing_radius<=radius+.000001 and pool.filter(func(p):return result.ids.has(p.id)).all(func(p):return p.position.distance_to(result.center)<=radius+.000001),"all chosen enemies remain covered after recentering")
		pool.reverse()
		check(Targeting.solve(pool,radius,Vector2.ZERO)==result,"ordering of snapshot does not change result")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
