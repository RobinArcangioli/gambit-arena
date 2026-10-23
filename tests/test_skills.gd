extends Node
const Executor = preload("res://scripts/skills/skill_executor.gd")
const Actor = preload("res://scripts/combat/stats_actor.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
const Lab = preload("res://scenes/skills/skills_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("Skills: " + message)

func actor(profile: Resource, at: Vector3) -> Actor:
	var unit := Actor.new()
	unit.configure(profile)
	add_child(unit)
	unit.position = at
	return unit

func snapshot(executor: Executor) -> Array:
	return [executor.energy, executor.recovered, executor.spent, executor.accepted, executor.cooldown_starts, executor.remaining(&"heal"), executor.remaining(&"special"), executor.action_id, executor.elapsed, executor.phase, executor.applied_healing, executor.applied_damage]

func _ready() -> void:
	var source := actor(HERO, Vector3.ZERO)
	var target := actor(ENEMY, Vector3(0.8, 0, 0))
	var executor := Executor.new(source, true)
	var initial: Array = snapshot(executor)
	check(executor.request(&"heal", source) == 0, "full health heal rejected")
	check(snapshot(executor) == initial, "useless heal has no cost or cooldown")
	source.state.damage(40)
	check(executor.request(&"heal", target) == 0, "heal is self only")
	check(executor.request(&"basic", source) == 0 and executor.request(&"special", source) == 0, "offensive self targets rejected")
	var id: int = executor.request(&"heal", source)
	check(id > 0 and executor.energy == 40 and executor.spent == 20 and executor.remaining(&"heal") == 4.0, "heal commitment exact")
	var committed: Array = snapshot(executor)
	for index in range(30):
		executor.request(&"heal", source)
		executor.request(&"special", target)
	check(snapshot(executor) == committed, "busy heal cannot double charge or be interrupted")
	check(not executor.try_impact(id), "early heal impact rejected")
	source.state.health_changed.connect(func(_hp: int, _max: int) -> void: executor.try_impact(id), CONNECT_ONE_SHOT)
	executor.advance(0.6)
	check(source.state.health == 90 and executor.applied_healing == 30 and executor.applied_damage == 0, "one heal effect, no damage")
	check(executor.energy == 43 and executor.recovered == 3 and executor.spent == 20, "recovery continues during cast")
	check(not executor.try_impact(id) and source.state.health == 90, "duplicate heal no effect")
	executor.advance(0.4)
	check(executor.request(&"heal", source) == 0 and executor.last_rejection == "cooldown", "heal cooldown blocks reuse")
	check(executor.request(&"special", target) > id and executor.energy == 15, "special has separate cooldown and cost")
	executor.advance(0.6)
	check(target.state.health == 37 and executor.applied_damage == 23 and executor.applied_healing == 0, "special uses twice attack minus defense")
	executor.advance(0.4)
	check(executor.request(&"basic", target) > 0, "free basic during both skill cooldowns")
	executor.advance(1.0)
	check(target.state.health == 26 and executor.applied_damage == 11 and executor.spent == 50, "basic unchanged and no added cost")
	executor.advance(1.0)
	check(executor.remaining(&"heal") == 0.0 and executor.remaining(&"special") > 0.0, "cooldowns independent")
	check(executor.request(&"heal", source) > 0, "heal available after expiry")
	executor.advance(0.6)
	check(source.state.health == 100 and executor.applied_healing == 10, "overheal bounded to missing health")
	executor.advance(5.0)
	initial = snapshot(executor)
	check(executor.request(&"heal", source) == 0 and snapshot(executor) == initial, "full health refusal after cooldown remains free")
	# Target healed by another effect during preparation: no extra heal or refund.
	executor.retire()
	source.state.damage(10)
	executor = Executor.new(source)
	executor.request(&"heal", source)
	source.state.heal(100)
	executor.advance(0.6)
	check(source.state.health == 100 and executor.applied_healing == 0 and executor.energy == 40, "became full before effect, no refund")
	executor.retire()
	# Special snapshot, range recheck, no late damage and no refund.
	target.configure(ENEMY)
	executor = Executor.new(source)
	executor.request(&"special", target)
	source.state.set_attack(99)
	executor.advance(0.6)
	check(target.state.health == 37, "special snapshots attack at commitment")
	executor.advance(0.4)
	executor.retire()
	source.configure(HERO)
	target.configure(ENEMY)
	executor = Executor.new(source)
	target.position.x = 1.01
	initial = snapshot(executor)
	check(executor.request(&"special", target) == 0 and snapshot(executor) == initial, "special launch out of range has no cost")
	target.position.x = 0.8
	executor.request(&"special", target)
	target.position.x = 1.01
	executor.advance(0.6)
	check(executor.outcome == "hors portee" and target.state.health == 60 and executor.energy == 30, "special misses after range lost, cost kept")
	target.position.x = 0.8
	executor.advance(10.0)
	check(target.state.health == 60, "no late special after target return")
	executor.retire()
	# Death before self-heal never resurrects or recovers energy afterward.
	source.state.damage(40)
	executor = Executor.new(source, true)
	executor.request(&"heal", source)
	executor.advance(0.2)
	source.state.damage(1000000)
	var dead_energy: int = executor.energy
	executor.advance(10.0)
	check(source.state.health == 0 and executor.applied_healing == 0 and not executor.active and executor.energy == dead_energy, "dead caster neither heals nor regenerates")
	check(executor.request(&"heal", source) == 0, "dead caster cannot request heal")
	source.configure(HERO)
	source.state.damage(40)
	executor = Executor.new(source, true)
	executor.request(&"heal", source)
	source.configure(HERO)
	executor.advance(1.0)
	check(not executor.active and executor.applied_healing == 0 and executor.energy == 40, "replaced state cancels heal before recovery")
	# Passive recovery: exact amounts at different cadences, cap and no stored excess.
	for hz in [30, 60, 120]:
		var regen := Executor.new(source, true, 0)
		for tick in range(2 * hz):
			regen.advance(1.0 / float(hz))
		check(regen.energy == 10 and regen.recovered == 10, "recovery at %d Hz" % hz)
		var paused: Array = snapshot(regen)
		regen.advance(100.0, true)
		regen.advance(NAN)
		regen.advance(INF)
		regen.advance(-1.0)
		check(snapshot(regen) == paused, "pause and invalid time freeze recovery")
		regen.advance(10000.0)
		check(regen.energy == 60 and regen.recovered == 60, "recovery capped")
		regen.advance(10000.0)
		source.state.damage(1)
		regen.request(&"heal", source)
		regen.advance(0.1)
		check(regen.energy == 40, "no banked recovery at capacity")
		regen.advance(0.1)
		check(regen.energy == 41, "fractional recovery accumulated")
		regen.retire()
		source.state.heal(100)
	var empty := Executor.new(source, true, 0)
	source.state.damage(40)
	check(empty.request(&"heal", source) == 0, "no energy heal rejected")
	empty.advance(4.0)
	check(empty.energy == 20 and empty.request(&"heal", source) > 0 and empty.energy == 0, "recovered resource makes heal available")
	empty.retire()
	var independent := Executor.new(target, true, 0)
	independent.advance(1.0)
	check(independent.energy == 5 and empty.energy == 0, "recovery isolated by actor")
	independent.retire()
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	check(lab.actors[0].state.health == 60 and lab.executor.energy == 60, "lab starts injured with full resource")
	lab._command(1)
	lab._physics_process(0.02)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	var background: Array = snapshot(lab.executor)
	lab._physics_process(10.0)
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused and snapshot(lab.executor) == background, "background freezes action cooldown and resource")
	var old_executor = lab.executor
	lab._reset()
	old_executor.advance(10.0)
	check(lab.paused and lab.actors[0].state.health == 60 and lab.executor.energy == 60 and not old_executor.active, "reset invalidates old heal and preserves pause")
	lab.mode_index = 1
	lab._reset()
	lab.paused = false
	for tick in range(240):
		lab._physics_process(1.0 / 60.0)
	check(lab.executor.energy == 20, "empty resource scenario recovers")
	lab.mode_index = 2
	lab._reset()
	lab._command(1)
	for tick in range(120):
		lab._physics_process(1.0 / 60.0)
	check(lab.actors[0].state.health == 0 and lab.executor.applied_healing == 0 and not lab.executor.active, "scripted death before effect")
	for repeat in range(10):
		lab._reset()
		await get_tree().process_frame
	var count: int = 0
	for child in lab.world.get_children():
		if child is Actor:
			count += 1
	check(count == 2, "ten resets without residues")
	check(HERO.max_health == 100 and ENEMY.max_health == 60, "shared profiles unchanged")
	lab.queue_free()
	source.queue_free()
	target.queue_free()
	await get_tree().process_frame
	var report: String = "STEP-014 / tests competences\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
