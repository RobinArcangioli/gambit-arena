extends Node
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const Scenarios = preload("res://scripts/gambits/gambit_scenarios.gd")
const Trace = preload("res://scripts/gambits/gambit_trace.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Actor = preload("res://scripts/hybrid/proxy_actor.gd")
const Lab = preload("res://scenes/gambits/gambit_diagnostics_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("GambitDiagnostics: " + message)

func reasons(report: Dictionary) -> Array[String]:
	var result: Array[String] = []
	for row in report["rules"]:
		result.append(row["reason"])
	return result

func normalized(journal: Array[Dictionary], identities: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var actions: Dictionary = {}
	for original in journal:
		var row: Dictionary = original.duplicate(true)
		row["target_id"] = identities.get(row["target_id"], 0)
		var id: int = row["action_id"]
		if id > 0:
			if not actions.has(id):
				actions[id] = actions.size() + 1
			row["action_id"] = actions[id]
		result.append(row)
	return result

func gameplay(sim: Simulation) -> Array:
	var result: Array = [sim.elapsed, sim.result, sim.hits, sim.spawned, sim.defeated, sim.max_step, sim.controller.evaluations, sim.controller.launched]
	var actors: Array = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		result.append([actor.position, actor.state.health, actor.gait, actor.action.energy, actor.action.spent, actor.action.accepted, actor.action.elapsed, actor.action.phase, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return result

func run_combat(sim: Simulation, enabled: bool) -> Dictionary:
	sim.controller.diagnostics_enabled = enabled
	sim.controller.rules = Controller.standard_rules()
	sim.reset(0)
	var identities: Dictionary = {sim.hero.combat_id: 1}
	for actor in sim.enemies:
		identities[actor.combat_id] = actor.serial + 1
	var timeline: Array[int] = []
	for tick in range(2400):
		sim.advance(1.0 / 60.0)
		timeline.append(hash(gameplay(sim)))
		if sim.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(sim.result == "VICTOIRE", "reproducible diagnostic combat finishes")
	check(sim.controller.trace.size() <= 64, "real combat trace bounded")
	return {"timeline": timeline, "final": gameplay(sim), "journal": normalized(sim.controller.trace.latest(), identities)}

func _ready() -> void:
	for index in range(Scenarios.NAMES.size()):
		var fixture: Dictionary = Scenarios.make(index)
		var view = fixture["view"]
		var before: Array = [view.source.duplicate(true), view.enemies.duplicate(true), view.energy, view.heal_cooldown, view.special_cooldown]
		var report: Dictionary = Evaluator.explain(fixture["rules"], view)
		check(report["decision"] == fixture["expected"] and reasons(report) == fixture["reasons"], "golden scenario %d decision and reasons" % index)
		var stable: bool = true
		for repeat in range(100):
			var fresh: Dictionary = Scenarios.make(index)
			stable = stable and Evaluator.explain(fresh["rules"], fresh["view"]) == report
			stable = stable and Evaluator.evaluate(fresh["rules"], fresh["view"]) == report["decision"]
		check(stable, "fresh fixtures repeat identically")
		check(before == [view.source, view.enemies, view.energy, view.heal_cooldown, view.special_cooldown], "explanation does not mutate snapshot")
		view.paused = true
		var paused_report: Dictionary = Evaluator.explain(fixture["rules"], view)
		check(paused_report["decision"]["reason"] == "unavailable" and paused_report["rules"].is_empty(), "global gate does not claim rules evaluated")
	check(Scenarios.make(-1).is_empty() and Scenarios.make(8).is_empty(), "fixture indices validated")
	var invalid: Dictionary = Scenarios.make(1)
	invalid["rules"][0].target = "unknown"
	check(reasons(Evaluator.explain(invalid["rules"], invalid["view"]))[0] == "invalid_rule", "invalid rule reason")
	invalid["view"].energy = -1
	var invalid_report: Dictionary = Evaluator.explain(invalid["rules"], invalid["view"])
	check(invalid_report["decision"]["reason"] == "invalid_input" and invalid_report["rules"].is_empty(), "invalid snapshot gate")
	var journal := Trace.new()
	var decision: Dictionary = {"rule_index": 0, "skill": "heal", "target_id": 1}
	var details: Array[Dictionary] = [{"rule_index": 0, "reason": "selected"}]
	for index in range(2000):
		journal.record("decision", float(index) / 10.0, decision, 0, "matched", details)
	var entries: Array[Dictionary] = journal.latest()
	check(journal.size() == 64 and journal.total == 2000 and journal.dropped == 1936, "2000 events retain exactly 64")
	check(entries[0]["sequence"] == 1937 and entries[63]["sequence"] == 2000, "oldest eviction preserves order")
	entries[0]["rules"][0]["reason"] = "tampered"
	check(journal.latest()[0]["rules"][0]["reason"] == "selected", "reader receives deep copies")
	check(journal.latest(-1).is_empty() and journal.latest(10000).size() == 64, "reader limit bounded")
	journal.record("bad", NAN, decision)
	journal.record("bad", -1.0, decision)
	check(journal.total == 2000, "invalid timestamps ignored")
	journal.clear()
	check(journal.size() == 0 and journal.total == 0 and journal.dropped == 0, "clear resets journal and counters")
	var extra: Array[Dictionary] = []
	for index in range(20):
		extra.append({"rule_index": index, "reason": "x".repeat(1000), "actor": self})
	journal.record("x".repeat(1000), 0.0, {"skill": self, "target_id": self, "actor": self}, 0, "x".repeat(1000), extra)
	var sanitized: Dictionary = journal.latest()[0]
	check(sanitized["event"].length() == 24 and sanitized["reason"].length() == 32 and sanitized["rules"].size() == 3, "payload strings and rows bounded")
	check(sanitized["skill"] == "" and sanitized["target_id"] == 0 and sanitized["rules"][0].size() == 2 and sanitized.size() == 9, "only whitelisted scalar payload retained")
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	var traced: Dictionary = await run_combat(sim, true)
	var silent: Dictionary = await run_combat(sim, false)
	check(traced["timeline"] == silent["timeline"] and traced["final"] == silent["final"], "diagnostics on/off leave every gameplay tick identical")
	check(silent["journal"].is_empty(), "disabled trace writes nothing")
	var replayed: Dictionary = await run_combat(sim, true)
	check(traced == replayed, "replay matches gameplay and normalized journal")
	var saw_decision: bool = false
	var saw_commit: bool = false
	var saw_terminal: bool = false
	for entry in traced["journal"]:
		saw_decision = saw_decision or entry["event"] == "decision"
		saw_commit = saw_commit or entry["event"] == "commit"
		saw_terminal = saw_terminal or entry["reason"] == "terminal"
	check(saw_decision and saw_commit and saw_terminal, "actual decision, engagement and terminal events recorded")
	sim.reset(0)
	sim.advance(1.0 / 60.0)
	sim.hero.mover.target.state.damage(1000000)
	sim.advance(1.0 / 60.0)
	var saw_invalidation: bool = false
	for entry in sim.controller.trace.latest():
		saw_invalidation = saw_invalidation or entry["event"] == "invalidated"
	check(saw_invalidation, "stale target invalidation recorded")
	sim.reset(0)
	sim.hero.state.damage(200)
	sim.controller.plan(0.01, sim.hero, sim.enemies, sim.clock)
	var last_explanation: Dictionary = sim.controller.explanation
	sim.hero.state.heal(100)
	check(sim.controller.execute(sim.hero, sim.enemies, sim.clock) == 0, "revalidation prevents obsolete heal")
	check(sim.controller.trace.latest(1)[0]["reason"] == "condition", "revalidation records actual refusal reason")
	check(sim.controller.explanation == last_explanation, "clearing pending intention preserves last explanation")
	last_explanation["rules"][0]["reason"] = "tampered"
	check(sim.controller.explanation["rules"][0]["reason"] == "selected", "explanation getter returns deep copy")
	sim.reset(0)
	sim.enemies[0].place(Vector2(0.8, 0))
	sim.hero.action.retire()
	sim.controller.plan(0.01, sim.hero, sim.enemies, sim.clock)
	var before_count: int = sim.controller.trace.total
	for repeat in range(60):
		sim.controller.execute(sim.hero, sim.enemies, sim.clock)
	check(sim.controller.trace.total == before_count + 1 and sim.controller.trace.latest(1)[0]["event"] == "rejected", "executor rejection logged once per pending intention")
	sim.clock.paused = true
	entries = sim.controller.trace.latest()
	sim.advance(100.0)
	check(sim.controller.trace.latest() == entries, "pause freezes trace")
	sim.reset(0)
	check(sim.clock.paused and sim.controller.trace.size() == 0 and sim.controller.explanation.is_empty(), "paused reset clears diagnostics")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._update_buttons()
	for mode in range(1, 9):
		lab.mode_index = mode
		lab._reset()
		for tick in range(120):
			lab._physics_process(1.0 / 60.0)
		check(lab.fixture_report["decision"] == lab.fixture["expected"] and lab.fixture_reads == 20, "real lab fixture %d at 10 Hz" % mode)
		check(lab.simulation.hero.action.accepted == 0 and lab.simulation.hero.state.health == 250, "value fixture executes no live gameplay")
	for tick in range(600):
		lab._physics_process(1.0 / 60.0)
	check(lab.simulation.controller.trace.size() == 64 and lab.simulation.controller.trace.dropped > 0, "lab journal wraps at 64")
	lab._toggle_trace()
	entries = lab.simulation.controller.trace.latest()
	var reads: int = lab.fixture_reads
	for tick in range(60):
		lab._physics_process(1.0 / 60.0)
	check(lab.fixture_reads == reads + 10 and lab.simulation.controller.trace.latest() == entries, "trace off leaves evaluation active")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	reads = lab.fixture_reads
	lab._toggle_view()
	lab._physics_process(100.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and lab.fixture_reads == reads and lab.simulation.controller.trace.latest() == entries, "background freezes diagnostics but view remains accessible")
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	check(lab.paused, "ten resets preserve pause")
	check(lab.simulation.controller.trace.size() == 0 and lab.simulation.controller.trace.total == 0 and lab.simulation.controller.trace.dropped == 0, "ten resets clear journal and counters")
	# World also owns a camera, environment and light; count only actor nodes.
	var expected_actors: Array = [lab.simulation.hero]
	expected_actors.append_array(lab.simulation.enemies)
	var actor_count: int = 0
	var only_current_actors: bool = true
	for child in lab.simulation.world.get_children():
		if child is Actor:
			actor_count += 1
			only_current_actors = only_current_actors and child in expected_actors
	check(actor_count == 4 and expected_actors.size() == 4 and only_current_actors, "ten resets leave exactly the four current actors (found %d)" % actor_count)
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-018 / tests diagnostics\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = summary_text
	add_child(label)
