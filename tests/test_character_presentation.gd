extends Node
const Actor = preload("res://scripts/combat/stats_actor.gd")
const View = preload("res://scripts/presentation/character_view.gd")
const Definition = preload("res://scripts/presentation/character_definition.gd")
const Main = preload("res://scenes/debug/graphics003_reference.tscn")
const Gallery = preload("res://scenes/debug/character_lab.tscn")
const PROFILES = [preload("res://resources/presentation/characters/anne.tres"), preload("res://resources/presentation/characters/mako.tres"), preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("CharacterPresentation: " + message)

func _ready() -> void:
	var actor := Actor.new()
	add_child(actor)
	for profile in PROFILES:
		actor.set_appearance(profile)
		check(actor.visual is View and actor.visual.valid, "valid rig and clips: " + profile.display_name)
		var origin: Transform3D = actor.transform
		for angle in range(8):
			actor.pose(0.0, true, Vector2.DOWN.rotated(angle * PI / 4))
			actor.advance_visual(0.1)
		check(actor.transform == origin, "orientation and animation never move logical actor")
		check(actor.visual.active_clip == profile.move_clip, "walking clip selected")
		actor.pose(0.0, false, Vector2.UP)
		check(actor.visual.active_clip == profile.idle_clip, "stopped actor selects idle")
		var time_before: float = actor.visual.sample_time
		actor.advance_visual(0.0)
		actor.advance_visual(-1.0)
		check(actor.visual.sample_time == time_before, "zero or invalid accepted time stays frozen")
		check(actor.visual.player.callback_mode_process == AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL, "no engine clock animation")
		actor.advance_visual(0.2)
		check(is_equal_approx(actor.visual.sample_time, time_before + 0.2), "idle follows supplied time")
	actor.set_appearance(Definition.new())
	check(actor.left_leg != null, "missing model falls back to mannequin")
	var wrong := Definition.new()
	wrong.model = PackedScene.new()
	var plain := Node.new()
	wrong.model.pack(plain)
	plain.free()
	actor.set_appearance(wrong)
	check(actor.left_leg != null, "wrong root falls back without orphan")
	for i in range(24):
		actor.set_appearance(PROFILES[i % 4])
		await get_tree().process_frame
		check(actor.get_child_count() == 1, "replacement releases previous child")
	actor.set_appearance(null, false)
	check(actor.get_child_count() == 0, "null view creates no child")
	actor.queue_free()
	await get_tree().process_frame
	var sequences: Array = []
	for mode in range(4):
		var main = Main.instantiate()
		var lab = main.get_node("ApplicationLab")
		lab.hero_appearance = PROFILES[mode] if mode < 2 else null
		lab.enemy_appearance = PROFILES[mode + 2] if mode < 2 else null
		lab.characters_enabled = mode != 3
		add_child(main)
		lab.set_process(false)
		lab.set_physics_process(false)
		var frames: Array = []
		for tick in range(900):
			lab._physics_process(1.0 / 60.0)
			var sim = lab.simulation
			var units: Array = []
			for unit in [sim.hero] + Array(sim.enemies):
				units.append([unit.position, unit.state.health, unit.action.energy, unit.action.phase, unit.action.spent, unit.action.applied_damage, unit.action.applied_healing, unit.mover.facing, unit.action.last_skill])
			frames.append([sim.elapsed, sim.result, sim.spawned, sim.defeated, sim.hits, units])
		sequences.append(frames)
		lab.paused = true
		var hero_view = lab.simulation.hero.visual
		var previous_time: float = hero_view.sample_time if hero_view is View else 0.0
		lab._physics_process(1.0)
		check(not hero_view is View or hero_view.sample_time == previous_time, "pause freezes model")
		lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
		lab._physics_process(1.0)
		check(not hero_view is View or hero_view.sample_time == previous_time, "background freezes model")
		lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
		for replay in range(10):
			lab._reset()
			await get_tree().process_frame
		var actors: int = 0
		for child in lab.world.get_children():
			if child is Actor: actors += 1
		check(actors == 1 + lab.simulation.enemies.size(), "replay has only live run actors")
		check(lab.simulation.hero.presentation_enabled == (mode != 3), "replay keeps chosen presentation")
		main.queue_free()
		await get_tree().process_frame
	check(sequences[0] == sequences[1] and sequences[1] == sequences[2] and sequences[2] == sequences[3], "900 ticks identical across four models, mannequin and null")
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	gallery._cycle_hero()
	gallery._cycle_enemy()
	check(gallery.gallery_actors[0].appearance == PROFILES[1] and gallery.gallery_actors[1].appearance == PROFILES[3], "gallery exposes Mako and second skeleton")
	gallery._cycle_motion()
	gallery._process(0.1)
	check(gallery.gallery_actors[0].visual.walking, "gallery walking preview")
	gallery.paused = true
	var frozen: float = gallery.visual_time
	gallery._process(1.0)
	check(gallery.visual_time == frozen, "gallery pause freezes time")
	gallery.queue_free()
	await get_tree().process_frame
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
