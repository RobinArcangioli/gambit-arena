extends Node2D
## Developer overlay: the actual logical 8x8 terrain projected by the game camera.
var game
func _process(_delta:float) -> void:queue_redraw()
func _draw() -> void:
	if not is_instance_valid(game) or not is_instance_valid(game.camera):return
	var bounds=preload("res://scripts/arena/arena_bounds.gd")
	for segment in bounds.grid_segments():draw_line(_at(segment[0]),_at(segment[1]),Color(.35,.95,1,.65),1)
	var corners:=PackedVector2Array()
	for point in bounds.polygon():corners.append(_at(point))
	corners.append(corners[0])
	draw_polyline(corners,Color("ffd16a"),2);draw_circle(_at(Vector2.ZERO),3,Color("ffd16a"))
	for unit in game.simulation.all_units():draw_circle(_at(unit.mover.ground_position),3,Color.WHITE)
func _at(point:Vector2) -> Vector2:return game.render_box.position+game.camera.unproject_position(Vector3(point.x,0,point.y))
