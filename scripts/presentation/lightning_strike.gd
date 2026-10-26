extends Node3D
## Decorative strike at the captured impact location, even after the target is removed.
const Geometry = preload("res://scripts/presentation/lightning_geometry.gd")
var age: float = 0.0
var duration: float
var profile: Resource
var bolt: MeshInstance3D
var sparks: MeshInstance3D
var ring: MeshInstance3D
var flare: MeshInstance3D
var bolt_material: ShaderMaterial
var spark_material: ShaderMaterial
var ring_material: ShaderMaterial
var flare_material: ShaderMaterial
var path_points := PackedVector3Array()

func setup(definition: Resource, visual_seed: int) -> void:
	profile = definition
	duration = maxf(0.1, profile.duration)
	var random := RandomNumberGenerator.new()
	random.seed = visual_seed
	var camera: Camera3D = get_viewport().get_camera_3d()
	var facing: Vector3 = camera.global_basis.z if camera != null else Vector3(0.5, 0.7, 0.5).normalized()
	for i in range(13):
		var progress: float = i / 12.0
		var offset := Vector3(random.randf_range(-0.28, 0.28), 0, random.randf_range(-0.20, 0.20))
		if i == 12: offset = Vector3.ZERO
		path_points.append(Vector3(0, lerpf(profile.sky_height, profile.impact_height, progress), 0) + offset)
	var paths: Array = [path_points]
	var widths: Array = [profile.glow_width]
	for branch in range(3):
		var start: Vector3 = path_points[3 + branch * 2]
		var end: Vector3 = start + Vector3((-1 if branch % 2 == 0 else 1) * 0.8, -0.9, 0.25)
		var points := PackedVector3Array()
		for i in range(5):
			points.append(start.lerp(end, i / 4.0) + Vector3(random.randf_range(-0.12, 0.12), 0, random.randf_range(-0.1, 0.1)))
		paths.append(points)
		widths.append(profile.glow_width * 0.55)
	bolt_material = Geometry.material(profile)
	bolt = Geometry.instance(Geometry.ribbons(paths, widths, facing), bolt_material)
	add_child(bolt)
	var rays: Array = []
	var ray_widths: Array = []
	for i in range(9):
		var angle: float = TAU * i / 9.0 + random.randf_range(-0.15, 0.15)
		var ray := Vector3(cos(angle), random.randf_range(0.15, 0.8), sin(angle))
		rays.append(PackedVector3Array([ray * 0.16, ray * random.randf_range(0.5, 0.9)]))
		ray_widths.append(0.07)
	spark_material = Geometry.material(profile)
	sparks = Geometry.instance(Geometry.ribbons(rays, ray_widths, facing), spark_material)
	add_child(sparks)
	ring_material = Geometry.material(profile, 2)
	ring = Geometry.quad(profile.impact_radius * 2, ring_material)
	ring.rotation.x = -PI * 0.5
	ring.position.y = 0.045
	add_child(ring)
	flare_material = Geometry.material(profile, 1)
	flare = Geometry.quad(profile.impact_radius * 2, flare_material)
	add_child(flare)
	flare.position.y = profile.impact_height
	if camera != null: flare.global_basis = camera.global_basis
	advance_visual(0)

func advance_visual(dt: float) -> void:
	age = minf(duration, age + maxf(0, dt))
	var strike_time: float = maxf(0.05, profile.strike_duration)
	var pulse: float = 1.0 - smoothstep(strike_time * 0.38, strike_time * 0.73, age)
	# A brief weaker afterstroke keeps the silhouette readable without a screen flash.
	pulse = maxf(pulse, (1.0 - smoothstep(strike_time * 0.84, strike_time, age)) * smoothstep(strike_time * 0.67, strike_time * 0.77, age) * 0.65)
	bolt_material.set_shader_parameter("visibility", pulse)
	bolt_material.set_shader_parameter("reveal", minf(1.0, 0.35 + age / 0.025))
	var progress: float = clampf(age / duration, 0, 1)
	spark_material.set_shader_parameter("visibility", 1.0 - smoothstep(0.15, 0.75, progress))
	sparks.position.y = 0.2 + progress * 0.25
	sparks.scale = Vector3.ONE * lerpf(0.7, 1.5, progress)
	ring_material.set_shader_parameter("visibility", (1.0 - progress) * 0.8)
	ring.scale = Vector3.ONE * lerpf(0.6, 1.45, progress)
	flare_material.set_shader_parameter("visibility", (1.0 - smoothstep(0.05, 0.48, progress)) * 0.8)
	bolt.visible = pulse > 0.001
	sparks.visible = progress < 0.75
	flare.visible = progress < 0.48
