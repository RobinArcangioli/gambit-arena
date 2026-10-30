extends "res://scripts/app/hero_page.gd"
signal hero_requested
const Editor = preload("res://scripts/gambits/orders_editor.gd")
var save_path: String = "user://party_rules_v2.json"
var editor: Editor
func _ready() -> void:
	super._ready()
	editor.apply_palette(appearance.palette,appearance.editor_accent,appearance.editor_background)
	theme = editor.theme
	back_button.text = "‹ Fiche"
	title.text = "Gambits · "+reference.get("name","")
	title.add_theme_font_size_override("font_size",22)
	team_requested.connect(func():
		if active:hero_requested.emit())
	touch_router.active_scrollers = func():return [scroll] if active and is_visible_in_tree() and not editor.popup_open() else []
func _build_reference() -> void:
	_label(column,"Priorité de haut en bas · Allié inclut le héros",16)
	editor = Editor.new();editor.hero_id = hero_id;editor.icon_style = icon_style;editor.save_path = save_path;column.add_child(editor)
func set_active(enabled: bool) -> void:
	super.set_active(enabled)
	if editor!=null:editor.set_active(enabled)

func _layout() -> void:
	super._layout()
	if content==null:return
	if content.size.x<450:
		scroll.position.x=12;scroll.size.x=content.size.x-24
		title.add_theme_font_size_override("font_size",18)
	title.clip_text=true
