extends Node2D
## Common presentation interface; receives projection, never simulation references.
var camera: Camera3D
var view_size := Vector2.ONE

func sync_projection(source_camera: Camera3D, size_value: Vector2) -> void:
	camera = source_camera
	view_size = size_value
	queue_redraw()

func project_ground(point: Vector2) -> Vector2:
	return camera.unproject_position(Vector3(point.x, 0, point.y))
