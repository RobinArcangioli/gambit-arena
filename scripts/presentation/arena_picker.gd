extends ColorRect
## Presentation-only menu. Its owner controls pause, lifecycle and the chosen view.
signal arena_selected(arena_id: StringName)
signal close_requested
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
var scroll: ScrollContainer
var content: VBoxContainer
var heading: Label
var close_button: Button
var cards: Dictionary = {}
var captions: Dictionary = {}
var selected_id: StringName = &"colisee_solaire"

func _ready() -> void:
	color = Color("142736")
	mouse_filter = Control.MOUSE_FILTER_STOP
	heading = Label.new()
	heading.text = "Choisir l'arene"
	heading.add_theme_font_size_override("font_size", 22)
	heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(heading)
	scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.scroll_deadzone = 12
	add_child(scroll)
	content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)
	for arena_id in Catalog.ids():
		var button := Button.new()
		button.custom_minimum_size.y = 132
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.pressed.connect(_emit_selection.bind(arena_id))
		content.add_child(button)
		cards[arena_id] = button
		var thumbnail := TextureRect.new()
		thumbnail.texture = Catalog.preview(arena_id)
		thumbnail.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		thumbnail.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		thumbnail.position = Vector2(10, 8)
		thumbnail.size = Vector2(64, 114)
		thumbnail.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(thumbnail)
		var caption := Label.new()
		caption.position = Vector2(84, 12)
		caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		caption.offset_left = 84
		caption.offset_top = 12
		caption.offset_right = -12
		caption.offset_bottom = -12
		caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		caption.add_theme_font_size_override("font_size", 18)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(caption)
		captions[arena_id] = caption
	close_button = Button.new()
	close_button.text = "Fermer / rester en pause"
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.pressed.connect(_request_close)
	add_child(close_button)
	resized.connect(_layout)
	mark_selected(selected_id)
	_layout()

func mark_selected(arena_id: StringName) -> void:
	selected_id = arena_id
	for choice in captions:
		captions[choice].text = "%s%s" % [Catalog.title(choice), "\nSelectionnee" if choice == selected_id else ""]

func _emit_selection(arena_id: StringName) -> void:
	arena_selected.emit(arena_id)

func _request_close() -> void:
	close_requested.emit()

func _layout() -> void:
	if scroll == null:
		return
	heading.position = Vector2(12, 12)
	heading.size = Vector2(size.x - 24, 36)
	scroll.position = Vector2(12, 60)
	scroll.size = Vector2(maxf(1, size.x - 24), maxf(1, size.y - 140))
	close_button.position = Vector2(12, maxf(60, size.y - 68))
	close_button.size = Vector2(maxf(1, size.x - 24), 52)
