extends "res://scripts/presentation/arena_view.gd"
## Uniform image scale and explicit crop; camera and game coordinates remain unchanged.
@export var background: Texture2D
@export var calibration_overlay: Texture2D
@export var image_center := Vector2(270, 455)
@export var grid_half_size := Vector2(240, 138)
# Presentation frame in logical ground coordinates, not a movement boundary.
@export var framing_half_extent: float = 3.0
@export_range(0.1, 1.0) var framing_fill: float = 0.88
var show_calibration: bool = false
var opaque_backdrop: bool = true
var image_rect := Rect2()

func sync_projection(source_camera: Camera3D, size_value: Vector2) -> void:
	super.sync_projection(source_camera, size_value)
	if not is_instance_valid(camera) or background == null:
		return
	var center: Vector2 = project_ground(Vector2.ZERO)
	var extent := Vector2.ZERO
	for point in [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]:
		var offset: Vector2 = (project_ground(point * framing_half_extent) - center).abs()
		extent = extent.max(offset)
	var scale_factor: float = maxf(extent.x / maxf(1, grid_half_size.x * framing_fill),
		extent.y / maxf(1, grid_half_size.y * framing_fill))
	image_rect = Rect2(center - image_center * scale_factor, background.get_size() * scale_factor)

func ground_to_image(point: Vector2) -> Vector2:
	return (project_ground(point) - image_rect.position) / image_rect.size.x * background.get_width()

func inside_calibration(point: Vector2) -> bool:
	var offset: Vector2 = (ground_to_image(point) - image_center).abs() / grid_half_size
	return offset.x + offset.y <= 1.00001

func _draw_texture_clipped(texture: Texture2D) -> void:
	if texture == null or not image_rect.has_area():
		return
	var clipped: Rect2 = image_rect.intersection(Rect2(Vector2.ZERO, view_size))
	if not clipped.has_area():
		return
	var ratio: Vector2 = texture.get_size() / image_rect.size
	draw_texture_rect_region(texture, clipped, Rect2((clipped.position - image_rect.position) * ratio, clipped.size * ratio))

func _draw() -> void:
	if opaque_backdrop:draw_rect(Rect2(Vector2.ZERO, view_size), Color("14212a"))
	_draw_texture_clipped(background)
	if show_calibration:
		_draw_texture_clipped(calibration_overlay)
