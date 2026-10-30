extends Node3D
## Value-only procedural meteor. All hits and cancellation belong to the simulation.
var profile:Resource=preload("res://resources/presentation/effects/meteor.tres")
const FIRE=preload("res://scripts/presentation/meteor_fire.gdshader")
const GLOW=preload("res://scripts/presentation/meteor_glow.gdshader")
const SMOKE=preload("res://scripts/presentation/meteor_smoke.gdshader")
const FROM=Vector3(-3.2,7,-1.5)
var age:float=0
var exploding:bool=false
var radius:float=1.4
var strength:float=1
var flight_duration:float=1.0/1.3
var rock:Node3D
var tail:Node3D
var burst:Node3D
var fire_materials:Array[ShaderMaterial]=[]
var glow_materials:Array[ShaderMaterial]=[]
var smoke_materials:Array[ShaderMaterial]=[]
var fragments:Array[Dictionary]=[]
var smoke:Array[Dictionary]=[]
var trail_flames:Array[Dictionary]=[]
var pink_streaks:Array[MeshInstance3D]=[]
var variant_override:int=-1
var variant:int=1
var wisps:Array[Node3D]=[]
var wisp_material:StandardMaterial3D
var volume:MeshInstance3D
var volume_material:StandardMaterial3D
var flash:MeshInstance3D
var flash_material:ShaderMaterial
var spark_material:StandardMaterial3D
var debris_material:StandardMaterial3D
var ember_material:StandardMaterial3D
var shock_wave:MeshInstance3D
var fire_crown:MeshInstance3D
var shock_material:ShaderMaterial
var crown_material:ShaderMaterial
var fire_embers:Array[Dictionary]=[]
var fire_ember_material:StandardMaterial3D
var rng:=RandomNumberGenerator.new()
func setup(extent:float,intensity:float=1,travel:float=1.0/1.3) -> void:
	radius=extent;strength=intensity*profile.strength;flight_duration=travel;rng.seed=93271
	variant=profile.explosion_variant if variant_override<0 else variant_override
	rock=Node3D.new();add_child(rock)
	tail=Node3D.new();add_child(tail)
	burst=Node3D.new();add_child(burst);burst.hide()
	var stone:=_fire_material(0,true)
	var body:=_sphere(.34,11,7)
	var head:=_mesh(rock,body,stone);head.scale=Vector3(1,.86,1.12)
	# Uneven stone silhouette, no luminous round head or decorative seams.
	for i in range(7):
		var chunk:=_mesh(rock,_sphere(rng.randf_range(.12,.2),5,3),stone)
		chunk.position=Vector3(rng.randf_range(-.25,.25),rng.randf_range(-.2,.2),rng.randf_range(-.23,.23))
		chunk.rotation=Vector3(rng.randf()*3,rng.randf()*3,rng.randf()*3)
	for i in range(9):
		var flame:=_mesh(tail,_sphere(1,10,6),_fire_material(i*4.7))
		trail_flames.append({"view":flame,"index":i})
	for i in range(3):
		var mat:=_glow_material(profile.trail_color if i<2 else profile.core_color,.58 if i<2 else .3,true)
		var card:=_quad(tail,Vector2(1.65-i*.24,2.65-i*.22),mat)
		card.position=Vector3((i-1)*.15,1.08,0);card.rotation.y=i*PI/3
	for i in range(3):
		var mat:=_glow_material(Color("b81662"),.44,true)
		var streak:=_quad(tail,Vector2(.10,1.8-i*.2),mat)
		streak.position=Vector3((i-1)*.24,.85,-.18);pink_streaks.append(streak)
	# The explosion is a real upper hemisphere with a shared, fixed footprint.
	flash_material=_glow_material(Color.WHITE,.9,false)
	flash=_quad(burst,Vector2.ONE*radius*2,flash_material);flash.rotation.x=-PI/2;flash.position.y=.045
	volume_material=_paint(Color.WHITE,false)
	volume_material.cull_mode=BaseMaterial3D.CULL_DISABLED
	volume=_mesh(burst,_hemisphere(),volume_material)
	wisp_material=_paint(profile.explosion_color,false)
	wisp_material.vertex_color_use_as_albedo=true
	wisp_material.cull_mode=BaseMaterial3D.CULL_DISABLED
	for i in range(3):
		var pivot:=Node3D.new();burst.add_child(pivot);wisps.append(pivot)
		_mesh(pivot,_wisp_mesh(i),wisp_material)
	for i in range(8):
		var mat:=ShaderMaterial.new();mat.shader=SMOKE;mat.set_shader_parameter("seed",float(i)*9.7);smoke_materials.append(mat)
		var card:=_quad(burst,Vector2.ONE,mat)
		var angle:float=float(i)*2.39996
		smoke.append({"view":card,"direction":Vector2.from_angle(angle),"extent":rng.randf_range(.7,1.2),"lift":rng.randf_range(.5,1.25)})
	spark_material=_paint(Color.WHITE,true)
	ember_material=_paint(Color("ef3309"),true)
	debris_material=_paint(Color("392418"),false)
	for i in range(42):
		var angle:float=TAU*rng.randf()
		var is_stone:bool=i%3==0
		var mesh:Mesh
		if is_stone:mesh=_sphere(rng.randf_range(.04,.10),5,3)
		else:
			var spark:=BoxMesh.new();spark.size=Vector3(.012,rng.randf_range(.10,.23),.012);mesh=spark
		var piece:=_mesh(burst,mesh,debris_material if is_stone else spark_material if i%2==0 else ember_material)
		fragments.append({"view":piece,"direction":Vector2.from_angle(angle),"distance":rng.randf_range(.55,.97)*radius,"height":rng.randf_range(.35,1.55),"spin":rng.randf_range(-9,9),"stone":is_stone})
	# Passive, bounded fire accents: all shapes stay within the effect footprint.
	shock_material=ShaderMaterial.new();shock_material.shader=preload("res://scripts/presentation/meteor_shockwave.gdshader")
	shock_material.render_priority=2
	shock_material.set_shader_parameter("fiery",profile.impact_fire_style>0)
	shock_wave=_quad(burst,Vector2.ONE*radius*2,shock_material)
	shock_wave.rotation.x=-PI/2;shock_wave.position.y=.065
	crown_material=ShaderMaterial.new();crown_material.shader=preload("res://scripts/presentation/meteor_flare.gdshader")
	crown_material.render_priority=3
	fire_crown=_mesh(burst,_fire_crown_mesh(),crown_material)
	fire_crown.visible=profile.impact_fire_style>0
	fire_ember_material=_paint(Color("ff5b10"),false)
	fire_ember_material.render_priority=3
	if profile.impact_fire_style==2:
		for i in range(18):
			var ember:=_mesh(burst,_sphere(rng.randf_range(.018,.037),5,3),fire_ember_material)
			fire_embers.append({"view":ember,"angle":rng.randf()*TAU,"distance":rng.randf_range(.55,.93)*radius,"height":rng.randf_range(.4,1.1)})
	_set_flight()
