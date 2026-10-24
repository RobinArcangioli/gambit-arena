extends "res://scripts/combat/battle_lab.gd"
const Editor = preload("res://scripts/gambits/gambit_editor.gd")
const SCENARIOS: Array[String] = ["Combat", "Soin", "Groupe 20"]
var editor := Editor.new()
var row_labels: Array[Label] = []
var toggle_buttons: Array[Button] = []
var up_buttons: Array[Button] = []
var down_buttons: Array[Button] = []
var rules_title: Label
var editor_ready: bool = false

func _ready() -> void:
	simulation.controller.rules = editor.snapshot()
	super._ready()
	$HUD/Title.text = "STEP-019 / GAMBITS"
	$HUD/Description.text = "Priorite du haut vers le bas\nModifier en jeu ou en pause ; Rejouer conserve"
	$HUD/SlotsTitle.hide()
	for slot in slots:
		slot.hide()
	marks_button.hide()
	rules_title = Label.new()
	rules_title.text = "Trois regles / premiere disponible choisie"
	rules_title.add_theme_font_size_override("font_size", 17)
	rules_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(rules_title)
	for index in range(3):
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 17)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hud.add_child(label)
		row_labels.append(label)
		var toggle := _button("", _toggle_rule.bind(index))
		toggle_buttons.append(toggle)
		up_buttons.append(_button("Haut", _move_rule.bind(index, -1)))
		down_buttons.append(_button("Bas", _move_rule.bind(index, 1)))
	editor.changed.connect(_apply_rules)
	editor_ready = true
	_update_layout()
	_refresh_rows()

func _button(caption: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = caption
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 17)
	button.pressed.connect(callback)
	hud.add_child(button)
	return button

func _update_layout() -> void:
	super._update_layout()
	if not setup_complete:
		return
	var width: float = safe_rect.size.x
	var height: float = safe_rect.size.y
	readout.position = Vector2(28, 124)
	render_box.position = safe_rect.position + Vector2(16, 192)
	render_box.size = Vector2(width - 32, maxf(220, height - 522))
	floor_canvas.position = render_box.position
	rings.position = render_box.position
	$HUD/FooterPanel.position = Vector2(16, height - 318)
	$HUD/FooterPanel.size = Vector2(width - 32, 306)
	replay.position = Vector2(28, height - 306)
	replay.size = Vector2(160, 48)
	position_button.position = Vector2(200, height - 306)
	position_button.size = Vector2(width - 228, 48)
	if not editor_ready:
		return
	rules_title.position = Vector2(28, height - 250)
	for index in range(3):
		var y: float = height - 220 + index * 68
		row_labels[index].position = Vector2(28, y + 2)
		row_labels[index].size = Vector2(width - 270, 58)
		toggle_buttons[index].position = Vector2(width - 228, y)
		toggle_buttons[index].size = Vector2(64, 56)
		up_buttons[index].position = Vector2(width - 156, y)
		up_buttons[index].size = Vector2(60, 56)
		down_buttons[index].position = Vector2(width - 88, y)
		down_buttons[index].size = Vector2(60, 56)

func _toggle_rule(index: int) -> void:
	editor.toggle(index)

func _move_rule(index: int, direction: int) -> void:
	editor.move(index, direction)

func _apply_rules() -> void:
	# Discard every pending intention, even when only a higher row changed.
	# stop() does not cancel or refund the executor's already committed action.
	simulation.controller.stop(simulation.hero, "rules_changed", simulation.clock.elapsed)
	simulation.controller.rules = editor.snapshot()
	_refresh_rows()
	_present()

func _refresh_rows() -> void:
	if not editor_ready:
		return
	var rules = editor.snapshot()
	for index in range(3):
		var rule = rules[index]
		var skill_text: String = "Soin" if rule.skill == "heal" else "Speciale" if rule.skill == "special" else "Attaque"
		var target_text: String = "Soi" if rule.target == "self" else "Ennemi"
		var condition_text: String = "toujours" if rule.condition == "always" else "PV < %d %%" % rule.threshold
		var caption: String = "%s\n%s / %s" % [skill_text, target_text, condition_text]
		row_labels[index].text = "%d. %s" % [index + 1, caption]
		row_labels[index].modulate = Color.WHITE if rule.enabled else Color(0.65, 0.65, 0.65)
		toggle_buttons[index].text = "Oui" if rule.enabled else "Non"
		toggle_buttons[index].tooltip_text = "Activer/desactiver la regle %d" % [index + 1]
		up_buttons[index].disabled = index == 0
		down_buttons[index].disabled = index == 2

func _reset() -> void:
	simulation.reset(mode_index)
	if mode_index == 1:
		simulation.hero.state.damage(60)
	_present()
	_update_buttons()
	_refresh_rows()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % SCENARIOS.size()
	_reset()

func _update_buttons() -> void:
	simulation.clock.paused = paused
	pause_button.text = "Reprendre" if paused else "Pause"
	position_button.disabled = paused
	if setup_complete:
		position_button.text = "%d/3 %s" % [mode_index + 1, SCENARIOS[mode_index]]

func _present() -> void:
	super._present()
	var fighter = simulation.hero
	var intent: Dictionary = simulation.controller.decision
	var choice: String = "aucune intention"
	if fighter.action.active:
		choice = "engagee : %s" % fighter.action.last_skill
	elif intent.get("kind", "none") == "intent":
		choice = "R%d : %s" % [intent["rule_index"] + 1, intent["skill"]]
	readout.text = "%s | PV %d/%d | Energie %d\n%s | %s\nCD soin %.1f / speciale %.1f | ennemis %d" % [simulation.result, fighter.state.health, fighter.state.max_health, fighter.action.energy, "PAUSE" if paused else "EN JEU", choice, fighter.action.remaining(&"heal"), fighter.action.remaining(&"special"), simulation.enemies.size()]
