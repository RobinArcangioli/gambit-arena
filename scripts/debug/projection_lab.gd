extends Node2D
## Temporary, scripted diagnostic. This is not the hero movement controller.

const GroundProjection = preload("res://scripts/world/ground_projection.gd")
const ACTOR_TEXTURE: Texture2D = preload("res://assets/debug/actor.svg")
const TALL_TEXTURE: Texture2D = preload("res://assets/debug/actor_tall.svg")
const DECOR_TEXTURE: Texture2D = preload("res://assets/debug/pillar.svg")
const CROSS_CENTER := Vector2(-140.0, -140.0)
const DECOR_CENTER := Vector2(130.0, 130.0)
const HALF_TRAVEL: float = 45.0
const CYCLE_SECONDS: float = 8.0
const ERROR_LIMIT: float = 0.01
const DISPLAY_HEIGHTS: Array[int] = [48, 64, 80]

@onready var world: Node2D = $World
@onready var actor_a: Node2D = $World/ActorA
@onready var actor_b: Node2D = $World/ActorB
@onready var actor_c: Node2D = $World/ActorC
@onready var pillar: Node2D = $World/Pillar
@onready var safe_frame: Control = $HUD/SafeFrame
@onready var title_label: Label = $HUD/SafeFrame/Title
@onready var crossing_label: Label = $HUD/SafeFrame/CrossingTitle
@onready var decor_label: Label = $HUD/SafeFrame/DecorTitle
@onready var diagnostics: Label = $HUD/SafeFrame/Diagnostics
@onready var pause_button: Button = $HUD/SafeFrame/PauseButton
@onready var size_button: Button = $HUD/SafeFrame/SizeButton
@onready var restart_button: Button = $HUD/SafeFrame/RestartButton
@onready var silhouette_button: Button = $HUD/SafeFrame/SilhouetteButton

var elapsed: float = 0.0
var is_paused: bool = false
var animate_silhouette: bool = false
var max_round_trip_error: float = 0.0
var ground_a: Vector2 = Vector2.ZERO
var ground_b: Vector2 = Vector2.ZERO
var ground_c: Vector2 = Vector2.ZERO
var sprite_a: Sprite2D
var sprite_b: Sprite2D
var sprite_c: Sprite2D
var size_index: int = 0
var safe_rect := Rect2()


func _ready() -> void:
	sprite_a = _add_sprite(actor_a, ACTOR_TEXTURE, Color("63d8e5"))
	sprite_b = _add_sprite(actor_b, ACTOR_TEXTURE, Color("ffbc70"))
	_add_sprite(pillar, DECOR_TEXTURE, Color.WHITE)
	sprite_c = _add_sprite(actor_c, ACTOR_TEXTURE, Color("b9a0ff"))
	for actor in [actor_a, actor_b, actor_c, pillar]:
		_add_foot_marker(actor)
	max_round_trip_error = _check_projection()
	pause_button.pressed.connect(_toggle_pause)
	size_button.pressed.connect(_cycle_size)
	restart_button.pressed.connect(_restart_cycle)
	silhouette_button.pressed.connect(_toggle_silhouette)
	_update_layout()
	_update_scene()
	get_viewport().size_changed.connect(_update_layout)
	# Native safe-area metrics can arrive after the first ready notification.
	call_deferred("_update_layout")


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		is_paused = true
	if what == NOTIFICATION_APPLICATION_RESUMED and is_node_ready():
		call_deferred("_update_layout")


func _toggle_pause() -> void:
	is_paused = not is_paused
	_update_scene()


func _cycle_size() -> void:
	size_index = (size_index + 1) % DISPLAY_HEIGHTS.size()
	_update_scene()


func _restart_cycle() -> void:
	elapsed = 0.0
	_update_scene()


func _toggle_silhouette() -> void:
	animate_silhouette = not animate_silhouette
	_update_scene()