func _fire_crown_mesh() -> ArrayMesh:
	var tool:=SurfaceTool.new();tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for segment in range(96):
		var points:Array[Vector3]=[];var coords:Array[Vector2]=[]
		for corner in [Vector2i(segment,0),Vector2i(segment+1,0),Vector2i(segment,1),Vector2i(segment+1,1)]:
			var angle:float=TAU*float(corner.x)/96.0
			var r:float=1.0-float(corner.y)*.035
			points.append(Vector3(cos(angle)*r,float(corner.y),sin(angle)*r))
			coords.append(Vector2(float(corner.x)/96.0,float(corner.y)))
		for i in [0,1,2,2,1,3]:tool.set_uv(coords[i]);tool.add_vertex(points[i])
	return tool.commit()
func _wisp_point(progress:float,index:int) -> Vector3:
	var theta:float=.25+progress*1.10
	var angle:float=float(index)*TAU/3.0+progress*2.7
	return Vector3(sin(theta)*cos(angle),cos(theta),sin(theta)*sin(angle))*1.018
func _wisp_mesh(index:int) -> ArrayMesh:
	var tool:=SurfaceTool.new();tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(32):
		var points:Array[Vector3]=[]
		var weights:Array[float]=[]
		for step in [i,i+1]:
			var progress:float=float(step)/32.0
			var center:Vector3=_wisp_point(progress,index)
			var tangent:Vector3=(_wisp_point(minf(1,progress+.005),index)-_wisp_point(maxf(0,progress-.005),index)).normalized()
			var weight:float=pow(maxf(0,sin(progress*PI)),.6)
			var side:Vector3=center.normalized().cross(tangent).normalized()*.020*weight*profile.explosion_accent_width
			points.append(center-side);points.append(center+side)
			weights.append(weight);weights.append(weight)
		for vertex in [0,1,2,2,1,3]:
			tool.set_color(Color(1,1,1,weights[vertex]));tool.set_normal(points[vertex].normalized());tool.add_vertex(points[vertex])
	return tool.commit()
