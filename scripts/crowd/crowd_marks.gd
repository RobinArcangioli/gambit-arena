extends Node2D
const GroundCrowd = preload("res://scripts/crowd/ground_crowd.gd")
var camera: Camera3D
var points: Array[Vector2] = []

func _draw() -> void:
	if not is_instance_valid(camera):
		return
	for index in range(points.size()):
		var outline := PackedVector2Array()
		for segment in range(33):
			var angle: float = TAU * float(segment) / 32.0
			var ground: Vector2 = points[index] + Vector2(cos(angle), sin(angle)) * GroundCrowd.RADIUS
			outline.append(camera.unproject_position(Vector3(ground.x, 0, ground.y)))
		draw_polyline(outline, Color("66e9ee") if index == 0 else Color("ffc18b"), 1.2, true)
