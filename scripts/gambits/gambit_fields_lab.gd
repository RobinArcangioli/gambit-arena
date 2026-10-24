extends "res://scripts/gambits/gambit_editor_lab.gd"
## Modal draft. Opening pauses; closing never silently resumes the game.
var edit_buttons: Array[Button] = []
var overlay: ColorRect
var panel: ColorRect
var form_title: Label
var target_button: Button
var condition_button: Button
var skill_button: Button
var threshold_label: Label
var threshold_buttons: Array[Button] = []
var explanation_label: Label
var apply_button: Button
var cancel_button: Button
var editing_index: int = -1
var draft: Dictionary = {}

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-020 / REGLES"
	$HUD/Description.text = "Toucher une regle pour la modifier\nLe formulaire met en pause ; reprise explicite"
	for index in range(3):
		row_labels[index].hide()
		var button := _button("", _open_editor.bind(index))
		button.add_theme_font_size_override("font_size", 16)
		edit_buttons.append(button)
	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.8)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	panel = ColorRect.new()
	panel.color = Color("1a2936")
	overlay.add_child(panel)
	form_title = _form_label(23)
	target_button = _form_button(_cycle_target)
	condition_button = _form_button(_cycle_condition)
	skill_button = _form_button(_cycle_skill)
	threshold_label = _form_label(18)
	for amount in [-5, -1, 1, 5]:
		var button := _form_button(_adjust_threshold.bind(amount))
		button.text = "%+d" % amount
		threshold_buttons.append(button)
	explanation_label = _form_label(17)
	explanation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	apply_button = _form_button(_save_editor)
	apply_button.text = "Appliquer"
	cancel_button = _form_button(_cancel_editor)
	cancel_button.text = "Annuler"
	overlay.hide()
	_update_layout()
	_refresh_rows()

func _form_label(font_size: int) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(label)
	return label

func _form_button(callback: Callable) -> Button:
	var button := Button.new()
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 19)
	button.pressed.connect(callback)
	panel.add_child(button)
	return button

func _update_layout() -> void:
	super._update_layout()
	for index in range(edit_buttons.size()):
		edit_buttons[index].position = row_labels[index].position
		edit_buttons[index].size = row_labels[index].size
	if not is_instance_valid(cancel_button):
		return
	overlay.position = Vector2.ZERO
	overlay.size = get_viewport_rect().size
	panel.size = Vector2(safe_rect.size.x - 32, 576)
	panel.position = safe_rect.position + Vector2(16, maxf(16, (safe_rect.size.y - 576) * 0.5))
	var width: float = panel.size.x - 32
	form_title.position = Vector2(16, 16)
	target_button.position = Vector2(16, 62)
	target_button.size = Vector2(width, 56)
	condition_button.position = Vector2(16, 130)
	condition_button.size = Vector2(width, 56)
	threshold_label.position = Vector2(16, 198)
	var cell: float = (width - 24) / 4.0
	for index in range(4):
		threshold_buttons[index].position = Vector2(16 + index * (cell + 8), 230)
		threshold_buttons[index].size = Vector2(cell, 52)
	skill_button.position = Vector2(16, 298)
	skill_button.size = Vector2(width, 56)
	explanation_label.position = Vector2(16, 370)
	explanation_label.size = Vector2(width, 112)
	cancel_button.position = Vector2(16, 504)
	cancel_button.size = Vector2((width - 12) * 0.5, 56)
	apply_button.position = Vector2(28 + (width - 12) * 0.5, 504)
	apply_button.size = Vector2((width - 12) * 0.5, 56)

func _refresh_rows() -> void:
	super._refresh_rows()
	for index in range(edit_buttons.size()):
		edit_buttons[index].text = row_labels[index].text.replace("\n", " / Modifier\n")
		edit_buttons[index].modulate = row_labels[index].modulate

func _open_editor(index: int) -> void:
	if editing_index >= 0 or index < 0 or index >= 3:
		return
	var rule = editor.snapshot()[index]
	draft = {"target": rule.target, "condition": rule.condition, "threshold": rule.threshold, "skill": rule.skill}
	editing_index = index
	paused = true
	_update_buttons()
	_present()
	_refresh_form()
	overlay.show()

func _cycle_target() -> void:
	if editing_index < 0:
		return
	draft["target"] = "enemy" if draft["target"] == "self" else "self"
	_refresh_form()

func _cycle_condition() -> void:
	if editing_index < 0:
		return
	draft["condition"] = "hp_below" if draft["condition"] == "always" else "always"
	_refresh_form()

func _cycle_skill() -> void:
	if editing_index < 0:
		return
	var choices: Array[String] = ["basic", "heal", "special"]
	draft["skill"] = choices[(choices.find(draft["skill"]) + 1) % choices.size()]
	_refresh_form()

func _adjust_threshold(amount: int) -> void:
	if editing_index < 0 or draft["condition"] != "hp_below":
		return
	draft["threshold"] = clampi(int(draft["threshold"]) + amount, 0, 100)
	_refresh_form()

func _refresh_form() -> void:
	form_title.text = "Modifier la regle %d / PAUSE" % (editing_index + 1)
	target_button.text = "Cible : " + ("Soi" if draft["target"] == "self" else "Ennemi")
	condition_button.text = "Condition : " + ("Toujours" if draft["condition"] == "always" else "PV inferieurs au seuil")
	skill_button.text = "Action : " + ("Soin" if draft["skill"] == "heal" else "Speciale" if draft["skill"] == "special" else "Attaque")
	var threshold: int = draft["threshold"]
	threshold_label.text = "Seuil : %d %% des PV de la cible" % threshold
	var deltas: Array[int] = [-5, -1, 1, 5]
	for index in range(4):
		threshold_buttons[index].disabled = draft["condition"] == "always" or (threshold == 0 and deltas[index] < 0) or (threshold == 100 and deltas[index] > 0)
	var error_text: String = Editor.validate_fields(draft)
	apply_button.disabled = not error_text.is_empty()
	explanation_label.modulate = Color.WHITE if error_text.is_empty() else Color("ffbc99")
	if not error_text.is_empty():
		explanation_label.text = error_text + "\nChanger la cible ou l'action. Rien n'est applique."
	elif draft["condition"] == "always":
		explanation_label.text = "Toujours : seuil ignore. Soin ne soigne pas une cible deja pleine.\nAppliquer garde la pause."
	else:
		explanation_label.text = "PV de la cible strictement < %d %%.\n0 %% : jamais ; 100 %% : cible blessee.\nAppliquer garde la pause." % threshold

func _save_editor() -> void:
	if editing_index < 0:
		return
	if editor.update_fields(editing_index, draft):
		_close_editor()
	else:
		_refresh_form()

func _cancel_editor() -> void:
	if editing_index >= 0:
		_close_editor()

func _close_editor() -> void:
	editing_index = -1
	draft.clear()
	overlay.hide()
	_update_buttons()
	_present()

func _toggle_pause() -> void:
	if editing_index < 0:
		super._toggle_pause()

func _toggle_rule(index: int) -> void:
	if editing_index < 0:
		super._toggle_rule(index)

func _move_rule(index: int, direction: int) -> void:
	if editing_index < 0:
		super._move_rule(index, direction)

func _reset() -> void:
	if editing_index < 0:
		super._reset()

func _next_placement() -> void:
	if editing_index < 0:
		super._next_placement()

func _unhandled_key_input(event: InputEvent) -> void:
	if editing_index >= 0:
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
			_cancel_editor()
		get_viewport().set_input_as_handled()
	else:
		super._unhandled_key_input(event)
