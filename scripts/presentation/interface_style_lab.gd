extends "res://scripts/app/app_root.gd"
## Visual comparison only: genuine app routes with in-memory preferences/rules/team.
const ICONS=[preload("res://assets/ui/appearance_eclipse.svg"),preload("res://assets/ui/appearance_crystal.svg"),preload("res://assets/ui/appearance_palette.svg")]
var choices_panel:PanelContainer
var style_caption:Label
func _ready() -> void:
	save_path="";appearance_path="";super._ready()
	DisplayServer.window_set_title("Gambit Arena · Arcane / Berserk · Icônes")
	var overlay:=CanvasLayer.new();overlay.layer=100;add_child(overlay)
	choices_panel=PanelContainer.new();overlay.add_child(choices_panel)
	var box:=StyleBoxFlat.new();box.bg_color=Color("090b12ed");box.content_margin_left=10;box.content_margin_right=10;box.content_margin_top=6;box.content_margin_bottom=6
	choices_panel.add_theme_stylebox_override("panel",box)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",3);choices_panel.add_child(column)
	style_caption=Label.new();style_caption.add_theme_font_size_override("font_size",13);column.add_child(style_caption)
	var row:=HBoxContainer.new();column.add_child(row)
	for i in range(3):
		var button:=Button.new();button.text=["A · Éclipse","B · Cristal / braise","C · Palette"][i];button.icon=ICONS[i]
		button.add_theme_font_size_override("font_size",14);button.custom_minimum_size.y=38;button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		button.pressed.connect(choose_icon.bind(i));row.add_child(button)
	var pages:=HBoxContainer.new();column.add_child(pages)
	for item in [["Accueil",&"home"],["Équipe",&"team"],["Fiche",&"hero"],["Gambits",&"gambits"]]:
		var button:=Button.new();button.text=item[0];button.add_theme_font_size_override("font_size",13);button.custom_minimum_size.y=32
		button.size_flags_horizontal=Control.SIZE_EXPAND_FILL;button.pressed.connect(preview_page.bind(item[1]));pages.add_child(button)
	appearance_changed.connect(_refresh_caption);_refresh_caption(interface_style.id)
	get_viewport().size_changed.connect(_place_choices);_place_choices()
func choose_icon(index:int) -> void:set_switch_icon(ICONS[index])
func _place_choices() -> void:
	choices_panel.position=Vector2(12,get_viewport_rect().size.y-124);choices_panel.size=Vector2(get_viewport_rect().size.x-24,112)
func _refresh_caption(_id:StringName) -> void:
	style_caption.text="Style "+interface_style.display_name+" · Bouton en haut à droite pour basculer"
func preview_page(destination:StringName) -> void:
	if guard.blocked or transitioning:return
	if route!=&"home":return_home();await get_tree().process_frame;await get_tree().process_frame
	if destination==&"home":return
	open_team();await get_tree().process_frame;await get_tree().process_frame
	if destination==&"team":return
	_select_team_hero(&"mako");await get_tree().process_frame;await get_tree().process_frame
	if destination==&"gambits":open_gambits()
