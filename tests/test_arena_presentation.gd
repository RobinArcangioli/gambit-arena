extends Node
const Gallery = preload("res://scenes/debug/graphics_lab.tscn")
const Main = preload("res://scenes/debug/graphics003_reference.tscn")
const REFERENCE = preload("res://resources/presentation/arenas/reference.tres")
const COLISEE = preload("res://resources/presentation/arenas/colisee_solaire.tres")
const Definition = preload("res://scripts/presentation/arena_definition.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("ArenaPresentation: " + message)

func _ready() -> void:
	var gallery = Gallery.instantiate()
	add_child(gallery)
	await get_tree().process_frame
	check(gallery.floor_canvas.definition == COLISEE, "gallery begins with supplied Colisee")
	var camera_transform: Transform3D = gallery.camera.transform
	var camera_size: float = gallery.camera.size
	var positions: Array = [gallery.hero.position, gallery.enemy.position]
	for index in range(20):
		gallery.select_arena(REFERENCE if index % 2 == 0 else COLISEE)
		await get_tree().process_frame
	check(gallery.floor_canvas.get_child_count() == 1, "switches replace and release the previous view")
	check(gallery.camera.transform == camera_transform and gallery.camera.size == camera_size, "switch keeps camera projection and orientation")
	check(positions == [gallery.hero.position, gallery.enemy.position], "switch leaves ground placement untouched")
	var illustrated = gallery.floor_canvas.active_view
	for size_value in [Vector2(516, 540), Vector2(516, 304), Vector2(336, 180), Vector2(700, 800)]:
		gallery.render_box.size = size_value
		await get_tree().process_frame
		gallery._sync_projection()
		check(is_equal_approx(illustrated.image_rect.size.x / illustrated.image_rect.size.y, 540.0 / 960.0), "image has uniform scale at %s" % size_value)
		var inside: bool = true
		for point in [Vector2.ZERO, Vector2(-3, -3), Vector2(3, -3), Vector2(3, 3), Vector2(-3, 3)]:
			inside = inside and illustrated.inside_calibration(point)
		check(inside, "logical center and all terrain corners stay inside supplied calibration diamond at %s" % size_value)
		check(illustrated.ground_to_image(Vector2.ZERO).is_equal_approx(Vector2(270, 455)), "visual grid center aligned with logical origin")
	gallery._toggle_calibration()
	check(illustrated.show_calibration, "grid overlay is independent from game state")
	gallery.floor_canvas.set_definition(Definition.new())
	check(gallery.floor_canvas.definition == REFERENCE, "missing definition scene falls back to reference")
	var wrong := Definition.new()
	wrong.view_scene = PackedScene.new()
	var wrong_root := Node.new()
	wrong.view_scene.pack(wrong_root)
	wrong_root.free()
	gallery.floor_canvas.set_definition(wrong)
	check(gallery.floor_canvas.definition == REFERENCE, "incompatible scene safely falls back")
	gallery.queue_free()
	await get_tree().process_frame
	# Same real Main simulation, different views. Compare every tick, not just the outcome.
	var runs: Array = []
	for choice in [REFERENCE, COLISEE, null]:
		var main = Main.instantiate()
		add_child(main)
		var lab = main.get_node("ApplicationLab")
		lab.set_physics_process(false)
		lab.set_process(false)
		lab.floor_canvas.set_definition(choice)
		lab.floor_canvas.set_presentation_enabled(choice != null)
		var ticks: Array = []
		for tick in range(900):
			lab._physics_process(1.0 / 60.0)
			var sim = lab.simulation
			var units: Array = []
			for unit in [sim.hero] + Array(sim.enemies):
				units.append([unit.position, unit.state.health, unit.action.energy, unit.action.phase,
					unit.action.spent, unit.action.applied_damage, unit.action.applied_healing,
					unit.mover.facing, unit.action.last_skill])
			ticks.append([sim.elapsed, sim.result, sim.spawned, sim.defeated, sim.hits, sim.wave_number, units])
		check(lab.floor_canvas.active_view.visible == (choice != null), "null presentation is hidden without stopping simulation")
		runs.append(ticks)
		main.queue_free()
		await get_tree().process_frame
	check(runs[0] == runs[1] and runs[1] == runs[2], "900 real ticks identical with reference, Colisee and absent arena view")
	var summary: String = "GRAPHICS-001 / arenes\n%s : %d controles, %d echecs\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
	if "--test-exit" in OS.get_cmdline_user_args():
		get_tree().quit(0 if failures == 0 else 1)
