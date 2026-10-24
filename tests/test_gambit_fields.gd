extends Node
const Editor = preload("res://scripts/gambits/gambit_editor.gd")
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Actor = preload("res://scripts/hybrid/proxy_actor.gd")
const Lab = preload("res://scenes/gambits/gambit_fields_lab.tscn")
var checks: int = 0
var failures: int = 0
var notifications: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("GambitFields: " + message)

func on_change() -> void:
	notifications += 1

func signature(rules: Array) -> Array:
	var result: Array = []
	for rule in rules:
		result.append([rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill])
	return result

func gameplay(lab: Node) -> Array:
	var sim = lab.simulation
	var result: Array = [sim.elapsed, sim.hits, sim.controller.launched, sim.controller.evaluations]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		result.append([actor.position, actor.state.health, actor.gait, actor.action.action_id, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return result

func fields(target: String, condition: String, threshold: int, skill: String) -> Dictionary:
	return {"target": target, "condition": condition, "threshold": threshold, "skill": skill}

func _ready() -> void:
	var model := Editor.new()
	model.changed.connect(on_change)
	var original: Array = signature(model.snapshot())
	var malformed: Array[Dictionary] = [{}, {"target": "self"}]
	for value in [-1, 101, 50.0, "50", true, null, NAN, INF]:
		var candidate: Dictionary = fields("self", "hp_below", 50, "heal")
		candidate["threshold"] = value
		malformed.append(candidate)
	for pair in [["target", "ally"], ["target", 0], ["condition", "unknown"], ["condition", false], ["skill", "paid_test"], ["skill", null]]:
		var candidate: Dictionary = fields("self", "hp_below", 50, "heal")
		candidate[pair[0]] = pair[1]
		malformed.append(candidate)
	var extra: Dictionary = fields("self", "hp_below", 50, "heal")
	extra["enabled"] = false
	malformed.append(extra)
	for invalid in malformed:
		check(not Editor.validate_fields(invalid).is_empty() and not model.update_fields(0, invalid), "invalid payload refused atomically")
	check(notifications == 0 and signature(model.snapshot()) == original, "invalid edits have no mutation or notification")
	check(not model.update_fields(-1, fields("self", "always", 0, "heal")) and not model.update_fields(3, fields("self", "always", 0, "heal")), "invalid row refused")
	for target in ["self", "enemy"]:
		for condition in ["always", "hp_below"]:
			for skill in ["heal", "basic", "special"]:
				for threshold in [0, 1, 50, 99, 100]:
					var candidate: Dictionary = fields(target, condition, threshold, skill)
					var expected: bool = (target == "self" and skill == "heal") or (target == "enemy" and skill != "heal")
					check(Editor.validate_fields(candidate).is_empty() == expected, "compatibility and threshold boundaries")
	model.toggle(0)
	var replacement: Dictionary = fields("enemy", "hp_below", 25, "special")
	check(model.update_fields(0, replacement) and notifications == 2, "accepted replacement emits exactly once")
	check(not model.snapshot()[0].enabled and signature(model.snapshot())[1] == original[1] and signature(model.snapshot())[2] == original[2], "enabled flag, other rows and order preserved")
	check(model.update_fields(0, replacement) and notifications == 2, "unchanged save emits nothing")
	replacement["threshold"] = 99
	check(model.snapshot()[0].threshold == 25, "caller dictionary cannot mutate stored rule")
	model.move(0, 1)
	check(model.snapshot()[1].threshold == 25 and not model.snapshot()[1].enabled, "edited fields follow reorder")
	# Evaluator boundary: condition is on selected target, strict and unrounded.
	var view := Snapshot.new()
	view.source = {"id": 1, "health": 100, "max_health": 100, "position": Vector2.ZERO}
	view.enemies.append({"id": 2, "health": 50, "max_health": 100, "position": Vector2(0.9, 0)})
	var selective := Editor.new()
	selective.toggle(1)
	selective.toggle(2)
	selective.update_fields(0, fields("enemy", "hp_below", 50, "basic"))
	check(Evaluator.evaluate(selective.snapshot(), view)["kind"] == "none", "exact 50 percent does not satisfy below 50")
	view.enemies[0]["health"] = 49
	check(Evaluator.evaluate(selective.snapshot(), view)["target_id"] == 2, "enemy health, not hero health, matches threshold")
	selective.update_fields(0, fields("enemy", "hp_below", 0, "basic"))
	check(Evaluator.evaluate(selective.snapshot(), view)["kind"] == "none", "zero threshold never matches living target")
	selective.update_fields(0, fields("enemy", "hp_below", 100, "basic"))
	check(Evaluator.evaluate(selective.snapshot(), view)["target_id"] == 2, "100 threshold matches injured target")
	view.enemies[0]["health"] = 100
	check(Evaluator.evaluate(selective.snapshot(), view)["kind"] == "none", "100 threshold excludes full health")
	selective.update_fields(0, fields("enemy", "always", 0, "basic"))
	check(Evaluator.evaluate(selective.snapshot(), view)["target_id"] == 2, "always ignores threshold")
	selective.update_fields(0, fields("self", "always", 100, "heal"))
	check(Evaluator.evaluate(selective.snapshot(), view)["kind"] == "none", "always heal still rejects full health")
	view.source["health"] = 99
	check(Evaluator.evaluate(selective.snapshot(), view)["skill"] == "heal", "edited self heal works")
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await get_tree().process_frame
	lab.paused = false
	lab._update_buttons()
	original = signature(lab.editor.snapshot())
	var frozen: Array = gameplay(lab)
	lab.edit_buttons[0].pressed.emit()
	check(lab.paused and lab.overlay.visible and lab.editing_index == 0, "row opens modal and pauses")
	lab.target_button.pressed.emit()
	check(lab.apply_button.disabled and not lab.explanation_label.text.is_empty(), "incompatible target displays error and disables apply")
	lab._save_editor()
	lab._toggle_pause()
	lab._reset()
	lab._next_placement()
	lab._move_rule(0, 1)
	lab._toggle_rule(0)
	lab._physics_process(10.0)
	check(gameplay(lab) == frozen and signature(lab.editor.snapshot()) == original and lab.editing_index == 0, "modal blocks background mutations and invalid save")
	lab.cancel_button.pressed.emit()
	check(lab.paused and not lab.overlay.visible and lab.draft.is_empty() and signature(lab.editor.snapshot()) == original, "cancel discards draft and keeps pause")
	lab.edit_buttons[0].pressed.emit()
	lab.condition_button.pressed.emit()
	lab._adjust_threshold(5)
	check(lab.draft["threshold"] == 50 and lab.threshold_buttons[0].disabled, "always disables threshold edits without losing value")
	lab.target_button.pressed.emit()
	lab.skill_button.pressed.emit()
	check(not lab.apply_button.disabled, "changing both target and action creates valid draft")
	check(signature(lab.editor.snapshot()) == original, "valid draft still has no effect before apply")
	notifications = 0
	lab.editor.changed.connect(on_change)
	lab.apply_button.pressed.emit()
	check(notifications == 1 and lab.paused and lab.editing_index == -1 and lab.editor.snapshot()[0].skill == "special" and lab.editor.snapshot()[0].condition == "always", "apply publishes all fields once and stays paused")
	check(signature(lab.editor.snapshot()) == signature(lab.simulation.controller.rules), "controller receives validated copy")
	check(lab.edit_buttons[0].text.contains("Speciale") and lab.edit_buttons[0].text.contains("toujours"), "summary reflects actual fields")
	lab.edit_buttons[1].pressed.emit()
	lab.condition_button.pressed.emit()
	for repeat in range(30):
		lab._adjust_threshold(-5)
	check(lab.draft["threshold"] == 0 and lab.threshold_buttons[0].disabled, "touch controls clamp lower bound")
	for repeat in range(30):
		lab._adjust_threshold(5)
	lab._adjust_threshold(-1)
	check(lab.draft["threshold"] == 99, "touch supports single percent steps")
	lab._adjust_threshold(1)
	check(lab.draft["threshold"] == 100 and lab.threshold_buttons[3].disabled, "touch controls clamp upper bound")
	lab.apply_button.pressed.emit()
	check(lab.editor.snapshot()[1].threshold == 100 and lab.edit_buttons[1].text.contains("100"), "threshold committed and displayed")
	# At full hero health, row zero (special/always) supplies an approach intent.
	lab._toggle_pause()
	lab.simulation.controller.plan(0.02, lab.simulation.hero, lab.simulation.enemies, lab.simulation.clock)
	var pending: Dictionary = lab.simulation.controller.decision
	check(pending.get("skill") == "special", "pending intention before modal edit")
	lab.edit_buttons[0].pressed.emit()
	lab.apply_button.pressed.emit()
	check(lab.simulation.controller.decision == pending, "unchanged save preserves pending intention")
	lab.edit_buttons[0].pressed.emit()
	lab.condition_button.pressed.emit()
	lab._adjust_threshold(-5)
	lab.cancel_button.pressed.emit()
	check(lab.simulation.controller.decision == pending, "cancel preserves pending intention")
	lab.edit_buttons[0].pressed.emit()
	lab.condition_button.pressed.emit()
	lab.apply_button.pressed.emit()
	check(lab.simulation.controller.decision.is_empty() and lab.simulation.hero.mover.target == null, "changed fields invalidate pending action and movement")
	# Restore a low-health self heal through the public transaction for action test.
	lab.editor.update_fields(0, fields("self", "hp_below", 50, "heal"))
	lab._toggle_pause()
	lab._next_placement()
	lab._physics_process(0.02)
	check(lab.simulation.hero.action.last_skill == &"heal" and lab.simulation.hero.action.active, "injured scenario engages heal")
	var action_id: int = lab.simulation.hero.action.action_id
	lab.edit_buttons[0].pressed.emit()
	frozen = gameplay(lab)
	lab._adjust_threshold(-5)
	lab.apply_button.pressed.emit()
	check(gameplay(lab) == frozen and lab.simulation.hero.action.action_id == action_id and lab.simulation.hero.action.active, "field edit preserves already engaged action and costs")
	lab._toggle_pause()
	for tick in range(37):
		lab._physics_process(1.0 / 60.0)
	check(lab.simulation.hero.action.applied_healing == 30 and lab.simulation.hero.action.spent == 20, "engaged heal resolves once after edit")
	lab.edit_buttons[2].pressed.emit()
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	frozen = gameplay(lab)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and lab.overlay.visible and gameplay(lab) == frozen, "background retains draft and explicit pause")
	lab.cancel_button.pressed.emit()
	var saved: Array = signature(lab.editor.snapshot())
	for repeat in range(10):
		lab.edit_buttons[0].pressed.emit()
		lab.cancel_button.pressed.emit()
		lab._reset()
		await get_tree().process_frame
	var actors: Array = [lab.simulation.hero]
	actors.append_array(lab.simulation.enemies)
	var count: int = 0
	var only_current: bool = true
	for child in lab.simulation.world.get_children():
		if child is Actor:
			count += 1
			only_current = only_current and child in actors
	check(count == 4 and only_current and lab.edit_buttons.size() == 3, "ten modal/reset cycles without actor or row duplicates")
	check(lab.paused and signature(lab.editor.snapshot()) == saved and signature(lab.simulation.controller.rules) == saved, "all edited fields persist across paused resets")
	lab._toggle_pause()
	lab._next_placement()
	check(signature(lab.editor.snapshot()) == saved and signature(lab.simulation.controller.rules) == saved, "scenario changes preserve edited fields")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-020 / tests champs gambits\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = summary_text
	add_child(label)
