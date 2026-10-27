extends Button
## Vector icons keep chevrons, check and trash legible on every Android font.
var symbol: String
var enabled_order: bool = true
func _draw() -> void:
	var c := size * 0.5
	var ink := Color("d9aa4c")
	if disabled:ink.a = 0.35
	match symbol:
		"up", "down":
			var d: float = -1 if symbol=="up" else 1
			draw_polyline(PackedVector2Array([c+Vector2(-5,-3*d),c+Vector2(0,3*d),c+Vector2(5,-3*d)]),ink,2,true)
		"enabled":
			ink = Color("68dc9a") if enabled_order else Color("ef7c7c")
			if disabled:ink.a=0.35
			draw_style_box(_square(ink),Rect2(c-Vector2(10,10),Vector2(20,20)))
			if enabled_order:draw_polyline(PackedVector2Array([c+Vector2(-6,0),c+Vector2(-2,4),c+Vector2(6,-5)]),ink,2,true)
			else:
				draw_line(c-Vector2(5,5),c+Vector2(5,5),ink,2,true)
				draw_line(c+Vector2(-5,5),c+Vector2(5,-5),ink,2,true)
		"delete":
			draw_line(c+Vector2(-5,-4),c+Vector2(-4,7),ink,2,true)
			draw_line(c+Vector2(5,-4),c+Vector2(4,7),ink,2,true)
			draw_line(c+Vector2(-4,7),c+Vector2(4,7),ink,2,true)
			draw_line(c+Vector2(-7,-7),c+Vector2(7,-7),ink,2,true)
			draw_line(c+Vector2(-2,-10),c+Vector2(2,-10),ink,2,true)
func _square(ink: Color) -> StyleBoxFlat:
	var box:=StyleBoxFlat.new();box.bg_color=Color(0,0,0,0)
	box.border_color=ink;box.set_border_width_all(1);box.set_corner_radius_all(4);return box
