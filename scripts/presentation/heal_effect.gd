extends Node3D
## Passive visual: only the presenter supplies time and the already applied heal value.
var age: float = 0.0
var duration: float = 0.85
var amount: int = 0
var tint: Color
var radius: float
var halo: MeshInstance3D
var material: StandardMaterial3D
var amount_label: Label3D
var motes: Array[Label3D] = []
var amount_height: float

func setup(profile: Resource, healed: int) -> void:
	duration = maxf(0.1, profile.duration)
	amount = healed
	tint = profile.color
	radius = profile.radius
	amount_height = profile.amount_height
	material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = tint
	material.no_depth_test = false
	halo = MeshInstance3D.new()
	var ring := TorusMesh.new()
	ring.inner_radius = radius * 0.89
	ring.outer_radius = radius
	ring.rings = 24
	ring.ring_segments = 6
	halo.mesh = ring
	halo.material_override = material
	halo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(halo)
	amount_label = _label("+%d" % amount, 48)
	for i in range(4): motes.append(_label("+", 32))
	advance_visual(0.0)

func _label(text: String, size: int) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.font_size = size
	label.pixel_size = 0.006
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.modulate = tint
	label.outline_modulate = Color(0.04, 0.17, 0.10, 1)
	label.outline_size = 5
	label.no_depth_test = false
	add_child(label)
	return label

func advance_visual(dt: float) -> void:
	age = minf(duration, age + maxf(0.0, dt))
	var progress: float = clampf(age / duration, 0.0, 1.0)
	var opacity: float = 1.0 - smoothstep(0.4, 1.0, progress)
	material.albedo_color = Color(tint, opacity * 0.75)
	halo.scale = Vector3.ONE * lerpf(0.7, 1.3, progress)
	halo.position.y = 0.035
	amount_label.position = Vector3(0, amount_height + progress * 0.35, 0)
	amount_label.modulate = Color(tint, opacity)
	for i in range(motes.size()):
		var angle: float = TAU * i / motes.size() + 0.35
		motes[i].position = Vector3(cos(angle) * radius, 0.22 + progress * 0.65 + (i % 2) * 0.12, sin(angle) * radius)
		motes[i].modulate = Color(tint, opacity * 0.85)
