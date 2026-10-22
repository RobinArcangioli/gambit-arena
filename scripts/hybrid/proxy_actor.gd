extends Node3D
## Original procedural mannequin: no external model, rig, physics or combat.
@export var enemy: bool = false
var body: Node3D
var left_arm: Node3D
var right_arm: Node3D
var left_leg: Node3D
var right_leg: Node3D

func _ready() -> void:
	body = Node3D.new()
	body.name = "Model"
	add_child(body)
	var cloth := StandardMaterial3D.new()
	cloth.albedo_color = Color("d56b54") if enemy else Color("39b8d0")
	cloth.roughness = 0.85
	var dark := StandardMaterial3D.new()
	dark.albedo_color = Color("493751") if enemy else Color("224354")
	dark.roughness = 0.9
	var trim := StandardMaterial3D.new()
	trim.albedo_color = Color("c3a4d3") if enemy else Color("f1cf83")
	trim.roughness = 0.8
	_add_box(body, Vector3(0.4, 0.4, 0.26), Vector3(0, 0.54, 0), cloth)
	_add_box(body, Vector3(0.42, 0.06, 0.28), Vector3(0, 0.4, 0), trim)
	if enemy:
		_add_box(body, Vector3(0.34, 0.32, 0.32), Vector3(0, 0.9, 0), trim)
	else:
		var sphere := SphereMesh.new()
		sphere.radius = 0.18
		sphere.height = 0.36
		sphere.radial_segments = 12
		sphere.rings = 6
		_add_mesh(body, sphere, Vector3(0, 0.9, 0), trim)
	_add_box(body, Vector3(0.22, 0.08, 0.03), Vector3(0, 0.92, 0.178), dark)
	left_leg = _limb(Vector3(-0.12, 0.34, 0), Vector3(0.15, 0.34, 0.19), dark)
	right_leg = _limb(Vector3(0.12, 0.34, 0), Vector3(0.15, 0.34, 0.19), dark)
	left_arm = _limb(Vector3(-0.28, 0.7, 0), Vector3(0.13, 0.34, 0.14), cloth)
	right_arm = _limb(Vector3(0.28, 0.7, 0), Vector3(0.13, 0.34, 0.14), cloth)

func _add_mesh(parent: Node3D, mesh: Mesh, at: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = material
	instance.position = at
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(instance)

func _add_box(parent: Node3D, size_value: Vector3, at: Vector3, material: Material) -> void:
	var box := BoxMesh.new()
	box.size = size_value
	_add_mesh(parent, box, at, material)

func _limb(at: Vector3, size_value: Vector3, material: Material) -> Node3D:
	var pivot := Node3D.new()
	body.add_child(pivot)
	pivot.position = at
	_add_box(pivot, size_value, Vector3(0, -size_value.y * 0.5, 0), material)
	return pivot

func pose(time: float, walking: bool, facing: Vector2) -> void:
	if facing.length_squared() > 0.0001:
		rotation.y = atan2(facing.x, facing.y)
	var swing: float = sin(time * TAU * 2.0) * 0.4 if walking else 0.0
	left_leg.rotation.x = swing
	right_leg.rotation.x = -swing
	left_arm.rotation.x = -swing
	right_arm.rotation.x = swing
