extends Node
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Main = preload("res://scenes/main.tscn")
const Gallery = preload("res://scenes/debug/action_lab.tscn")
const View = preload("res://scripts/presentation/character_view.gd")
const PROFILES = [preload("res://resources/presentation/characters/anne.tres"), preload("res://resources/presentation/characters/mako.tres"), preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("CombatPresentation: " + message)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func scalar_only(value: Variant) -> bool:
	if typeof(value) == TYPE_OBJECT or typeof(value) == TYPE_CALLABLE or typeof(value) == TYPE_SIGNAL: return false
	if value is Dictionary:
		for key in value:
			if not scalar_only(key) or not scalar_only(value[key]): return false
	if value is Array:
		for item in value:
			if not scalar_only(item): return false
	return true

func _ready() -> void:
	var original_orphans: int = int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var world := Node3D.new()
	add_child(world)
	var actor := Actor.new()
	world.add_child(actor)
	for profile in PROFILES:
		actor.set_appearance(profile)
		var view: View = actor.visual
		check(view.player.has_animation(profile.attack_clip) and view.player.has_animation(profile.hit_clip) and view.player.has_animation(profile.death_clip), "all action clips imported: " + profile.display_name)
		var original_transform: Transform3D = actor.transform
		view.sync_action(true, &"basic", 77, 0.3, 0.6, 0.4)
		check(view.active_clip == profile.attack_clip and is_equal_approx(view.clip_time, profile.attack_contact * 0.5), "windup is sampled before contact")
		view.sync_action(true, &"basic", 77, 0.6, 0.6, 0.4)
		check(is_equal_approx(view.clip_time, profile.attack_contact), "clip contact maps to real 0.6 second impact")
		view.react_hit()
		check(view.active_clip == profile.attack_clip and view.flash_remaining > 0 and view.hit_remaining == 0, "hit never interrupts attack animation")
		view.sync_action(true, &"basic", 77, 0.8, 0.6, 0.4)
		var expected: float = lerpf(profile.attack_contact, view.player.get_animation(profile.attack_clip).length, 0.5)
		check(is_equal_approx(view.clip_time, expected), "recovery sampled over actual 0.4 seconds")
		view.sync_action(false, &"basic", 77, 1.0, 0.6, 0.4)
		view.react_hit()
		check(view.active_clip == profile.hit_clip, "unoccupied actor plays HitReact")
		var before: float = view.clip_time
		view.advance_visual(0)
		check(view.clip_time == before, "no accepted time means no reaction progress")
		view.advance_visual(profile.hit_duration * 0.5)
		check(is_equal_approx(view.clip_time, view.player.get_animation(profile.hit_clip).length * 0.5), "reaction follows supplied game time")
		view.advance_visual(profile.hit_duration)
		check(view.hit_remaining == 0 and view.active_clip == profile.idle_clip and view.flash_remaining == 0, "reaction and flash finish cleanly")
		view.start_death()
		view.advance_visual(profile.death_duration * 0.5)
		check(view.dying and view.active_clip == profile.death_clip and is_equal_approx(view.clip_time, view.player.get_animation(profile.death_clip).length * 0.5), "death animation follows supplied time")
		view.advance_visual(10)
		view.pose(0, true, Vector2.UP)
		view.sync_action(true, &"basic", 99, 0.3, 0.6, 0.4)
		check(view.dying and view.active_clip == profile.death_clip and absf(view.clip_time - view.player.get_animation(profile.death_clip).length) <= 0.0002, "death clamps at last pose and cannot resume walking or attacking")
		check(actor.transform == original_transform, "all animation transforms remain below logical actor")
		var safe_tracks: bool = true
		for name in view.player.get_animation_list():
			var animation: Animation = view.player.get_animation(name)
			for track in range(animation.get_track_count()):
				safe_tracks = safe_tracks and animation.track_get_type(track) in [Animation.TYPE_POSITION_3D, Animation.TYPE_ROTATION_3D, Animation.TYPE_SCALE_3D]
				safe_tracks = safe_tracks and animation.track_get_path(track).get_subname_count() == 1 and str(animation.track_get_path(track).get_subname(0)).to_lower() != "root"
		check(safe_tracks, "clips contain only safe skeletal transforms, no callbacks or root motion")
	world.queue_free()
	await settle()
	await _test_main()
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	gallery._preview("attack")
	for i in range(38): gallery._process(1.0/60.0)
	check(gallery.gallery_actors[0].visual.attack_active and gallery.gallery_actors[1].visual.flash_remaining > 0, "F6 gallery previews attack and contact reaction")
	gallery._preview("death")
	gallery._process(0.1)
	check(gallery.gallery_actors[0].visual.dying and gallery.gallery_actors[1].visual.dying, "F6 gallery previews both deaths")
	gallery.paused = true
	var time_before: float = gallery.gallery_actors[0].visual.death_elapsed
	gallery._process(1)
	check(gallery.gallery_actors[0].visual.death_elapsed == time_before, "F6 death preview pauses")
	gallery._cycle_hero()
	check(not gallery.gallery_actors[0].visual.dying, "changing preview model resets its transient state")
	gallery.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == original_orphans, "new gallery and Main free every view")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)

