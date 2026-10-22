extends Node
const Action = preload("res://scripts/combat/attack_action.gd")
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Profile = preload("res://scripts/combat/actor_profile.gd")
const Lab = preload("res://scenes/combat/attack_lab.tscn")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0
var deaths: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("AttackAction: " + message)

func actor(profile: Resource, at: Vector3) -> Actor:
	var unit := Actor.new()
	unit.configure(profile)
	add_child(unit)
	unit.position = at
	return unit

func _ready() -> void:
	var source := actor(HERO, Vector3.ZERO)
	var target := actor(ENEMY, Vector3(0.8, 0, 0))
	var other := actor(ENEMY, Vector3(-0.8, 0, 0))
	var action := Action.new()
	check(action.begin(source, source) == 0 and action.begin(source, null) == 0, "self/null rejected")
	target.position.x = 1.001
	check(action.begin(source, target) == 0, "out of range launch rejected")
	target.position = Vector3(1, 5, 0)
	var id: int = action.begin(source, target)
	check(id > 0, "inclusive reach uses ground plane")
	check(action.begin(source, other) == 0 and action.action_id == id, "busy rejects replacement")
	check(not action.try_impact(id) and target.state.health == 60, "early impact rejected")
	action.advance(0.3)
	action.advance(50.0, true)
	check(action.elapsed == 0.3 and target.state.health == 60, "pause freezes windup")
	action.advance(-1.0)
	action.advance(NAN)
	action.advance(INF)
	check(action.elapsed == 0.3, "invalid deltas ignored")
	# Reentrant duplicate callback from the health signal must be rejected.
	target.state.health_changed.connect(func(_hp: int, _max: int) -> void: action.try_impact(id))
	action.advance(0.3)
	check(target.state.health == 49 and other.state.health == 60 and action.applied_damage == 11, "one impact on locked target")
	check(not action.try_impact(id) and not action.try_impact(id + 1), "duplicate/foreign callbacks rejected")
	check(action.active and action.phase == "RECUPERATION", "recovery blocks new attack")
	action.advance(30.0, true)
	check(action.elapsed == 0.6 and action.begin(source, other) == 0, "pause freezes recovery")
	action.advance(0.4)
	check(not action.active and target.state.health == 49, "finish without second impact")
	var next_id: int = action.begin(source, other)
	check(next_id > id and not action.try_impact(id), "stale ID cannot hit next action")
	action.advance(10.0)
	check(other.state.health == 49 and not action.active, "large delta still one impact")
	target.configure(ENEMY)
	target.position = Vector3(0.8, 0, 0)
	action.begin(source, target)
	action.advance(0.3)
	target.position.x = 1.001
	action.advance(0.3)
	check(action.outcome == "hors portee" and target.state.health == 60, "range revalidated at impact")
	target.position.x = 0.8
	action.advance(1.0)
	check(target.state.health == 60, "miss cannot apply late after return")
	action.begin(source, target)
	target.state.damage(60)
	action.advance(1.0)
	check(action.phase == "ANNULEE" and action.applied_damage == 0, "dead target cancels")
	check(action.begin(source, target) == 0, "dead target launch rejected")
	target.configure(ENEMY)
	action.begin(source, target)
	source.state.damage(100)
	action.advance(1.0)
	check(action.phase == "ANNULEE" and target.state.health == 60, "dead attacker cancels")
	check(action.begin(source, target) == 0, "dead attacker launch rejected")
	source.configure(HERO)
	action.begin(source, target)
	target.configure(ENEMY)
	action.advance(1.0)
	check(action.phase == "ANNULEE" and target.state.health == 60, "replaced state cannot receive stale hit")
	action.begin(source, target)
	action.cancel()
	action.advance(2.0)
	check(target.state.health == 60 and not action.try_impact(action.action_id), "explicit cancel invalidates impact")
	# Destruction both queued and fully freed.
	action.begin(source, target)
	target.queue_free()
	action.advance(1.0)
	check(action.phase == "ANNULEE", "queued target cancelled")
	await get_tree().process_frame
	check(action.begin(source, target) == 0, "freed target launch rejected")
	target = actor(ENEMY, Vector3(0.8, 0, 0))
	action.begin(source, target)
	target.queue_free()
	await get_tree().process_frame
	action.advance(1.0)
	check(action.phase == "ANNULEE", "fully freed target cancelled")
	target = actor(ENEMY, Vector3(0.8, 0, 0))
	action.begin(source, target)
	source.queue_free()
	await get_tree().process_frame
	action.advance(1.0)
	check(action.phase == "ANNULEE" and target.state.health == 60, "fully freed attacker cancelled")
	source = actor(HERO, Vector3.ZERO)
	# Lethal impact, exactly one death, then normal recovery.
	source.state.set_attack(1000)
	target.state.died.connect(func() -> void: deaths += 1)
	action.begin(source, target)
	action.advance(0.6)
	check(deaths == 1 and target.state.health == 0 and action.applied_damage == 60, "lethal damage clamped, death once")
	action.advance(0.4)
	check(action.phase == "TERMINEE" and deaths == 1, "lethal attack finishes recovery")
	var armored := Profile.new()
	armored.defense = 1000
	target.configure(armored)
	source.configure(HERO)
	action.begin(source, target)
	source.state.set_attack(999)
	action.advance(1.0)
	check(action.applied_damage == 1 and target.state.health == 99, "attack snapshot and minimum damage")
	# Equivalent result across normal frame cadences.
	for hz in [30, 60, 120]:
		source.configure(HERO)
		target.configure(ENEMY)
		action.begin(source, target)
		for tick in range(hz * 2):
			action.advance(1.0 / float(hz))
		check(target.state.health == 49 and not action.active, "cadence independent single impact")
	target.configure(ENEMY)
	action.begin(source, target)
	source.configure(HERO)
	action.advance(1.0)
	check(action.phase == "ANNULEE" and target.state.health == 60, "replaced source state cancels")
	# Distinct executors receive distinct IDs.
	var second := Action.new()
	var first_id: int = action.begin(source, target)
	var second_id: int = second.begin(other, source)
	check(first_id != second_id and second_id > first_id, "IDs unique across executors")
	action.cancel()
	second.cancel()
	# Real lab: target switching does not redirect a committed action.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.paused = false
	lab._command(0)
	lab._command(1)
	lab._physics_process(0.6)
	check(lab.actors[1].state.health == 49 and lab.actors[2].state.health == 60, "lab target lock")
	lab._reset()
	lab._command(0)
	lab._physics_process(0.2)
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab._physics_process(5.0)
	check(lab.action.elapsed == 0.2 and lab.actors[1].state.health == 60, "background pause")
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	check(lab.paused, "explicit resume required")
	var old_action = lab.action
	lab._reset()
	old_action.advance(5.0)
	check(lab.paused and lab.actors[1].state.health == 60 and not old_action.active, "reset cancels pending impact, preserves pause")
	lab.paused = false
	for mode in range(1, 5):
		lab.mode_index = mode
		lab._reset()
		lab._command(0)
		lab._physics_process(1.0)
		check(lab.action.applied_damage == 0, "automatic intervention before impact")
		if mode == 1:
			check(lab.actors[1].state.health == 60 and lab.action.outcome == "hors portee", "automatic range miss")
		await get_tree().process_frame
	for index in range(10):
		lab._reset()
		await get_tree().process_frame
	var count: int = 0
	for child in lab.world.get_children():
		if child is Actor:
			count += 1
	check(count == 3, "ten resets without residues")
	lab.queue_free()
	source.queue_free()
	target.queue_free()
	other.queue_free()
	await get_tree().process_frame
	var result: String = "OK" if failures == 0 else "ECHEC"
	var report: String = "STEP-011 / tests des actions\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % [result, checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
