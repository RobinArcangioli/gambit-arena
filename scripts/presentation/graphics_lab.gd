extends "res://scripts/arena/arena.gd"
## Independent visual gallery. No CombatSimulation, exécuteur or gameplay actors.
const REFERENCE = preload("res://resources/presentation/arenas/reference.tres")
const COLISEE = preload("res://resources/presentation/arenas/colisee_solaire.tres")
const IllustratedView = preload("res://scripts/presentation/illustrated_arena_view.gd")
const GalleryLayout = preload("res://scripts/ui/hud_layout.gd")
var gallery_ready: bool = false
var calibration_visible: bool = false

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "GRAPHICS-001 / ARENES"
	$HUD/SlotsTitle.text = "Presentation interchangeable / terrain inchange"
	for slot in slots:
		slot.hide()
	for index in range(3):
		slots[index].show()
		slots[index].disabled = false
	slots[0].text = "Reference"
	slots[0].pressed.connect(select_arena.bind(REFERENCE))
	slots[1].text = "Colisee"
	slots[1].pressed.connect(select_arena.bind(COLISEE))
	slots[2].text = "Grille image"
	slots[2].pressed.connect(_toggle_calibration)
	gallery_ready = true
	select_arena(COLISEE)

func select_arena(choice: ArenaDefinition) -> void:
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
		slots[2].disabled = floor_canvas.definition.arena_id != &"colisee_solaire"

func _sync_projection() -> void:
	# Same fitting rule as the portrait game, including short viewports.
	if not is_node_ready():
		return
	camera.size = GalleryLayout.camera_width(Vector2(viewport_3d.size))
	floor_canvas.view_size = Vector2(viewport_3d.size)
	floor_canvas.sync_view()
