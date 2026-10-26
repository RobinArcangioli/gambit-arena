extends RefCounted
## Small procedural meshes, with a static shader. Time is always supplied explicitly.
const GLOW = preload("res://shaders/presentation/lightning_glow.gdshader")

static func material(profile: Resource, shape: int = 0) -> ShaderMaterial:
	var result := ShaderMaterial.new()
	result.shader = GLOW
	result.set_shader_parameter("glow_color", profile.glow_color)
	result.set_shader_parameter("core_color", profile.core_color)
	result.set_shader_parameter("shape", shape)
	return result

static func quad(size: float, paint: Material) -> MeshInstance3D:
	var mesh := QuadMesh.new()
	mesh.size = Vector2.ONE * size
	return instance(mesh, paint)

static func instance(mesh: Mesh, paint: Material) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = paint
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return node

static func ribbons(paths: Array, widths: Array, facing: Vector3) -> ArrayMesh:
	var vertices := PackedVector3Array()
	var uvs := PackedVector2Array()
	var colors := PackedColorArray()
	for path_index in range(paths.size()):
		var path: PackedVector3Array = paths[path_index]
		for i in range(path.size() - 1):
			var tangent: Vector3 = (path[i + 1] - path[i]).normalized()
			var side: Vector3 = tangent.cross(facing).normalized() * float(widths[path_index])
			if side.length_squared() < 0.000001: side = Vector3.RIGHT * float(widths[path_index])
			var corners: Array[Vector3] = [path[i] - side, path[i] + side, path[i + 1] + side, path[i + 1] - side]
			var start: float = float(i) / (path.size() - 1)
			var end: float = float(i + 1) / (path.size() - 1)
			var tex: Array[Vector2] = [Vector2(0, start), Vector2(1, start), Vector2(1, end), Vector2(0, end)]
			for index in [0, 1, 2, 0, 2, 3]:
				vertices.append(corners[index])
				uvs.append(tex[index])
				colors.append(Color(1, 1, 1, 1 if path_index == 0 else 0.7))
	var data: Array = []
	data.resize(Mesh.ARRAY_MAX)
	data[Mesh.ARRAY_VERTEX] = vertices
	data[Mesh.ARRAY_TEX_UV] = uvs
	data[Mesh.ARRAY_COLOR] = colors
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	return mesh
