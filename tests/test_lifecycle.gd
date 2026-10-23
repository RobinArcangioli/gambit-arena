extends Node
const Clock = preload("res://scripts/core/game_clock.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const Lab = preload("res://scenes/skills/lifecycle_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("Lifecycle: " + message)

func actor(profile: Resource, at: Vector3) -> Actor:
	var unit := Actor.new()
	unit.configure(profile)
	add_child(unit)
	unit.position = at
	return unit

func snapshot(executor: Executor) -> Array:
	return [executor.energy, executor.recovered, executor.spent, executor.accepted, executor.cooldown_starts, executor.remaining(&"heal"), executor.remaining(&"special"), executor.action_id, executor.elapsed, executor.active, executor.phase, executor.applied_healing, executor.applied_damage]

func _ready() -> void:
	var clock := Clock.new()
	for delta in [NAN, INF, -1.0, 0.0]:
		check(clock.step(delta) == 0.0 and clock.elapsed == 0.0, "invalid time ignored")
	check(is_equal_approx(clock.step(30.0), 1.0 / 30.0), "long frame bounded without catchup")
	clock.paused = true
	clock.reset()
	check(clock.paused and clock.elapsed == 0.0 and clock.step(1.0) == 0.0, "reset preserves pause")
	clock.paused = false
	var source := actor(HERO, Vector3.ZERO)
	var target := actor(ENEMY, Vector3(0.8, 0, 0))
	for skill in [&"basic", &"heal", &"special"]:
		source.configure(HERO)
		source.state.damage(40)
		target.configure(ENEMY)
		var executor := Executor.new(source, true)
		executor.bind_clock(clock)
		var selected: Actor = source if skill == &"heal" else target
		var id: int = executor.request(skill, selected)
		check(id > 0, "action accepted: " + str(skill))
		executor.advance(0.3)
		clock.paused = true
		var frozen: Array = snapshot(executor)
		for tick in range(60):
			executor.advance(1.0)
			clock.step(1.0)
		check(snapshot(executor) == frozen, "pause freezes action, cooldown and energy")
		check(executor.request(skill, selected) == 0 and not executor.try_impact(id), "paused direct calls rejected")
		check(snapshot(executor) == frozen, "paused requests have no cost")
		clock.paused = false
		executor.advance(0.3)
		check(executor.resolved and executor.active, "resume reaches one effect")
		check(source.state.health == (90 if skill == &"heal" else 60), "heal effect exact")
		check(target.state.health == (49 if skill == &"basic" else 37 if skill == &"special" else 60), "damage effect exact")
		clock.paused = true
		frozen = snapshot(executor)
		executor.advance(10.0)
		check(snapshot(executor) == frozen and not executor.try_impact(id), "recovery pause and duplicate callback")
		clock.paused = false
		executor.advance(0.4)
		check(not executor.active, "recovery finishes after resume")
		check(not source.state.died.is_connected(executor._on_source_lost), "finished action releases lifecycle subscription")
		executor.retire()
		# Death during a pause cancels immediately, without advancing game time.
		source.configure(HERO)
		source.state.damage(40)
		target.configure(ENEMY)
		executor = Executor.new(source, true)
		executor.bind_clock(clock)
		selected = source if skill == &"heal" else target
		id = executor.request(skill, selected)
		executor.advance(0.3)
		clock.paused = true
		source.state.damage(1000000)
		check(not executor.active and executor.phase == "ANNULEE", "source death cancels synchronously in pause")
		frozen = snapshot(executor)
		clock.paused = false
		executor.advance(10.0)
		check(snapshot(executor) == frozen and not executor.try_impact(id), "dead source no delayed effect or regeneration")
		check(source.state.health == 0 and target.state.health == 60, "no postmortem damage or resurrection")
	# An unrelated target death cancels preparation, retaining the paid cost.
	source.configure(HERO)
	target.configure(ENEMY)
	var executor := Executor.new(source)
	executor.bind_clock(clock)
	var id: int = executor.request(&"special", target)
	clock.paused = true
	target.state.damage(1000000)
	check(not executor.active and executor.energy == 30 and executor.remaining(&"special") == 6.0, "target death in pause cancels without refund")
	clock.paused = false
	executor.advance(10.0)
	check(not executor.try_impact(id) and executor.applied_damage == 0, "cancelled target never hit later")
	executor.retire()
	# A lethal committed impact keeps recovery, even when its target exits the tree.
	target.configure(ENEMY)
	target.state.damage(59)
	executor = Executor.new(source)
	id = executor.request(&"basic", target)
	executor.advance(0.6)
	check(executor.active and executor.applied_damage == 1 and not target.state.alive, "own lethal effect keeps recovery")
	target.free()
	executor.advance(0.4)
	check(not executor.active and executor.phase == "TERMINEE", "freed defeated target does not break recovery")
	executor.retire()
	# Removal during preparation and stale callbacks after a reset.
	target = actor(ENEMY, Vector3(0.8, 0, 0))
	executor = Executor.new(source)
	id = executor.request(&"special", target)
	target.free()
	check(not executor.active and not executor.try_impact(id), "tree exit cancels pending effect")
	executor.retire()
	target = actor(ENEMY, Vector3(0.8, 0, 0))
	executor = Executor.new(source)
	executor.bind_clock(clock)
	id = executor.request(&"special", target)
	# Simulate a delayed impact callback reaching its time threshold while paused.
	executor.elapsed = 0.6
	clock.paused = true
	check(not executor.try_impact(id) and target.state.health == 60, "due callback cannot bypass shared pause")
	clock.paused = false
	check(executor.try_impact(id) and target.state.health == 37, "due callback can resolve once after resume")
	source.free()
	check(not executor.active, "source exit cancels recovery")
	executor.retire()
	target.free()
	var world := Node3D.new()
	add_child(world)
	var simulation := Simulation.new()
	add_child(simulation)
	simulation.configure(world)
	simulation.reset(2)
	for tick in range(90):
		simulation.advance(1.0 / 60.0)
	check(simulation.spawned > 0, "progressive combat starts")
	simulation.clock.paused = true
	var combat_state: Array = [simulation.elapsed, simulation.spawn_clock, simulation.spawned, simulation.hero.position, simulation.hero.gait, snapshot(simulation.hero.action)]
	for tick in range(180):
		simulation.advance(1.0)
	check(combat_state == [simulation.elapsed, simulation.spawn_clock, simulation.spawned, simulation.hero.position, simulation.hero.gait, snapshot(simulation.hero.action)], "combat pause freezes movement, pose, spawn and skills")
	check(simulation.hero.action.request(&"basic", simulation.enemies[0]) == 0, "combat actor shares pause gate")
	var old_action = simulation.hero.action
	simulation.reset(0)
	check(simulation.clock.paused and old_action.request(&"basic", simulation.enemies[0]) == 0, "combat reset retains pause and retires previous actions")
	simulation.clock.paused = false
	simulation.hero.state.damage(1000000)
	simulation.advance(1.0 / 60.0)
	check(simulation.result == "DEFAITE" and simulation.clock.stopped, "terminal combat stops shared clock")
	check(simulation.enemies[0].action.request(&"basic", simulation.hero) == 0, "terminal actors cannot launch")
	simulation.clear()
	simulation.queue_free()
	world.queue_free()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._update_buttons()
	lab._command(1)
	lab._physics_process(0.02)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	var frozen: Array = snapshot(lab.executor)
	lab._physics_process(30.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and lab.clock.paused and snapshot(lab.executor) == frozen, "background and resume keep explicit pause")
	var old_executor = lab.executor
	lab._reset()
	check(lab.paused and lab.clock.paused and not old_executor.active, "lab reset in pause cancels old action")
	for mode in [1, 2]:
		lab.mode_index = mode
		lab._reset()
		lab.paused = false
		lab._update_buttons()
		lab._command(2)
		for tick in range(120):
			lab._physics_process(1.0 / 60.0)
		check(not lab.executor.active and lab.executor.applied_damage == 0 and lab.executor.spent == 30, "scripted death blocks effect and keeps cost")
		check(lab.actors[1 if mode == 1 else 0].state.health == 0, "correct scripted victim")
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	var count: int = 0
	for child in lab.world.get_children():
		if child is Actor:
			count += 1
	check(count == 2, "ten resets leave only two actors")
	lab.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-015 / tests pause et cycle de vie\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
