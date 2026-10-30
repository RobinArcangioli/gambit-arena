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

static func editor_theme(base:Theme=null,accent:Color=Color("d9aa4c"),panel_color:Color=Color("10182f")) -> Theme:
	var result: Theme = (preload("res://resources/ui/night_gold.tres") if base==null else base).duplicate(true)
	for state in ["normal","hover","pressed","disabled","focus"]:
		var style := result.get_stylebox(state,"Button").duplicate() as StyleBoxFlat
		style.content_margin_left = 7;style.content_margin_right = 7
		result.set_stylebox(state,"Button",style)
		var option := style.duplicate() as StyleBoxFlat;option.content_margin_right = 23
		result.set_stylebox(state,"OptionButton",option)
	for key in ["font_color","font_hover_color","font_focus_color","font_pressed_color","font_disabled_color"]:
		result.set_color(key,"OptionButton",result.get_color(key,"Button"))
	result.set_color("arrow_color","OptionButton",accent)
	var panel := result.get_stylebox("normal","Button").duplicate() as StyleBoxFlat
	panel.bg_color = panel_color;panel.content_margin_top = 8;panel.content_margin_bottom = 8
	result.set_stylebox("panel","PopupMenu",panel)
	result.set_stylebox("hover","PopupMenu",result.get_stylebox("hover","Button"))
	result.set_color("font_color","PopupMenu",result.get_color("font_color","Button"))
	result.set_color("font_hover_color","PopupMenu",result.get_color("font_pressed_color","Button"))
	result.set_constant("v_separation","PopupMenu",24)
	result.set_font_size("font_size","PopupMenu",18)
	for state in ["scroll","grabber","grabber_highlight","grabber_pressed"]:
		var bar := StyleBoxFlat.new();bar.set_corner_radius_all(4)
		bar.bg_color = Color(panel_color,.6) if state=="scroll" else Color("8e754c") if state=="grabber" and (base==null or base==preload("res://resources/ui/night_gold.tres")) else accent.darkened(.25) if state=="grabber" else accent
		bar.content_margin_left=4;bar.content_margin_right=4;bar.content_margin_top=4;bar.content_margin_bottom=4
		result.set_stylebox(state,"VScrollBar",bar)
	result.set_icon("radio_checked","PopupMenu",_radio(true,accent,result.get_color("font_pressed_color","Button")))
	result.set_icon("radio_unchecked","PopupMenu",_radio(false,accent,result.get_color("font_pressed_color","Button")))
	return result

static func _radio(checked: bool,accent:Color=Color("d9aa4c"),fill:Color=Color("ffd68a")) -> Texture2D:
	var svg: String = '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"><circle cx="9" cy="9" r="6" fill="none" stroke="#d9aa4c" stroke-width="1.5" opacity="%s"/>%s</svg>' % ["1" if checked else "0.5",'<circle cx="9" cy="9" r="3" fill="#ffd68a"/>' if checked else ""]
	svg=svg.replace("#d9aa4c","#"+accent.to_html(false)).replace("#ffd68a","#"+fill.to_html(false))
	var image := Image.new();image.load_svg_from_string(svg)
	return ImageTexture.create_from_image(image)
