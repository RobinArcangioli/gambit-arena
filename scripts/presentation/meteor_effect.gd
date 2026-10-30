extends Node3D
## Procedural art only. The simulation supplies release and impact independently.
var profile:Resource=preload("res://resources/presentation/effects/meteor.tres")
var age:float=0
var exploding:bool=false
var radius:float=1.4
var strength:float=1
var flight_duration:float=1
var rock:Node3D
var tail:Node3D
var burst:Node3D
var shock:MeshInstance3D
var paints:Array[StandardMaterial3D]=[]
var colors:Array[Color]=[]
var fragments:Array[Dictionary]=[]
var glows:Array[ShaderMaterial]=[]
var trail_cards:Array[MeshInstance3D]=[]
var fireballs:Array[MeshInstance3D]=[]
const FROM=Vector3(-2.8,6.5,-1.4)
func setup(extent:float,intensity:float=1,travel:float=1) -> void:
	radius=extent;strength=intensity*profile.strength;flight_duration=travel
	rock=Node3D.new();add_child(rock)
	tail=Node3D.new();add_child(tail)
	burst=Node3D.new();add_child(burst);burst.hide()
	var dark:=_paint(Color("321024"),false)
	var hot:=_paint(Color("ff496e"),true)
	var core:=_paint(Color("ffe6b2"),true)
	var red:=_paint(Color(0.83,0.015,0.19,.48),true)
	var pink:=_paint(Color(1,.035,.32,.2),true)
	var body:=SphereMesh.new();body.radius=.22;body.height=.44;body.radial_segments=9;body.rings=5
	_mesh(rock,body,dark)
	# Broken incandescent seams wrap a dark faceted core.
	for i in range(3):
		var seam:=_ring(rock,.218,.012,hot)
		seam.rotation=Vector3(.5+i*.9,.6*i,.8*i)
	var rng:=RandomNumberGenerator.new();rng.seed=95123
	for i in range(3):
		var card:=_glow(tail,Vector2(1.15-i*.3,3.3-i*.5),profile.trail_color if i==0 else profile.shadow_color if i==1 else profile.core_color,.8 if i==0 else .45,true)
		card.position.y=1.3-i*.15;trail_cards.append(card)
	# Layered ground halo stays inside the exact gameplay radius.
	var halo:=_glow(burst,Vector2.ONE*radius*2,profile.explosion_color,.95,false)
	halo.rotation.x=-PI/2;halo.position.y=.04
	for i in range(9):
		var fire:=_glow(burst,Vector2.ONE*(1.0 if i>0 else 1.9),Color("fa2961") if i%2==0 else Color("ff803e"),.65,false)
		fire.position=Vector3(cos(i*2.4)*radius*.48 if i>0 else 0,.2,sin(i*2.4)*radius*.48 if i>0 else 0)
		fireballs.append(fire)
	_ring(burst,radius-.025,.025,red).position.y=.06
	shock=_ring(burst,radius-.045,.045,hot);shock.position.y=.08
	for i in range(30):
		var angle:float=TAU*float(i)/30+rng.randf_range(-.05,.05)
		var shard:=SphereMesh.new();shard.radius=rng.randf_range(.025,.065);shard.height=shard.radius*2;shard.radial_segments=5;shard.rings=2
		var piece:=_mesh(burst,shard,core if i%4==0 else hot if i%3==0 else red)
		fragments.append({"view":piece,"direction":Vector2.from_angle(angle),"distance":rng.randf_range(.45,.94)*radius,"height":rng.randf_range(.3,.95),"spin":rng.randf_range(-6,6)})
	_set_flight()
func _glow(parent:Node3D,size:Vector2,color:Color,alpha:float,is_trail:bool) -> MeshInstance3D:
	var mat:=ShaderMaterial.new();mat.shader=preload("res://scripts/presentation/meteor_glow.gdshader")
	color.a=alpha;mat.set_shader_parameter("tint",color);mat.set_shader_parameter("trail",is_trail);glows.append(mat)
	var mesh:=QuadMesh.new();mesh.size=size;return _mesh(parent,mesh,mat)
func _paint(color:Color,additive:bool) -> StandardMaterial3D:
	var mat:=StandardMaterial3D.new();mat.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA;mat.cull_mode=BaseMaterial3D.CULL_DISABLED
	if additive:mat.blend_mode=BaseMaterial3D.BLEND_MODE_ADD
	mat.albedo_color=color;paints.append(mat);colors.append(color);return mat
func _mesh(parent:Node3D,mesh:Mesh,paint:Material) -> MeshInstance3D:
	var view:=MeshInstance3D.new();view.mesh=mesh;view.material_override=paint
	view.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF;parent.add_child(view);return view
func _ring(parent:Node3D,extent:float,width:float,paint:Material) -> MeshInstance3D:
	var mesh:=TorusMesh.new();mesh.inner_radius=maxf(.001,extent-width);mesh.outer_radius=extent+width
	mesh.rings=48;mesh.ring_segments=6;return _mesh(parent,mesh,paint)
func impact() -> void:
	exploding=true;age=0;rock.hide();tail.hide();burst.show();_set_explosion()
func advance_visual(dt:float) -> void:
	if not is_finite(dt) or dt<0:return
	age+=dt
	if exploding:_set_explosion()
	else:_set_flight()
func _set_flight() -> void:
	var t:float=clampf(age/maxf(.001,flight_duration),0,1)
	rock.position=FROM*(1-t*t)+Vector3(0,.16,0)
	rock.rotation=Vector3(age*3,age*4,age*2)
	tail.position=rock.position
	var camera:=get_viewport().get_camera_3d()
	var up:Vector3=FROM.normalized()
	var normal:Vector3=camera.global_basis.z if camera!=null else Vector3.BACK
	var right:Vector3=up.cross(normal).normalized()
	tail.basis=Basis(right,up,right.cross(up).normalized())
	var opacity:float=smoothstep(0,.08,t)*strength
	for glow in glows:glow.set_shader_parameter("opacity",opacity);glow.set_shader_parameter("phase",age)
	for i in range(paints.size()):
		var color:Color=colors[i];color.a*=minf(1,opacity);paints[i].albedo_color=color
func _set_explosion() -> void:
	var t:float=clampf(age,0,1)
	# Start visibly at impact; use the established healing fade-out envelope.
	var opacity:float=profile.fade.sample(lerpf(profile.fade.fade_in_end,1,t))*strength
	for i in range(paints.size()):
		var color:Color=colors[i];color.a*=minf(1,opacity);paints[i].albedo_color=color
	for glow in glows:glow.set_shader_parameter("opacity",opacity);glow.set_shader_parameter("phase",age)
	var camera:=get_viewport().get_camera_3d()
	for fire in fireballs:
		if camera!=null:fire.global_basis=camera.global_basis.scaled(Vector3.ONE*lerpf(.45,1.3,sqrt(t)))
	shock.scale=Vector3.ONE*lerpf(.12,1,sqrt(t))
	for item in fragments:
		var distance:float=float(item.distance)*(1-pow(1-t,3))
		item.view.position=Vector3(item.direction.x*distance,.08+sin(t*PI)*float(item.height),item.direction.y*distance)
		item.view.rotation=Vector3(t*item.spin,t*2,0)
		item.view.scale=Vector3.ONE*(1-t*.7)
