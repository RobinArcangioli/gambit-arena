extends Node
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const Lab = preload("res://scenes/gambits/gambit_lab.tscn")
const Actor = preload("res://scripts/combat/stats_actor.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("Gambits: " + message)

func row(id: int, hp: int, at: Vector2) -> Dictionary:
	return {"id": id, "health": hp, "max_health": 100, "position": at}

func fixture() -> Snapshot:
	var view := Snapshot.new()
	view.source = row(1, 60, Vector2.ZERO)
	view.enemies = [row(3, 100, Vector2(-0.8, 0)), row(2, 100, Vector2(0.8, 0))]
	return view

func rule(skill: String, condition: String = "always") -> Rule:
	var result := Rule.new()
	result.skill = skill
	result.target = "self" if skill == "heal" else "enemy"
	result.condition = condition
	return result

func capture(view: Snapshot) -> Array:
	return [view.source.duplicate(true), view.enemies.duplicate(true), view.energy, view.heal_cooldown, view.special_cooldown, view.busy, view.paused, view.stopped]

func _ready() -> void:
	var rules: Array[Rule] = [rule("heal", "hp_below"), rule("special"), rule("basic")]
	var view := fixture()
	var original: Array = capture(view)
	var result: Dictionary = Evaluator.evaluate(rules, view)
	check(result["rule_index"] == 1 and result["skill"] == "special" and result["target_id"] == 2, "priority and stable ID tie break")
	var deterministic: bool = true
	for repeat in range(1000):
		deterministic = deterministic and Evaluator.evaluate(rules, view) == result
	check(deterministic and capture(view) == original, "1000 evaluations repeat without input mutation")
	view.enemies.reverse()
	check(Evaluator.evaluate(rules, view) == result, "enemy iteration order does not affect choice")
	result["target_id"] = 999
	check(Evaluator.evaluate(rules, view)["target_id"] == 2, "returned decision is independent")
	check(rules[0].skill == "heal" and rules[0].threshold == 50 and rules[1].enabled, "rules remain unchanged")
	view.source["health"] = 49
	result = Evaluator.evaluate(rules, view)
	check(result["rule_index"] == 0 and result["target_id"] == 1 and not result["approach"], "injured self takes priority")
	view.source["health"] = 50
	check(Evaluator.evaluate(rules, view)["rule_index"] == 1, "strict 50 percent boundary")
	view.source["max_health"] = 3
	view.source["health"] = 1
	rules[0].threshold = 33
	check(Evaluator.evaluate(rules, view)["rule_index"] == 1, "fractional HP not rounded down")
	rules[0].threshold = 34
	check(Evaluator.evaluate(rules, view)["rule_index"] == 0, "fractional HP above threshold boundary")
	rules[0].threshold = 50
	view = fixture()
	view.source["health"] = 40
	view.energy = 19
	check(Evaluator.evaluate(rules, view)["skill"] == "basic", "unaffordable rules fall through")
	view.energy = 20
	check(Evaluator.evaluate(rules, view)["skill"] == "heal", "exact energy cost allowed")
	view.heal_cooldown = 0.000001
	check(Evaluator.evaluate(rules, view)["skill"] == "basic", "positive cooldown blocks without rounding")
	view.energy = 30
	check(Evaluator.evaluate(rules, view)["skill"] == "special", "next affordable rule chosen")
	view.special_cooldown = 6.0
	check(Evaluator.evaluate(rules, view)["skill"] == "basic", "both cooldowns blocked use basic")
	view = fixture()
	rules[1].enabled = false
	check(Evaluator.evaluate(rules, view)["rule_index"] == 2, "disabled rule skipped")
	rules[1].enabled = true
	rules[1].target = "self"
	check(Evaluator.evaluate(rules, view)["rule_index"] == 2, "invalid target skill pair skipped")
	rules[1].target = "enemy"
	rules[1].condition = "unknown"
	check(Evaluator.evaluate(rules, view)["rule_index"] == 2, "unknown condition skipped")
	rules[1].condition = "always"
	rules[1].threshold = 101
	check(Evaluator.evaluate(rules, view)["rule_index"] == 2, "invalid threshold skipped")
	rules[1].threshold = 50
	var swapped: Array[Rule] = [rules[2], rules[1], rules[0]]
	check(Evaluator.evaluate(swapped, view)["skill"] == "basic", "rule ordering is priority")
	var empty: Array[Rule] = []
	check(Evaluator.evaluate(empty, view)["reason"] == "no_match", "empty list yields none")
	var null_rule: Array[Rule] = [null, rules[2]]
	check(Evaluator.evaluate(null_rule, view)["rule_index"] == 1, "null rule skipped")
	var too_many: Array[Rule] = [rules[0], rules[1], rules[2], rules[2]]
	check(Evaluator.evaluate(too_many, view)["reason"] == "invalid_input", "more than three rules rejected")
	view.enemies[0]["health"] = 0
	check(Evaluator.evaluate(rules, view)["target_id"] == 2, "dead candidate ignored")
	view.enemies[1]["health"] = 0
	check(Evaluator.evaluate(rules, view)["reason"] == "no_match", "no living targets")
	view.source["health"] = 40
	check(Evaluator.evaluate(rules, view)["skill"] == "heal", "self heal without enemies")
	view.source["health"] = 100
	rules[0].condition = "always"
	check(Evaluator.evaluate(rules, view)["kind"] == "none", "full health cannot select useless heal")
	rules[0].condition = "hp_below"
	view = fixture()
	view.enemies = [row(2, 100, Vector2(2, 0)), row(3, 20, Vector2(3, 0))]
	rules[1].condition = "hp_below"
	result = Evaluator.evaluate(rules, view)
	check(result["target_id"] == 3 and result["approach"], "filter before nearest, distant target is approach intent")
	rules[1].condition = "always"
	view.enemies = [row(2, 100, Vector2(1, 0))]
	check(not Evaluator.evaluate(rules, view)["approach"], "reach boundary inclusive")
	view.enemies[0]["position"] = Vector2(1.001, 0)
	check(Evaluator.evaluate(rules, view)["approach"], "outside reach requires approach")
	for flag in ["busy", "paused", "stopped"]:
		view = fixture()
		view.set(flag, true)
		check(Evaluator.evaluate(rules, view)["reason"] == "unavailable", "blocked source: " + flag)
	view = fixture()
	view.source["health"] = 0
	check(Evaluator.evaluate(rules, view)["reason"] == "unavailable", "dead source unavailable")
	check(Evaluator.evaluate(rules, null)["reason"] == "invalid_input", "null snapshot rejected")
	view = fixture()
	view.enemies[0]["id"] = 2
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "duplicate identities rejected")
	view = fixture()
	view.enemies[0]["id"] = 1
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "enemy cannot share source ID")
	view = fixture()
	view.source["health"] = "60"
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "wrong scalar type rejected")
	view = fixture()
	view.enemies[0]["position"] = Vector2(NAN, 0)
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "nonfinite position rejected")
	view = fixture()
	view.special_cooldown = INF
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "nonfinite cooldown rejected")
	view = fixture()
	view.source["live_reference"] = self
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "extra object reference rejected")
	view = fixture()
	view.enemies.clear()
	for index in range(20):
		view.enemies.append(row(index + 2, 100, Vector2(index + 1, 0)))
	check(Evaluator.evaluate(rules, view)["target_id"] == 2, "twenty enemies supported")
	view.enemies.append(row(22, 100, Vector2(22, 0)))
	check(Evaluator.evaluate(rules, view)["reason"] == "invalid_input", "over twenty rejected")
	# Actual lab: evaluated intentions never execute and UI shares explicit pause.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._update_buttons()
	for hz in [30, 60, 120]:
		lab._reset()
		for tick in range(hz * 2):
			lab._physics_process(1.0 / float(hz))
		check(lab.evaluations == 20, "10 Hz diagnostic cadence at %d Hz" % hz)
		check(lab.actors[0].state.health == 60 and lab.actors[1].state.health == 600 and lab.sample_energy == 60 and lab.executor.accepted == 0, "no live gameplay mutation")
	lab._command(0)
	check(lab.decision["skill"] == "heal" and lab.actors[0].state.health == 30, "wound changes intention without healing")
	lab._command(2)
	check(lab.decision["skill"] == "basic", "energy fixture changes decision")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	var count: int = lab.evaluations
	lab._physics_process(10.0)
	lab._command(0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and lab.evaluations == count and lab.actors[0].state.health == 30, "background freezes reads and diagnostic commands")
	lab._reset()
	check(lab.paused and lab.decision["reason"] == "unavailable", "reset preserves pause")
	lab._toggle_pause()
	for mode in range(4):
		lab.mode_index = mode
		lab._reset()
		check(lab.decision["kind"] == ("none" if mode == 3 else "intent"), "scenario %d" % mode)
		if mode == 2:
			check(lab.decision["target_id"] == 2, "real lab equal distance tie break")
	for repeat in range(10):
		lab.mode_index = repeat % 4
		lab._reset()
		await get_tree().process_frame
	var actors: int = 0
	for child in lab.world.get_children():
		if child is Actor:
			actors += 1
	check(actors == 2, "ten resets leave expected actors")
	lab.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-016 / tests gambits\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
