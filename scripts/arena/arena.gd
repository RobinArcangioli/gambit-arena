extends Control
## Static arena layout: no gameplay movement, targeting, collision or combat.
const ArenaBounds = preload("res://scripts/arena/arena_bounds.gd")
const ProxyActor = preload("res://scripts/hybrid/proxy_actor.gd")
const ArenaFloor = preload("res://scripts/arena/arena_floor.gd")
const PLACEMENTS: Array[Vector2] = [Vector2.ZERO, Vector2(-4, -4), Vector2(4, -4), Vector2(4, 4), Vector2(-4, 4)]
@onready var floor_canvas: ArenaFloor = $Floor
@onready var render_box: SubViewportContainer = $Render3D
@onready var viewport_3d: SubViewport = $Render3D/Viewport
@onready var world: Node3D = $Render3D/Viewport/World
@onready var camera: Camera3D = $Render3D/Viewport/World/Camera
@onready var hero: ProxyActor = $Render3D/Viewport/World/Hero
@onready var enemy: ProxyActor = $Render3D/Viewport/World/Enemy
@onready var hud: Control = $HUD
@onready var pause_button: Button = $HUD/PauseButton
@onready var position_button: Button = $HUD/PositionButton
@onready var marks_button: Button = $HUD/MarksButton
var slots: Array[Button] = []
var safe_rect := Rect2()
var paused: bool = false
var placement_index: int = 0

func _ready() -> void:
	camera.position = Vector3(10, sqrt(200.0 / 3.0), 10)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_CLEAR_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color.WHITE
	environment.ambient_light_energy = 0.65
	environment_node.environment = environment
	world.add_child(environment_node)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55, -30, 0)
	light.light_energy = 0.9
	light.shadow_enabled = false
	world.add_child(light)
	floor_canvas.camera = camera
	for index in range(6):
		var slot := Button.new()
		slot.name = "ReservedSlot%d" % (index + 1)
		slot.text = "%d / A venir" % (index + 1)
		slot.disabled = true
		slot.focus_mode = Control.FOCUS_NONE
		slot.add_theme_font_size_override("font_size", 18)
		hud.add_child(slot)
		slots.append(slot)
	pause_button.pressed.connect(_toggle_pause)
	position_button.pressed.connect(_next_placement)
	marks_button.pressed.connect(_toggle_marks)
	get_viewport().size_changed.connect(_update_layout)
	viewport_3d.size_changed.connect(_sync_projection)
	_update_layout()
	_place_actors()
	_update_buttons()
	call_deferred("_sync_projection")

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		paused = true
		if is_node_ready():
			_update_buttons()
	if what == NOTIFICATION_APPLICATION_RESUMED and is_node_ready():
		call_deferred("_update_layout")

func _update_layout() -> void:
	safe_rect = get_viewport_rect()
	if OS.get_name() == "Android":
		var transform_to_view: Transform2D = get_viewport().get_screen_transform().affine_inverse()
		var converted: Rect2 = transform_to_view * Rect2(DisplayServer.get_display_safe_area())
		var clipped: Rect2 = converted.intersection(get_viewport_rect())
		if clipped.has_area():
			safe_rect = clipped
	$Backdrop.size = get_viewport_rect().size
	hud.position = safe_rect.position
	hud.size = safe_rect.size
	var width: float = safe_rect.size.x
	var height: float = safe_rect.size.y
	$HUD/HeaderPanel.position = Vector2(16, 12)
	$HUD/HeaderPanel.size = Vector2(width - 32, 100)
	$HUD/Title.position = Vector2(28, 24)
	$HUD/Description.position = Vector2(28, 66)
	pause_button.position = Vector2(width - 140, 20)
	pause_button.size = Vector2(112, 42)
	render_box.position = safe_rect.position + Vector2(16, 124)
	render_box.size = Vector2(width - 32, maxf(300, height - 388))
	floor_canvas.position = render_box.position
	$HUD/FooterPanel.position = Vector2(16, height - 252)
	$HUD/FooterPanel.size = Vector2(width - 32, 240)
	var button_width: float = (width - 68) * 0.5
	position_button.position = Vector2(28, height - 240)
	position_button.size = Vector2(button_width, 56)
	marks_button.position = Vector2(40 + button_width, height - 240)
	marks_button.size = Vector2(button_width, 56)
	$HUD/SlotsTitle.position = Vector2(28, height - 174)
	var slot_width: float = (width - 80) / 3.0
	for index in range(slots.size()):
		var row: int = int(index / 3.0)
		slots[index].position = Vector2(28 + (index % 3) * (slot_width + 12), height - 144 + row * 62)
		slots[index].size = Vector2(slot_width, 54)
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	if not is_node_ready():
		return
	camera.size = float(viewport_3d.size.x) / 48.0
	floor_canvas.view_size = Vector2(viewport_3d.size)
	floor_canvas.queue_redraw()

func _place_actors() -> void:
	var ground: Vector2 = ArenaBounds.clamp_ground(PLACEMENTS[placement_index])
	var other_ground: Vector2 = ArenaBounds.clamp_ground(-ground if placement_index != 0 else Vector2(1.4, -1.4))
	hero.position = Vector3(ground.x, 0, ground.y)
	enemy.position = Vector3(other_ground.x, 0, other_ground.y)
	hero.pose(0.0, false, Vector2(1, 1))
	enemy.pose(0.0, false, Vector2(-1, -1))
	floor_canvas.feet = [hero.position, enemy.position]
	floor_canvas.queue_redraw()

func _update_buttons() -> void:
	pause_button.text = "Reprendre" if paused else "Pause"
	position_button.text = "Position : %d/5" % (placement_index + 1)
	position_button.disabled = paused
	marks_button.text = "Reperes : oui" if floor_canvas.show_marks else "Reperes : non"

func _toggle_pause() -> void:
	paused = not paused
	_update_buttons()

func _next_placement() -> void:
	if paused:
		return
	placement_index = (placement_index + 1) % PLACEMENTS.size()
	_place_actors()
	_update_buttons()

func _toggle_marks() -> void:
	floor_canvas.show_marks = not floor_canvas.show_marks
	floor_canvas.queue_redraw()
	_update_buttons()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_SPACE: _toggle_pause()
		KEY_P: _next_placement()
		KEY_G: _toggle_marks()
		_: return
	get_viewport().set_input_as_handled()
