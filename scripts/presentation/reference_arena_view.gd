extends "res://scripts/presentation/arena_view.gd"
## Original procedural floor, extracted without altering its geometry or palette.
const Bounds = preload("res://scripts/arena/arena_bounds.gd")

func _square(extent: float) -> PackedVector2Array:
	return PackedVector2Array([project_ground(Vector2(-extent, -extent)),
		project_ground(Vector2(extent, -extent)), project_ground(Vector2(extent, extent)),
		project_ground(Vector2(-extent, extent))])

func _outline(points: PackedVector2Array, tint: Color, width: float) -> void:
	var loop: PackedVector2Array = points.duplicate()
	loop.append(points[0])
	draw_polyline(loop, tint, width, true)

func _draw() -> void:
	if not is_instance_valid(camera):
		return
	draw_rect(Rect2(Vector2.ZERO, view_size), Color("14212a"))
	draw_colored_polygon(_square(Bounds.HALF_EXTENT + 0.3), Color("827257"))
	draw_colored_polygon(_square(Bounds.HALF_EXTENT + 0.15), Color("263c42"))
	for x in range(-3, 3):
		for z in range(-3, 3):
			var tile := PackedVector2Array([project_ground(Vector2(x, z)), project_ground(Vector2(x + 1, z)),
				project_ground(Vector2(x + 1, z + 1)), project_ground(Vector2(x, z + 1))])
			draw_colored_polygon(tile, Color("385451") if (x + z) % 2 == 0 else Color("3c5956"))
			_outline(tile, Color("304944"), 1.0)
	_outline(_square(Bounds.HALF_EXTENT), Color("dabf80"), 2.0)
	_outline(_square(0.42), Color("8fa68c"), 2.0)
	for edge in [Vector2(-3.15, 0), Vector2(3.15, 0), Vector2(0, -3.15), Vector2(0, 3.15)]:
		draw_circle(project_ground(edge), 5, Color("d6b678"))
