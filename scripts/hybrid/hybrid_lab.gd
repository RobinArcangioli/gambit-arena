extends Control
## Single transparent 3D viewport over a registered 2D background.
const ProxyActor = preload("res://scripts/hybrid/proxy_actor.gd")
const GroundCanvas = preload("res://scripts/hybrid/ground_canvas.gd")
const DECOR_TEXTURE: Texture2D = preload("res://assets/hybrid/occluder.svg")
const MODES: Array[String] = ["Croisement", "Decor 2D", "Charge 20"]
const SIZES: Array[int] = [48, 64, 80]
@onready var ground: GroundCanvas = $Ground
@onready var render_box: SubViewportContainer = $Render3D
@onready var viewport_3d: SubViewport = $Render3D/Viewport
@onready var world: Node3D = $Render3D/Viewport/World
@onready var camera: Camera3D = $Render3D/Viewport/World/Camera
@onready var hero: ProxyActor = $Render3D/Viewport/World/Hero
@onready var enemy: ProxyActor = $Render3D/Viewport/World/Enemy
@onready var hud: Control = $HUD
@onready var status_label: Label = $HUD/Status
@onready var mode_button: Button = $HUD/ModeButton
@onready var size_button: Button = $HUD/SizeButton
@onready var pause_button: Button = $HUD/PauseButton
@onready var reset_button: Button = $HUD/ResetButton
@onready var marks_button: Button = $HUD/MarksButton
@onready var walk_button: Button = $HUD/WalkButton
var actors: Array[ProxyActor] = []
var decor: Sprite3D
var elapsed: float = 0.0
var paused: bool = false
var walking: bool = true
var mode_index: int = 0
var size_index: int = 0
var round_trip_error: float = 0.0
var projection_ratio: float = 0.0
var safe_rect := Rect2()
var sample_seconds: float = 0.0
var sample_frames: int = 0
var sample_max_ms: float = 0.0

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
	actors = [hero, enemy]
	for index in range(18):
		var actor := ProxyActor.new()
		actor.name = "Extra%02d" % index
		actor.enemy = true
		world.add_child(actor)
		actors.append(actor)
	decor = Sprite3D.new()
	decor.name = "Decor2D"
	decor.texture = DECOR_TEXTURE
	decor.pixel_size = 1.65 / 112.0
	decor.position.y = 1.65 * 0.5
	decor.rotation.y = PI * 0.25
	decor.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	decor.alpha_scissor_threshold = 0.5
	decor.no_depth_test = false
	decor.shaded = false
	decor.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	world.add_child(decor)
	ground.camera = camera
	mode_button.pressed.connect(_next_mode)
	size_button.pressed.connect(_next_size)
	pause_button.pressed.connect(_toggle_pause)
	reset_button.pressed.connect(_reset)
	marks_button.pressed.connect(_toggle_marks)
	walk_button.pressed.connect(_toggle_walk)
	get_viewport().size_changed.connect(_update_layout)
	viewport_3d.size_changed.connect(_sync_projection)
	_update_layout()
	_update_actors()
	call_deferred("_sync_projection")

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		paused = true
	if what == NOTIFICATION_APPLICATION_RESUMED and is_node_ready():
		call_deferred("_update_layout")

func _update_layout() -> void:
	safe_rect = get_viewport_rect()
	if OS.get_name() == "Android":
		var inverse_screen: Transform2D = get_viewport().get_screen_transform().affine_inverse()
		var converted: Rect2 = inverse_screen * Rect2(DisplayServer.get_display_safe_area())
		var clipped: Rect2 = converted.intersection(get_viewport_rect())
		if clipped.has_area():
			safe_rect = clipped
	$Backdrop.size = get_viewport_rect().size
	hud.position = safe_rect.position
	hud.size = safe_rect.size
	$HUD/Title.position = Vector2(20, 20)
	$HUD/Description.position = Vector2(20, 62)
	render_box.position = safe_rect.position + Vector2(0, 150)
	render_box.size = Vector2(safe_rect.size.x, 380)
	ground.position = render_box.position
	status_label.position = Vector2(20, safe_rect.size.y - 380)
	var buttons: Array[Button] = [mode_button, size_button, pause_button, reset_button, marks_button, walk_button]
	var button_width: float = (safe_rect.size.x - 52) * 0.5
	for index in range(buttons.size()):
		var row: int = int(index / 2.0)
		buttons[index].position = Vector2(20 + (index % 2) * (button_width + 12), safe_rect.size.y - 208 + row * 68)
		buttons[index].size = Vector2(button_width, 60)
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	if not is_node_ready():
		return
	# Keep 48 reference pixels per world unit regardless of viewport width.
	camera.size = float(viewport_3d.size.x) / 48.0
	ground.view_size = Vector2(viewport_3d.size)
	_check_projection()
	ground.queue_redraw()

