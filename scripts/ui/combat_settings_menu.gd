extends PanelContainer
signal display_changed(hero_bars: bool, enemy_bars: bool)
signal text_display_changed(outgoing:bool,incoming:bool,healing:bool)
signal closed
var bars_box: CheckBox
var enemy_bars_box: CheckBox
var outgoing_box:CheckBox
var incoming_box:CheckBox
var healing_box:CheckBox
var scroller:ScrollContainer
var options:VBoxContainer
var ok_button: Button
var status: Label
func _ready() -> void:
	var style:=get_theme_stylebox("normal","Button").duplicate() as StyleBoxFlat
	style.bg_color.a=0.72;style.set_corner_radius_all(8);style.border_color=Color("a68349")
	add_theme_stylebox_override("panel",style)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",8);add_child(column)
	var title:=Label.new();title.text="Réglages de combat";title.add_theme_font_size_override("font_size",18);title.add_theme_color_override("font_color",Color("ffd16a"));column.add_child(title)
	scroller=ScrollContainer.new();scroller.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;scroller.size_flags_vertical=Control.SIZE_EXPAND_FILL;column.add_child(scroller)
	options=VBoxContainer.new();options.size_flags_horizontal=Control.SIZE_EXPAND_FILL;options.add_theme_constant_override("separation",8);scroller.add_child(options)
	bars_box=_checkbox(options,"Afficher les barres des héros
PV / PM / Incantation")
	enemy_bars_box=_checkbox(options,"Afficher les barres des ennemis\nPV / PM / Incantation")
	var group_panel:=PanelContainer.new();options.add_child(group_panel)
	var group_style:=StyleBoxFlat.new();group_style.bg_color=Color(0,0,0,.25);group_style.set_corner_radius_all(6);group_style.set_content_margin_all(8);group_panel.add_theme_stylebox_override("panel",group_style)
	var group:=VBoxContainer.new();group.add_theme_constant_override("separation",2);group_panel.add_child(group)
	var section:=Label.new();section.text="Textes flottants";section.custom_minimum_size.y=22;section.add_theme_font_size_override("font_size",14);section.add_theme_color_override("font_color",Color("ffd16a"));group.add_child(section)
	outgoing_box=_checkbox(group,"Dégâts infligés")
	incoming_box=_checkbox(group,"Dégâts reçus")
	healing_box=_checkbox(group,"Soins")
	for box in [outgoing_box,incoming_box,healing_box]:box.custom_minimum_size.y=32
	for box in [outgoing_box,incoming_box,healing_box]:box.toggled.connect(_texts_changed)
	status=Label.new();status.add_theme_font_size_override("font_size",12);status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;status.hide();column.add_child(status)
	ok_button=Button.new();ok_button.text="OK";ok_button.custom_minimum_size=Vector2(56,44);ok_button.size_flags_horizontal=Control.SIZE_SHRINK_CENTER;column.add_child(ok_button)
	bars_box.toggled.connect(_changed);enemy_bars_box.toggled.connect(_changed);ok_button.pressed.connect(func():closed.emit())
func _checkbox(parent: Node, caption: String) -> CheckBox:
	var box:=CheckBox.new();box.text=caption;box.custom_minimum_size.y=44
	box.add_theme_font_size_override("font_size",14)
	for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:box.add_theme_color_override(state,Color("fff2d4"))
	box.add_theme_icon_override("checked",preload("res://assets/ui/settings_checked.svg"))
	box.add_theme_icon_override("unchecked",preload("res://assets/ui/settings_unchecked.svg"))
	for state in ["normal","hover","pressed","disabled"]:box.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	var focus:=StyleBoxFlat.new();focus.bg_color=Color(0,0,0,0)
	focus.border_color=Color("d9aa4c");focus.set_border_width_all(1);focus.set_corner_radius_all(4)
	box.add_theme_stylebox_override("focus",focus)
	parent.add_child(box);return box
func reflect(hero_bars: bool, enemy_bars: bool, outgoing:bool=true,incoming:bool=true,healing:bool=true) -> void:
	bars_box.set_pressed_no_signal(hero_bars);enemy_bars_box.set_pressed_no_signal(enemy_bars)
	outgoing_box.set_pressed_no_signal(outgoing);incoming_box.set_pressed_no_signal(incoming);healing_box.set_pressed_no_signal(healing)
func _changed(_value: bool) -> void:display_changed.emit(bars_box.button_pressed,enemy_bars_box.button_pressed)
func set_blocked(blocked: bool) -> void:
	for button in [bars_box,enemy_bars_box,outgoing_box,incoming_box,healing_box,ok_button]:button.disabled=blocked

func _texts_changed(_value:bool) -> void:text_display_changed.emit(outgoing_box.button_pressed,incoming_box.button_pressed,healing_box.button_pressed)
func preferred_height() -> float:return get_combined_minimum_size().y+options.get_combined_minimum_size().y
