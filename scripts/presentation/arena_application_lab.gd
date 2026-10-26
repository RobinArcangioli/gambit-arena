extends "res://scripts/performance/performance_lab.gd"
## Only the composition/UI layer knows the art catalogue. Combat inherits unchanged.
const ArenaPicker = preload("res://scripts/presentation/arena_picker.gd")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
var arena_picker: ArenaPicker
var arena_menu_ready: bool = false

func _ready() -> void:
	super._ready()
	arena_picker = ArenaPicker.new()
	arena_picker.hide()
	add_child(arena_picker)
	arena_picker.arena_selected.connect(_choose_arena)
	arena_picker.close_requested.connect(_close_arena_picker)
	_menu_button("Choisir l'arene", _open_arena_picker)
	performance_content.move_child(performance_content.get_child(-1), 1)
	arena_menu_ready = true
	move_child(application_guard, get_child_count() - 1)
	_update_layout()

func _update_layout() -> void:
	super._update_layout()
	if arena_menu_ready:
		_rect(arena_picker, safe_rect)

func _touch_scrollers() -> Array[ScrollContainer]:
	if arena_menu_ready and arena_picker.visible:
		return [arena_picker.scroll]
	return super._touch_scrollers()

func _open_arena_picker() -> void:
	if not arena_menu_ready or application_guard.blocked or editing_index >= 0 or capture.busy():
		return
	paused = true
	performance_menu.hide()
	touch_router.cancel_gesture()
	arena_picker.mark_selected(floor_canvas.definition.arena_id)
	arena_picker.show()
	_update_buttons()

func _choose_arena(arena_id: StringName) -> void:
	if application_guard.blocked or not arena_picker.visible or capture.busy():
		return
	if floor_canvas.definition.arena_id != arena_id:
		arena_definition = Catalog.definition(arena_id)
		floor_canvas.set_definition(arena_definition)
		_sync_projection()
	_close_arena_picker()

func _close_arena_picker() -> void:
	arena_picker.hide()
	touch_router.cancel_gesture()
	paused = true
	_update_buttons()

func _toggle_pause() -> void:
	if not arena_menu_ready or not arena_picker.visible:
		super._toggle_pause()

func start_benchmark(choice: String) -> bool:
	if arena_menu_ready and arena_picker.visible:
		return false
	return super.start_benchmark(choice)

func _unhandled_key_input(event: InputEvent) -> void:
	if arena_menu_ready and arena_picker.visible:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_close_arena_picker()
		get_viewport().set_input_as_handled()
		return
	super._unhandled_key_input(event)
