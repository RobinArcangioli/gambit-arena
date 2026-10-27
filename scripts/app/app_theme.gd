extends RefCounted
## Shared art factory. Serialized in resources/ui/night_gold.tres for easy replacement.
static func make() -> Theme:
	var result := Theme.new()
	result.default_font_size = 18
	var colors := {"normal": Color(0.063,0.094,0.184,0.94), "hover": Color(0.09,0.17,0.30,0.97), "pressed": Color(0.39,0.22,0.10,0.96), "disabled": Color(0.063,0.094,0.184,0.78), "focus": Color(0.10,0.18,0.31,0.98)}
	for state in colors:
		var box := StyleBoxFlat.new()
		box.bg_color = colors[state]
		box.border_color = Color("d9aa4c") if state != "disabled" else Color("766c57")
		box.set_border_width_all(2 if state in ["focus", "pressed"] else 1)
		box.set_corner_radius_all(10)
		box.content_margin_left = 14; box.content_margin_right = 14
		box.content_margin_top = 8; box.content_margin_bottom = 8
		box.shadow_color = Color(0.015,0.02,0.04,0.45);box.shadow_size = 3
		result.set_stylebox(state,"Button",box)
	for key in ["font_color","font_hover_color","font_focus_color"]:result.set_color(key,"Button",Color("fff2d4"))
	result.set_color("font_pressed_color","Button",Color("ffd68a"))
	result.set_color("font_disabled_color","Button",Color("a29a86"))
	result.set_color("font_color","Label",Color("fff2d4"))
	result.set_color("font_outline_color","Label",Color("10182f"))
	result.set_constant("outline_size","Label",4)
	return result
