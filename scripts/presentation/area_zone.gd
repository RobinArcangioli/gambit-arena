extends Node3D
## Passive ground indicator. Receives only radius and position, never gameplay objects.
var radius:float=-1
var geometry:=ImmediateMesh.new()
func _init() -> void:
	var mesh:=MeshInstance3D.new();mesh.mesh=geometry
	var paint:=StandardMaterial3D.new();paint.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
	paint.albedo_color=Color("ffd16a");paint.no_depth_test=true
	mesh.material_override=paint;mesh.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF;add_child(mesh)
func set_radius(value:float) -> void:
	if is_equal_approx(radius,value) or not is_finite(value) or value<=0:return
	radius=value;geometry.clear_surfaces();geometry.surface_begin(Mesh.PRIMITIVE_LINES)
	for i in range(64):
		for angle in [TAU*i/64.0,TAU*(i+1)/64.0]:geometry.surface_add_vertex(Vector3(cos(angle)*radius,0,sin(angle)*radius))
	for edge in [[Vector3(-.12,0,0),Vector3(.12,0,0)],[Vector3(0,0,-.12),Vector3(0,0,.12)]]:
		for vertex in edge:geometry.surface_add_vertex(vertex)
	geometry.surface_end()
