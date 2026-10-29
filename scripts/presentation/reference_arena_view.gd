extends "res://scripts/presentation/arena_view.gd"
## Diagnostic rendition of the same shared combat octagon.
const Bounds=preload("res://scripts/arena/arena_bounds.gd")
func _outline(points:PackedVector2Array,tint:Color,width:float) -> void:
	var loop:PackedVector2Array=points.duplicate();loop.append(points[0]);draw_polyline(loop,tint,width,true)
func _polygon(margin:float=0) -> PackedVector2Array:
	var points:=PackedVector2Array()
	for point in Bounds.polygon(margin):points.append(project_ground(point))
	return points
func _draw() -> void:
	if not is_instance_valid(camera):return
	draw_rect(Rect2(Vector2.ZERO,view_size),Color("14212a"))
	draw_colored_polygon(_polygon(-.3),Color("827257"))
	draw_colored_polygon(_polygon(-.15),Color("263c42"))
	draw_colored_polygon(_polygon(),Color("385451"))
	for segment in Bounds.grid_segments():draw_line(project_ground(segment[0]),project_ground(segment[1]),Color("304944"),1,true)
	_outline(_polygon(),Color("dabf80"),2)
