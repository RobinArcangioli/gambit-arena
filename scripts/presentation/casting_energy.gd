extends Node3D
## Deterministic, bounded mana motes. Only explicitly supplied visual time is sampled.
const MoteShader = preload("res://shaders/presentation/mana_mote.gdshader")
const COUNT: int = 8
var age: float = 0.0
var strength: float = 0.65
var motes: Array[MeshInstance3D] = []
var paints: Array[ShaderMaterial] = []

func _ready() -> void:
	var mesh := QuadMesh.new()
	mesh.size = Vector2.ONE * 0.15
	for index in range(COUNT):
		var paint := ShaderMaterial.new();paint.shader = MoteShader
		var mote := MeshInstance3D.new();mote.mesh = mesh;mote.material_override = paint
		mote.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(mote);motes.append(mote);paints.append(paint)
	advance_visual(0.0)

func advance_visual(dt: float) -> void:
	if not is_finite(dt) or dt < 0.0:return
	age = fposmod(age + dt, 120.0)
	var camera := get_viewport().get_camera_3d()
	for index in range(motes.size()):
		var progress: float = fposmod(age / 1.35 + float(index) / COUNT, 1.0)
		var angle: float = float(index) * 2.39996 + progress * 0.75
		var radius: float = lerpf(0.83, 0.10, progress * progress)
		var height: float = lerpf(0.18 + 0.045 * (index % 4), 0.72, progress) + sin(progress * PI) * 0.14
		motes[index].position = Vector3(cos(angle) * radius, height, sin(angle) * radius)
		if camera != null:motes[index].global_basis = camera.global_basis
		var envelope: float = smoothstep(0.0, 0.18, progress) * (1.0 - smoothstep(0.78, 1.0, progress))
		paints[index].set_shader_parameter("opacity", envelope * strength)
