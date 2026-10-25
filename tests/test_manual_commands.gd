extends Node
const Manual = preload("res://scripts/manual/manual_commands.gd")
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const Lab = preload("res://scenes/manual/manual_command_lab.tscn")
const Reference = preload("res://scenes/ui/skill_slots_lab.tscn")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0
var manual := Manual.new()
var clock := Clock.new()
var hero: Unit
var enemy: Unit
var enemies: Array[Unit] = []

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("ManualCommands: " + message)

func dispose_pair() -> void:
	manual.reset()
	for actor in [hero, enemy]:
		if is_instance_valid(actor):
			actor.action.retire()
			actor.free()
	hero = null
	enemy = null
	enemies.clear()

func fresh(distance: float = 0.9, energy: int = 60) -> void:
	dispose_pair()
	clock.paused = false
	clock.reset()
	hero = Unit.new()
	hero.configure(HERO)
	add_child(hero)
	hero.place(Vector2.ZERO)
	hero.action.retire()
	hero.action = Executor.new(hero, true, energy)
	hero.action.bind_clock(clock)
	enemy = Unit.new()
	var profile = ENEMY.duplicate()
	profile.max_health = 10000
	enemy.configure(profile)
	add_child(enemy)
	enemy.place(Vector2(distance, 0))
	enemies.append(enemy)

func fixture_tick(dt: float) -> void:
	var elapsed_step: float = clock.step(dt)
	if elapsed_step > 0.0:
		hero.action.advance(elapsed_step)
	manual.execute(hero, enemies, clock)

func prepare_sim(sim: Simulation, distance: float = 0.9) -> void:
	sim.clock.paused = false
	sim.controller.rules = Controller.standard_rules()
	sim.reset(0)
	for index in range(sim.enemies.size() - 1, 0, -1):
		var removed = sim.enemies[index]
		removed.action.retire()
		removed.queue_free()
		sim.enemies.remove_at(index)
	sim.spawned = 1
	sim.budget = 1
	var target = sim.enemies[0]
	var profile = ENEMY.duplicate()
	profile.max_health = 10000
	target.configure(profile)
	target.place(Vector2(distance, 0))
	target.mover.speed = 0.0
	target.action.retire()

func gameplay(sim: Simulation) -> Array:
	var values: Array = [sim.elapsed, sim.spawn_clock, sim.spawned, sim.defeated, sim.hits, sim.result, sim.controller.evaluations, sim.controller.launched, sim.controller.trace.total]
	var actors: Array[Unit] = [sim.hero]
	actors.append_array(sim.enemies)
	for actor in actors:
		values.append([actor.position, actor.state.health, actor.gait, actor.action.elapsed, actor.action.energy, actor.action.spent, actor.action.accepted, actor.action.last_skill, actor.action.remaining(&"heal"), actor.action.remaining(&"special")])
	return values