func _update_layout() -> void:
	var visible_rect: Rect2 = get_viewport_rect()
	safe_rect = visible_rect
	if OS.get_name() == "Android":
		var native_safe := Rect2(DisplayServer.get_display_safe_area())
		var to_viewport: Transform2D = get_viewport().get_screen_transform().affine_inverse()
		var converted: Rect2 = to_viewport * native_safe
		var clipped: Rect2 = converted.intersection(visible_rect)
		if clipped.has_area():
			safe_rect = clipped
	safe_frame.position = safe_rect.position
	safe_frame.size = safe_rect.size
	var width: float = safe_rect.size.x
	var height: float = safe_rect.size.y
	title_label.position = Vector2(20, 16)
	title_label.size = Vector2(width - 40, 62)
	crossing_label.position = Vector2(20, 78)
	decor_label.position = Vector2(20, 338)
	diagnostics.position = Vector2(20, height - 264)
	diagnostics.size = Vector2(width - 40, 116)
	var button_width: float = (width - 52.0) * 0.5
	pause_button.position = Vector2(20, height - 140)
	size_button.position = Vector2(32 + button_width, height - 140)
	restart_button.position = Vector2(20, height - 72)
	silhouette_button.position = Vector2(32 + button_width, height - 72)
	for button in [pause_button, size_button, restart_button, silhouette_button]:
		button.size = Vector2(button_width, 60)
	world.position = safe_rect.position + Vector2(width * 0.5, 420)
	_update_scene()


func _physics_process(delta: float) -> void:
	if not is_paused:
		elapsed = fposmod(elapsed + delta, CYCLE_SECONDS)
	_update_scene()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_SPACE:
			_toggle_pause()
		KEY_R:
			_restart_cycle()
		KEY_T:
			_toggle_silhouette()
		KEY_S:
			_cycle_size()
		_:
			return
	_update_scene()
	get_viewport().set_input_as_handled()


func _add_sprite(parent: Node2D, texture: Texture2D, tint: Color) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = "Visual"
	sprite.centered = false
	sprite.modulate = tint
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_set_texture_at_feet(sprite, texture)
	parent.add_child(sprite)
	return sprite


func _set_texture_at_feet(sprite: Sprite2D, texture: Texture2D) -> void:
	if sprite.texture == texture:
		return
	sprite.texture = texture
	# The bottom-center pixel is the shared anchor, including the tall frame.
	sprite.offset = Vector2(-texture.get_width() * 0.5, -texture.get_height())


func _add_foot_marker(parent: Node2D) -> void:
	var marker := Line2D.new()
	marker.name = "FootMarker"
	marker.width = 2.0
	marker.default_color = Color("f6f5df")
	marker.points = PackedVector2Array([
		Vector2(-5, 0), Vector2(5, 0), Vector2.ZERO,
		Vector2(0, -4), Vector2(0, 4)
	])
	parent.add_child(marker)


func _update_scene() -> void:
	# Constant ground speed on each leg; immediate reversal is diagnostic only.
	var phase: float = elapsed / CYCLE_SECONDS
	var progress: float = phase * 2.0 if phase < 0.5 else (1.0 - phase) * 2.0
	var travel: float = lerpf(-HALF_TRAVEL, HALF_TRAVEL, progress)
	ground_a = CROSS_CENTER + Vector2(travel - 4.0, travel + 4.0)
	ground_b = CROSS_CENTER + Vector2(-travel + 4.0, -travel - 4.0)
	ground_c = DECOR_CENTER + Vector2(travel + 5.0, travel - 5.0)
	actor_a.position = GroundProjection.ground_to_screen(ground_a)
	actor_b.position = GroundProjection.ground_to_screen(ground_b)
	actor_c.position = GroundProjection.ground_to_screen(ground_c)
	pillar.position = GroundProjection.ground_to_screen(DECOR_CENTER)
	var use_tall: bool = animate_silhouette and int(elapsed / 2.0) % 2 == 1
	var texture: Texture2D = TALL_TEXTURE if use_tall else ACTOR_TEXTURE
	_set_texture_at_feet(sprite_a, texture)
	_set_texture_at_feet(sprite_c, texture)
	var visual_scale: float = float(DISPLAY_HEIGHTS[size_index]) / 48.0
	for sprite in [sprite_a, sprite_b, sprite_c]:
		sprite.scale = Vector2.ONE * visual_scale
	pause_button.text = "Reprendre" if is_paused else "Pause"
	size_button.text = "Taille : %d px" % DISPLAY_HEIGHTS[size_index]
	silhouette_button.text = "Silhouette : oui" if animate_silhouette else "Silhouette : non"
	_update_diagnostics(use_tall)
	queue_redraw()