func _check_projection() -> void:
	round_trip_error = 0.0
	for point in [Vector3.ZERO, Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(-2, 0, 2)]:
		var screen: Vector2 = camera.unproject_position(point)
		var ray_origin: Vector3 = camera.project_ray_origin(screen)
		var ray_direction: Vector3 = camera.project_ray_normal(screen)
		var restored: Vector3 = ray_origin - ray_direction * (ray_origin.y / ray_direction.y)
		round_trip_error = maxf(round_trip_error, restored.distance_to(point))
	var axis: Vector2 = camera.unproject_position(Vector3(1, 0, 0)) - camera.unproject_position(Vector3.ZERO)
	projection_ratio = absf(axis.x / axis.y)
	if round_trip_error > 0.001 or absf(projection_ratio - 2.0) > 0.001:
		push_error("TRANSITION-001: projection registration failed.")

func _process(delta: float) -> void:
	if not paused:
		elapsed = fposmod(elapsed + delta, 8.0)
		sample_seconds += delta
		sample_frames += 1
		sample_max_ms = maxf(sample_max_ms, delta * 1000.0)
	_update_actors()
	_update_status()

func _update_actors() -> void:
	var phase: float = elapsed / 8.0
	var progress: float = phase * 2.0 if phase < 0.5 else (1.0 - phase) * 2.0
	var travel: float = lerpf(-1.7, 1.7, progress)
	var direction: float = 1.0 if phase < 0.5 else -1.0
	decor.visible = mode_index == 1
	ground.feet.clear()
	for index in range(actors.size()):
		var actor: ProxyActor = actors[index]
		actor.visible = index < 2 or mode_index == 2
		if not actor.visible:
			continue
		var facing := Vector2(direction, direction)
		if mode_index == 2:
			var angle: float = elapsed * TAU / 8.0 + float(index) * TAU / 20.0
			var radius: float = 1.2 if index < 10 else 2.4
			actor.position = Vector3(cos(angle) * radius, 0, sin(angle) * radius)
			facing = Vector2(-sin(angle), cos(angle))
		elif index == 0:
			actor.position = Vector3(travel - 0.15, 0, travel + 0.15)
		elif mode_index == 0:
			actor.position = Vector3(-travel + 0.15, 0, -travel - 0.15)
			facing = -facing
		else:
			actor.position = Vector3(2.0, 0, -2.0)
			facing = Vector2(1, 1)
		actor.body.scale = Vector3.ONE * float(SIZES[size_index]) / 48.0
		actor.pose(elapsed, walking and not (mode_index == 1 and index == 1), facing)
		ground.feet.append(actor.position)
	ground.queue_redraw()

func _update_status() -> void:
	mode_button.text = "Mode : " + MODES[mode_index]
	size_button.text = "Echelle : %d" % SIZES[size_index]
	pause_button.text = "Reprendre" if paused else "Pause"
	marks_button.text = "Reperes : oui" if ground.show_marks else "Reperes : non"
	walk_button.text = "Marche : oui" if walking else "Marche : non"
	var mean_fps: float = float(sample_frames) / sample_seconds if sample_seconds > 0.0 else 0.0
	var state: String = "PAUSE" if paused else "EN MARCHE"
	status_label.text = "%s | cycle %.1f s | %d acteurs\nProjection : %.3f:1 | erreur %.5f\nFPS actuels %d | moyenne %.1f\nMesure %.0f s | pire image %.1f ms\nRepartir remet aussi la mesure a zero\nMarche = pose ; les trajets restent actifs" % [state, elapsed, 20 if mode_index == 2 else 2, projection_ratio, round_trip_error, Engine.get_frames_per_second(), mean_fps, sample_seconds, sample_max_ms]

func _clear_sample() -> void:
	sample_seconds = 0.0
	sample_frames = 0
	sample_max_ms = 0.0

func _next_mode() -> void:
	mode_index = (mode_index + 1) % MODES.size()
	_reset()

func _next_size() -> void:
	size_index = (size_index + 1) % SIZES.size()
	_clear_sample()
	_update_actors()

func _toggle_pause() -> void:
	paused = not paused

func _reset() -> void:
	elapsed = 0.0
	_clear_sample()
	_update_actors()

func _toggle_marks() -> void:
	ground.show_marks = not ground.show_marks

func _toggle_walk() -> void:
	walking = not walking
	_clear_sample()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_M: _next_mode()
		KEY_S: _next_size()
		KEY_SPACE: _toggle_pause()
		KEY_R: _reset()
		KEY_G: _toggle_marks()
		KEY_W: _toggle_walk()
		_: return
	get_viewport().set_input_as_handled()