func setup_fight(app) -> void:
	app.simulation.rules.anne[0].enabled = false
	app.simulation.rules.mako[0].enabled = false
	app.simulation.hero(&"anne").place(Vector2(-0.45, 0.45))
	app.simulation.hero(&"mako").place(Vector2(2, 2))
	app.simulation.add_enemy(Vector2(0.1, -0.1))
	for unit in app.simulation.all_units(): unit.mover.speed = 0.0

func _test_main() -> void:
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	setup_fight(app)
	var victim = app.simulation.enemies[0]
	app._physics_process(1.0/60.0)
	check(app.simulation.hero(&"anne").visual.attack_active, "real manual/automatic executor snapshot drives attack")
	check(app.simulation.events.any(func(row): return row.kind == "start"), "engagement event published")
	for i in range(36): app._physics_process(1.0/60.0)
	check(app.action_presenter.reactions_played > 0, "real applied damage creates visual feedback")
	check(app.simulation.events.all(scalar_only), "event payloads never contain live objects")
	var detached: Array[Dictionary] = app.simulation.events
	var published_count: int = detached.size()
	detached.clear()
	check(app.simulation.events.size() == published_count, "consumer cannot clear the producer's event frame")
	var copies: Array[Dictionary] = app.simulation.events.duplicate(true)
	var reactions: int = app.action_presenter.reactions_played
	for event in copies:
		for i in range(3): app.action_presenter.consume(event)
	check(app.action_presenter.reactions_played == reactions, "duplicate events never replay an impact")
	app._reset()
	setup_fight(app)
	victim = app.simulation.enemies[0]
	app._physics_process(1.0/60.0)
	victim.place(Vector2(2.8, -2.8))
	for i in range(37): app._physics_process(1.0/60.0)
	check(app.action_presenter.reactions_played == 0, "miss outside range never creates a successful hit")
	# A whole action can resolve between snapshots; consume its events, not only final phase.
	app._reset()
	setup_fight(app)
	var source = app.simulation.hero(&"anne")
	victim = app.simulation.enemies[0]
	var direct_id: int = source.action.request(&"basic", victim)
	source.action.advance(1.1)
	app._physics_process(1.0/60.0)
	var transitions: Array = []
	for event in app.simulation.events:
		if event.action_id == direct_id: transitions.append(event.kind)
	check(transitions == ["start", "resolve", "end"] and app.action_presenter.reactions_played == 1, "complete action between snapshots still gives one real impact reaction")
	# Last enemy dies; gameplay ends while a detached graphical death finishes afterward.
	app.simulation.wave_count = 1
	app.simulation.total_per_wave = 1
	app._reset()
	setup_fight(app)
	victim = app.simulation.enemies[0]
	var victim_id: int = victim.combat_id
	victim.state.damage(victim.state.health - 1)
	for i in range(38): app._physics_process(1.0/60.0)
	check(app.simulation.result == "VICTOIRE" and app.simulation.enemies.is_empty(), "death does not retain enemy in combat or delay victory")
	check(app.simulation.hero(&"anne").visual.attack_tail, "last killing strike visually completes recovery after terminal retirement")
	check(app.action_presenter.ghosts.size() == 1 and app.action_presenter.deaths_played == 1, "exactly one detached death view")
	check(not app.overhead.has(victim_id), "dead actor has no overhead HUD bars")
	var ghost: Dictionary = app.action_presenter.ghosts[0]
	check(ghost.view.dying and ghost.view.get_parent() == app.action_presenter, "death view is independent of queued logical unit")
	await settle()
	check(not is_instance_valid(victim) and is_instance_valid(ghost.view), "logical actor freed while its death view survives")
	var frozen_clock: float = app.simulation.clock.elapsed
	app.paused = true
	app._update_buttons()
	var frozen_age: float = ghost.age
	for i in range(10): app._physics_process(1)
	check(ghost.age == frozen_age, "pause freezes detached death")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	app.notification(NOTIFICATION_APPLICATION_PAUSED)
	app._physics_process(1)
	check(ghost.age == frozen_age, "Android background freezes detached death")
	app.notification(NOTIFICATION_APPLICATION_RESUMED)
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	app._toggle_pause()
	app._physics_process(1)
	check(ghost.age == frozen_age, "return tick cannot jump death animation")
	app._physics_process(1)
	check(is_equal_approx(ghost.age - frozen_age, 1.0/30.0), "terminal visual tail is clamped without game-time catchup")
	check(app.simulation.clock.elapsed == frozen_clock, "death tail never advances stopped gameplay clock")
	for i in range(60): app._physics_process(1.0/60.0)
	check(app.action_presenter.ghosts.is_empty(), "death view released after animation and short hold")
	check(not app.simulation.hero(&"anne").visual.attack_active, "terminal attack tail also finishes without rearming")
	var stale: Dictionary = {"kind": "death", "run_id": app.simulation.run_id, "actor_id": victim_id}
	app._reset()
	app.action_presenter.consume(stale)
	check(app.action_presenter.ghosts.is_empty() and app.action_presenter.deaths_played == 0, "events from an old run are ignored")
	for cycle in range(10):
		setup_fight(app)
		app.simulation.enemies[0].state.damage(100000)
		app.paused = true
		app._update_buttons()
		app._physics_process(1.0/60.0)
		check(app.action_presenter.ghosts.size() == 1, "external death while paused is captured once")
		app._reset()
		check(app.action_presenter.ghosts.is_empty(), "replay immediately releases every previous death view")
		await settle()
	app.action_animations_enabled = false
	setup_fight(app)
	app.simulation.enemies[0].state.damage(100000)
	app._physics_process(1.0/60.0)
	check(app.action_presenter.ghosts.is_empty(), "action presentation can be disabled without gameplay dependency")
	app._reset()
	app.action_animations_enabled = true
	for hero in app.simulation.heroes: hero.state.damage(100000)
	app._physics_process(1.0/60.0)
	check(app.simulation.result == "DEFAITE" and app.action_presenter.ghosts.size() == 2, "both dead heroes also receive independent death views")
	app._reset()
	check(app.action_presenter.ghosts.is_empty() and app.simulation.heroes.all(func(unit): return unit.state.alive and unit.visual != null), "replay creates new live heroes without resurrecting old views")
	app.simulation.max_alive = 20
	app.simulation.total_per_wave = 20
	app._reset()
	for i in range(20): app.simulation.add_enemy(app.simulation.Pattern.spawn_position(i))
	for unit in app.simulation.enemies: unit.state.damage(100000)
	app._physics_process(1.0/60.0)
	check(app.action_presenter.ghosts.size() == app.action_presenter.MAX_GHOSTS, "many simultaneous deaths respect the visual view cap")
	await settle()
	check(app.action_presenter.get_child_count() == app.action_presenter.MAX_GHOSTS, "evicted death views are freed")
	app._reset()
	check(app.action_presenter.ghosts.is_empty(), "replay clears capped death batches")
	app.paused = false
	app._update_buttons()
	setup_fight(app)
	source = app.simulation.hero(&"anne")
	victim = app.simulation.enemies[0]
	for i in range(40):
		source.action.request(&"basic", victim)
		source.action.cancel()
	var bounded: Array[Dictionary] = source.action.take_visual_events()
	check(bounded.size() == source.action.MAX_VISUAL_EVENTS and bounded.all(scalar_only), "actor event queue is bounded and value-only")
	check(source.action.take_visual_events().is_empty() and source.action.spent == 0, "draining events consumes them without spending resources")
	main.queue_free()
	await settle()
