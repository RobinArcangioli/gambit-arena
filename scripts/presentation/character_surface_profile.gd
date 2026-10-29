extends Resource
## Presentation-only material and light settings. Imported textures and meshes stay shared.
@export var display_name: String = "Peint doux"
@export var roughness: float = 0.9
@export var metallic: float = 0.0
@export var specular: float = 0.12
@export var diffuse_mode: int = BaseMaterial3D.DIFFUSE_BURLEY
@export var ambient_color: Color = Color("c6d3ec")
@export var ambient_energy: float = 0.5
@export var light_color: Color = Color("fff0da")
@export var light_energy: float = 0.9
@export var use_imported_materials: bool = false

func make_material(source: Material) -> Material:
	if use_imported_materials or not source is BaseMaterial3D:return source
	var paint := source.duplicate() as BaseMaterial3D
	paint.roughness=roughness;paint.metallic=metallic;paint.metallic_specular=specular
	paint.diffuse_mode=diffuse_mode
	return paint

func apply_lighting(world: Node) -> void:
	for child in world.get_children():
		if child is WorldEnvironment and child.environment!=null:
			child.environment.ambient_light_color=ambient_color
			child.environment.ambient_light_energy=ambient_energy
		elif child is DirectionalLight3D:
			child.light_color=light_color;child.light_energy=light_energy
