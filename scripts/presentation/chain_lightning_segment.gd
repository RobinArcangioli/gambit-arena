extends Node3D
## One passive electrical segment created by an authoritative hit fact.
const Geometry = preload("res://scripts/presentation/lightning_geometry.gd")
const Fade = preload("res://scripts/presentation/effect_fade.gd")
var fade := Fade.new()
var age: float = 0
var profile: Resource
var bolt: MeshInstance3D
var flare: MeshInstance3D
var sparks: MeshInstance3D
var ring: MeshInstance3D
var bolt_paint: ShaderMaterial
var flare_paint: ShaderMaterial
var spark_paint: ShaderMaterial
var ring_paint: ShaderMaterial
var target: Vector3
func setup(definition: Resource, event: Dictionary) -> void:
	profile = definition
	var origin: Vector3 = event.get("chain_from_position",event.source_position) + Vector3.UP * .64
	target = event.target_position + Vector3.UP * .57
	var camera: Camera3D = get_viewport().get_camera_3d()
	var facing: Vector3 = camera.global_basis.z if camera!=null else Vector3(.5,.7,.5).normalized()
	var random := RandomNumberGenerator.new();random.seed=int(event.action_id)*4099+int(event.get("bounce_index",0))*117
	var main := PackedVector3Array()
	var offset: Vector3 = target-origin
	var sideways: Vector3 = offset.normalized().cross(facing).normalized()
	var up: Vector3 = facing.cross(sideways).normalized()
	for i in range(17):
		var p: float = float(i)/16
		var disturbance: Vector3 = (sideways*random.randf_range(-.19,.19)+up*random.randf_range(-.10,.10))*sin(p*PI)
		main.append(origin+offset*p+disturbance)
	var paths: Array = [main];var widths: Array = [profile.width]
	for branch in range(profile.branches):
		var at: Vector3 = main[3+(branch*3)%11]
		var signum: float = -1 if branch%2==0 else 1
		var end: Vector3 = at+sideways*signum*random.randf_range(.25,.48)+offset.normalized()*.18
		var points := PackedVector3Array()
		for i in range(5): points.append(at.lerp(end,float(i)/4)+up*random.randf_range(-.05,.05))
		paths.append(points);widths.append(profile.width*.38)
	bolt_paint=Geometry.material(profile);bolt=Geometry.instance(Geometry.ribbons(paths,widths,facing),bolt_paint);add_child(bolt)
	flare_paint=Geometry.material(profile,1);flare=Geometry.quad(profile.impact_radius*2,flare_paint)
	add_child(flare);flare.position=target
	if camera!=null:flare.global_basis=camera.global_basis
	var rays: Array = [];var ray_widths: Array = []
	for ray in range(9):
		var angle: float = float(ray)/9*TAU
		var direction: Vector3 = sideways*cos(angle)+up*sin(angle)
		rays.append(PackedVector3Array([direction*.06,direction*.20+sideways*random.randf_range(-.05,.05),direction*random.randf_range(.28,.44)]));ray_widths.append(.032)
	spark_paint=Geometry.material(profile);sparks=Geometry.instance(Geometry.ribbons(rays,ray_widths,facing),spark_paint)
	add_child(sparks);sparks.position=target
	ring_paint=Geometry.material(profile,2);ring=Geometry.quad(.65,ring_paint)
	add_child(ring);ring.position=event.target_position+Vector3.UP*.035;ring.rotation.x=-PI*.5
	advance_visual(0)
func advance_visual(dt: float) -> void:
	age+=maxf(0,dt)
	var progress: float = clampf(age/profile.duration,0,1)
	var pulse: float = (1-smoothstep(.18,.68,progress))*(.84+.16*cos(age*110))
	var afterstroke: float = smoothstep(.36,.43,progress)*(1-smoothstep(.51,.79,progress))*.45
	bolt_paint.set_shader_parameter("visibility",maxf(pulse,afterstroke)*profile.strength)
	bolt_paint.set_shader_parameter("reveal",clampf(age/.028+.16,0,1))
	flare_paint.set_shader_parameter("visibility",(1-smoothstep(.04,.42,progress))*.65*profile.strength)
	spark_paint.set_shader_parameter("visibility",fade.sample(progress)*.85*profile.strength)
	sparks.scale=Vector3.ONE*lerpf(.6,1.5,progress)
	ring.scale=Vector3.ONE*lerpf(.4,1.5,progress)
	ring_paint.set_shader_parameter("visibility",(1-progress)*.48*profile.strength)
