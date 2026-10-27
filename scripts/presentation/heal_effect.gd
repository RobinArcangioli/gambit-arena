extends Node3D
## Passive gyroscope: copied presentation values and explicitly accepted visual time only.
const GlowShader = preload("res://shaders/presentation/heal_glow.gdshader")
var age: float = 0.0
var duration: float = 1.0
var amount: int = 0
var tint: Color
var radius: float
var halo: MeshInstance3D
var inner_ring: MeshInstance3D
var aura: MeshInstance3D
var amount_label: Label3D
var amount_height: float
var center_height: float
var ring_materials: Array[StandardMaterial3D] = []
var ring_colors: Array[Color] = []
var glow_materials: Array[ShaderMaterial] = []
var glow_shells: Array[MeshInstance3D] = []
var spin_axes: Array[Vector3] = []
var turns := Vector2.ZERO
var opacity: float = 0.0

func setup(profile: Resource, healed: int) -> void:
	duration = maxf(0.1, profile.duration)
	amount = healed
	tint = profile.color
	radius = profile.radius
	amount_height = profile.amount_height
	center_height = profile.center_height
	turns = profile.turns
	spin_axes = [_axis(profile.outer_spin_axis, Vector3.RIGHT), _axis(profile.inner_spin_axis, Vector3.FORWARD)]
	for index in range(2):
		var outer_radius: float = radius * (1.0 if index == 0 else profile.inner_radius_ratio)
		var thickness: float = 0.04 if index == 0 else 0.032
		var paint := StandardMaterial3D.new()
		paint.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		paint.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		paint.albedo_color = profile.ring_color if index == 0 else profile.inner_ring_color
		ring_materials.append(paint)
		ring_colors.append(paint.albedo_color)
		var ring: MeshInstance3D = _torus(outer_radius, thickness, paint)
		if index == 0: halo = ring
		else: inner_ring = ring
		var glow := _glow_material(true)
		glow_materials.append(glow)
		glow_shells.append(_torus(outer_radius + 0.055, thickness + 0.11, glow))
	var aura_paint := _glow_material(false)
	glow_materials.append(aura_paint)
	aura = MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2.ONE * radius * 2.8
	aura.mesh = quad
	aura.material_override = aura_paint
	aura.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(aura)
	aura.position.y = center_height
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null: aura.global_basis = camera.global_basis
	amount_label = Label3D.new()
	amount_label.text = "+%d" % amount
	amount_label.font_size = 48
	amount_label.pixel_size = 0.006
	amount_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	amount_label.outline_modulate = Color(0.025, 0.14, 0.045, 1)
	amount_label.outline_size = 5
	add_child(amount_label)
	advance_visual(0.0)

func _glow_material(tube: bool) -> ShaderMaterial:
	var paint := ShaderMaterial.new()
	paint.shader = GlowShader
	paint.set_shader_parameter("glow_color", tint)
	paint.set_shader_parameter("tube", tube)
	return paint

func _torus(outer_radius: float, thickness: float, paint: Material) -> MeshInstance3D:
	var ring := TorusMesh.new()
	ring.outer_radius = outer_radius
	ring.inner_radius = maxf(0.01, outer_radius - thickness)
	ring.rings = 64
	ring.ring_segments = 8
	var instance := MeshInstance3D.new()
	instance.mesh = ring
	instance.material_override = paint
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	instance.position.y = center_height
	add_child(instance)
	return instance

static func _axis(value: Vector3, fallback: Vector3) -> Vector3:
	return value.normalized() if value.is_finite() and value.length_squared() > 0.000001 else fallback

func advance_visual(dt: float) -> void:
	if not is_finite(dt) or dt < 0.0: return
	age = minf(duration, age + dt)
	var progress: float = clampf(age / duration, 0.0, 1.0)
	opacity = smoothstep(0.0, 0.06, progress) * (1.0 - smoothstep(0.36, 1.0, progress))
	var rings: Array[MeshInstance3D] = [halo, inner_ring]
	for index in range(2):
		var tilt := Basis(Vector3.RIGHT if index == 0 else Vector3.FORWARD, 0.45 if index == 0 else 1.15)
		var orientation := Basis(spin_axes[index], TAU * progress * turns[index]) * tilt
		rings[index].basis = orientation
		glow_shells[index].basis = orientation
		# Keep the white/mint core translucent; the surrounding additive shell provides glow.
		var color: Color = ring_colors[index]
		color.a *= opacity
		ring_materials[index].albedo_color = color
	for paint in glow_materials: paint.set_shader_parameter("visibility", opacity)
	amount_label.position = Vector3(0, amount_height + progress * 0.24, 0)
	amount_label.modulate = Color(0.72, 1.0, 0.80, opacity)
	amount_label.outline_modulate = Color(0.025, 0.14, 0.045, opacity)
