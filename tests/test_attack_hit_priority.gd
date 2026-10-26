extends Node
## GRAPHICS-004-fix1: current basic action owns the player and skeleton before hits arrive.
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Main = preload("res://scenes/main.tscn")
const PROFILES = [preload("res://resources/presentation/characters/anne.tres"), preload("res://resources/presentation/characters/mako.tres"), preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("AttackHitPriority: " + message)

func rotation_track(view) -> int:
	var animation: Animation = view.player.get_animation(view.definition.attack_clip)
	for i in range(animation.get_track_count()):
		if str(animation.track_get_path(i)).ends_with(":UpperArm.L") and animation.track_get_type(i) == Animation.TYPE_ROTATION_3D: return i
	return -1

func valid_attack_pose(view) -> bool:
	if view.active_clip != view.definition.attack_clip or view.player.current_animation != view.definition.attack_clip: return false
	var skeleton = view.model.find_children("*", "Skeleton3D", true, false)[0]
	var bone: int = skeleton.find_bone("UpperArm.L")
	var track: int = rotation_track(view)
	if bone < 0 or track < 0: return false
	var clip: Animation = view.player.get_animation(view.definition.attack_clip)
	return skeleton.get_bone_pose_rotation(bone).normalized().angle_to(clip.rotation_track_interpolate(track, view.clip_time).normalized()) < 0.002

func clip_pose_matches(view, clip_name: StringName) -> bool:
	if view.active_clip != clip_name or view.player.current_animation != clip_name: return false
	var skeleton = view.model.find_children("*", "Skeleton3D", true, false)[0]
	var clip: Animation = view.player.get_animation(clip_name)
	for track in range(clip.get_track_count()):
		if clip.track_get_type(track) != Animation.TYPE_ROTATION_3D: continue
		var bone: int = skeleton.find_bone(str(clip.track_get_path(track).get_subname(0)))
		if bone < 0 or skeleton.get_bone_pose_rotation(bone).normalized().angle_to(clip.rotation_track_interpolate(track, view.clip_time).normalized()) >= 0.002: return false
	return true

func _ready() -> void:
	var actor := Actor.new()
	add_child(actor)
	for profile in PROFILES:
		actor.set_appearance(profile)
		var view = actor.visual
		view.react_hit()
		check(view.active_clip == profile.hit_clip, "idle reaction starts before a new attack")
		var intact: bool = true
		for tick in range(90):
			var elapsed: float = tick / 90.0
			view.sync_action(true, &"basic", 123, elapsed, 0.6, 0.4)
			var skeleton = view.model.find_children("*", "Skeleton3D", true, false)[0]
			var arm: int = skeleton.find_bone("UpperArm.L")
			var before: Quaternion = skeleton.get_bone_pose_rotation(arm)
			for hit in range(6): view.react_hit()
			intact = intact and valid_attack_pose(view) and before.angle_to(skeleton.get_bone_pose_rotation(arm)) < 0.002
			intact = intact and view.attack_active and view.hit_remaining == 0
		check(intact, "six hits per frame cannot replace the attack clip or skeleton: " + profile.display_name)
		view.sync_action(true, &"basic", 123, 1.0 - 0.000000000000001, 0.6, 0.4)
		check(valid_attack_pose(view) and view.player.is_playing(), "attack end boundary does not stop the player")
		view.sync_action(true, &"basic", 124, 0.1, 0.6, 0.4)
		check(valid_attack_pose(view), "consecutive attacks reuse the clip without losing the pose")
		view.player.stop()
		view.sync_action(true, &"basic", 124, 0.3, 0.6, 0.4)
		check(valid_attack_pose(view) and view.player.is_playing(), "stopped player is rearmed even when cached clip name matches")
		view.sync_action(false, &"basic", 123, 1.0, 0.6, 0.4)
		view.react_hit()
		check(view.active_clip == profile.hit_clip, "HitReact works again when the attack is over")
		check(actor.position == Vector3.ZERO and actor.state.health == actor.state.max_health, "visual conflict cannot mutate actor or health")
		for skill in [&"heal", &"lightning"]:
			var windup: float = 1.5 if skill == &"heal" else 2.0
			view.sync_action(true, skill, 124, windup * 0.5, windup, 0.4)
			check(clip_pose_matches(view, profile.cast_clip) and view.hit_remaining == 0, "cast immediately interrupts HitReact and plays Duck")
			for hit in range(6): view.react_hit()
			check(clip_pose_matches(view, profile.cast_clip) and view.cast_active, "hits cannot replace an incantation")
			check(is_equal_approx(view.clip_time, profile.cast_release * 0.5), "Duck follows the actual 1.5 or 2 second windup")
			view.sync_action(true, skill, 124, windup + 0.2, windup, 0.4)
			view.react_hit()
			check(clip_pose_matches(view, profile.cast_clip), "cast recovery also keeps priority over HitReact")
		view.sync_action(true, &"lightning", 124, 2.4 - 0.000000000000001, 2.0, 0.4)
		check(clip_pose_matches(view, profile.cast_clip) and view.player.is_playing(), "cast end boundary does not stop the player")
		view.sync_action(true, &"heal", 125, 0.2, 1.5, 0.4)
		check(clip_pose_matches(view, profile.cast_clip), "consecutive sorts reuse Duck without interruption")
		view.sync_action(false, &"heal", 124, 2.4, 2.0, 0.4)
		view.react_hit()
		view.pose(0, true, Vector2.DOWN)
		check(view.active_clip == profile.move_clip and view.hit_remaining == 0, "movement immediately interrupts HitReact")
		view.react_hit()
		check(view.active_clip == profile.move_clip, "HitReact cannot interrupt movement")
		view.sync_action(true, &"heal", 125, 0.4, 1.5, 0.4)
		view.start_death()
		view.sync_action(true, &"lightning", 126, 0.4, 2.0, 0.4)
		view.react_hit()
		check(view.active_clip == profile.death_clip and view.dying, "death immediately interrupts casting and cannot be interrupted")
	actor.queue_free()
	await get_tree().process_frame
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	app.simulation.rules.anne[0].enabled = false
	app.simulation.rules.mako[0].enabled = false
	var anne = app.simulation.hero(&"anne")
	var mako = app.simulation.hero(&"mako")
	anne.place(Vector2(-0.8, 0))
	mako.place(Vector2(0.8, 0))
	app.simulation.add_enemy(Vector2(-0.8, 0.8))
	app.simulation.add_enemy(Vector2(0.8, -0.8))
	for unit in app.simulation.all_units(): unit.mover.speed = 0
	# Their incoming hits resolve in the exact tick where each hero starts an attack.
	for i in range(2):
		var enemy = app.simulation.enemies[i]
		enemy.action.request(&"basic", anne if i == 0 else mako)
		enemy.action.advance(0.59)
	var intact: Dictionary = {"anne": true, "mako": true}
	var starts: Dictionary = {"anne": 0, "mako": 0}
	var received: Dictionary = {"anne": 0, "mako": 0}
	var previous: Dictionary = {"anne": 0, "mako": 0}
	for tick in range(180):
		app._physics_process(1.0/60.0)
		for hero in [anne, mako]:
			var key: String = String(hero.actor_key)
			if hero.action.active and hero.action.last_skill == &"basic":
				intact[key] = intact[key] and valid_attack_pose(hero.visual)
				if previous[key] != hero.action.action_id:
					starts[key] += 1
					previous[key] = hero.action.action_id
			for event in app.simulation.events:
				if event.kind == "resolve" and event.target_id == hero.combat_id and event.damage > 0: received[key] += 1
		if tick % 30 == 0:
			await get_tree().process_frame
			for hero in [anne,mako]:
				if hero.action.active and hero.action.last_skill == &"basic": intact[String(hero.actor_key)] = intact[String(hero.actor_key)] and valid_attack_pose(hero.visual)
	for key in ["anne", "mako"]:
		check(starts[key] >= 2 and received[key] >= 2, "fixture exercises repeated attacks and incoming hits on " + key)
		check(intact[key], "actual Main never loses the active attack, including frame boundaries: " + key)
	# Same-tick incoming hits while each hero starts a different spell.
	app._reset()
	app.simulation.rules.anne[0].enabled = true
	app.simulation.rules.mako[0].enabled = true
	anne = app.simulation.hero(&"anne")
	mako = app.simulation.hero(&"mako")
	mako.state.damage(110)
	app.simulation.add_enemy(Vector2(-0.65, 1.45))
	app.simulation.add_enemy(Vector2(0.65, -1.45))
	for unit in app.simulation.all_units(): unit.mover.speed = 0
	for i in range(2):
		var enemy = app.simulation.enemies[i]
		enemy.action.request(&"basic", anne if i == 0 else mako)
		enemy.action.advance(0.59)
	app._physics_process(1.0/60.0)
	check(anne.action.last_skill == &"heal" and mako.action.last_skill == &"lightning", "actual Main starts Anne's heal and Mako's lightning")
	check(clip_pose_matches(anne.visual, anne.appearance.cast_clip) and clip_pose_matches(mako.visual, mako.appearance.cast_clip), "both casts own the skeleton despite simultaneous incoming hits")
	var all_actions_visible: bool = true
	for tick in range(180):
		app._physics_process(1.0/60.0)
		for hero in [anne,mako]:
			if hero.state.alive and hero.action.active:
				var expected: StringName = hero.appearance.attack_clip if hero.action.last_skill == &"basic" else hero.appearance.cast_clip
				var matches: bool = clip_pose_matches(hero.visual, expected) and hero.visual.hit_remaining == 0
				all_actions_visible = all_actions_visible and matches
	check(all_actions_visible, "every active attack/cast/recovery has priority over Idle and HitReact in actual Main")
	main.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "priority test leaves no orphan views")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
