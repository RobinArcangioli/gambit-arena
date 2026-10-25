extends "res://scripts/ui/portrait_hud_lab.gd"
const Availability = preload("res://scripts/ui/skill_availability.gd")
const Capture = preload("res://scripts/gambits/gambit_controller.gd")
var slots_ready: bool = false
var skills_visible: bool = true
var selected_slot: int = 0
var slot_states: Array[Dictionary] = []
var skill_cards: Array[Button] = []
var gambits_tab: Button
var skills_tab: Button
var skills_scroll: ScrollContainer
var skills_content: Control
var skill_details: Label

func _ready() -> void:
	super._ready()
	rules_title.hide()
	gambits_tab = _button("Gambits", _show_skills.bind(false))
	skills_tab = _button("Competences", _show_skills.bind(true))
	for tab in [gambits_tab, skills_tab]:
		tab.toggle_mode = true
		tab.add_theme_font_size_override("font_size", 17)
	skills_scroll = _scroll(hud)
	skills_content = _content(skills_scroll, 240)
	for index in range(6):
		# Reuse the six historically reserved controls rather than duplicate them.
		var card: Button = slots[index]
		card.reparent(skills_content, false)
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		card.show()
		card.name = "SkillSlot%d" % (index + 1)
		card.focus_mode = Control.FOCUS_NONE
		card.clip_text = true
		card.add_theme_font_size_override("font_size", 15)
		card.disabled = index >= 3
		if index < 3:
			card.pressed.connect(_select_slot.bind(index))
		skill_cards.append(card)
	skill_details = Label.new()
	skill_details.add_theme_font_size_override("font_size", 16)
	skill_details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	skill_details.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skills_content.add_child(skill_details)
	skill_details.minimum_size_changed.connect(_details_minimum_changed)
	slots_ready = true
	_present()
	_show_skills(true)

func _details_minimum_changed() -> void:
	if slots_ready:
		call_deferred("_update_layout")

func _update_layout() -> void:
	super._update_layout()
	if not slots_ready:
		return
	var footer: Rect2 = Layout.regions(safe_rect.size)["footer"]
	var tab_width: float = (footer.size.x - 32) * 0.5
	_rect(gambits_tab, Rect2(footer.position + Vector2(12, 60), Vector2(tab_width, 48)))
	_rect(skills_tab, Rect2(footer.position + Vector2(20 + tab_width, 60), Vector2(tab_width, 48)))
	var body := Rect2(footer.position + Vector2(12, 116), Vector2(footer.size.x - 24, footer.size.y - 128))
	_rect(rules_scroll, body)
	_rect(skills_scroll, body)
	var content_width: float = body.size.x - 16
	var cell_width: float = (content_width - 16) / 3.0
	var y: float = 0.0
	for row_index in range(2):
		var row_height: float = 72.0
		for column in range(3):
			row_height = maxf(row_height, skill_cards[row_index * 3 + column].get_combined_minimum_size().y)
		for column in range(3):
			_rect(skill_cards[row_index * 3 + column], Rect2(column * (cell_width + 8), y, cell_width, row_height))
		y += row_height + 8
	_rect(skill_details, Rect2(0, y, content_width, maxf(108, skill_details.get_combined_minimum_size().y)))
	skills_content.custom_minimum_size.y = y + skill_details.size.y + 8

func _show_skills(value: bool) -> void:
	if not slots_ready or editing_index >= 0:
		return
	skills_visible = value
	rules_scroll.visible = not value
	skills_scroll.visible = value
	gambits_tab.set_pressed_no_signal(not value)
	skills_tab.set_pressed_no_signal(value)
	_update_layout()

func _select_slot(index: int) -> void:
	if not slots_ready or editing_index >= 0 or index < 0 or index >= 3:
		return
	selected_slot = index
	_refresh_skills()

func _present() -> void:
	super._present()
	if slots_ready:
		_refresh_skills()

func _refresh_skills() -> void:
	var view = Capture.capture(simulation.hero, simulation.enemies, simulation.clock)
	# Planning intentionally omits dead sources; presentation still needs their state.
	if is_instance_valid(simulation.hero) and not simulation.hero.state.alive:
		var fighter = simulation.hero
		view.source = {"id": fighter.combat_id, "health": 0, "max_health": fighter.state.max_health, "position": Vector2(fighter.position.x, fighter.position.z)}
		view.energy = fighter.action.energy
		view.heal_cooldown = fighter.action.remaining(&"heal")
		view.special_cooldown = fighter.action.remaining(&"special")
		view.paused = simulation.clock.paused
		view.stopped = simulation.clock.stopped
	slot_states = Availability.describe(view)
	var changed_text: bool = false
	for index in range(6):
		var row: Dictionary = slot_states[index]
		var caption_text: String = "%d. A venir\nReserve" % (index + 1)
		if index < 3:
			caption_text = "%d. %s\n%s\n%d E / %.1f s" % [index + 1, row["name"], Availability.caption(row["state"]), row["cost"], ceilf(row["remaining"] * 10.0) / 10.0]
		changed_text = changed_text or skill_cards[index].text != caption_text
		skill_cards[index].text = caption_text
		skill_cards[index].modulate = Color("c1f1d2") if row["state"] == "ready" else Color.WHITE
		skill_cards[index].tooltip_text = _skill_tooltip() if index < 3 else "Emplacement reserve"
	var selected: Dictionary = slot_states[selected_slot]
	var details_text: String = _details_caption(selected)
	changed_text = changed_text or skill_details.text != details_text
	skill_details.text = details_text
	if changed_text:
		call_deferred("_update_layout")

func _skill_tooltip() -> String:
	return "Consulter les details"

func _details_caption(selected: Dictionary) -> String:
	return "%s / cout %d E / delai %.1f s\n%s\nConsultation uniquement : aucun lancement." % [selected["name"], selected["cost"], selected["cooldown"], Availability.explanation(selected["state"])]

func _touch_scrollers() -> Array[ScrollContainer]:
	var result: Array[ScrollContainer] = super._touch_scrollers()
	if slots_ready and editing_index < 0 and skills_scroll.is_visible_in_tree():
		result.append(skills_scroll)
	return result
