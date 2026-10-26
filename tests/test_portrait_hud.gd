extends Node
const Layout = preload("res://scripts/ui/hud_layout.gd")
const Lab = preload("res://scenes/ui/portrait_hud_lab.tscn")
const Reference = preload("res://scenes/gambits/gambit_fields_lab.tscn")
const Actor = preload("res://scripts/combat/stats_actor.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("PortraitHUD: " + message)

func enclosed(outer: Rect2, inner: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 0.01 and inner.position.y >= outer.position.y - 0.01 and inner.end.x <= outer.end.x + 0.01 and inner.end.y <= outer.end.y + 0.01

func gameplay(lab: Node) -> Array:
	var sim = lab.simulation
	var result: Array = [sim.elapsed, sim.spawned, sim.defeated, sim.hits, sim.result, sim.controller.launched, sim.controller.evaluations]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		result.append([actor.position, actor.state.health, actor.gait, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.last_skill, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return result

func check_last_rule(lab: Node, caption: String) -> void:
	lab._update_layout()
	# Let minimum sizes and the container's deferred sort settle before scrolling.
	await get_tree().process_frame
	await get_tree().process_frame
	var scrollbar: VScrollBar = lab.rules_scroll.get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value - scrollbar.page
	await get_tree().process_frame
	await get_tree().process_frame
	var window: Rect2 = lab.rules_scroll.get_global_rect()
	for button in [lab.edit_buttons[2], lab.toggle_buttons[2], lab.up_buttons[2], lab.down_buttons[2]]:
		check(enclosed(window, button.get_global_rect()), "%s: viewport=%s button=%s content=%s scroll=%.1f max=%.1f page=%.1f" % [caption, window, button.get_global_rect(), lab.rules_content.size, scrollbar.value, scrollbar.max_value, scrollbar.page])
	check(lab.rules_content.custom_minimum_size.y >= lab.edit_buttons[2].position.y + lab.edit_buttons[2].size.y, "scroll extent includes actual last row height")

func _ready() -> void:
	var view := Rect2(0, 0, 540, 960)
	check(Layout.usable_rect(view, Rect2()) == view, "empty safe area falls back")
	check(Layout.usable_rect(view, Rect2(900, 900, 20, 20)) == view, "disjoint safe area falls back")
	check(Layout.usable_rect(view, Rect2(Vector2(NAN, 0), Vector2(20, 20))) == view, "nonfinite safe area falls back")
	check(Layout.usable_rect(view, Rect2(-10, 24, 600, 1000)) == Rect2(0, 24, 540, 936), "safe area clipped to viewport")
	# Android physical coordinates must be converted before intersection.
	var transform_to_view := Transform2D(Vector2(2, 0), Vector2(0, 2), Vector2(10, 20))
	var physical := Rect2(34, 68, 1032, 1800)
	var converted: Rect2 = transform_to_view.affine_inverse() * physical
	check(Layout.usable_rect(view, converted) == Rect2(12, 24, 516, 900), "scaled and offset physical safe area conversion")
	for size_value in [Vector2(360, 640), Vector2(400, 720), Vector2(480, 800), Vector2(540, 960), Vector2(600, 1100), Vector2(768, 1024)]:
		var bounds := Rect2(Vector2.ZERO, size_value)
		var areas: Dictionary = Layout.regions(size_value)
		var previous_end: float = 0.0
		for key in ["header", "status", "arena", "footer"]:
			var area: Rect2 = areas[key]
			check(area.has_area() and enclosed(bounds, area) and area.position.y >= previous_end, "nonoverlapping safe region %s at %s" % [key, size_value])
			previous_end = area.end.y
		check(enclosed(bounds, areas["modal"]), "modal within safe region")
		var arena: Rect2 = areas["arena"]
		var camera_width: float = Layout.camera_width(arena.size)
		check(camera_width >= 10.2 and camera_width * arena.size.y / arena.size.x >= 6.7999, "projection fits arena and actor height")
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await get_tree().process_frame
	lab.paused = false
	lab._update_buttons()
	var frozen: Array = gameplay(lab)
	# Simulate asymmetric insets in the actual scene, without querying Android.
	for candidate in [Rect2(0, 0, 540, 960), Rect2(20, 36, 500, 876), Rect2(80, 100, 360, 640)]:
		lab.safe_area_override = candidate
		lab._update_layout()
		await get_tree().process_frame
		check(lab.safe_rect == candidate, "real HUD accepts logical diagnostic safe area")
		for control in [lab.pause_button, lab.replay, lab.position_button, lab.status_panel, lab.rules_scroll, lab.render_box]:
			check(enclosed(candidate, control.get_global_rect()), "major controls and arena inside asymmetric safe area")
		check(not lab.status_panel.get_global_rect().intersects(lab.render_box.get_global_rect()) and not lab.rules_scroll.get_global_rect().intersects(lab.render_box.get_global_rect()), "readout and rules do not cover arena")
		for index in range(3):
			for button in [lab.edit_buttons[index], lab.toggle_buttons[index], lab.up_buttons[index], lab.down_buttons[index]]:
				check(button.size.x >= 48 and button.size.y >= 48, "touch targets at least 48 logical pixels")
				check(button.pressed.get_connections().size() == 1, "one signal connection after layout/reparent")
		lab.edit_buttons[0].pressed.emit()
		await get_tree().process_frame
		check(enclosed(candidate, lab.panel.get_global_rect()) and enclosed(candidate, lab.apply_button.get_global_rect()) and enclosed(candidate, lab.cancel_button.get_global_rect()), "modal and fixed commands inside safe area")
		check(not lab.form_scroll.get_global_rect().intersects(lab.apply_button.get_global_rect()), "scrolling fields do not cover fixed commands")
		lab.cancel_button.pressed.emit()
		check(gameplay(lab) == frozen, "layout and modal inspection do not advance gameplay")
		lab.paused = false
		lab._update_buttons()
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	await check_last_rule(lab, "last rule fully reachable")
	# Force a minimum taller than the original hardcoded 72 px.
	for button in lab.edit_buttons:
		button.add_theme_font_size_override("font_size", 24)
	await check_last_rule(lab, "larger multiline minimum fully reachable")
	for button in lab.edit_buttons:
		button.add_theme_font_size_override("font_size", 16)
	await check_last_rule(lab, "normal font restored and reachable")
	var was_enabled: bool = lab.editor.snapshot()[2].enabled
	lab.toggle_buttons[2].pressed.emit()
	check(lab.editor.snapshot()[2].enabled != was_enabled, "scrolled control still edits once")
	lab.toggle_buttons[2].pressed.emit()
	# Readout is sourced from runtime values, including pause and replay.
	lab._next_placement()
	check(lab.health_label.text.contains("40 / 100") and lab.health_bar.value == 40 and lab.health_bar.max_value == 100, "health readout matches injured scenario")
	lab._physics_process(0.02)
	check(lab.energy_bar.value == 40 and lab.action_label.text.contains("Soin"), "energy and committed action readout")
	lab.edit_buttons[0].pressed.emit()
	lab._adjust_threshold(-1)
	lab.apply_button.pressed.emit()
	check(lab.paused and lab.get_node("HUD/Description").text.contains("PAUSE") and lab.editor.snapshot()[0].threshold == 49, "editing still applies and stays visibly paused")
	frozen = gameplay(lab)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and gameplay(lab) == frozen, "background leaves explicit pause")
	for repeat in range(10):
		lab._reset()
		lab._update_layout()
		await get_tree().process_frame
	var current: Array = [lab.simulation.hero]
	current.append_array(lab.simulation.enemies)
	var actor_count: int = 0
	var current_only: bool = true
	for child in lab.world.get_children():
		if child is Actor:
			actor_count += 1
			current_only = current_only and child in current
	check(actor_count == 4 and current_only and lab.edit_buttons.size() == 3, "ten resets have no actor or row duplicates")
	check(lab.paused and lab.editor.snapshot()[0].threshold == 49 and lab.energy_bar.value == 60, "replay preserves configuration and refreshes readout")
	# Compare real combats against the unchanged STEP-020 laboratory.
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
		identical = identical and gameplay(lab) == gameplay(reference)
		if lab.simulation.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(identical and lab.simulation.result == "VICTOIRE", "HUD has identical combat timeline to STEP-020")
	check(lab.get_node("HUD/Description").text.contains("VICTOIRE") and lab.action_label.text.contains("termine"), "terminal state visible")
	lab.queue_free()
	reference.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-021 / tests HUD portrait\n%s : %d controles, %d echecs\nZones sures, defilement, lecture et combat.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = summary_text
	add_child(label)
