extends Node3D
## Procedural pocket watch; value-only setup and explicitly accepted world visual time.
const DefaultFade = preload("res://resources/presentation/effects/common_fade.tres")
var age: float = 0.0
var duration: float = 2.0
var opacity: float = 0.0
var radius: float = 0.47
var face: Node3D
var hands: Array[Node3D] = []
var materials: Array[StandardMaterial3D] = []
var colors: Array[Color] = []
var fade: Resource = DefaultFade
var initial_speed: Vector2
var final_speed: Vector2
var acceleration_time: float
var strength: float
var angles := Vector2.ZERO

func setup(profile: Resource) -> void:
	duration = maxf(0.1, profile.duration)
	radius = maxf(0.1, profile.radius)
	fade = profile.fade if profile.fade != null else DefaultFade
	initial_speed = profile.initial_turns_per_second
	final_speed = profile.final_turns_per_second
	acceleration_time = maxf(0.001, profile.acceleration_time)
	strength = clampf(profile.opacity, 0, 1)
	face = Node3D.new();add_child(face)
	var rim := _material(profile.gold, 1)
	var bright := _material(profile.highlights, 2)
	var fill := _material(profile.face_color, 0)
	var disk := SurfaceTool.new();disk.begin(Mesh.PRIMITIVE_TRIANGLES)
	var ring := SurfaceTool.new();ring.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(72):
		var a := Vector2.from_angle(TAU * float(i) / 72.0)
		var b := Vector2.from_angle(TAU * float(i + 1) / 72.0)
		_triangle(disk, Vector2.ZERO, a * radius, b * radius)
		var inner: float = radius - 0.032
		_triangle(ring, a * radius, a * inner, b * radius)
		_triangle(ring, b * radius, a * inner, b * inner)
	_mesh(disk.commit(),fill)
	_mesh(ring.commit(),rim)
	for i in range(12):
		var marker := Node3D.new();face.add_child(marker)
		marker.rotation.z = -TAU * float(i) / 12.0
		var length: float = 0.065 if i % 3 == 0 else 0.035
		_quad(marker, Vector2(0.022 if i % 3 == 0 else 0.015,length), Vector2(0,radius-0.07),bright)
	# Crown identifies a watch without adding ornament or an opaque backdrop.
	_quad(face,Vector2(0.10,0.045),Vector2(0,radius+0.018),rim)
	for i in range(2):
		var pivot := Node3D.new();face.add_child(pivot);hands.append(pivot)
		var length: float = radius * (0.50 if i == 0 else 0.78)
		_quad(pivot,Vector2(0.033 if i == 0 else 0.024,length),Vector2(0,length*0.5-0.04),bright)
	_quad(face,Vector2(0.045,0.045),Vector2.ZERO,rim)
	advance_visual(0.0)

func _material(color: Color, priority: int) -> StandardMaterial3D:
	var paint := StandardMaterial3D.new()
	paint.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	paint.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	paint.cull_mode = BaseMaterial3D.CULL_DISABLED
	paint.no_depth_test = true
	paint.render_priority = priority
	paint.albedo_color = color
	materials.append(paint);colors.append(color)
	return paint

func _mesh(mesh: Mesh, paint: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new();instance.mesh = mesh;instance.material_override = paint
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	face.add_child(instance);return instance

func _quad(parent: Node3D, size: Vector2, at: Vector2, paint: Material) -> void:
	var mesh := QuadMesh.new();mesh.size = size
	var instance := MeshInstance3D.new();instance.mesh = mesh;instance.material_override = paint
	instance.position = Vector3(at.x,at.y,0)
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(instance)

static func _triangle(tool: SurfaceTool, a: Vector2, b: Vector2, c: Vector2) -> void:
	for point in [a,b,c]:tool.add_vertex(Vector3(point.x,point.y,0))

static func integrated_turns(seconds: float, initial: float, final: float, ramp: float) -> float:
	var t: float = maxf(0, seconds)
	var acceleration: float = maxf(0.001, ramp)
	var rising: float = minf(t, acceleration)
	return initial * rising + 0.5 * (final-initial) * rising*rising / acceleration + final * maxf(0,t-acceleration)

func advance_visual(dt: float) -> void:
	if not is_finite(dt) or dt < 0 or face == null:return
	age = minf(duration,age+dt)
	opacity = fade.sample(age/duration) * strength
	for i in range(2):
		angles[i] = TAU * integrated_turns(age,initial_speed[i],final_speed[i],acceleration_time)
		hands[i].rotation.z = -angles[i]
	for i in range(materials.size()):
		var color: Color = colors[i];color.a *= opacity;materials[i].albedo_color = color
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null:face.global_basis = camera.global_basis