func _hemisphere() -> ArrayMesh:
	var tool:=SurfaceTool.new();tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rings:int=18;var segments:int=72
	for ring in range(rings):
		for segment in range(segments):
			if variant==2 and ring>3 and sin(float(segment)*.43+ring*.5)*sin(float(segment)*.77-ring*.35)>.56:continue
			var points:Array[Vector3]=[]
			for pair in [Vector2i(ring,segment),Vector2i(ring+1,segment),Vector2i(ring,segment+1),Vector2i(ring+1,segment+1)]:
				var theta:float=PI*.5*float(pair.x)/float(rings)
				var angle:float=TAU*float(pair.y)/float(segments)
				var noise_value:float=sin(angle*17+theta*13)*sin(theta*19-angle*7)
				var rough:float=1+noise_value*(.045 if variant==2 else .008)
				points.append(Vector3(sin(theta)*cos(angle)*minf(1,rough),cos(theta)*rough,sin(theta)*sin(angle)*minf(1,rough)))
			var tint:float=1.0
			tool.set_color(Color(tint,tint,tint,1))
			for i in [0,1,2,2,1,3]:tool.set_normal(points[i].normalized());tool.add_vertex(points[i])
	volume_material.vertex_color_use_as_albedo=true
	return tool.commit()
func _sphere(extent:float,segments:int,rings:int) -> SphereMesh:
	var mesh:=SphereMesh.new();mesh.radius=extent;mesh.height=extent*2;mesh.radial_segments=segments;mesh.rings=rings;return mesh
func _fire_material(seed_value:float,stone:bool=false) -> ShaderMaterial:
	var mat:=ShaderMaterial.new();mat.shader=FIRE;mat.set_shader_parameter("seed",seed_value);mat.set_shader_parameter("stone",stone)
	fire_materials.append(mat);return mat
func _glow_material(color:Color,alpha:float,is_trail:bool) -> ShaderMaterial:
	var mat:=ShaderMaterial.new();mat.shader=GLOW;color.a=alpha;mat.set_shader_parameter("tint",color);mat.set_shader_parameter("trail",is_trail)
	glow_materials.append(mat);return mat
func _paint(color:Color,additive:bool) -> StandardMaterial3D:
	var mat:=StandardMaterial3D.new();mat.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA;mat.albedo_color=color
	if additive:mat.blend_mode=BaseMaterial3D.BLEND_MODE_ADD
	return mat
func _mesh(parent:Node3D,mesh:Mesh,paint:Material) -> MeshInstance3D:
	var view:=MeshInstance3D.new();view.mesh=mesh;view.material_override=paint;view.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF;parent.add_child(view);return view
func _quad(parent:Node3D,size:Vector2,paint:Material) -> MeshInstance3D:
	var mesh:=QuadMesh.new();mesh.size=size;return _mesh(parent,mesh,paint)
func impact() -> void:
	exploding=true;age=0;rock.hide();tail.hide();burst.show();_set_explosion()
func advance_visual(dt:float) -> void:
	if not is_finite(dt) or dt<0:return
	age+=dt
	if exploding:_set_explosion()
	else:_set_flight()
func _set_flight() -> void:
	var t:float=clampf(age/maxf(.001,flight_duration),0,1)
	rock.position=FROM*(1-t*t)+Vector3(0,.18,0)
	rock.rotation=Vector3(age*7,age*5,age*9)
	tail.position=rock.position
	tail.quaternion=Quaternion(Vector3.UP,FROM.normalized())
	for item in trail_flames:
		var i:int=item.index;var phase:float=age*25+i*2.3
		var size:float=lerpf(.32,.06,float(i)/8)
		item.view.position=Vector3(sin(phase)*.1,.10+float(i)*.21,cos(phase*.7)*.1)
		item.view.scale=Vector3(size,size*1.65,size)
	for i in range(pink_streaks.size()):pink_streaks[i].position.x=(i-1)*.24+sin(age*21+i*2)*.06
	for mat in fire_materials:
		mat.set_shader_parameter("age",.11+sin(age*23)*.025);mat.set_shader_parameter("opacity",minf(1,strength))
	for mat in glow_materials:
		mat.set_shader_parameter("phase",age);mat.set_shader_parameter("opacity",strength)
