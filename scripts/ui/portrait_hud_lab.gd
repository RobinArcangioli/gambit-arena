extends "res://scripts/gambits/gambit_fields_lab.gd"
const TouchRouter = preload("res://scripts/ui/touch_scroll_router.gd")
var touch_router: TouchRouter = null
const Layout = preload("res://scripts/ui/hud_layout.gd")
var hud_ready: bool = false
var status_panel: ColorRect
var health_label: Label
var energy_label: Label
var action_label: Label
var cooldown_label: Label
var enemies_label: Label
var health_bar: ProgressBar
var energy_bar: ProgressBar
var rules_scroll: ScrollContainer
var rules_content: Control
var form_scroll: ScrollContainer
var form_content: Control
# Diagnostic hook for the F6 scene; empty in normal use. Coordinates are logical.
var safe_area_override := Rect2()
var layout_probe: float = 0.0

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "GAMBIT ARENA"
	$HUD/Title.add_theme_font_size_override("font_size", 20)
	$HUD/Description.add_theme_font_size_override("font_size", 16)
	readout.hide()
	status_panel = ColorRect.new()
	status_panel.color = Color("182c38")
	status_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(status_panel)
	health_label = _status_label()
	energy_label = _status_label()
	action_label = _status_label()
	cooldown_label = _status_label()
	enemies_label = _status_label()
	health_bar = _bar(Color("69c995"))
	energy_bar = _bar(Color("77bce8"))
	rules_scroll = _scroll(hud)
	rules_content = _content(rules_scroll, 232)
	for index in range(3):
		for button in [edit_buttons[index], toggle_buttons[index], up_buttons[index], down_buttons[index]]:
			button.reparent(rules_content, false)
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			button.add_theme_font_size_override("font_size", 16)
			button.clip_text = true
	form_scroll = _scroll(panel)
	form_content = _content(form_scroll, 432)
	for control in [target_button, condition_button, threshold_label, skill_button, explanation_label]:
		control.reparent(form_content, false)
		if control is BaseButton:
			control.mouse_filter = Control.MOUSE_FILTER_PASS
	for button in threshold_buttons:
		button.reparent(form_content, false)
		button.mouse_filter = Control.MOUSE_FILTER_PASS
	for button in [target_button, condition_button, skill_button, apply_button, cancel_button, pause_button, replay, position_button]:
		button.add_theme_font_size_override("font_size", 17)
		button.clip_text = true
	form_title.add_theme_font_size_override("font_size", 19)
	threshold_label.add_theme_font_size_override("font_size", 16)
	rules_title.text = "Gambits / priorite de haut en bas"
	rules_title.add_theme_font_size_override("font_size", 16)
	touch_router = TouchRouter.new()
	touch_router.active_scrollers = _touch_scrollers
	add_child(touch_router)
	hud_ready = true
	_update_layout()
	_refresh_rows()
	_present()

func _status_label() -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", 16)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.clip_text = true
	status_panel.add_child(label)
	return label

func _bar(tint: Color) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill := StyleBoxFlat.new()
	fill.bg_color = tint
	bar.add_theme_stylebox_override("fill", fill)
	var background := StyleBoxFlat.new()
	background.bg_color = Color("0b1822")
	bar.add_theme_stylebox_override("background", background)
	status_panel.add_child(bar)
	return bar

func _scroll(parent: Node) -> ScrollContainer:
	var scroller := ScrollContainer.new()
	# Kept for native GUI inputs; raw HUD touches are owned by TouchRouter.
	scroller.scroll_deadzone = 12
	scroller.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroller.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	parent.add_child(scroller)
	return scroller

func _content(scroller: ScrollContainer, content_height: float) -> Control:
	var content := Control.new()
	# Wheel events pass STOP by default; touch drags need an unbroken PASS chain.
	content.mouse_filter = Control.MOUSE_FILTER_PASS
	content.custom_minimum_size = Vector2(0, content_height)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroller.add_child(content)
	return content

func _rect(control: Control, rectangle: Rect2) -> void:
	control.position = rectangle.position
	control.size = rectangle.size

func _available_area(view: Rect2) -> Rect2:
	var candidate: Rect2 = view
	if safe_area_override.has_area():
		candidate = safe_area_override
	elif OS.get_name() == "Android":
		candidate = get_viewport().get_screen_transform().affine_inverse() * Rect2(DisplayServer.get_display_safe_area())
	return Layout.usable_rect(view, candidate)

