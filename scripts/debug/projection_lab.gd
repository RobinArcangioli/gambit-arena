extends Node2D
## Temporary, scripted diagnostic. This is not the hero movement controller.

const GroundProjection = preload("res://scripts/world/ground_projection.gd")
const ACTOR_TEXTURE: Texture2D = preload("res://assets/debug/actor.svg")
const TALL_TEXTURE: Texture2D = preload("res://assets/debug/actor_tall.svg")
const DECOR_TEXTURE: Texture2D = preload("res://assets/debug/pillar.svg")
const CROSS_CENTER := Vector2(-140.0, -140.0)
const DECOR_CENTER := Vector2(100.0, 100.0)
const HALF_TRAVEL: float = 65.0
const CYCLE_SECONDS: float = 8.0
const ERROR_LIMIT: float = 0.01

@onready var world: Node2D = $World
@onready var actor_a: Node2D = $World/ActorA
@onready var actor_b: Node2D = $World/ActorB
@onready var actor_c: Node2D = $World/ActorC
@onready var pillar: Node2D = $World/Pillar
@onready var diagnostics: Label = $HUD/Diagnostics

var elapsed: float = 0.0
var is_paused: bool = false
var animate_silhouette: bool = true
var max_round_trip_error: float = 0.0
var ground_a: Vector2 = Vector2.ZERO
var ground_b: Vector2 = Vector2.ZERO
var ground_c: Vector2 = Vector2.ZERO
var sprite_a: Sprite2D
var sprite_c: Sprite2D


func _ready() -> void:
	sprite_a = _add_sprite(actor_a, ACTOR_TEXTURE, Color("63d8e5"))
	_add_sprite(actor_b, ACTOR_TEXTURE, Color("ffbc70"))
	_add_sprite(pillar, DECOR_TEXTURE, Color.WHITE)
	sprite_c = _add_sprite(actor_c, ACTOR_TEXTURE, Color("b9a0ff"))
	for actor in [actor_a, actor_b, actor_c, pillar]:
		_add_foot_marker(actor)
	max_round_trip_error = _check_projection()
	_update_scene()
	get_viewport().size_changed.connect(_update_scene)


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
			is_paused = not is_paused
		KEY_R:
			elapsed = 0.0
		KEY_T:
			animate_silhouette = not animate_silhouette
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
	world.position = Vector2(get_viewport_rect().size.x * 0.5, 430.0)
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
	_update_diagnostics(use_tall)
	queue_redraw()


func _update_diagnostics(use_tall: bool) -> void:
	var result: String = "OK" if max_round_trip_error < ERROR_LIMIT else "ECHEC"
	var state: String = "PAUSE" if is_paused else "EN MARCHE"
	var silhouette: String = "haute (80 px)" if use_tall else "normale (48 px)"
	diagnostics.text = (
		"%s | boucle %.1f / 8 s\n" % [state, elapsed]
		+ "Projection/inverse : %s (erreur %.6f)\n" % [result, max_round_trip_error]
		+ "A sol : (%.1f, %.1f)\n" % [ground_a.x, ground_a.y]
		+ "A ecran : (%.1f, %.1f)\n" % [actor_a.global_position.x, actor_a.global_position.y]
		+ "Silhouette : %s\n" % silhouette
		+ "Espace : pause | R : debut | T : silhouette"
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
	_draw_ground_line(CROSS_CENTER + Vector2(-65, -65),
		CROSS_CENTER + Vector2(65, 65), Color("526579"))
	_draw_ground_line(DECOR_CENTER + Vector2(-65, -65),
		DECOR_CENTER + Vector2(65, 65), Color("526579"))


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