func _set_explosion() -> void:
	var t:float=clampf(age,0,1)
	var envelope:float=profile.fade.sample(lerpf(profile.fade.fade_in_end,1,t))
	var expansion:float=1-exp(-t*22)
	for mat in fire_materials:
		mat.set_shader_parameter("age",t);mat.set_shader_parameter("opacity",minf(1,envelope*strength))
	for mat in glow_materials:mat.set_shader_parameter("phase",t);mat.set_shader_parameter("opacity",envelope*strength)
	flash_material.set_shader_parameter("opacity",strength*(1-smoothstep(.025,.19,t)))
	flash.scale=Vector3.ONE*lerpf(.35,1,minf(1,t*16))
	var camera:=get_viewport().get_camera_3d()
	volume.position=Vector3(0,.04,0)
	var grow:float=lerpf(.15,1.0,1-exp(-t*38))
	var height:float=[.72,.90,1.10][variant]
	volume.scale=Vector3(radius*grow,radius*height*grow,radius*grow)
	for i in range(wisps.size()):
		wisps[i].position=volume.position
		wisps[i].scale=volume.scale
		wisps[i].rotation.y=t*(4.0+float(i)*.7)
	var accent:Color=profile.explosion_color
	accent.a=profile.explosion_accent_opacity*envelope*smoothstep(0,.045,t)*(1-smoothstep(.36,.82,t))
	wisp_material.albedo_color=accent
	volume_material.albedo_color=Color(1,1,1,minf(1,envelope*strength)*(profile.compact_dome_opacity if variant==0 else .83 if variant==1 else .9))
	volume_material.albedo_color.a*=1-smoothstep(.20 if variant==0 else .26,.68 if variant==0 else .76,t)
	for i in range(smoke.size()):
		var item:Dictionary=smoke[i]
		var distance:float=radius*.51*expansion
		item.view.position=Vector3(item.direction.x*distance,.3+t*item.lift,item.direction.y*distance)
		if camera!=null:item.view.global_basis=camera.global_basis.scaled(Vector3.ONE*item.extent*(.5+t))
		smoke_materials[i].set_shader_parameter("phase",t)
		smoke_materials[i].set_shader_parameter("opacity",smoothstep(.2,.55,t)*envelope*.35)
	for item in fragments:
		var distance:float=item.distance*(1-pow(1-t,3))
		item.view.position=Vector3(item.direction.x*distance,.08+sin(t*PI)*item.height,item.direction.y*distance)
		item.view.rotation=Vector3(t*item.spin,t*4,t*item.spin*.7)
		item.view.scale=Vector3.ONE*(1-t*.7)
	spark_material.albedo_color=Color(1,1,1,envelope)
	ember_material.albedo_color=Color(.94,.09,.005,envelope)
	debris_material.albedo_color=Color(.18,.10,.055,envelope)
	var wave_progress:float=clampf(t/.28,0,1)
	shock_material.set_shader_parameter("age",t)
	shock_material.set_shader_parameter("opacity",strength)
	fire_crown.scale=Vector3.ONE*radius*lerpf(.18,.98,1-pow(1-wave_progress,2))
	fire_crown.scale.y=radius*.32
	fire_crown.position.y=.07
	crown_material.set_shader_parameter("age",t)
	crown_material.set_shader_parameter("opacity",envelope*smoothstep(0,.04,t)*(1-smoothstep(.25,.65,t)))
	for ember in fire_embers:
		var travel:float=1-pow(1-t,3)
		ember.view.position=Vector3(cos(ember.angle)*ember.distance*travel,.1+sin(t*PI)*ember.height,sin(ember.angle)*ember.distance*travel)
		ember.view.scale=Vector3(.7,2.7, .7)*(1-t*.7)
	fire_ember_material.albedo_color=Color(1,.18,.005,envelope*(1-smoothstep(.4,.85,t)))
