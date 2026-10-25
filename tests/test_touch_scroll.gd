extends Node
## Inject events into the real viewport: do not bypass GUI routing via callbacks.
const Lab = preload("res://scenes/waves/wave_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("TouchScroll: " + message)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func mouse_button(at: Vector2, pressed_value: bool, button: MouseButton = MOUSE_BUTTON_LEFT, device_id: int = 0) -> void:
	var event := InputEventMouseButton.new()
	event.device = device_id
	event.position = at
	event.global_position = at
	event.button_index = button
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed_value and button == MOUSE_BUTTON_LEFT else 0
	event.pressed = pressed_value
	get_viewport().push_input(event, true)

func finger(at: Vector2, pressed_value: bool, canceled_value: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = at
	event.pressed = pressed_value
	event.canceled = canceled_value
	get_viewport().push_input(event, true)
	# Android's emulated mouse stream must neither duplicate taps nor revive a swipe.
	mouse_button(at, pressed_value, MOUSE_BUTTON_LEFT, -1)

func drag(at: Vector2, relative_value: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = at
	event.relative = relative_value
	get_viewport().push_input(event, true)

func tap(at: Vector2) -> void:
	finger(at, true)
	finger(at, false)

func swipe(at: Vector2, movement: Vector2) -> void:
	finger(at, true)
	drag(at + movement * 0.5, movement * 0.5)
	drag(at + movement, movement * 0.5)
	finger(at + movement, false)

func rules_state(lab: Node) -> Array:
	var values: Array = []
	for rule in lab.editor.snapshot():
		values.append([rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill])
	return values

func _ready() -> void:
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	# Force scrollable lists at the supported small safe-area size.
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	lab._update_layout()
	lab.paused = false
	lab._update_buttons()
	await settle()
	get_viewport().notify_mouse_entered()
	var count: int = lab.simulation.manual.submitted
	var start: Vector2 = lab.skill_cards[1].get_global_rect().get_center()
	check(lab.skills_scroll.get_global_rect().has_point(start), "skill gesture starts in visible viewport")
	swipe(start, Vector2(0, -48))
	check(lab.skills_scroll.scroll_vertical > 0 and lab.simulation.manual.submitted == count, "swipe starting on skill scrolls without command")
	await settle()
	# Blank gap between the first two columns also passes touch through its content.
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	start = lab.skill_cards[0].get_global_rect().position + Vector2(lab.skill_cards[0].size.x + 4, 50)
	swipe(start, Vector2(0, -40))
	check(lab.skills_scroll.scroll_vertical > 0 and lab.simulation.manual.submitted == count, "blank-space swipe reaches parent scroll container")
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	start = lab.skill_cards[1].get_global_rect().get_center()
	tap(start)
	check(lab.simulation.manual.submitted == count + 1 and lab.simulation.manual.snapshot().get("skill", "") == "heal", "short touch sends exactly one manual command")
	# A small jitter stays below the gesture deadzone and is still a tap.
	count = lab.simulation.manual.submitted
	finger(start, true)
	drag(start + Vector2(0, -3), Vector2(0, -3))
	finger(start + Vector2(0, -3), false)
	check(lab.simulation.manual.submitted == count + 1, "small finger jitter preserves short tap")
	count = lab.simulation.manual.submitted
	finger(start, true)
	drag(start + Vector2(0, -30), Vector2(0, -30))
	drag(start, Vector2(0, 30))
	finger(start, false)
	check(lab.simulation.manual.submitted == count, "swipe back to initial button never reactivates canceled tap")
	# Cancellation (e.g. interrupted touch) must not trigger a command.
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	start = lab.skill_cards[1].get_global_rect().get_center()
	finger(start, true)
	drag(start + Vector2(0, -30), Vector2(0, -30))
	finger(start + Vector2(0, -30), false, true)
	check(lab.simulation.manual.submitted == count, "canceled swipe does not launch")
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	start = lab.skill_cards[1].get_global_rect().get_center()
	count = lab.simulation.manual.submitted
	finger(start, true)
	finger(start, false, true)
	check(lab.simulation.manual.submitted == count, "canceled short touch never activates")
	# A second finger cannot turn the first touch into a command.
	finger(start, true)
	var second := InputEventScreenTouch.new()
	second.index = 1
	second.position = start + Vector2(10, 0)
	second.pressed = true
	get_viewport().push_input(second, true)
	second.pressed = false
	get_viewport().push_input(second, true)
	finger(start, false)
	check(lab.simulation.manual.submitted == count, "second finger cancels tap activation")
	# Physical mouse remains usable with the touch router.
	count = lab.simulation.manual.submitted
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	start = lab.skill_cards[1].get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = start
	motion.global_position = start
	get_viewport().push_input(motion, true)
	mouse_button(start, true)
	mouse_button(start, false)
	check(lab.simulation.manual.submitted == count + 1, "mouse click remains exactly one command")
	mouse_button(start, true, MOUSE_BUTTON_WHEEL_DOWN)
	mouse_button(start, false, MOUSE_BUTTON_WHEEL_DOWN)
	check(lab.skills_scroll.scroll_vertical > 0, "mouse wheel still scrolls skill list")
	# Switch by real touch, then drag across an edit button.
	tap(lab.gambits_tab.get_global_rect().get_center())
	await settle()
	check(not lab.skills_visible and lab.rules_scroll.visible, "short touch switches tabs")
	var before_rules: Array = rules_state(lab)
	start = lab.edit_buttons[0].get_global_rect().get_center()
	swipe(start, Vector2(0, -40))
	check(lab.rules_scroll.scroll_vertical > 0 and lab.editing_index == -1 and rules_state(lab) == before_rules, "swipe on gambit summary scrolls without opening editor")
	lab.rules_scroll.scroll_vertical = 0
	await settle()
	start = lab.toggle_buttons[0].get_global_rect().get_center()
	swipe(start, Vector2(0, -35))
	check(lab.rules_scroll.scroll_vertical > 0 and rules_state(lab) == before_rules, "swipe on toggle does not change rule")
	lab.rules_scroll.scroll_vertical = 0
	await settle()
	start = lab.down_buttons[0].get_global_rect().get_center()
	swipe(start, Vector2(0, -35))
	check(rules_state(lab) == before_rules, "swipe on priority button does not reorder")
	lab.rules_scroll.scroll_vertical = 0
	await settle()
	tap(lab.toggle_buttons[0].get_global_rect().get_center())
	check(lab.editor.snapshot()[0].enabled != before_rules[0][0], "short touch still toggles rule")
	lab.safe_area_override = Rect2(80, 100, 360, 520)
	lab._update_layout()
	await settle()
	tap(lab.edit_buttons[0].get_global_rect().get_center())
	await settle()
	check(lab.editing_index == 0 and lab.paused, "short touch opens modal and pauses")
	var draft_before: Dictionary = lab.draft.duplicate(true)
	start = lab.target_button.get_global_rect().get_center()
	swipe(start, Vector2(0, -50))
	check(lab.form_scroll.scroll_vertical > 0 and lab.draft == draft_before, "form also scrolls without changing touched field")
	tap(lab.cancel_button.get_global_rect().get_center())
	await settle()
	check(lab.editing_index == -1 and lab.paused, "cancel remains accessible and keeps pause")
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	lab._update_layout()
	await settle()
	tap(lab.skills_tab.get_global_rect().get_center())
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	var queue: Dictionary = lab.simulation.manual.snapshot()
	start = lab.skill_cards[1].get_global_rect().get_center()
	swipe(start, Vector2(0, -45))
	check(lab.skills_scroll.scroll_vertical > 0 and lab.simulation.manual.snapshot() == queue, "scroll works during pause without changing command")
	# Reach the end through touch input, not direct scrollbar assignment.
	for repeat in range(30):
		start = lab.skills_scroll.get_global_rect().position + Vector2(20, lab.skills_scroll.size.y - 12)
		swipe(start, Vector2(0, -64))
		await settle()
	var bar: VScrollBar = lab.skills_scroll.get_v_scroll_bar()
	check(absf(bar.value - (bar.max_value - bar.page)) <= 1.0 and lab.skill_details.get_global_rect().end.y <= lab.skills_scroll.get_global_rect().end.y + 0.01, "last skill detail reachable through repeated swipes")
	var lower_value: int = lab.skills_scroll.scroll_vertical
	start = lab.skills_scroll.get_global_rect().position + Vector2(20, 20)
	swipe(start, Vector2(0, 50))
	check(lab.skills_scroll.scroll_vertical < lower_value, "downward swipe scrolls back toward top")
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	lab.paused = false
	lab._update_buttons()
	count = lab.simulation.manual.submitted
	start = lab.skill_cards[1].get_global_rect().get_center()
	finger(start, true)
	lab._reset()
	finger(start, false)
	check(lab.simulation.manual.submitted == 0, "replay cancels a touch held on a command")
	finger(start, true)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab.touch_router.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	finger(start, false)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.simulation.manual.submitted == 0 and lab.paused, "interrupted gesture cannot activate on background return")
	lab.paused = false
	lab._update_buttons()
	tap(start)
	check(lab.simulation.manual.submitted == 1, "fresh tap works after interrupted gesture")
	lab.queue_free()
	await settle()
	var summary_text: String = "FIX-STEP-023-001 / swipe tactile\n%s : %d controles, %d echecs\nGestes via viewport, appuis, molette et formulaire.\nConfirmer aussi sur Android ; F8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	label.add_theme_font_size_override("font_size", 18)
	add_child(label)
