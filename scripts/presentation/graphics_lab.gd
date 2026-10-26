extends "res://scripts/arena/arena.gd"
## Independent visual gallery. No CombatSimulation, exécuteur or gameplay actors.
const REFERENCE = preload("res://resources/presentation/arenas/reference.tres")
const COLISEE = preload("res://resources/presentation/arenas/colisee_solaire.tres")
const IllustratedView = preload("res://scripts/presentation/illustrated_arena_view.gd")
const GalleryLayout = preload("res://scripts/ui/hud_layout.gd")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
const ArenaPicker = preload("res://scripts/presentation/arena_picker.gd")
const Guard = preload("res://scripts/platform/application_guard.gd")
const Router = preload("res://scripts/ui/touch_scroll_router.gd")
var gallery_guard := Guard.new()
var gallery_router := Router.new()
var picker: ArenaPicker
var gallery_ready: bool = false
var calibration_visible: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "GRAPHICS-002 / ARENES"
	$HUD/SlotsTitle.text = "Presentation interchangeable / terrain inchange"
	for slot in slots:
		slot.hide()
	for index in range(3):
		slots[index].show()
		slots[index].disabled = false
	slots[0].text = "Reference"
	slots[0].pressed.connect(select_arena.bind(REFERENCE))
	slots[1].text = "Arenes..."
	slots[1].pressed.connect(_open_picker)
	slots[2].text = "Grille image"
	slots[2].pressed.connect(_toggle_calibration)
	picker = ArenaPicker.new()
	picker.hide()
	add_child(picker)
	picker.arena_selected.connect(_choose_gallery_arena)
	picker.close_requested.connect(_close_picker)
	gallery_router.active_scrollers = _gallery_scrollers
	add_child(gallery_router)
	add_child(gallery_guard)
	gallery_ready = true
	_update_layout()
	select_arena(COLISEE)

func select_arena(choice: ArenaDefinition) -> void:
	if gallery_guard.blocked:
		return
	floor_canvas.set_definition(choice)
	_sync_projection()
	_apply_calibration()
	$HUD/Description.text = "%s\nCamera conservee / image recadree sans deformation" % floor_canvas.definition.display_name

func _toggle_calibration() -> void:
	calibration_visible = not calibration_visible
	_apply_calibration()

func _apply_calibration() -> void:
	if floor_canvas.active_view is IllustratedView:
		floor_canvas.active_view.show_calibration = calibration_visible
		floor_canvas.active_view.queue_redraw()
	if gallery_ready:
		slots[2].text = "Grille %s" % ("oui" if calibration_visible else "non")
		slots[2].disabled = not floor_canvas.active_view is IllustratedView

func _open_picker() -> void:
	if gallery_guard.blocked:
		return
	paused = true
	gallery_router.cancel_gesture()
	picker.mark_selected(floor_canvas.definition.arena_id)
	picker.show()
	_update_buttons()

func _choose_gallery_arena(arena_id: StringName) -> void:
	if gallery_guard.blocked or not picker.visible:
		return
	select_arena(Catalog.definition(arena_id))
	_close_picker()

func _close_picker() -> void:
	picker.hide()
	gallery_router.cancel_gesture()
	_update_buttons()

func _gallery_scrollers() -> Array[ScrollContainer]:
	return [picker.scroll] if gallery_ready and picker.visible else []

func _update_layout() -> void:
	super._update_layout()
	if gallery_ready:
		picker.position = safe_rect.position
		picker.size = safe_rect.size

func _toggle_pause() -> void:
	if gallery_guard.blocked or (gallery_ready and picker.visible):
		return
	super._toggle_pause()
	if not paused:
		gallery_guard.acknowledge_resume()

func _notification(what: int) -> void:
	if not is_instance_valid(gallery_guard):
		return
	if gallery_guard.observe(what) and gallery_guard.resume_required:
		paused = true
		if gallery_ready:
			gallery_router.notification(what)
			_update_buttons()

func _unhandled_key_input(event: InputEvent) -> void:
	if gallery_ready and picker.visible:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_close_picker()
		get_viewport().set_input_as_handled()
		return
	super._unhandled_key_input(event)

func _sync_projection() -> void:
	# Same fitting rule as the portrait game, including short viewports.
	if not is_node_ready():
		return
	camera.size = GalleryLayout.camera_width(Vector2(viewport_3d.size))
	floor_canvas.view_size = Vector2(viewport_3d.size)
	floor_canvas.sync_view()
