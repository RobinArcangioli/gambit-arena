extends Node
const Availability = preload("res://scripts/ui/skill_availability.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Lab = preload("res://scenes/ui/skill_slots_lab.tscn")
const Reference = preload("res://scenes/ui/portrait_hud_lab.tscn")
const Actor = preload("res://scripts/hybrid/proxy_actor.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("SkillSlots: " + message)

func fixture() -> Snapshot:
	var view := Snapshot.new()
	view.source = {"id": 1, "health": 40, "max_health": 100, "position": Vector2.ZERO}
	view.enemies.append({"id": 2, "health": 60, "max_health": 60, "position": Vector2(0.8, 0)})
	return view

func states(view: Snapshot) -> Array[String]:
	var result: Array[String] = []
	for row in Availability.describe(view):
		result.append(row["state"])
	return result

func gameplay(lab: Node) -> Array:
	var sim = lab.simulation
	var result: Array = [sim.elapsed, sim.spawned, sim.defeated, sim.hits, sim.result, sim.controller.launched, sim.controller.evaluations, sim.controller.trace.total]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		result.append([actor.position, actor.state.health, actor.gait, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.accepted, actor.action.last_skill, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return result

func enclosed(outer: Rect2, inner: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 0.01 and inner.position.y >= outer.position.y - 0.01 and inner.end.x <= outer.end.x + 0.01 and inner.end.y <= outer.end.y + 0.01

func _ready() -> void:
	var view := fixture()
	check(states(view) == ["ready", "ready", "ready", "reserved", "reserved", "reserved"], "three ready skills and three reserved slots")
	var rows = Availability.describe(view)
	check(rows[0]["cost"] == 0 and rows[1]["cost"] == 20 and rows[2]["cost"] == 30 and rows[1]["cooldown"] == 4.0 and rows[2]["cooldown"] == 6.0, "costs and cooldowns from executor constants")
	var before: Array = [view.source.duplicate(true), view.enemies.duplicate(true), view.energy, view.heal_cooldown, view.special_cooldown, view.paused, view.busy]
	for repeat in range(1000):
		Availability.describe(view)
	check(before == [view.source, view.enemies, view.energy, view.heal_cooldown, view.special_cooldown, view.paused, view.busy], "1000 reads have no snapshot mutation")
	rows[0]["state"] = "changed"
	rows[1]["cost"] = -10
	check(Availability.describe(view)[0]["state"] == "ready" and Availability.describe(view)[1]["cost"] == 20, "outputs are independent")
	view.paused = true
	view.busy = true
	view.heal_cooldown = 1.0
	check(states(view)[0] == "paused" and states(view)[1] == "paused", "pause precedes busy and cooldown")
	view.paused = false
	check(states(view)[1] == "busy", "busy precedes cooldown")
	view.busy = false
	check(states(view)[1] == "cooldown" and Availability.describe(view)[1]["remaining"] == 1.0, "cooldown and numeric remainder")
	view.heal_cooldown = 0.000001
	check(states(view)[1] == "cooldown", "positive cooldown never ready")
	view.heal_cooldown = 0
	view.energy = 19
	check(states(view)[0] == "ready" and states(view)[1] == "energy" and states(view)[2] == "energy", "basic free and paid skills lack energy")
	view.energy = 20
	check(states(view)[1] == "ready" and states(view)[2] == "energy", "exact heal cost available")
	view.energy = 30
	check(states(view)[2] == "ready", "exact special cost available")
	view.source["health"] = 100
	check(states(view)[1] == "full_health", "full health blocks heal")
	view.enemies[0]["position"] = Vector2(1.0, 0)
	check(states(view)[0] == "ready", "exact reach available")
	view.enemies[0]["position"] = Vector2(1.00001, 0)
	check(states(view)[0] == "out_of_range", "outside reach unavailable")
	view.enemies[0]["health"] = 0
	check(states(view)[0] == "no_target", "dead enemies excluded")
	view.enemies.clear()
	check(states(view)[2] == "no_target", "empty target list")
	view.stopped = true
	check(states(view)[0] == "finished", "terminal blocks skills")
	view.source["health"] = 0
	check(states(view)[0] == "dead", "dead hero has explicit state")
	check(states(null)[0] == "invalid" and states(Snapshot.new())[1] == "invalid", "invalid input has no ready skill")
	view = fixture()
	view.enemies.append({"id": 3, "health": 60, "max_health": 60, "position": Vector2(-0.8, 0)})
	view.enemies.reverse()
	check(Availability.describe(view)[0]["target_id"] == 2, "stable nearest living target on equal distance")
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await get_tree().process_frame
	lab.paused = false
	lab._update_buttons()
	check(lab.skill_cards.size() == 6 and lab.skills_visible and not lab.rules_scroll.visible, "six-slot view is initial screen")
	for index in range(6):
		check(lab.skill_cards[index].disabled == (index >= 3), "only reserved cards disabled")
		check(lab.skill_cards[index].pressed.get_connections().size() == (1 if index < 3 else 0), "one inspect callback, no reserved callback")
	var frozen: Array = gameplay(lab)
	for repeat in range(100):
		lab.skill_cards[repeat % 3].pressed.emit()
		lab.gambits_tab.pressed.emit()
		lab.skills_tab.pressed.emit()
		lab._present()
	check(gameplay(lab) == frozen, "inspecting and tabs do not execute, spend, move or journal")
	check(lab.skill_details.text.contains("Consultation uniquement"), "read-only role explicitly displayed")
	lab._toggle_pause()
	frozen = gameplay(lab)
	lab.skill_cards[1].pressed.emit()
	lab._physics_process(10.0)
	check(lab.slot_states[1]["state"] == "paused" and gameplay(lab) == frozen, "inspection while paused freezes all game state")
	lab._toggle_pause()
	lab._next_placement()
	check(lab.slot_states[1]["state"] == "ready", "injured hero can heal without moving")
	lab._physics_process(0.02)
	check(lab.slot_states[1]["state"] == "busy" and lab.slot_states[1]["remaining"] > 0.0, "actual engaged heal shown busy with cooldown")
	frozen = gameplay(lab)
	lab.skill_cards[1].pressed.emit()
	check(gameplay(lab) == frozen and lab.simulation.hero.action.spent == 20, "inspect engaged skill does not double-pay")
	lab.gambits_tab.pressed.emit()
	lab.edit_buttons[0].pressed.emit()
	check(lab.paused and lab.overlay.visible, "gambit editor still pauses")
	lab.skills_tab.pressed.emit()
	check(not lab.skills_visible, "tab switching blocked under modal")
	lab._adjust_threshold(-1)
	lab.apply_button.pressed.emit()
	lab.skills_tab.pressed.emit()
	check(lab.skills_visible and lab.paused and lab.editor.snapshot()[0].threshold == 49, "edited rules survive returning to skills")
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	lab._update_layout()
	await get_tree().process_frame
	await get_tree().process_frame
	for control in [lab.skills_tab, lab.gambits_tab, lab.skills_scroll]:
		check(enclosed(lab.safe_rect, control.get_global_rect()), "tabs and skills viewport inside safe area")
	for card in lab.skill_cards:
		check(card.size.x >= 48 and card.size.y >= 48, "skill touch cells at least 48 pixels")
	lab.skills_scroll.ensure_control_visible(lab.skill_cards[5])
	await get_tree().process_frame
	await get_tree().process_frame
	check(enclosed(lab.skills_scroll.get_global_rect(), lab.skill_cards[5].get_global_rect()), "sixth slot reachable by scrolling")
	var scrollbar: VScrollBar = lab.skills_scroll.get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value - scrollbar.page
	await get_tree().process_frame
	await get_tree().process_frame
	check(lab.skill_details.get_global_rect().end.y <= lab.skills_scroll.get_global_rect().end.y + 0.01 and lab.skills_content.custom_minimum_size.y >= lab.skill_details.position.y + lab.skill_details.size.y, "last detail line reachable and inside content extent")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	frozen = gameplay(lab)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and gameplay(lab) == frozen, "background and return keep pause")
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	var current: Array = [lab.simulation.hero]
	current.append_array(lab.simulation.enemies)
	var actor_count: int = 0
	var only_current: bool = true
	for child in lab.world.get_children():
		if child is Actor:
			actor_count += 1
			only_current = only_current and child in current
	check(actor_count == 4 and only_current and lab.skill_cards.size() == 6, "ten resets without actors or slot duplicates")
	check(lab.paused and lab.editor.snapshot()[0].threshold == 49 and lab.slot_states[1]["remaining"] == 0.0, "reset retains configuration and clears cooldown display")
	# Both UI views must leave the full simulation trajectory unchanged.
	var reference = Reference.instantiate()
	add_child(reference)
	reference.set_physics_process(false)
	lab.mode_index = 0
	lab.editor.update_fields(0, {"target": "self", "condition": "hp_below", "threshold": 50, "skill": "heal"})
	lab._reset()
	reference._reset()
	lab.paused = false
	reference.paused = false
	lab._update_buttons()
	reference._update_buttons()
	var identical: bool = true
	for tick in range(2400):
		lab._physics_process(1.0 / 60.0)
		reference._physics_process(1.0 / 60.0)
		lab._select_slot(tick % 3)
		identical = identical and gameplay(lab) == gameplay(reference)
		if lab.simulation.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(identical and lab.simulation.result == "VICTOIRE", "combat identical to STEP-021 despite repeated inspection")
	check(lab.slot_states[0]["state"] == "finished", "victory shows terminal availability")
	lab._reset()
	lab.simulation.hero.state.damage(1000000)
	lab._physics_process(0.02)
	check(lab.slot_states[0]["state"] == "dead" and lab.slot_states[1]["state"] == "dead", "real hero death shown explicitly")
	lab.queue_free()
	reference.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-022 / tests emplacements\n%s : %d controles, %d echecs\nDisponibilite, consultation et combat.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = summary_text
	add_child(label)
