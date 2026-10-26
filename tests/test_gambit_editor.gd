extends Node
const Editor = preload("res://scripts/gambits/gambit_editor.gd")
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Lab = preload("res://scenes/gambits/gambit_editor_lab.tscn")
var checks: int = 0
var failures: int = 0
var notifications: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("GambitEditor: " + message)

func signature(rules: Array) -> Array:
	var values: Array = []
	for rule in rules:
		values.append([rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill])
	return values

func on_change() -> void:
	notifications += 1

func gameplay(lab: Node) -> Array:
	var sim = lab.simulation
	var values: Array = [sim.elapsed, sim.spawn_clock, sim.spawned, sim.defeated, sim.hits, sim.result, sim.controller.evaluations, sim.controller.launched]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		values.append([actor.position, actor.state.health, actor.gait, actor.action.action_id, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return values

func _ready() -> void:
	var model := Editor.new()
	model.changed.connect(on_change)
	var original: Array = signature(model.snapshot())
	check(original.size() == 3 and original[0][4] == "heal" and original[1][4] == "special" and original[2][4] == "basic", "three standard rules in order")
	var exported = model.snapshot()
	exported[0].enabled = false
	exported[1].skill = "heal"
	exported.clear()
	check(signature(model.snapshot()) == original, "snapshot cannot mutate owned rules")
	check(not model.toggle(-1) and not model.toggle(3) and not model.move(0, -1) and not model.move(2, 1) and not model.move(0, 2) and not model.move(1, 0), "invalid operations refused")
	check(notifications == 0 and signature(model.snapshot()) == original, "invalid operations do not notify or mutate")
	check(model.toggle(0) and notifications == 1, "one toggle emits once")
	check(model.move(0, 1) and notifications == 2, "one move emits once")
	var moved = model.snapshot()
	check(moved[1].skill == "heal" and not moved[1].enabled and moved[1].threshold == 50 and moved[0].skill == "special", "whole rule follows its priority including enabled state")
	var other := Editor.new()
	check(signature(other.snapshot()) == original, "independent editor instances")
	var stable: bool = true
	for repeat in range(1000):
		model.move(1, -1)
		model.move(0, 1)
		var current = model.snapshot()
		stable = stable and current.size() == 3 and current[0].skill == "special" and current[1].skill == "heal" and not current[1].enabled and current[2].skill == "basic"
	check(stable, "1000 round trips without duplicates or lost fields")
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	await get_tree().process_frame
	lab.paused = false
	lab._update_buttons()
	check(lab.row_labels.size() == 3 and lab.toggle_buttons.size() == 3 and lab.up_buttons[0].disabled and lab.down_buttons[2].disabled, "real three-row UI and disabled boundary controls")
	check(lab.toggle_buttons[0].size.y >= 48 and lab.up_buttons[1].size.x >= 48, "touch targets at least 48 logical pixels")
	# In the injured scenario, enabling a higher rule must invalidate a pending
	# basic even though the selected basic Resource has not changed its fields.
	lab._next_placement()
	check(lab.mode_index == 1 and lab.simulation.hero.state.health == 40, "injured scenario")
	lab.toggle_buttons[0].pressed.emit()
	lab.toggle_buttons[1].pressed.emit()
	lab.simulation.controller.plan(0.02, lab.simulation.hero, lab.simulation.enemies, lab.simulation.clock)
	check(lab.simulation.controller.decision.get("skill") == "basic", "basic pending while higher rules disabled")
	var before_edit: Array = gameplay(lab)
	lab.toggle_buttons[0].pressed.emit()
	check(lab.simulation.controller.decision.is_empty() and lab.simulation.hero.mover.target == null and gameplay(lab) == before_edit, "enable higher row clears intention without changing gameplay")
	check(lab.simulation.controller.execute(lab.simulation.hero, lab.simulation.enemies, lab.simulation.clock) == 0, "old intention cannot commit after edit")
	lab._physics_process(0.02)
	check(lab.simulation.hero.action.active and lab.simulation.hero.action.last_skill == &"heal" and lab.simulation.hero.action.spent == 20, "next tick chooses newly enabled higher heal")
	var locked_id: int = lab.simulation.hero.action.action_id
	lab._toggle_pause()
	var frozen: Array = gameplay(lab)
	lab.down_buttons[0].pressed.emit()
	check(lab.editor.snapshot()[1].skill == "heal" and lab.row_labels[1].text.contains("Soin"), "UI reorder moves displayed rule")
	lab.toggle_buttons[1].pressed.emit()
	lab.toggle_buttons[2].pressed.emit()
	check(gameplay(lab) == frozen and lab.simulation.hero.action.action_id == locked_id and lab.simulation.hero.action.active, "paused edits preserve engaged action, health, energy and cooldowns")
	lab._physics_process(10.0)
	check(gameplay(lab) == frozen, "pause has no catch-up during editing")
	check(not lab.editor.snapshot()[0].enabled and not lab.editor.snapshot()[1].enabled and not lab.editor.snapshot()[2].enabled, "all three may be disabled")
	lab._toggle_pause()
	for tick in range(61):
		lab._physics_process(1.0 / 60.0)
	check(lab.simulation.hero.action.applied_healing == 30 and lab.simulation.hero.action.spent == 20 and lab.simulation.hero.action.accepted == 1, "committed heal finishes once despite disabled rule")
	check(not lab.simulation.hero.action.active and lab.simulation.hero.mover.target == null, "disabled rules start no next action or approach")
	var saved: Array = signature(lab.editor.snapshot())
	lab._reset()
	check(signature(lab.simulation.controller.rules) == saved, "replay preserves order and activation")
	var start: Vector3 = lab.simulation.hero.position
	for tick in range(60):
		lab._physics_process(1.0 / 60.0)
	check(lab.simulation.hero.position == start and lab.simulation.hero.action.accepted == 0, "fresh combat with all rules off leaves hero idle")
	# Move basic above a valid heal, then back below it: selection follows order.
	lab._reset()
	lab.toggle_buttons[1].pressed.emit()
	lab.toggle_buttons[2].pressed.emit()
	lab.up_buttons[2].pressed.emit()
	lab.up_buttons[1].pressed.emit()
	lab.simulation.controller.plan(0.02, lab.simulation.hero, lab.simulation.enemies, lab.simulation.clock)
	check(lab.simulation.controller.decision.get("skill") == "basic" and lab.simulation.controller.decision.get("rule_index") == 0, "moving basic above valid heal changes selection")
	lab.down_buttons[0].pressed.emit()
	lab.down_buttons[1].pressed.emit()
	lab._physics_process(0.02)
	check(lab.simulation.hero.action.last_skill == &"heal" and lab.simulation.controller.last_rule == 1, "moving basic below heal changes next commitment")
	saved = signature(lab.editor.snapshot())
	lab._next_placement()
	check(lab.mode_index == 2 and signature(lab.simulation.controller.rules) == saved and signature(lab.editor.snapshot()) == saved, "scenario change preserves configuration")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	frozen = gameplay(lab)
	lab.up_buttons[2].pressed.emit()
	saved = signature(lab.editor.snapshot())
	lab._physics_process(5.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and gameplay(lab) == frozen, "background and return require explicit resume even after edit")
	lab.mode_index = 0
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	var expected: Array = [lab.simulation.hero]
	expected.append_array(lab.simulation.enemies)
	var actor_count: int = 0
	var current_only: bool = true
	for child in lab.simulation.world.get_children():
		if child is Actor:
			actor_count += 1
			current_only = current_only and child in expected
	check(actor_count == 4 and current_only and lab.paused, "ten paused resets retain only current actors")
	check(signature(lab.editor.snapshot()) == saved and signature(lab.simulation.controller.rules) == saved, "ten resets preserve configuration")
	check(lab.simulation.controller.trace.size() == 0 and lab.simulation.controller.launched == 0, "resets clear old trace and execution counters")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-019 / tests editeur gambits\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = summary_text
	add_child(label)