func enclosed(outer: Rect2, inner: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 0.01 and inner.position.y >= outer.position.y - 0.01 and inner.end.x <= outer.end.x + 0.01 and inner.end.y <= outer.end.y + 0.01

func _ready() -> void:
	fresh()
	check(manual.submit(&"special", hero, enemies, clock), "valid command queued")
	check(hero.action.accepted == 0 and hero.action.spent == 0 and hero.action.remaining(&"special") == 0, "submission has no costs or execution")
	var id: int = manual.execute(hero, enemies, clock)
	check(id > 0 and manual.launched == 1 and not manual.pending and hero.action.spent == 30 and hero.action.cooldown_starts == 1, "one authoritative commitment")
	for repeat in range(100):
		manual.execute(hero, enemies, clock)
	check(hero.action.accepted == 1 and hero.action.spent == 30, "consumed command cannot execute twice")
	hero.action.advance(0.6)
	check(enemy.state.health == 9977 and not hero.action.try_impact(id), "one special impact through existing executor")
	# An active action is immutable; only one subsequent command can be replaced.
	fresh()
	hero.state.damage(60)
	id = hero.action.request(&"basic", enemy)
	manual.submit(&"special", hero, enemies, clock)
	manual.submit(&"heal", hero, enemies, clock)
	check(manual.replaced == 1 and manual.snapshot()["skill"] == "heal" and hero.action.action_id == id and hero.action.active, "replacement preserves active basic")
	check(manual.execute(hero, enemies, clock) == 0 and hero.action.spent == 0, "busy command waits without payment")
	hero.action.advance(1.0)
	check(manual.execute(hero, enemies, clock) > 0 and hero.action.last_skill == &"heal" and hero.action.spent == 20, "latest command follows recovery")
	# Strict lifetime and replacement deadline, with no wall-time dependence.
	fresh()
	manual.submit(&"heal", hero, enemies, clock)
	clock.elapsed = 2.5
	manual.submit(&"heal", hero, enemies, clock)
	check(is_equal_approx(manual.snapshot()["remaining"], 3.0), "replacement refreshes three-second lifetime")
	clock.elapsed = 5.499
	check(manual.execute(hero, enemies, clock) == 0 and manual.pending, "full-health heal still waits just before deadline")
	hero.state.damage(60)
	clock.elapsed = 5.5
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending and manual.expired == 1 and hero.action.spent == 0, "exact deadline expires before newly possible execution")
	fresh()
	manual.submit(&"heal", hero, enemies, clock)
	clock.paused = true
	var queue: Dictionary = manual.snapshot()
	for repeat in range(100):
		fixture_tick(100.0)
	check(manual.pending and manual.snapshot()["remaining"] == queue["remaining"] and hero.action.accepted == 0, "pause freezes lifetime and execution")
	check(not manual.submit(&"special", hero, enemies, clock) and manual.snapshot()["skill"] == "heal", "paused click cannot replace pending command")
	clock.paused = false
	check(not manual.submit(&"unknown", hero, enemies, clock) and manual.snapshot()["skill"] == "heal", "invalid click leaves pending command intact")
	hero.state.damage(60)
	fixture_tick(0.02)
	check(hero.action.last_skill == &"heal" and not manual.pending, "explicit resume executes pending command")
	# Revalidate health, energy, cooldown, range and identity at commitment.
	fresh(0.9, 19)
	hero.state.damage(60)
	manual.submit(&"heal", hero, enemies, clock)
	check(manual.execute(hero, enemies, clock) == 0 and manual.waiting_reason == "energy", "insufficient energy waits")
	for tick in range(13):
		fixture_tick(1.0 / 60.0)
	check(hero.action.last_skill == &"heal" and hero.action.spent == 20 and hero.action.accepted == 1, "recovered energy permits one heal")
	fresh()
	hero.state.damage(60)
	manual.submit(&"heal", hero, enemies, clock)
	hero.state.heal(100)
	check(manual.execute(hero, enemies, clock) == 0 and manual.waiting_reason == "full_health" and hero.action.spent == 0, "healed source makes waiting heal useless")
	fresh()
	hero.action.request(&"special", enemy)
	hero.action.advance(1.0)
	manual.submit(&"special", hero, enemies, clock)
	check(manual.execute(hero, enemies, clock) == 0 and manual.waiting_reason == "cooldown", "current cooldown prevents repeated charge")
	hero.action.advance(5.0)
	check(manual.execute(hero, enemies, clock) > 0 and hero.action.spent == 60 and hero.action.cooldown_starts == 2, "availability rechecked after cooldown")
	fresh()
	manual.submit(&"special", hero, enemies, clock)
	enemy.place(Vector2(2, 0))
	manual.prepare(hero, enemies, clock)
	check(manual.execute(hero, enemies, clock) == 0 and hero.mover.target == enemy and hero.action.spent == 0, "moved target approached without out-of-range charge")
	enemy.place(Vector2(1, 0))
	check(manual.execute(hero, enemies, clock) > 0, "inclusive exact reach accepted")
	fresh()
	manual.submit(&"basic", hero, enemies, clock)
	enemy.configure(ENEMY)
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending, "replaced target state invalidates intent")
	manual.submit(&"basic", hero, enemies, clock)
	hero.configure(HERO)
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending, "replaced source state invalidates intent")
	fresh()
	manual.submit(&"special", hero, enemies, clock)
	clock.paused = true
	enemy.state.damage(1000000)
	check(not manual.pending and manual.last_event == "target_lost" and hero.action.spent == 0, "target death clears synchronously even paused")
	manual.submit(&"heal", hero, enemies, clock)
	clock.paused = false
	manual.submit(&"heal", hero, enemies, clock)
	hero.state.damage(1000000)
	check(not manual.pending and manual.last_event == "source_lost", "source death clears synchronously")
	fresh()
	manual.submit(&"basic", hero, enemies, clock)
	enemy.queue_free()
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending, "queued deletion rejected before commitment")
	await get_tree().process_frame
	fresh()
	manual.submit(&"heal", hero, enemies, clock)
	enemies.clear()
	check(not manual.submit(&"basic", hero, enemies, clock) and manual.snapshot()["skill"] == "heal", "missing target refuses replacement without losing valid heal")
	clock.stopped = true
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending, "stopped clock cancels before execution")
	# Clock clamping and expiry are shared with the simulation, at multiple tick rates.
	for hz in [30, 60, 120]:
		fresh()
		manual.submit(&"heal", hero, enemies, clock)
		for tick in range(hz * 3 - 1):
			fixture_tick(1.0 / float(hz))
		check(manual.pending, "still queued before deadline at %d Hz" % hz)
		fixture_tick(1.0 / float(hz))
		check(not manual.pending and manual.expired == 1, "expires at three game seconds at %d Hz" % hz)
	fresh()
	manual.submit(&"heal", hero, enemies, clock)
	fixture_tick(100.0)
	check(manual.pending and is_equal_approx(clock.elapsed, Clock.MAX_STEP), "large frame cannot consume wall-time lifetime")
	# Lock the target selected at click, with stable-ID tie resolution.
	fresh()
	var other := Unit.new()
	other.configure(ENEMY)
	add_child(other)
	other.place(Vector2(-0.9, 0))
	enemies.push_front(other)
	manual.submit(&"basic", hero, enemies, clock)
	check(manual.snapshot()["target_id"] == enemy.combat_id, "stable ID wins equal distances regardless of list order")
	other.place(Vector2(-0.7, 0))
	var copied: Dictionary = manual.snapshot()
	copied["skill"] = "heal"
	copied["target_id"] = other.combat_id
	check(manual.snapshot()["target_id"] == enemy.combat_id and manual.snapshot()["skill"] == "basic", "snapshot independent and nearer newcomer cannot steal target")
	enemies.erase(enemy)
	check(manual.execute(hero, enemies, clock) == 0 and not manual.pending and other.state.health == 60, "removed target cancels without retargeting")
	other.free()
	dispose_pair()
	# Actual coordinator: manual priority, expiry fallback, stationary attacks and reset.
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.manual_enabled = true
	prepare_sim(sim)
	sim.request_manual(&"basic")
	sim.advance(1.0 / 60.0)
	check(sim.manual.launched == 1 and sim.controller.launched == 0 and sim.hero.action.last_skill == &"basic", "manual wins before available automatic special")
	id = sim.hero.action.action_id
	sim.request_manual(&"special")
	sim.request_manual(&"basic")
	var still: bool = true
	for tick in range(65):
		sim.advance(1.0 / 60.0)
		still = still and sim.hero.position == Vector3.ZERO and sim.hero.gait == 0.0
	check(still and sim.manual.launched == 2 and sim.controller.launched == 0 and sim.hero.action.action_id != id and sim.hero.action.spent == 0, "replacement launches once after action, without leg motion or displacement")
	prepare_sim(sim)
	sim.request_manual(&"heal")
	for tick in range(179):
		sim.advance(1.0 / 60.0)
	check(sim.manual.pending and sim.hero.action.accepted == 0 and sim.controller.launched == 0, "unavailable manual command reserves priority while waiting")
	sim.advance(1.0 / 60.0)
	check(sim.manual.expired == 1 and not sim.manual.pending and sim.controller.special_starts == 1, "expiry resumes gambits on same tick")
	prepare_sim(sim, 2.0)
	sim.request_manual(&"special")
	var walking: bool = false
	for tick in range(180):
		sim.advance(1.0 / 60.0)
		walking = walking or (sim.hero.mover.velocity.length_squared() > 0 and sim.hero.gait > 0)
		if sim.manual.launched > 0:
			break
	check(walking and sim.manual.launched == 1 and sim.hero.position.x > 0 and Action.distance_between(sim.hero, sim.enemies[0]) <= 1.0, "real movement brings manual attack into range")
	prepare_sim(sim)
	var accounting: bool = true
	var commands: Array[StringName] = [&"basic", &"special", &"heal"]
	for tick in range(600):
		if tick % 37 == 0:
			sim.request_manual(commands[floori(float(tick) / 37.0) % 3])
		sim.advance(1.0 / 60.0)
		accounting = accounting and sim.hero.action.accepted == sim.controller.launched + sim.manual.launched and sim.hero.position == Vector3.ZERO and sim.hero.gait == 0.0
	check(accounting and sim.manual.launched > 0, "mixed manual/automatic actions accounted once and stationary at reach")
	prepare_sim(sim)
	sim.request_manual(&"special")
	sim.clock.paused = true
	var frozen: Array = gameplay(sim)
	queue = sim.manual.snapshot()
	sim.advance(100.0)
	check(gameplay(sim) == frozen and sim.manual.snapshot() == queue, "coordinator pause freezes command and combat")
	var retained = sim.hero.action
	for repeat in range(10):
		sim.reset(0)
		await get_tree().process_frame
	check(not sim.manual.pending and sim.manual.submitted == 0 and sim.clock.paused and world.get_child_count() == 4 and not retained.active, "ten paused resets clear queue, counters and old actors")
	sim.clock.paused = false
	sim.request_manual(&"heal")
	sim.hero.state.damage(1000000)
	sim.advance(0.02)
	check(sim.result == "DEFAITE" and not sim.manual.pending and not sim.request_manual(&"basic"), "death and terminal reject commands")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	# No input: the new path must preserve the exact automatic combat trajectory.
	var lab = Lab.instantiate()
	var reference = Reference.instantiate()
	add_child(lab)
	add_child(reference)
	lab.set_physics_process(false)
	reference.set_physics_process(false)
	lab.paused = false
	reference.paused = false
	lab._update_buttons()
	reference._update_buttons()
	var identical: bool = true
	for tick in range(2400):
		lab._physics_process(1.0 / 60.0)
		reference._physics_process(1.0 / 60.0)
		identical = identical and gameplay(lab.simulation) == gameplay(reference.simulation)
		if lab.simulation.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(identical and lab.simulation.result == "VICTOIRE", "no manual input reproduces complete STEP-022 combat")
	reference.queue_free()
	lab._reset()
	for index in range(6):
		check(lab.skill_cards[index].pressed.get_connections().size() == (1 if index < 3 else 0), "one callback per active card and none on reserves")
	lab.skill_cards[0].pressed.emit()
	lab.skill_cards[2].pressed.emit()
	check(lab.simulation.manual.snapshot()["skill"] == "special" and lab.simulation.manual.replaced == 1 and lab.simulation.hero.action.accepted == 0, "real buttons queue and replace, no execution in callback")
	lab._toggle_pause()
	queue = lab.simulation.manual.snapshot()
	lab.skill_cards[1].pressed.emit()
	check(lab.simulation.manual.snapshot() == queue and lab.skill_details.text.contains("combat en pause"), "paused button refusal displayed without replacement")
	lab.gambits_tab.pressed.emit()
	lab.edit_buttons[0].pressed.emit()
	lab._select_slot(1)
	check(lab.simulation.manual.snapshot() == queue and lab.overlay.visible, "modal blocks manual clicks")
	lab._adjust_threshold(-1)
	lab.apply_button.pressed.emit()
	check(lab.paused and lab.simulation.manual.snapshot() == queue, "gambit edit preserves frozen manual intent")
	lab.skills_tab.pressed.emit()
	lab.safe_area_override = Rect2(80, 100, 360, 640)
	lab._update_layout()
	await get_tree().process_frame
	await get_tree().process_frame
	check(enclosed(lab.safe_rect, lab.skills_scroll.get_global_rect()), "manual UI inside reduced safe area")
	var scrollbar: VScrollBar = lab.skills_scroll.get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value - scrollbar.page
	await get_tree().process_frame
	await get_tree().process_frame
	check(lab.skill_details.get_global_rect().end.y <= lab.skills_scroll.get_global_rect().end.y + 0.01, "long command feedback fully reachable by scrolling")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab._physics_process(100.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and lab.simulation.manual.snapshot() == queue, "background freezes pending command and requires explicit resume")
	lab._reset()
	check(not lab.simulation.manual.pending and lab.paused and lab.editor.snapshot()[0].threshold == 49, "UI replay clears command and preserves gambits and pause")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-023 / commandes manuelles\n%s : %d controles, %d echecs\nPriorite, attente, revalidation et cycle de vie.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 18)
	label.text = summary_text
	add_child(label)
