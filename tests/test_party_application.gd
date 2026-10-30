extends Node
const Main = preload("res://scenes/main.tscn")
const Actor = preload("res://scripts/party/party_unit.gd")
const Rules = preload("res://scripts/party/party_rules.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("PartyApplication: " + message)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

func mouse_button(at: Vector2, pressed_value: bool) -> void:
	var event := InputEventMouseButton.new()
	event.device = -1
	event.position = at
	event.global_position = at
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed_value else 0
	event.pressed = pressed_value
	get_viewport().push_input(event, true)

func finger(at: Vector2, pressed_value: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = at
	event.pressed = pressed_value
	get_viewport().push_input(event, true)
	mouse_button(at, pressed_value)

func tap(at: Vector2) -> void:
	finger(at, true)
	finger(at, false)

func swipe(at: Vector2, movement: Vector2) -> void:
	finger(at, true)
	var event := InputEventScreenDrag.new()
	event.index = 0
	event.position = at + movement
	event.relative = movement
	get_viewport().push_input(event, true)
	finger(at + movement, false)

func scalar_state(sim) -> Array:
	var rows: Array = []
	for actor in sim.all_units(): rows.append([actor.position, actor.state.health, actor.action.mana, actor.action.elapsed, actor.action.accepted, actor.action.spent])
	return [sim.clock.elapsed, sim.run_id, sim.spawned, sim.result, rows, sim.rules.duplicate(true)]

func _ready() -> void:
	var initial_orphans: int = int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	await settle()
	check(app.simulation.heroes.size() == 2, "actual Main composes two heroes")
	check(app.simulation.hero(&"anne").visual.definition.character_id == &"anne" and app.simulation.hero(&"mako").visual.definition.character_id == &"mako", "logical identity selects independent art profiles")
	check(app.get_child(-1) == app.application_guard, "input guard remains last child")
	app.safe_area_override = Rect2(70, 100, 360, 640)
	app._update_layout()
	await settle()
	get_viewport().notify_mouse_entered()
	tap(app.hero_buttons[1].get_global_rect().get_center())
	check(app.selected_hero == &"mako" and app.skill_buttons.size() == 3, "real touch and mouse copy select Mako once")
	check("Foudre" in app.skill_buttons[1].text and not "Speciale" in app.status.text, "active HUD names owned skills without secondary special")
	app.simulation.add_enemy(Vector2(2, 0))
	await settle()
	var button_at: Vector2 = app.skill_buttons[1].get_global_rect().get_center()
	tap(button_at)
	check(app.simulation.hero(&"mako").pending.get("skill") == &"lightning", "manual touch queues Mako lightning")
	check(app.simulation.hero(&"mako").action.spent == 0, "touch does not commit outside next game tick")
	app._physics_process(1.0 / 60.0)
	check(app.simulation.hero(&"mako").action.last_skill == &"lightning" and app.simulation.hero(&"mako").action.spent == 0 and app.simulation.hero(&"mako").action.mana == 60, "one touch starts lightning without early mana debit")
	app.simulation.hero(&"mako").state.damage(110)
	for i in range(30): app._physics_process(1.0/60.0)
	app._update_bars()
	var anne = app.simulation.hero(&"anne")
	var mako = app.simulation.hero(&"mako")
	var anne_bar = app.overhead[anne.combat_id]
	var mako_bar = app.overhead[mako.combat_id]
	check(anne_bar.casting and mako_bar.casting, "both spell bars visible while casting")
	check(is_equal_approx(anne_bar.cast_ratio, anne.action.cast_progress()) and is_equal_approx(mako_bar.cast_ratio, mako.action.cast_progress()), "bars use executor progress, not wall time")
	check(anne_bar.health_color.r > anne_bar.health_color.b and anne_bar.mana_color.b > anne_bar.mana_color.r and anne_bar.cast_color==Color("8befff"), "red health, blue mana, light cyan spell cast palette")
	check(anne_bar.mouse_filter == Control.MOUSE_FILTER_IGNORE, "overhead bars cannot capture touch")
	check(app.overhead.size() == 3, "each hero and enemy has bars")
	app.paused = true
	app._update_buttons()
	var frozen: Array = scalar_state(app.simulation)
	for i in range(10): app._physics_process(1.0)
	check(scalar_state(app.simulation) == frozen, "pause freezes full party and spells")
	var cast_time: float = mako.action.elapsed
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	app.notification(NOTIFICATION_APPLICATION_PAUSED)
	app._command(&"lightning")
	app._physics_process(1.0)
	check(mako.action.elapsed == cast_time and app.paused, "background cannot queue or progress a spell")
	app.notification(NOTIFICATION_APPLICATION_RESUMED)
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	app._toggle_pause()
	app._physics_process(1.0)
	check(mako.action.elapsed == cast_time, "first returned tick is discarded")
	app._physics_process(1.0/60.0)
	check(mako.action.elapsed > cast_time, "explicit resume restores accepted game time")
	app.paused = true
	app._update_buttons()
	app._show_tab("rules")
	await settle()
	var rules_before: Dictionary = app.simulation.rules.duplicate(true)
	var at: Vector2 = app.rules_buttons[0].get_global_rect().get_center()
	swipe(at, Vector2(0, -90))
	await settle()
	check(app.footer_scroll.scroll_vertical > 0 and not app.overlay.visible, "swipe starting on rule scrolls without editing")
	check(app.simulation.rules == rules_before, "swipe never mutates rules")
	app.footer_scroll.scroll_vertical = 0
	await settle()
	tap(app.rules_buttons[0].get_global_rect().get_center())
	await settle()
	check(app.editing_index == 0 and app.paused and app.overlay.visible, "rule opens in pause through real touch")
	check(app._touch_scrollers() == [app.modal_scroll], "modal owns only active scroller")
	app._cycle_rule_skill()
	check(app.draft.skill == "basic" and app.draft.target == "enemy", "Mako draft cannot acquire Anne heal")
	app._close_modal()
	check(app.simulation.rules == rules_before, "cancel leaves both hero configurations intact")
	app._select_hero(&"anne")
	app._open_rule(0)
	check(app.draft.target == "ally" and app.draft.threshold == 50, "Anne starts with ally below 50 percent")
	app._change_threshold(-1)
	app._apply_rule()
	check(app.simulation.rules.anne[0].threshold == 49 and app.simulation.rules.mako == rules_before.mako, "editing changes only selected hero")
	app._preview_migration()
	check(app.overlay.visible and app.simulation.rules.anne[0].threshold == 49, "migration preview never applies silently")
	app._close_modal()
	app._preview_migration()
	app._apply_migration()
	check(app.simulation.rules.anne[0].target == "ally" and not app.simulation.rules.anne[1].enabled, "explicit migration confirmation applies compatible rules")
	var before_arena: Array = scalar_state(app.simulation)
	app._open_arena_picker()
	check(app.paused and app._touch_scrollers() == [app.arena_picker.scroll], "arena catalogue opens safely in party screen")
	app._choose_arena(&"pirates_fantomes")
	check(app.floor_canvas.definition.arena_id == &"pirates_fantomes" and scalar_state(app.simulation) == before_arena, "changing arena leaves full party state intact")
	for id in app.Catalog.ids():
		app._open_arena_picker()
		app._choose_arena(id)
		check(app.floor_canvas.definition.arena_id == id and scalar_state(app.simulation) == before_arena, "all catalogue profiles preserve the party")
	app._open_arena_picker()
	app._choose_arena(&"pirates_fantomes")
	for i in range(12):
		app._reset()
		await settle()
		var actors: int = 0
		for child in app.world.get_children():
			if child is Actor: actors += 1
		check(actors == 2 and app.overhead.size() == 2, "replay cleans actors and bars")
	check(app.floor_canvas.definition.arena_id == &"pirates_fantomes" and app.simulation.rules.anne[0].target == "ally", "replay preserves arena and per-hero rules")
	main.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == initial_orphans, "party screen destruction leaves no orphan nodes")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
