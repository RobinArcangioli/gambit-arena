extends MeshInstance3D
## Passive ground footprint; supplied radius is already in ground/world units.
const ShadowShader = preload("res://assets/shaders/footprint_shadow.gdshader")
const GROUND_LIFT: float = 0.006
var radius: float = 0.0

func configure(ground_radius: float, tint: Color, feather: float) -> void:
	radius = maxf(0.0, ground_radius) if is_finite(ground_radius) else 0.0
	var plane := PlaneMesh.new()
	plane.size = Vector2.ONE * radius * 2.0
	mesh = plane
	var surface := ShaderMaterial.new()
	surface.shader = ShadowShader
	surface.set_shader_parameter("tint", tint)
	surface.set_shader_parameter("feather", clampf(feather, 0.001, 0.25))
	material_override = surface
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	position.y = GROUND_LIFT
	visible = radius > 0.0 and tint.a > 0.0
