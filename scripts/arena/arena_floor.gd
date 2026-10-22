extends Node2D
## 2D arena artwork aligned to the fixed 3D camera. No collision geometry.
const ArenaBounds = preload("res://scripts/arena/arena_bounds.gd")
var camera: Camera3D
var view_size := Vector2(508, 572)
var show_marks: bool = false
var feet: Array[Vector3] = []

func _project(point: Vector2) -> Vector2:
	return camera.unproject_position(Vector3(point.x, 0, point.y))

func _square(half_extent: float) -> PackedVector2Array:
	return PackedVector2Array([_project(Vector2(-half_extent, -half_extent)),
		_project(Vector2(half_extent, -half_extent)), _project(Vector2(half_extent, half_extent)),
		_project(Vector2(-half_extent, half_extent))])

func _outline(points: PackedVector2Array, color: Color, width: float) -> void:
	var loop: PackedVector2Array = points.duplicate()
	loop.append(points[0])
	draw_polyline(loop, color, width, true)

func _draw() -> void:
	if not is_instance_valid(camera):
		return
	draw_rect(Rect2(Vector2.ZERO, view_size), Color("14212a"))
	draw_colored_polygon(_square(ArenaBounds.HALF_EXTENT + 0.3), Color("827257"))
	draw_colored_polygon(_square(ArenaBounds.HALF_EXTENT + 0.15), Color("263c42"))
	for x in range(-3, 3):
		for z in range(-3, 3):
			var tile := PackedVector2Array([_project(Vector2(x, z)), _project(Vector2(x + 1, z)),
				_project(Vector2(x + 1, z + 1)), _project(Vector2(x, z + 1))])
			var color := Color("385451") if (x + z) % 2 == 0 else Color("3c5956")
			draw_colored_polygon(tile, color)
			_outline(tile, Color("304944"), 1.0)
	_outline(_square(ArenaBounds.HALF_EXTENT), Color("dabf80"), 2.0)
	# Flat ornamental inlay at the center; no blocking prop over the playfield.
	_outline(_square(0.42), Color("8fa68c"), 2.0)
	for edge in [Vector2(-3.15, 0), Vector2(3.15, 0), Vector2(0, -3.15), Vector2(0, 3.15)]:
		var point: Vector2 = _project(edge)
		draw_circle(point, 5, Color("d6b678"))
	if show_marks:
		_outline(_square(ArenaBounds.HALF_EXTENT - ArenaBounds.ACTOR_MARGIN), Color("78d0d2"), 1.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(1, 0)), Color("f3bd67"), 2.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(0, 1)), Color("77c9ef"), 2.0)
		for foot in feet:
			var point: Vector2 = camera.unproject_position(foot)
			draw_line(point - Vector2(5, 0), point + Vector2(5, 0), Color("fff2bb"), 1.5)
			draw_line(point - Vector2(0, 4), point + Vector2(0, 4), Color("fff2bb"), 1.5)