func _process(delta: float) -> void:
	if not hud_ready or not is_finite(delta) or delta <= 0:
		return
	# System bars can change the safe area without resizing the logical viewport.
	layout_probe += delta
	if layout_probe >= 0.25:
		layout_probe = 0.0
		if _available_area(get_viewport_rect()) != safe_rect:
			_update_layout()

func _update_layout() -> void:
	if not hud_ready:
		super._update_layout()
		return
	var view: Rect2 = get_viewport_rect()
	safe_rect = _available_area(view)
	$Backdrop.size = view.size
	hud.position = safe_rect.position
	hud.size = safe_rect.size
	var areas: Dictionary = Layout.regions(safe_rect.size)
	_rect($HUD/HeaderPanel, areas["header"])
	_rect($HUD/Title, Rect2(24, 18, safe_rect.size.x - 164, 28))
	_rect($HUD/Description, Rect2(24, 46, safe_rect.size.x - 164, 24))
	_rect(pause_button, Rect2(safe_rect.size.x - 136, 20, 112, 48))
	_rect(status_panel, areas["status"])
	var status_width: float = status_panel.size.x
	var half: float = (status_width - 36) * 0.5
	_rect(health_label, Rect2(12, 6, half, 24))
	_rect(energy_label, Rect2(24 + half, 6, half, 24))
	_rect(health_bar, Rect2(12, 34, half, 8))
	_rect(energy_bar, Rect2(24 + half, 34, half, 8))
	_rect(action_label, Rect2(12, 48, status_width - 24, 24))
	_rect(cooldown_label, Rect2(12, 75, status_width - 24, 24))
	_rect(enemies_label, Rect2(12, 100, status_width - 24, 24))
	var arena_rect: Rect2 = areas["arena"]
	_rect(render_box, Rect2(safe_rect.position + arena_rect.position, arena_rect.size))
	floor_canvas.position = render_box.position
	rings.position = render_box.position
	var footer: Rect2 = areas["footer"]
	_rect($HUD/FooterPanel, footer)
	var toolbar_width: float = (footer.size.x - 32) * 0.5
	_rect(replay, Rect2(footer.position + Vector2(12, 8), Vector2(toolbar_width, 48)))
	_rect(position_button, Rect2(footer.position + Vector2(20 + toolbar_width, 8), Vector2(toolbar_width, 48)))
	_rect(rules_title, Rect2(footer.position + Vector2(12, 60), Vector2(footer.size.x - 24, 24)))
	_rect(rules_scroll, Rect2(footer.position + Vector2(12, 88), Vector2(footer.size.x - 24, footer.size.y - 100)))
	# Reserve scrollbar width even when hidden: summaries never change column width.
	var row_width: float = rules_scroll.size.x - 16
	var summary_width: float = row_width - 174
	var row_y: float = 0.0
	for index in range(3):
		# Multiline text/theme minimums may exceed the requested 72 px.
		var row_height: float = maxf(72, edit_buttons[index].get_combined_minimum_size().y)
		var command_height: float = 48.0
		for button in [toggle_buttons[index], up_buttons[index], down_buttons[index]]:
			command_height = maxf(command_height, button.get_combined_minimum_size().y)
		row_height = maxf(row_height, command_height)
		_rect(edit_buttons[index], Rect2(0, row_y, summary_width, row_height))
		var command_y: float = row_y + (row_height - command_height) * 0.5
		_rect(toggle_buttons[index], Rect2(summary_width + 6, command_y, 52, command_height))
		_rect(up_buttons[index], Rect2(summary_width + 64, command_y, 52, command_height))
		_rect(down_buttons[index], Rect2(summary_width + 122, command_y, 52, command_height))
		row_y += row_height + 8.0
	# ScrollContainer measures its direct child, not the grandchildren's bounds.
	rules_content.custom_minimum_size.y = row_y
	_rect(overlay, view)
	var modal: Rect2 = areas["modal"]
	_rect(panel, Rect2(safe_rect.position + modal.position, modal.size))
	_rect(form_title, Rect2(12, 10, panel.size.x - 24, 32))
	_rect(form_scroll, Rect2(12, 50, panel.size.x - 24, panel.size.y - 126))
	var field_width: float = form_scroll.size.x - 16
	_rect(target_button, Rect2(0, 0, field_width, 52))
	_rect(condition_button, Rect2(0, 64, field_width, 52))
	_rect(threshold_label, Rect2(0, 132, field_width, 24))
	var cell: float = (field_width - 24) / 4.0
	for index in range(4):
		_rect(threshold_buttons[index], Rect2(index * (cell + 8), 164, cell, 48))
	_rect(skill_button, Rect2(0, 228, field_width, 52))
	_rect(explanation_label, Rect2(0, 294, field_width, 132))
	var command_width: float = (panel.size.x - 36) * 0.5
	_rect(cancel_button, Rect2(12, panel.size.y - 64, command_width, 52))
	_rect(apply_button, Rect2(24 + command_width, panel.size.y - 64, command_width, 52))
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	if not hud_ready:
		super._sync_projection()
		return
	camera.size = Layout.camera_width(Vector2(viewport_3d.size))
	floor_canvas.view_size = Vector2(viewport_3d.size)
	floor_canvas.sync_view()

