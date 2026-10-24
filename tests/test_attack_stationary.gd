extends Node
const Simulation = preload("res://scripts/combat/combat_simulation.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const ENEMY = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("AttackStationary: " + message)

func prepare(sim: Simulation, distance: float) -> void:
	sim.reset(0)
	# One stationary, durable target. No enemy attacks, spawn or separation push.
	for index in range(sim.enemies.size() - 1, 0, -1):
		var removed = sim.enemies[index]
		removed.action.retire()
		removed.hide()
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

func _ready() -> void:
	var world := Node3D.new()
	add_child(world)
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	# Default controller has basic only: it must not creep even at 0.9 or 1.0.
	for hz in [30, 60, 120]:
		for distance in [0.8, 0.9, 1.0]:
			prepare(sim, distance)
			var anchor: Vector3 = sim.hero.position
			var fixed: bool = true
			var legs_still: bool = true
			for tick in range(hz * 4):
				sim.advance(1.0 / float(hz))
				fixed = fixed and sim.hero.position == anchor and sim.hero.mover.velocity == Vector2.ZERO
				legs_still = legs_still and sim.hero.left_leg.rotation.x == 0.0 and sim.hero.right_leg.rotation.x == 0.0 and sim.hero.gait == 0.0
			check(fixed and legs_still, "position and legs fixed at distance %.1f / %d Hz" % [distance, hz])
			check(sim.controller.basic_starts >= 3 and sim.hits >= 3, "multiple real attacks still execute")
			check(sim.enemies[0].state.health == 10000 - sim.hits * 29 and sim.hero.action.spent == 0, "single basic damage and no cost")
			await get_tree().process_frame
	# The strict attack limit must not deadlock just beyond reach (no epsilon hold).
	for distance in [1.000005, 1.02, 2.0]:
		prepare(sim, distance)
		var approached: bool = false
		for tick in range(180):
			sim.advance(1.0 / 60.0)
			approached = approached or sim.hero.position != Vector3.ZERO
			if sim.hero.action.active:
				break
		check(approached and sim.hero.action.active and Action.distance_between(sim.hero, sim.enemies[0]) <= Action.REACH, "outside reach approaches and commits at %.6f" % distance)
		var reached: Vector3 = sim.hero.position
		var stable: bool = true
		for tick in range(240):
			sim.advance(1.0 / 60.0)
			stable = stable and sim.hero.position == reached
		check(stable and sim.controller.basic_starts >= 3, "no creep after reaching a stationary target")
		await get_tree().process_frame
	# Special/basic alternation and editing through the same controller invalidation.
	sim.controller.rules = Controller.standard_rules()
	prepare(sim, 0.95)
	sim.advance(1.0 / 60.0)
	check(sim.hero.action.last_skill == &"special" and sim.hero.position == Vector3.ZERO, "special starts in place")
	var active_id: int = sim.hero.action.action_id
	sim.clock.paused = true
	sim.controller.stop(sim.hero, "rules_changed", sim.clock.elapsed)
	sim.controller.rules[1].enabled = false
	var frozen: Array = [sim.elapsed, sim.hero.position, sim.hero.gait, sim.hero.action.elapsed, sim.hero.action.energy]
	sim.advance(10.0)
	check(frozen == [sim.elapsed, sim.hero.position, sim.hero.gait, sim.hero.action.elapsed, sim.hero.action.energy] and sim.hero.action.action_id == active_id, "pause and edit preserve position and action")
	sim.clock.paused = false
	var fixed_after_edit: bool = true
	for tick in range(180):
		sim.advance(1.0 / 60.0)
		fixed_after_edit = fixed_after_edit and sim.hero.position == Vector3.ZERO
	check(fixed_after_edit and sim.controller.special_starts == 1 and sim.controller.basic_starts >= 1 and sim.hero.action.spent == 30, "edited pending choices stay stationary without extra costs")
	# A target leaving reach must still cause pursuit after the current action ends.
	sim.enemies[0].place(Vector2(2.5, 0))
	sim.enemies[0].mover.speed = 0.0
	var resumed: bool = false
	for tick in range(180):
		sim.advance(1.0 / 60.0)
		resumed = resumed or sim.hero.position.x > 0.0
	check(resumed, "pursuit resumes when target leaves reach")
	sim.clear()
	sim.queue_free()
	world.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-019 / FIX-STEP-019-001\n%s : %d controles, %d echecs\nImmobilite a portee, approche et actions.\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.text = summary_text
	label.add_theme_font_size_override("font_size", 19)
	add_child(label)
