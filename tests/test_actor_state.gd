extends Node
const ActorState = preload("res://scripts/combat/actor_state.gd")
const ActorProfile = preload("res://scripts/combat/actor_profile.gd")
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const StatsLab = preload("res://scenes/combat/stats_lab.tscn")
const ENEMY_PROFILE = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0
var deaths: int = 0
var changes: int = 0

func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error("ActorState: " + message)

func _ready() -> void:
	var a := ActorState.new(ENEMY_PROFILE)
	var b := ActorState.new(ENEMY_PROFILE)
	a.died.connect(func() -> void: deaths += 1)
	a.health_changed.connect(func(_current: int, _maximum: int) -> void: changes += 1)
	_check(a != b and a.health == 60 and b.health == 60, "distinct state from same Resource")
	_check(a.damage(15) == 15 and a.health == 45, "exact final damage")
	_check(b.health == 60 and ENEMY_PROFILE.max_health == 60, "damage isolation")
	a.set_attack(23)
	_check(a.attack == 23 and b.attack == 8 and ENEMY_PROFILE.attack == 8, "stat isolation")
	_check(a.heal(10) == 10 and a.health == 55, "healing")
	_check(a.heal(1000000000) == 5 and a.health == 60, "overheal clamp")
	var previous_changes: int = changes
	_check(a.damage(-5) == 0 and a.damage(0) == 0 and a.heal(-5) == 0 and a.heal(0) == 0 and a.heal(5) == 0, "invalid and empty operations")
	_check(changes == previous_changes, "no change signal for no-op")
	_check(a.damage(1000000000) == 60 and a.health == 0 and not a.alive, "overkill clamp")
	_check(a.damage(15) == 0 and a.heal(100) == 0 and a.health == 0, "dead actor cannot heal or take damage")
	_check(deaths == 1 and changes == 4, "exact change and death notifications")
	_check(b.alive and b.health == 60, "death isolation")
	var profile := ActorProfile.new()
	profile.max_health = 42
	var snapshot := ActorState.new(profile)
	profile.max_health = 900
	profile.attack = 77
	_check(snapshot.max_health == 42 and snapshot.health == 42 and snapshot.attack == 12, "profile changes do not mutate existing state")
	profile.max_health = -8
	profile.attack = -1
	profile.defense = -1
	profile.move_speed = NAN
	var invalid := ActorState.new(profile)
	_check(invalid.health == 1 and invalid.attack == 0 and invalid.defense == 0 and invalid.move_speed == 0.0, "invalid profile bounded")
	invalid.set_attack(-20)
	_check(invalid.attack == 0, "negative runtime attack bounded")
	var crowd: Array[ActorState] = []
	for index in range(20):
		crowd.append(ActorState.new(ENEMY_PROFILE))
		crowd[index].damage(index)
	for index in range(20):
		_check(crowd[index].health == 60 - index, "20 actors independent")
	# Exercise the actual scene and command gates, including queued reset cleanup.
	var lab = StatsLab.instantiate()
	add_child(lab)
	_check(lab.actors.size() == 3 and lab.actors[1].state != lab.actors[2].state, "scene owns separate enemy states")
	lab.paused = false
	lab.selected = 1
	lab._apply(0)
	lab._apply(2)
	_check(lab.actors[1].state.health == 45 and lab.actors[2].state.health == 60 and lab.actors[1].state.attack == 13 and lab.actors[2].state.attack == 8, "scene damage and stats isolation")
	lab._notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab._apply(0)
	lab._apply(1)
	lab._apply(2)
	lab._apply(3)
	_check(lab.paused and lab.actors[1].state.health == 45 and lab.actors[1].state.attack == 13, "background pause gates every mutation")
	lab._notification(NOTIFICATION_APPLICATION_RESUMED)
	_check(lab.paused, "explicit resume required")
	lab._toggle_pause()
	lab._apply(3)
	_check(not lab.actors[1].state.alive and not lab.actors[1].visible and lab.actors[2].visible, "dead presentation isolated")
	lab._apply(1)
	_check(lab.actors[1].state.health == 0, "scene heal cannot revive")
	lab.paused = true
	for index in range(10):
		var old_actor = lab.actors[0]
		lab._reset()
		_check(old_actor.is_queued_for_deletion() and lab.paused and lab.actors[1].state.health == 60 and lab.actors[1].state.attack == 8, "reset replaces state and preserves pause")
		await get_tree().process_frame
	var count: int = 0
	for child in lab.world.get_children():
		if child is StatsActor:
			count += 1
	_check(count == 3, "no actor residue after 10 resets")
	lab.queue_free()
	await get_tree().process_frame
	var result: String = "OK" if failures == 0 else "ECHEC"
	var report: String = "STEP-010 / tests statistiques et PV\n%s : %d controles, %d echecs\nDetails dans Sortie / Debogueur.\nF8 pour arreter ; F5 pour le laboratoire." % [result, checks, failures]
	print(report)
	var label := Label.new()
	label.position = Vector2(20, 30)
	label.add_theme_font_size_override("font_size", 19)
	label.text = report
	add_child(label)
