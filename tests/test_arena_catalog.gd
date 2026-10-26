extends Node
const Main = preload("res://scenes/debug/graphics003_reference.tscn")
const Gallery = preload("res://scenes/debug/graphics_lab.tscn")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
const Illustrated = preload("res://scripts/presentation/illustrated_arena_view.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, caption: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("ArenaCatalog: " + caption)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func snapshot(lab: Node) -> Array:
	var sim = lab.simulation
	var rules: Array = []
	for rule in lab.editor.snapshot():
		rules.append([rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill])
	var data: Array = [sim.run_id, sim.elapsed, sim.spawned, sim.defeated, sim.hits, sim.wave_number,
		sim.manual.submitted, sim.manual.launched, sim.manual.snapshot(), rules]
	for actor in [sim.hero] + Array(sim.enemies):
		data.append([actor.combat_id, actor.position, actor.state.health, actor.action.energy,
			actor.action.elapsed, actor.action.action_id, actor.action.spent, actor.action.active])
	return data

func finger(at: Vector2, down: bool) -> void:
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.position = at
	touch.pressed = down
	get_viewport().push_input(touch, true)
	var copy := InputEventMouseButton.new()
	copy.device = -1
	copy.position = at
	copy.global_position = at
	copy.button_index = MOUSE_BUTTON_LEFT
	copy.pressed = down
	get_viewport().push_input(copy, true)

func drag(at: Vector2, offset: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = at
	event.relative = offset
	get_viewport().push_input(event, true)

func tap(at: Vector2) -> void:
	finger(at, true)
	finger(at, false)

func _ready() -> void:
	var initial_orphans: int = int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	check(Catalog.ids().size() == 9, "eight supplied arenas plus diagnostic reference")
	check(Catalog.definition(&"missing").arena_id == &"reference", "unknown ID has stable reference fallback")
	for arena_id in Catalog.ids():
		var definition = Catalog.definition(arena_id)
		check(definition.arena_id == arena_id and not definition.display_name.is_empty(), "profile identity %s" % arena_id)
		if arena_id != &"reference":
			check(Catalog.preview(arena_id).get_size() == Vector2(108, 192), "small thumbnail instead of full background %s" % arena_id)
	var main = Main.instantiate()
	add_child(main)
	var lab = main.get_node("ApplicationLab")
	lab.set_physics_process(false)
	lab.set_process(false)
	await settle()
	for tick in range(120):
		lab._physics_process(1.0 / 60.0)
	var before: Array = snapshot(lab)
	lab._open_performance()
	lab._open_arena_picker()
	check(lab.paused and lab.arena_picker.visible and not lab.performance_menu.visible, "picker opens in pause without overlapping menu")
	check(lab._touch_scrollers() == [lab.arena_picker.scroll], "picker owns only active touch list")
	check(lab.get_child(-1) == lab.application_guard, "application guard remains last input owner")
	check(not lab.start_benchmark("normal"), "benchmark cannot start beneath picker")
	# Every profile uses the same camera/calibration contract, on small and normal viewports.
	for arena_id in Catalog.ids():
		lab._choose_arena(arena_id)
		await settle()
		check(lab.floor_canvas.definition.arena_id == arena_id and lab.paused and not lab.arena_picker.visible, "selection closes picker and preserves explicit pause %s" % arena_id)
		check(snapshot(lab) == before, "selection does not reset, pay or mutate gameplay %s" % arena_id)
		if lab.floor_canvas.active_view is Illustrated:
			for view_size in [Vector2(516, 540), Vector2(336, 180)]:
				lab.render_box.size = view_size
				await settle()
				lab._sync_projection()
				var view = lab.floor_canvas.active_view
				var inside: bool = true
				for point in [Vector2.ZERO, Vector2(-3, -3), Vector2(3, -3), Vector2(3, 3), Vector2(-3, 3)]:
					inside = inside and view.inside_calibration(point)
				check(inside and is_equal_approx(view.image_rect.size.x / view.image_rect.size.y, 540.0 / 960.0), "same non-stretched ground registration %s / %s" % [arena_id, view_size])
		lab._open_arena_picker()
	lab._close_arena_picker()
	# Real scroll gesture starting on a thumbnail/card must never select an arena or skill.
	lab.safe_area_override = Rect2(20, 30, 360, 620)
	lab._update_layout()
	lab._open_arena_picker()
	await settle()
	lab.arena_picker.scroll.scroll_vertical = 0
	await settle()
	var start: Vector2 = lab.arena_picker.cards[&"colisee_solaire"].get_global_rect().position + Vector2(30, 60)
	var selected_before: StringName = lab.floor_canvas.definition.arena_id
	finger(start, true)
	drag(start - Vector2(0, 160), Vector2(0, -160))
	finger(start - Vector2(0, 160), false)
	await settle()
	check(lab.arena_picker.scroll.scroll_vertical > 0 and lab.arena_picker.visible and lab.floor_canvas.definition.arena_id == selected_before, "swipe from thumbnail scrolls without selecting")
	check(snapshot(lab) == before, "swipe submits no manual skill")
	var bar: VScrollBar = lab.arena_picker.scroll.get_v_scroll_bar()
	lab.arena_picker.scroll.scroll_vertical = int(bar.max_value)
	await settle()
	var last_at: Vector2 = lab.arena_picker.cards[&"reference"].get_global_rect().get_center()
	check(lab.arena_picker.scroll.get_global_rect().has_point(last_at), "last profile reachable in short viewport")
	tap(last_at)
	await settle()
	check(not lab.arena_picker.visible and lab.floor_canvas.definition.arena_id == &"reference" and lab.paused, "last card touch and mouse copy select exactly one profile")
	# Old press must not choose a different arena on application return.
	lab._open_arena_picker()
	lab.arena_picker.scroll.scroll_vertical = 0
	await settle()
	start = lab.arena_picker.cards[&"colisee_solaire"].get_global_rect().get_center()
	finger(start, true)
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	lab.notification(NOTIFICATION_APPLICATION_PAUSED)
	lab._choose_arena(&"sanctuaire_polaire")
	check(lab.floor_canvas.definition.arena_id == &"reference", "background cannot change selection")
	lab.notification(NOTIFICATION_APPLICATION_RESUMED)
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	finger(start, false)
	check(lab.arena_picker.visible and lab.floor_canvas.definition.arena_id == &"reference" and lab.paused, "old release after background is ignored")
	tap(start)
	check(lab.floor_canvas.definition.arena_id == &"colisee_solaire" and not lab.arena_picker.visible, "fresh touch works after return")
	check(snapshot(lab) == before, "full selection and lifecycle sequence preserves combat snapshot")
	var orphans_before: int = int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	for cycle in range(36):
		lab._open_arena_picker()
		lab._choose_arena(Catalog.ids()[cycle % 9])
		await settle()
	check(lab.floor_canvas.get_child_count() == 1, "36 switches retain exactly one active background")
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) <= orphans_before, "switching does not accumulate orphan nodes")
	check(snapshot(lab) == before, "36 replacements leave live actors and actions unchanged")
	lab._open_arena_picker()
	lab._choose_arena(&"pirates_fantomes")
	lab._reset()
	check(lab.floor_canvas.definition.arena_id == &"pirates_fantomes", "replay preserves chosen visual profile")
	main.queue_free()
	await settle()
	var gallery = Gallery.instantiate()
	add_child(gallery)
	await settle()
	for arena_id in Catalog.ids():
		gallery._open_picker()
		gallery._choose_gallery_arena(arena_id)
		check(gallery.floor_canvas.definition.arena_id == arena_id and not gallery.picker.visible, "standalone gallery supports %s" % arena_id)
	gallery.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == initial_orphans, "main and gallery destruction leave no orphan construction objects")
	var summary: String = "GRAPHICS-002 / catalogue\n%s : %d controles, %d echecs\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
	if "--test-exit" in OS.get_cmdline_user_args():
		get_tree().quit(0 if failures == 0 else 1)
