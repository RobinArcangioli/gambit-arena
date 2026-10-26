extends Node
const Lab = preload("res://scenes/platform/application_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("ApplicationLifecycle: " + message)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func snapshot(lab: Node) -> Array:
	var sim = lab.simulation
	var values: Array = [sim.run_id, sim.elapsed, sim.spawned, sim.defeated, sim.hits, sim.wave_number, sim.wave.issued, sim.wave.credit, sim.manual.snapshot(), sim.manual.submitted, sim.manual.launched, sim.controller.trace.total, sim.final_report]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		values.append([actor.combat_id, actor.position, actor.gait, actor.state.health, actor.action.energy, actor.action.elapsed, actor.action.action_id, actor.action.active, actor.action.spent, actor.action.accepted, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return values

func mouse(at: Vector2, down: bool, device_id: int = 0) -> void:
	var event := InputEventMouseButton.new()
	event.position = at
	event.global_position = at
	event.device = device_id
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
	event.pressed = down
	get_viewport().push_input(event, true)

func click(at: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)
	mouse(at, true)
	mouse(at, false)

func finger(at: Vector2, down: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = at
	event.pressed = down
	get_viewport().push_input(event, true)
	mouse(at, down, -1)

func drag(at: Vector2, offset: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = at
	event.relative = offset
	get_viewport().push_input(event, true)

func lose(lab: Node) -> void:
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab.notification(NOTIFICATION_APPLICATION_PAUSED)

func regain(lab: Node) -> void:
	lab.notification(NOTIFICATION_APPLICATION_RESUMED)
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)

func _ready() -> void:
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await settle()
	get_viewport().notify_mouse_entered()
	for index in range(3):
		if lab.editor.snapshot()[index].enabled:
			lab.editor.toggle(index)
	# Repeated loss/return in both orders, during a paid action with a queued heal.
	for cycle in range(10):
		regain(lab)
		lab.paused = false
		lab.application_guard.acknowledge_resume()
		lab.application_guard.consume_return_step()
		lab._update_buttons()
		lab._reset()
		await settle()
		lab.simulation.add_enemy(Vector2(0.8, 0))
		lab.simulation.hero.state.damage(20)
		var executor = lab.simulation.hero.action
		check(executor.request(&"special", lab.simulation.enemies[0]) > 0, "paid action engaged before background")
		executor.advance(0.25)
		check(lab.simulation.request_manual(&"heal"), "manual command queued before background")
		var frozen: Array = snapshot(lab)
		if cycle % 2 == 0:
			lose(lab)
		else:
			lab.notification(NOTIFICATION_APPLICATION_PAUSED)
			lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
		lose(lab)
		check(lab.paused and lab.simulation.clock.paused and lab.application_guard.blocked, "duplicate notifications keep one paused state")
		lab._toggle_pause()
		lab._reset()
		for tick in range(30):
			lab._physics_process(100)
		check(snapshot(lab) == frozen and lab.paused, "background cannot resume/reset or advance gameplay / %d" % cycle)
		lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN if cycle % 2 == 0 else NOTIFICATION_APPLICATION_RESUMED)
		check(lab.application_guard.blocked, "one missing return notification keeps input blocked")
		lab.notification(NOTIFICATION_APPLICATION_RESUMED if cycle % 2 == 0 else NOTIFICATION_APPLICATION_FOCUS_IN)
		await settle()
		lab._physics_process(100)
		check(not lab.application_guard.blocked and lab.paused and snapshot(lab) == frozen, "return never resumes automatically")
		click(lab.pause_button.get_global_rect().get_center())
		check(not lab.paused and not lab.application_guard.resume_required, "fresh click explicitly resumes")
		lab._physics_process(100)
		check(snapshot(lab) == frozen, "first post-return delta discarded without catch-up")
		lab._physics_process(0.01)
		check(is_equal_approx(lab.simulation.elapsed, 0.01) and is_equal_approx(executor.elapsed, 0.26) and executor.spent == 30 and executor.accepted == 1 and lab.simulation.manual.pending, "next small tick resumes exactly once without repayment")
	# Desktop-style focus loss without mobile suspension also has a complete return path.
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	check(lab.paused and not lab.application_guard.blocked, "focus-only roundtrip stays paused and can resume")
	lab._toggle_pause()
	lab._physics_process(0.01)
	lab.notification(NOTIFICATION_APPLICATION_PAUSED)
	lab.notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and not lab.application_guard.blocked, "suspension-only roundtrip stays paused and can resume")
	lab._toggle_pause()
	lab._physics_process(0.01)
	# Old mouse release on Reprendre must never resume after background.
	lab._toggle_pause()
	var pause_at: Vector2 = lab.pause_button.get_global_rect().get_center()
	mouse(pause_at, true)
	lose(lab)
	regain(lab)
	mouse(pause_at, false)
	check(lab.paused, "orphan mouse release cannot resume")
	click(pause_at)
	check(not lab.paused, "fresh mouse click remains usable")
	lab._physics_process(0.01)
	lab._reset()
	await settle()
	lab.simulation.hero.state.damage(20)
	lab._show_skills(true)
	await settle()
	var card_at: Vector2 = lab.skill_cards[1].get_global_rect().get_center()
	var submitted: int = lab.simulation.manual.submitted
	finger(card_at, true)
	lose(lab)
	regain(lab)
	finger(card_at, false)
	check(lab.paused and lab.simulation.manual.submitted == submitted, "old touch and emulated mouse release cannot command")
	click(lab.pause_button.get_global_rect().get_center())
	lab._physics_process(0.01)
	finger(card_at, true)
	finger(card_at, false)
	check(lab.simulation.manual.submitted == submitted + 1, "fresh touch commands exactly once after return")
	# Swipe remains available after the barrier, with no command from its release.
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	lab._update_layout()
	await settle()
	lab.skills_scroll.scroll_vertical = 0
	await settle()
	card_at = lab.skill_cards[1].get_global_rect().get_center()
	submitted = lab.simulation.manual.submitted
	finger(card_at, true)
	drag(card_at + Vector2(0, -56), Vector2(0, -56))
	finger(card_at + Vector2(0, -56), false)
	await settle()
	check(lab.skills_scroll.scroll_vertical > 0 and lab.simulation.manual.submitted == submitted, "fresh swipe still scrolls without commanding")
	# Modal draft and pause survive; returning must not apply or close it.
	lab._show_skills(false)
	lab._open_editor(0)
	lab._adjust_threshold(1)
	var saved_draft: Dictionary = lab.draft.duplicate(true)
	lose(lab)
	regain(lab)
	lab._toggle_pause()
	await settle()
	check(lab.editing_index == 0 and lab.overlay.visible and lab.draft == saved_draft and lab.paused, "editor draft preserved and cannot resume behind modal")
	check(lab.safe_rect == lab.safe_area_override, "safe area recalculated on return")
	lab._cancel_editor()
	check(lab.paused, "closing modal does not auto-resume")
	# Replaying after return keeps pause and clears old actions/queue; then explicit resume.
	var previous_run: int = lab.simulation.run_id
	lab._reset()
	await settle()
	check(lab.simulation.run_id == previous_run + 1 and lab.paused and lab.simulation.enemies.is_empty() and not lab.simulation.manual.pending, "replay after return stays paused with clean run")
	lab._toggle_pause()
	lab._physics_process(100)
	check(lab.simulation.elapsed == 0, "replay does not consume old return delta")
	lab._physics_process(0.01)
	check(is_equal_approx(lab.simulation.elapsed, 0.01), "new run resumes on next normal tick")
	# Defeat remains terminal across background, resume and a Reprendre click.
	lab.simulation.hero.state.damage(1000000)
	lab._physics_process(0.01)
	var terminal: Array = snapshot(lab)
	lose(lab)
	regain(lab)
	click(lab.pause_button.get_global_rect().get_center())
	lab._physics_process(100)
	check(snapshot(lab) == terminal and lab.simulation.result == "DEFAITE" and lab.get_node("HUD/Description").text == "DEFAITE", "terminal report survives return without resurrection")
	lab.queue_free()
	await settle()
	var summary_text: String = "STEP-027 / pause et retour application\n%s : %d controles, %d echecs\nNotifications, gestes et reprise explicite.\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	add_child(label)
