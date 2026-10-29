extends SubViewportContainer
## Passive presentation only. No actor stats, executor, physics or autonomous animation clock.
const View = preload("res://scripts/presentation/character_view.gd")
var definition: Resource
var ground_radius: float = 0.35
var viewport_3d: SubViewport
var camera: Camera3D
var character: View
var active: bool = true

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stretch = true
	viewport_3d = SubViewport.new()
	viewport_3d.transparent_bg = true
	viewport_3d.own_world_3d = true
	viewport_3d.gui_disable_input = true
	viewport_3d.msaa_3d = Viewport.MSAA_2X
	viewport_3d.size = Vector2i(256,256)
	add_child(viewport_3d)
	var world := Node3D.new();viewport_3d.add_child(world)
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_CLEAR_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color.WHITE
	environment.ambient_light_energy = 0.72
	environment_node.environment = environment;world.add_child(environment_node)
	var light := DirectionalLight3D.new();light.rotation_degrees = Vector3(-45,-30,0)
	light.light_energy = 0.9;light.shadow_enabled = false;world.add_child(light)
	View.SurfaceProfile.apply_lighting(world)
	camera = Camera3D.new();camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	camera.position = Vector3(2.8,1.65,4.0)
	world.add_child(camera);camera.look_at(Vector3(0,0.62,0),Vector3.UP)
	character = View.new();character.definition = definition;character.ground_radius = ground_radius
	world.add_child(character)
	character.pose(0,false,Vector2.DOWN)
	resized.connect(_frame)
	_frame();set_active(active)

func _frame() -> void:
	if camera == null:return
	var aspect: float = size.x / maxf(1,size.y)
	camera.size = maxf(1.65,1.55 / maxf(0.4,aspect))

func set_active(enabled: bool) -> void:
	active = enabled
	if viewport_3d != null:viewport_3d.render_target_update_mode = SubViewport.UPDATE_ALWAYS if enabled else SubViewport.UPDATE_DISABLED

func advance_visual(dt: float) -> void:
	if active and is_instance_valid(character):character.advance_visual(dt)
