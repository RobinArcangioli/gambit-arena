extends Node2D
## Temporary asset inspection scene. No combat or movement controller.
const ActorPresentation = preload("res://scripts/actors/actor_visual.gd")
const GroundProjection = preload("res://scripts/world/ground_projection.gd")
const DIRECTION_LABELS: Array[String] = ["SE (+x)", "SO (+y)", "NE (-y)", "NO (-x)"]
@onready var world: Node2D = $World
@onready var hero: ActorPresentation = $World/Hero
@onready var enemy: ActorPresentation = $World/Enemy
@onready var safe_frame: Control = $HUD/SafeFrame
@onready var title_label: Label = $HUD/SafeFrame/Title
@onready var description: Label = $HUD/SafeFrame/Description
@onready var status_label: Label = $HUD/SafeFrame/Status
@onready var state_button: Button = $HUD/SafeFrame/StateButton
@onready var direction_button: Button = $HUD/SafeFrame/DirectionButton
@onready var pause_button: Button = $HUD/SafeFrame/PauseButton
@onready var replay_button: Button = $HUD/SafeFrame/ReplayButton
@onready var cross_button: Button = $HUD/SafeFrame/CrossButton
@onready var frame_button: Button = $HUD/SafeFrame/FrameButton
var state_index: int = 0
var direction_index: int = 0
var paused: bool = false
var crossing: bool = false
var elapsed: float = 0.0
var safe_rect := Rect2()

func _ready() -> void:
	for actor in [hero, enemy]:
		var marker := Line2D.new()
		marker.name = "FootMarker"
		marker.width = 1.5
		marker.default_color = Color("fff2bb")
		marker.points = PackedVector2Array([Vector2(-5, 0), Vector2(5, 0), Vector2.ZERO, Vector2(0, -4), Vector2(0, 4)])
		actor.add_child(marker)
	state_button.pressed.connect(_next_state)
	direction_button.pressed.connect(_next_direction)
	pause_button.pressed.connect(_toggle_pause)
	replay_button.pressed.connect(_replay)
	cross_button.pressed.connect(_toggle_crossing)
	frame_button.pressed.connect(_next_frame)
	get_viewport().size_changed.connect(_update_layout)
	_update_layout()
	_apply_pose()
	call_deferred("_update_layout")

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		paused = true
		if is_node_ready():
			_apply_pause()
	if what == NOTIFICATION_APPLICATION_RESUMED and is_node_ready():
		call_deferred("_update_layout")

func _update_layout() -> void:
	safe_rect = get_viewport_rect()
	if OS.get_name() == "Android":
		var inverse_screen: Transform2D = get_viewport().get_screen_transform().affine_inverse()
		var native_safe := Rect2(DisplayServer.get_display_safe_area())
		var converted: Rect2 = inverse_screen * native_safe
		var clipped: Rect2 = converted.intersection(get_viewport_rect())
		if clipped.has_area():
			safe_rect = clipped
	safe_frame.position = safe_rect.position
	safe_frame.size = safe_rect.size
	var width: float = safe_rect.size.x
	var height: float = safe_rect.size.y
	title_label.position = Vector2(20, 20)
	description.position = Vector2(20, 64)
	status_label.position = Vector2(20, height - 350)
	var buttons: Array[Button] = [state_button, direction_button, pause_button, replay_button, cross_button, frame_button]
	var button_width: float = (width - 52) * 0.5
	for index in range(buttons.size()):
		var row: int = int(index / 2.0)
		buttons[index].position = Vector2(20 + (index % 2) * (button_width + 12), height - 208 + row * 68)
		buttons[index].size = Vector2(button_width, 60)
	world.position = safe_rect.position + Vector2(width * 0.5, 330)
	_update_positions()
	queue_redraw()

func _process(delta: float) -> void:
	if not paused and crossing:
		elapsed = fposmod(elapsed + delta, 8.0)
	_update_positions()
	_update_status()

func _update_positions() -> void:
	if crossing:
		var phase: float = elapsed / 8.0
		var progress: float = phase * 2.0 if phase < 0.5 else (1.0 - phase) * 2.0
		var travel: float = lerpf(-45, 45, progress)
		hero.position = GroundProjection.ground_to_screen(Vector2(travel - 5, travel + 5))
		enemy.position = GroundProjection.ground_to_screen(Vector2(-travel + 5, -travel - 5))
	else:
		hero.position = Vector2(-85, 0)
		enemy.position = Vector2(85, 0)

func _apply_pose() -> void:
	var state: String = ActorPresentation.STATES[state_index]
	var direction: String = ActorPresentation.DIRECTIONS[direction_index]
	hero.play_pose(state, direction, true)
	enemy.play_pose(state, direction, true)
	_apply_pause()

func _apply_pause() -> void:
	hero.set_visual_paused(paused)
	enemy.set_visual_paused(paused)
	_update_status()

func _next_state() -> void:
	state_index = (state_index + 1) % ActorPresentation.STATES.size()
	_apply_pose()

func _next_direction() -> void:
	direction_index = (direction_index + 1) % ActorPresentation.DIRECTIONS.size()
	_apply_pose()

func _toggle_pause() -> void:
	paused = not paused
	_apply_pause()

func _replay() -> void:
	elapsed = 0.0
	_apply_pose()
	_update_positions()

func _toggle_crossing() -> void:
	crossing = not crossing
	elapsed = 0.0
	_update_positions()
	_update_status()

func _next_frame() -> void:
	paused = true
	_apply_pause()
	for actor in [hero, enemy]:
		actor.visual.set_frame_and_progress((actor.visual.frame + 1) % 4, 0.0)
	_update_status()

func _update_status() -> void:
	state_button.text = "Etat : " + ActorPresentation.STATES[state_index].capitalize()
	direction_button.text = "Direction : " + DIRECTION_LABELS[direction_index]
	pause_button.text = "Reprendre" if paused else "Pause"
	cross_button.text = "Croisement : oui" if crossing else "Croisement : non"
	var playback: String = "PAUSE" if paused else ("LECTURE" if hero.visual.is_playing() else "TERMINE : Rejouer")
	status_label.text = "%s\n%s / %s\nImages heros %d/4 | ennemi %d/4\nIdle/Move bouclent ; autres : une fois\nFPS indicatifs : %d" % [playback, ActorPresentation.STATES[state_index], ActorPresentation.DIRECTIONS[direction_index], hero.visual.frame + 1, enemy.visual.frame + 1, Engine.get_frames_per_second()]

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_A: _next_state()
		KEY_D: _next_direction()
		KEY_SPACE: _toggle_pause()
		KEY_R: _replay()
		KEY_C: _toggle_crossing()
		KEY_N: _next_frame()
		_: return
	get_viewport().set_input_as_handled()

func _draw() -> void:
	draw_rect(get_viewport_rect(), Color("111b29"))
	var center: Vector2 = world.position
	var diamond := PackedVector2Array([center + Vector2(-190, 0), center + Vector2(0, -95), center + Vector2(190, 0), center + Vector2(0, 95)])
	draw_colored_polygon(diamond, Color("1d3043"))
	draw_line(center + Vector2(-150, 0), center + Vector2(150, 0), Color("38526a"), 1.0)
