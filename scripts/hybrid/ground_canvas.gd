extends Node2D
## True 2D background. Camera projection only supplies registration coordinates.
var camera: Camera3D
var view_size := Vector2(540, 380)
var show_marks: bool = true
var feet: Array[Vector3] = []

func _project(point: Vector2) -> Vector2:
	return camera.unproject_position(Vector3(point.x, 0, point.y))

func _draw() -> void:
	if not is_instance_valid(camera):
		return
	draw_rect(Rect2(Vector2.ZERO, view_size), Color("142131"))
	for x in range(-3, 3):
		for z in range(-3, 3):
			var tile := PackedVector2Array([
				_project(Vector2(x, z)), _project(Vector2(x + 1, z)),
				_project(Vector2(x + 1, z + 1)), _project(Vector2(x, z + 1))])
			var color := Color("304b55") if (x + z) % 2 == 0 else Color("35545b")
			draw_colored_polygon(tile, color)
	if show_marks:
		for coordinate in range(-3, 4):
			draw_line(_project(Vector2(coordinate, -3)), _project(Vector2(coordinate, 3)), Color("58747b"), 1.0)
			draw_line(_project(Vector2(-3, coordinate)), _project(Vector2(3, coordinate)), Color("58747b"), 1.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(1, 0)), Color("f3bd67"), 2.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(0, 1)), Color("77c9ef"), 2.0)
		for foot in feet:
			var point: Vector2 = camera.unproject_position(foot)
			draw_line(point - Vector2(5, 0), point + Vector2(5, 0), Color("fff2bb"), 1.5)
			draw_line(point - Vector2(0, 4), point + Vector2(0, 4), Color("fff2bb"), 1.5)
