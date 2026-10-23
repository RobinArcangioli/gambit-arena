extends Node
const Executor = preload("res://scripts/skills/skill_executor.gd")
const Actor = preload("res://scripts/combat/stats_actor.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const Lab = preload("res://scenes/skills/executor_lab.tscn")
const Combat = preload("res://scripts/combat/combat_simulation.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("SkillExecutor: " + message)

func actor(at: Vector3) -> Actor:
	var unit := Actor.new()
	var profile = HERO.duplicate()
	profile.max_health = 1000
	unit.configure(profile)
	add_child(unit)
	unit.position = at
	return unit

func snapshot(executor: Executor) -> Array:
	return [executor.energy, executor.spent, executor.accepted, executor.cooldown_starts, executor.remaining(&"paid_test"), executor.action_id, executor.elapsed, executor.active, executor.resolved]

func _ready() -> void:
	var source := actor(Vector3.ZERO)
	var target := actor(Vector3(0.8, 0, 0))
	var other := actor(Vector3(-0.8, 0, 0))
	var executor := Executor.new(source)
	var independent := Executor.new(other)
	var initial: Array = snapshot(executor)
	check(executor.request(&"unknown", target) == 0, "unknown action rejected")
	check(executor.request(&"paid_test", target, true) == 0, "paused request rejected")
	check(executor.request(&"paid_test", null) == 0 and executor.request(&"paid_test", source) == 0, "null and self rejected")
	target.position.x = 1.01
	check(executor.request(&"paid_test", target) == 0, "range launch rejected")
	check(executor.begin(other, target) == 0, "wrong source rejected")
	check(snapshot(executor) == initial, "all invalid requests leave commitment untouched")
	target.position.x = 0.8
	var id: int = executor.request(&"paid_test", target)
	check(id > 0 and executor.energy == 40 and executor.spent == 20 and executor.accepted == 1 and executor.cooldown_starts == 1, "one debit on acceptance")
	check(executor.remaining(&"paid_test") == 3.0, "cooldown starts at acceptance")
	var committed: Array = snapshot(executor)
	for request_index in range(100):
		executor.request(&"paid_test", target)
		executor.begin(source, target)
	check(snapshot(executor) == committed, "manual and automatic spam do not double commit")
	check(independent.energy == 60 and independent.remaining(&"paid_test") == 0.0, "per actor resource and cooldown isolation")
	check(not executor.try_impact(id), "early impact cannot debit again")
	# Duplicate/reentrant callbacks do not create a second cost, cooldown or impact.
	target.state.health_changed.connect(func(_health: int, _max: int) -> void: executor.try_impact(id), CONNECT_ONE_SHOT)
	executor.advance(0.6)
	check(target.state.health == 991 and executor.energy == 40 and executor.spent == 20, "single impact and single debit")
	check(absf(executor.remaining(&"paid_test") - 2.4) < 0.000001, "cooldown runs during windup")
	check(not executor.try_impact(id), "duplicate impact refused")
	var frozen: Array = snapshot(executor)
	executor.advance(100.0, true)
	executor.advance(NAN)
	executor.advance(INF)
	executor.advance(-1.0)
	check(snapshot(executor) == frozen, "pause and invalid deltas freeze action and cooldown")
	executor.advance(0.4)
	check(not executor.active and absf(executor.remaining(&"paid_test") - 2.0) < 0.000001, "recovery finished while cooldown remains")
	var cooldown_before: float = executor.remaining(&"paid_test")
	check(executor.request(&"paid_test", target) == 0 and executor.last_rejection == "cooldown", "cooldown rejects paid action")
	check(executor.remaining(&"paid_test") == cooldown_before and executor.spent == 20, "refusal does not restart cooldown")
	check(executor.begin(source, target) > id, "basic free action available during paid cooldown")
	executor.advance(1.0)
	check(executor.energy == 40 and executor.spent == 20 and executor.cooldown_starts == 1, "basic action remains free")
	executor.advance(0.99)
	check(executor.request(&"paid_test", target) == 0, "not ready just before expiry")
	executor.advance(0.01)
	check(executor.request(&"paid_test", target) > 0 and executor.energy == 20 and executor.cooldown_starts == 2, "second paid action after expiry")
	executor.advance(3.0)
	check(executor.request(&"paid_test", target) > 0 and executor.energy == 0 and executor.cooldown_starts == 3, "exact energy accepted")
	executor.advance(3.0)
	var empty: Array = snapshot(executor)
	check(executor.request(&"paid_test", target) == 0 and executor.last_rejection == "ressource insuffisante", "empty resource refuses")
	check(snapshot(executor) == empty, "insufficient resource leaves state untouched")
	check(executor.begin(source, target) > 0, "basic remains available at zero energy")
	executor.advance(1.0)
	# Range lost after acceptance: spent resource and started cooldown are retained.
	var miss := Executor.new(source)
	miss.request(&"paid_test", target)
	target.position.x = 2.0
	var health_before: int = target.state.health
	miss.advance(0.6)
	check(miss.outcome == "hors portee" and target.state.health == health_before, "out of range impact misses")
	check(miss.energy == 40 and miss.spent == 20 and miss.cooldown_starts == 1, "miss does not refund or recharge")
	miss.cancel()
	miss.advance(0.4)
	check(miss.energy == 40 and absf(miss.remaining(&"paid_test") - 2.0) < 0.000001, "cancel retains cost and ticking cooldown")
	miss.retire()
	check(miss.request(&"basic", target) == 0, "retired executor cannot restart")
	target.position.x = 0.8
	var death := Executor.new(source)
	death.request(&"paid_test", target)
	source.state.damage(1000000)
	death.advance(1.0)
	check(not death.active and death.energy == 40 and target.state.health == health_before, "source death cancels without refund or late impact")
	source.configure(HERO)
	check(death.request(&"basic", target) == 0, "retired executor does not revive with actor state")
	var replaced := Executor.new(source)
	replaced.request(&"paid_test", target)
	source.configure(HERO)
	replaced.advance(1.0)
	check(not replaced.active and replaced.request(&"basic", target) == 0, "replaced source state retires executor")
	var destroyed := Executor.new(source)
	destroyed.request(&"paid_test", target)
	target.queue_free()
	await get_tree().process_frame
	destroyed.advance(0.6)
	check(not destroyed.active and destroyed.energy == 40 and destroyed.cooldown_starts == 1, "freed target cancels without duplicate accounting")
	# Full lab: automatic requests and both actors share the same implementation.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.mode_index = 2
	lab._reset()
	lab.paused = false
	for tick in range(660):
		lab._physics_process(1.0 / 60.0)
	for current in lab.executors:
		check(current.accepted == 3 and current.spent == 60 and current.energy == 0 and current.cooldown_starts == 3, "auto two actors exact accounting")
	check(lab.actors[2].state.health == 946, "auto three hero and three enemy impacts")
	lab.mode_index = 0
	lab._reset()
	lab._command(0)
	lab._physics_process(0.02)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	var background: Array = snapshot(lab.executors[0])
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and snapshot(lab.executors[0]) == background, "background freezes cooldown and requires resume")
	var old_executor = lab.executors[0]
	lab._reset()
	old_executor.advance(10.0)
	check(lab.paused and lab.executors[0].energy == 60 and lab.executors[0].accepted == 0 and not old_executor.active, "reset invalidates old action and keeps pause")
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	var actor_count: int = 0
	for child in lab.world.get_children():
		if child is Actor:
			actor_count += 1
	check(actor_count == 3, "ten resets without actor residues")
	check(HERO.max_health == 100 and ENEMY.max_health == 60, "profiles unchanged")
	lab.queue_free()
	# Existing autonomous coordinator uses the same executor with basic attacks.
	var world := Node3D.new()
	add_child(world)
	var combat := Combat.new()
	add_child(combat)
	combat.configure(world)
	combat.reset(0)
	check(combat.hero.action is Executor and combat.enemies[0].action is Executor, "shared executor integrated for both camps")
	for tick in range(2400):
		combat.advance(1.0 / 60.0)
		if combat.result != "EN COURS":
			break
		if tick % 120 == 0:
			await get_tree().process_frame
	check(combat.result == "VICTOIRE" and combat.defeated == 3, "autonomous basic combat still completes")
	check(combat.hero.action.energy == 60 and combat.hero.action.spent == 0 and combat.hero.action.accepted > 0, "autonomous basic attacks pass shared gate without cost")
	combat.clear()
	combat.queue_free()
	world.queue_free()
	source.queue_free()
	other.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-013 / tests executeur partage\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