func _refresh_rows() -> void:
	super._refresh_rows()
	if not hud_ready:
		return
	var configured = editor.snapshot()
	for index in range(3):
		var rule = configured[index]
		var target_text: String = "Soi" if rule.target == "self" else "Ennemi"
		var condition_text: String = "Toujours" if rule.condition == "always" else "PV < %d %%" % rule.threshold
		edit_buttons[index].text = "%d. %s\n%s\n%s" % [index + 1, _skill_name(rule.skill), target_text, condition_text]
		edit_buttons[index].tooltip_text = "Modifier la regle %d" % (index + 1)
	call_deferred("_update_layout")

func _refresh_form() -> void:
	super._refresh_form()
	if hud_ready:
		form_title.text = "Regle %d / combat en pause" % (editing_index + 1)
		condition_button.text = "Condition : " + ("Toujours" if draft["condition"] == "always" else "PV < seuil")
		threshold_label.text = "Seuil : %d %% des PV de la cible" % draft["threshold"]

func _open_editor(index: int) -> void:
	var was_open: bool = editing_index >= 0
	super._open_editor(index)
	if hud_ready and not was_open and editing_index >= 0:
		form_scroll.scroll_vertical = 0

func _update_buttons() -> void:
	super._update_buttons()
	if hud_ready:
		_present()

static func _skill_name(skill: String) -> String:
	return "Soin" if skill == "heal" else "Speciale" if skill == "special" else "Attaque"

func _present() -> void:
	super._present()
	if not hud_ready:
		return
	var fighter = simulation.hero
	var state_text: String = simulation.result
	if simulation.result == "EN COURS":
		state_text = "PAUSE" if paused else "COMBAT"
	$HUD/Description.text = "%s / %s" % [state_text, SCENARIOS[mode_index]]
	health_label.text = "PV %d / %d" % [fighter.state.health, fighter.state.max_health]
	energy_label.text = "Energie %d / 60" % fighter.action.energy
	health_bar.max_value = fighter.state.max_health
	health_bar.value = fighter.state.health
	energy_bar.max_value = 60
	energy_bar.value = fighter.action.energy
	var intent: Dictionary = simulation.controller.decision
	action_label.text = "Repos / aucune regle disponible"
	if simulation.result != "EN COURS":
		action_label.text = "Combat termine / Rejouer disponible"
	elif fighter.action.active:
		action_label.text = "En cours : " + _skill_name(String(fighter.action.last_skill))
	elif intent.get("kind", "none") == "intent":
		action_label.text = "R%d / %s : %s" % [intent["rule_index"] + 1, "Approche" if intent["approach"] else "Choix", _skill_name(intent["skill"])]
	cooldown_label.text = "Delais : soin %.1f s / speciale %.1f s" % [fighter.action.remaining(&"heal"), fighter.action.remaining(&"special")]
	enemies_label.text = "Ennemis %d / vaincus %d sur %d" % [simulation.enemies.size(), simulation.defeated, simulation.budget]

func _touch_scrollers() -> Array[ScrollContainer]:
	var result: Array[ScrollContainer] = []
	if not hud_ready:
		return result
	if editing_index >= 0:
		result.append(form_scroll)
	elif rules_scroll.is_visible_in_tree():
		result.append(rules_scroll)
	return result

func _reset() -> void:
	if is_instance_valid(touch_router):
		touch_router.cancel_gesture()
	super._reset()
