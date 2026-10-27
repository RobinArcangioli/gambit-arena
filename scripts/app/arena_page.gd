extends "res://scripts/party/party_application.gd"
## Product composition only. The original combat and diagnostic scene keep their layout.
signal home_requested
const Choice = preload("res://scripts/app/arena_choice.gd")
var chooser: Callable
var fallback_choice := Choice.new()
var chosen_arena: StringName
var back_button: Button

func _ready() -> void:
	super._ready()
	back_button = _button(hud, "‹ Accueil", _request_home)
	toolbar[1].text = "Arènes"
	toolbar[2].text = "Compétences"
	$HUD/HeaderPanel.hide();$HUD/FooterPanel.hide()
	overlay.color.a = 0.88
	arena_picker.color.a = 0.88
	arena_picker.cards[&"reference"].hide()
	_update_layout()

func _reset() -> void:
	if not ready_ui or application_guard.blocked: return
	var id: StringName = chooser.call() if chooser.is_valid() else fallback_choice.next()
	if id == &"reference" or not Catalog.ENTRIES.has(id): id = &"colisee_solaire"
	chosen_arena = id
	arena_definition = Catalog.definition(id)
	floor_canvas.set_definition(arena_definition)
	super._reset()
	if OS.is_debug_build(): print("UI001 arena ", chosen_arena, " run ", simulation.run_id)
	_sync_projection()

func _request_home() -> void:
	if application_guard.blocked or _modal_open(): return
	touch_router.cancel_gesture()
	home_requested.emit()

func _update_buttons() -> void:
	super._update_buttons()
	if is_instance_valid(back_button): back_button.disabled = application_guard.blocked or _modal_open()

func _update_layout() -> void:
	super._update_layout()
	if not ready_ui: return
	$HUD/HeaderPanel.hide();$HUD/FooterPanel.hide()
	var view: Rect2 = get_viewport_rect()
	render_box.position = Vector2.ZERO; render_box.size = view.size
	floor_canvas.position = Vector2.ZERO
	bars_layer.position = Vector2.ZERO;bars_layer.size = view.size
	$HUD/Title.position = Vector2(132, 18)
	$HUD/Title.add_theme_font_size_override("font_size",17)
	$HUD/Description.position = Vector2(24, 68)
	pause_button.position = Vector2(safe_rect.size.x - 120, 12)
	pause_button.size = Vector2(108,48)
	pause_button.add_theme_font_size_override("font_size",16)
	if is_instance_valid(back_button):
		back_button.position = Vector2(12,12);back_button.size = Vector2(108,48)
	var half: float = (safe_rect.size.x - 56) * 0.5
	for i in range(2):
		hero_buttons[i].position = Vector2(24+i*(half+8),96)
		hero_buttons[i].size = Vector2(half,48)
	status.position = Vector2(24,151)
	var footer_height: float = minf(252, safe_rect.size.y * 0.29)
	var y: float = safe_rect.size.y - footer_height - 12
	for i in range(4):
		toolbar[i].position = Vector2(24+(i%2)*(half+8),y+int(i/2.0)*56)
		toolbar[i].size = Vector2(half,48)
	footer_scroll.position = Vector2(24,y+116)
	footer_scroll.size = Vector2(safe_rect.size.x-48,footer_height-116)
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	super._sync_projection()
	if not ready_ui or not is_instance_valid(floor_canvas.active_view): return
	var art = floor_canvas.active_view
	if not "image_rect" in art: return
	# Zoom the calibrated image AND camera together, around their common ground origin.
	# No independent stretch of the floor: feet and the painted grid stay aligned.
	var center: Vector2 = camera.unproject_position(Vector3.ZERO)
	var rect: Rect2 = art.image_rect
	var target: Vector2 = Vector2(viewport_3d.size)
	var zoom: float = maxf(1, maxf(center.x/maxf(1,center.x-rect.position.x),(target.x-center.x)/maxf(1,rect.end.x-center.x)))
	zoom = maxf(zoom,maxf(center.y/maxf(1,center.y-rect.position.y),(target.y-center.y)/maxf(1,rect.end.y-center.y)))
	camera.size /= zoom * 1.002
	floor_canvas.sync_view()
