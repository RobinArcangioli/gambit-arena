extends Node2D
## Diagnostic floor overlay only. Never participates in navigation or collisions.
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
var camera: Camera3D
var view_size := Vector2.ONE
var display_size := Vector2.ONE
var obstacles: Array[Vector2] = []
var route: Array[Vector2] = []
var trail: Array[Vector2] = []
var actors: Array[Vector2] = []

func project(point: Vector2) -> Vector2:
	return camera.unproject_position(Vector3(point.x, 0, point.y)) * display_size / view_size

func _draw() -> void:
	if not is_instance_valid(camera): return
	for center in obstacles:
		var shape := PackedVector2Array()
		for i in range(24): shape.append(project(center + Vector2(cos(TAU*i/24), sin(TAU*i/24)) * Crowd.RADIUS))
		draw_colored_polygon(shape, Color(0.55, 0.64, 0.72, 0.3))
		shape.append(shape[0])
		draw_polyline(shape, Color(0.8, 0.88, 0.95, 0.9), 2.0, true)
	for center in actors:
		var shape := PackedVector2Array()
		for i in range(25): shape.append(project(center + Vector2(cos(TAU*i/24), sin(TAU*i/24)) * Crowd.RADIUS))
		draw_polyline(shape, Color(0.9, 0.77, 0.4, 0.6), 1.0, true)
	if trail.size() > 1:
		var points := PackedVector2Array()
		for point in trail: points.append(project(point))
		draw_polyline(points, Color(0.3, 1, 0.65, 0.8), 2.0, true)
	if route.size() > 1:
		var points := PackedVector2Array()
		for point in route:
			var at: Vector2 = project(point)
			points.append(at)
			draw_circle(at, 2.5, Color(0.45, 0.82, 1))
		draw_polyline(points, Color(0.45, 0.82, 1, 0.75), 1.5, true)