func _update_diagnostics(use_tall: bool) -> void:
	var result: String = "OK" if max_round_trip_error < ERROR_LIMIT else "ECHEC"
	var state: String = "PAUSE" if is_paused else "EN MARCHE"
	var silhouette: String = "haute" if use_tall else "normale"
	diagnostics.text = (
		"%s | %.1f s | %d px ref. (%s)\n" % [state, elapsed, DISPLAY_HEIGHTS[size_index], silhouette]
		+ "Projection/inverse : %s (erreur %.6f)\n" % [result, max_round_trip_error]
		+ "A sol : (%.1f, %.1f)\n" % [ground_a.x, ground_a.y]
		+ "A ecran : (%.1f, %.1f)\n" % [actor_a.global_position.x, actor_a.global_position.y]
		+ "FPS indicatifs : %d | zone %.0f x %.0f" % [Engine.get_frames_per_second(), safe_rect.size.x, safe_rect.size.y]
	)


func _check_projection() -> float:
	var largest_error: float = 0.0
	var points: Array[Vector2] = [
		Vector2.ZERO, Vector2(100, 0), Vector2(0, 100),
		Vector2(-140, -140), Vector2(130, 40),
		Vector2(-23.75, 81.125), Vector2(900, -1200)
	]
	for origin in [Vector2.ZERO, Vector2(270, 430)]:
		for ground in points:
			var screen: Vector2 = GroundProjection.ground_to_screen(ground, origin)
			var restored: Vector2 = GroundProjection.screen_to_ground(screen, origin)
			largest_error = maxf(largest_error, ground.distance_to(restored))
	var known_screen: Vector2 = GroundProjection.ground_to_screen(Vector2(100, 0))
	largest_error = maxf(largest_error, known_screen.distance_to(Vector2(100, 50)))
	if largest_error >= ERROR_LIMIT:
		push_error("STEP-003: projection error exceeds 0.01 ground units.")
	print("STEP-003 projection max error: ", largest_error)
	return largest_error


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("111b29"))
	_draw_ground_patch(CROSS_CENTER)
	_draw_ground_patch(DECOR_CENTER)
	_draw_ground_line(CROSS_CENTER + Vector2(-HALF_TRAVEL, -HALF_TRAVEL),
		CROSS_CENTER + Vector2(HALF_TRAVEL, HALF_TRAVEL), Color("526579"))
	_draw_ground_line(DECOR_CENTER + Vector2(-HALF_TRAVEL, -HALF_TRAVEL),
		DECOR_CENTER + Vector2(HALF_TRAVEL, HALF_TRAVEL), Color("526579"))


func _draw_ground_patch(center: Vector2) -> void:
	var points := PackedVector2Array()
	for corner in [Vector2(-90, -90), Vector2(90, -90),
		Vector2(90, 90), Vector2(-90, 90)]:
		points.append(GroundProjection.ground_to_screen(center + corner, world.position))
	draw_colored_polygon(points, Color("1d3043"))
	points.append(points[0])
	draw_polyline(points, Color("3a536b"), 2.0, true)
	_draw_ground_line(center, center + Vector2(60, 0), Color("e19b62"))
	_draw_ground_line(center, center + Vector2(0, 60), Color("63bdc8"))


func _draw_ground_line(start: Vector2, end: Vector2, color: Color) -> void:
	draw_line(GroundProjection.ground_to_screen(start, world.position),
		GroundProjection.ground_to_screen(end, world.position), color, 1.0, true)
