extends Node3D
## Discreet preparation only. No success signal and no reference to a logical actor.
const Geometry = preload("res://scripts/presentation/lightning_geometry.gd")
var age: float = 0.0
var source_orb: MeshInstance3D
var target_ring: MeshInstance3D
var orb_material: ShaderMaterial
var ring_material: ShaderMaterial
var progress: float = 0.0

func setup(profile: Resource) -> void:
	orb_material = Geometry.material(profile, 1)
	ring_material = Geometry.material(profile, 2)
	source_orb = Geometry.quad(0.55, orb_material)
	add_child(source_orb)
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null: source_orb.global_basis = camera.global_basis
	target_ring = Geometry.quad(0.75, ring_material)
	target_ring.rotation.x = -PI * 0.5
	add_child(target_ring)
	advance_visual(0)

func set_anchors(source: Vector3, target: Vector3, cast_progress: float) -> void:
	source_orb.position = source
	target_ring.position = target + Vector3(0, 0.035, 0)
	progress = clampf(cast_progress, 0, 1)

func advance_visual(dt: float) -> void:
	age += maxf(0, dt)
	var pulse: float = 0.5 + sin(age * 7.0) * 0.12
	orb_material.set_shader_parameter("visibility", pulse * lerpf(0.35, 0.8, progress))
	ring_material.set_shader_parameter("visibility", pulse * 0.35)
	target_ring.scale = Vector3.ONE * (0.85 + progress * 0.15)
