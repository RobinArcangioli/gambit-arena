extends Node
const Actor = preload("res://scripts/combat/stats_actor.gd")
const Body = preload("res://scripts/crowd/ground_crowd.gd")
const Profiles = [preload("res://resources/presentation/characters/anne.tres"), preload("res://resources/presentation/characters/mako.tres"), preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FootprintShadow: " + message)
func _ready() -> void:
	var actor := Actor.new()
	add_child(actor)
	for profile in Profiles:
		actor.set_appearance(profile)
		var view = actor.visual
		var shadow = view.ground_shadow
		check(shadow != null and shadow.visible, "a footprint exists for " + profile.display_name)
		check(shadow.mesh.size.is_equal_approx(Vector2.ONE * Body.DIAMETER), "disk bounds match the actual physical diameter")
		actor.position = Vector3(1.1, 0, -0.8)
		for angle in range(8):
			actor.pose(0, true, Vector2.DOWN.rotated(angle * PI / 4))
			actor.advance_visual(0.1)
			var center: Vector3 = shadow.global_position
			check(Vector2(center.x, center.z).is_equal_approx(Vector2(actor.position.x, actor.position.z)), "rotations and walking keep the disk centered on the ground body")
		view.model.scale *= 1.3
		check(shadow.mesh.size.is_equal_approx(Vector2.ONE * Body.DIAMETER) and shadow.global_basis.get_scale().is_equal_approx(Vector3.ONE), "art scale does not silently change the physical footprint")
		actor.visual.react_hit()
		check(shadow.material_overlay == null, "hit flash affects model only")
		actor.visual.start_death()
		actor.advance_visual(0.5)
		check(shadow.position.is_equal_approx(Vector3(0, shadow.GROUND_LIFT, 0)), "death pose does not drag the disk through the ground")
		var released = actor.release_visual()
		add_child(released)
		check(released.ground_shadow == shadow, "released death view owns its footprint")
		released.queue_free()
		await get_tree().process_frame
	var profile = Profiles[0].duplicate()
	profile.ground_shadow_enabled = false
	actor.set_appearance(profile)
	check(actor.visual.valid and actor.visual.ground_shadow == null, "artist can disable the disk without disabling the character")
	profile.ground_shadow_enabled = true
	profile.ground_shadow_color = Color(0.1, 0.2, 0.3, 0.18)
	profile.ground_shadow_feather = 0.1
	actor.set_appearance(profile)
	check(actor.visual.ground_shadow.material_override.get_shader_parameter("tint") == profile.ground_shadow_color, "style comes from the replaceable art definition")
	actor.set_appearance(null, false)
	check(actor.get_child_count() == 0, "disabled presentation leaves no footprint node")
	actor.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "replacement and death leave no orphan")
	print("%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures])
	var label := Label.new()
	label.text = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	add_child(label)
