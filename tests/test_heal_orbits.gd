extends Node
const Profile = preload("res://resources/presentation/effects/heal.tres")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("HealOrbits: " + message)
func _ready() -> void:
	var effect = Profile.scene.instantiate()
	add_child(effect)
	effect.setup(Profile, 7)
	check(is_equal_approx(effect.duration, 1.0), "complete success effect lasts one second")
	check(effect.opacity == 0 and effect.amount_label.text == "+7", "soft appearance keeps actual healed amount")
	var initial_outer: Basis = effect.halo.basis
	var initial_inner: Basis = effect.inner_ring.basis
	effect.advance_visual(0.25)
	check(not effect.halo.basis.y.is_equal_approx(initial_outer.y) and not effect.inner_ring.basis.y.is_equal_approx(initial_inner.y), "both ring planes really rotate, not an invisible spin about their normal")
	check(effect.halo.basis.y.cross(effect.inner_ring.basis.y).length() > 0.2, "ring planes have different axes")
	check(effect.halo.mesh.outer_radius > effect.inner_ring.mesh.outer_radius, "rings have nested radii")
	var center := Vector3(0, Profile.center_height, 0)
	for tick in range(20):
		effect.advance_visual(0.025)
		check(effect.halo.position == center and effect.inner_ring.position == center and effect.aura.position == center, "rotation never orbits either center away from the target")
	var alpha: float = effect.ring_materials[0].albedo_color.a
	check(alpha > 0 and alpha < Profile.ring_color.a, "late phase fades gradually while remaining translucent")
	var frozen: Array = [effect.age, effect.halo.transform, effect.inner_ring.transform, effect.opacity]
	for delta in [0.0, -1.0, INF, NAN]: effect.advance_visual(delta)
	check(frozen == [effect.age, effect.halo.transform, effect.inner_ring.transform, effect.opacity], "zero and invalid time cannot change rings or glow")
	effect.advance_visual(0.24)
	check(effect.opacity < 0.01 and effect.age < effect.duration, "fade approaches transparent before cleanup")
	effect.advance_visual(0.5)
	check(effect.age == effect.duration and effect.opacity == 0 and effect.ring_materials[0].albedo_color.a == 0, "one second ends fully transparent even on a large accepted step")
	check(effect.amount_label.modulate.a == 0 and effect.amount_label.outline_modulate.a == 0, "number and its outline fade completely too")
	check(effect.glow_materials.all(func(paint): return paint.get_shader_parameter("visibility") == 0), "glow also reaches zero")
	effect.queue_free()
	var custom = Profile.duplicate()
	custom.ring_color.a = 0.2
	effect = custom.scene.instantiate()
	add_child(effect)
	effect.setup(custom, 3)
	effect.advance_visual(0.2)
	check(is_equal_approx(effect.ring_materials[0].albedo_color.a, 0.2), "artist alpha is respected independently of timing")
	effect.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "no orphan meshes or labels")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new();label.text = summary;add_child(label)
