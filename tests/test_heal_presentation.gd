extends Node
const Presenter = preload("res://scripts/presentation/combat_presenter.gd")
const Main = preload("res://scenes/main.tscn")
const Gallery = preload("res://scenes/debug/heal_lab.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("HealPresentation: " + message)

func event(sequence: int, healing: int = 30, kind: String = "resolve") -> Dictionary:
	return {"run_id": 1, "sequence": sequence, "source_id": 1, "target_id": 2,
		"kind": kind, "skill": "heal", "healing": healing, "target_position": Vector3(1, 0, 2)}

func _ready() -> void:
	var presenter := Presenter.new()
	add_child(presenter)
	presenter.reset_run(1)
	for kind in ["start", "cancel", "end"]: presenter.consume(event(presenter._sequences.get(1, 0) + 1, 30, kind))
	check(presenter.heal_effects.is_empty(), "engagement and cancellation cannot signal success")
	presenter.consume(event(4, 0))
	check(presenter.heals_played == 0, "zero effective healing has no success effect")
	presenter.consume(event(5, 7))
	check(presenter.heals_played == 1 and presenter.heal_effects.size() == 1, "effective healing creates one effect")
	var effect = presenter.heal_effects[0].view
	check(effect.amount == 7 and effect.amount_label.text == "+7", "display real clipped heal, not constant 30")
	check(effect.position == Vector3(1, 0, 2), "use resolution location even without a character view")
	presenter.consume(event(5, 7))
	check(presenter.heals_played == 1, "duplicate event cannot duplicate healing art")
	presenter.present([], [], 0, 1)
	check(effect.age == 0, "paused visual time freezes halo and amount")
	presenter.present([], [], 0.3, 1)
	check(is_equal_approx(effect.age, 0.3), "effect progresses only by supplied time")
	presenter.present([], [], 2.0, 1)
	check(presenter.heal_effects.is_empty(), "large accepted step still cleans up")
	for i in range(20): presenter.consume(event(10 + i))
	check(presenter.heal_effects.size() == presenter.MAX_HEAL_EFFECTS, "effects remain bounded under a burst")
	presenter.consume({"run_id": 1, "kind": "death", "actor_id": 2})
	check(presenter.heal_effects.is_empty(), "target death clears its existing healing art")
	presenter.consume(event(40))
	check(presenter.heal_effects.is_empty(), "dead target cannot gain a success visual")
	presenter.reset_run(2)
	presenter.consume(event(41))
	check(presenter.heal_effects.is_empty(), "old run resolutions ignored after replay")
	presenter.reset_run(1)
	presenter.heal_definition = presenter.heal_definition.duplicate()
	presenter.heal_definition.scene = null
	presenter.consume(event(1))
	check(presenter.heal_effects.is_empty(), "missing optional effect scene is safe")
	presenter.heal_definition = preload("res://resources/presentation/effects/heal.tres")
	presenter.enabled = false
	presenter.consume(event(2))
	check(presenter.heal_effects.is_empty(), "disabled adapter does not spawn optional art")
	presenter.enabled = true
	for replay in range(10):
		presenter.reset_run(replay + 3)
		var resolution: Dictionary = event(1)
		resolution.run_id = replay + 3
		presenter.consume(resolution)
		check(presenter.heal_effects.size() == 1, "one new effect in replay %d" % replay)
	presenter.reset_run(20)
	check(presenter.heal_effects.is_empty(), "ten replays leave no retained art")
	presenter.queue_free()
	await get_tree().process_frame
	for manual in [false, true]:
		for self_heal in [false, true]:
			var main = Main.instantiate()
			var app = main.get_node("ApplicationLab")
			app.save_path = ""
			add_child(main)
			app.set_process(false)
			app.set_physics_process(false)
			var anne = app.simulation.hero(&"anne")
			var target = anne if self_heal else app.simulation.hero(&"mako")
			target.state.damage(100)
			for unit in app.simulation.all_units(): unit.mover.speed = 0
			if manual:
				for row in app.simulation.rules.anne: row.enabled = false
				check(app.simulation.request_manual(&"anne", &"heal"), "manual heal accepted")
			for tick in range(85): app._physics_process(1.0/60.0)
			check(anne.action.casting() and app.action_presenter.heals_played == 0, "Duck is preparation only, manual/auto/self/ally")
			check(anne.action.spent == 0, "visual preparation cannot spend mana")
			for tick in range(12): app._physics_process(1.0/60.0)
			check(app.action_presenter.heals_played == 1, "manual and automatic healing use the same successful path")
			check(anne.action.spent == 20, "real heal still spends exactly 20 mana")
			check(app.action_presenter.heal_effects[0].target_id == target.combat_id, "effect targets actual ally or caster")
			var art = app.action_presenter.heal_effects[0].view
			var age: float = art.age
			app.paused = true
			for tick in range(10): app._physics_process(1.0/15.0)
			check(art.age == age, "Main pause freezes success effect")
			app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
			app.notification(NOTIFICATION_APPLICATION_PAUSED)
			app._physics_process(1)
			check(art.age == age, "background freezes healing halo")
			app.notification(NOTIFICATION_APPLICATION_RESUMED)
			app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
			app._toggle_pause()
			app._physics_process(1)
			check(art.age == age, "return frame discards elapsed background time")
			app._physics_process(1.0/60.0)
			check(art.age > age, "explicit resume restarts halo normally")
			age = art.age
			app._open_arena_picker()
			app._physics_process(1)
			app._close_arena_picker()
			app._physics_process(1)
			check(app.paused and art.age == age, "closing a menu cannot resume halo")
			app._reset()
			check(app.action_presenter.heal_effects.is_empty(), "replay clears art immediately")
			main.queue_free()
			await get_tree().process_frame
			await get_tree().process_frame
	# Resolution failures exercise real executors; none should create a success effect.
	for failure in ["death", "full", "range", "cancel", "source_death"]:
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		var anne = app.simulation.hero(&"anne")
		var mako = app.simulation.hero(&"mako")
		mako.state.damage(100)
		app._physics_process(1.0/60.0)
		for row in app.simulation.rules.anne: row.enabled = false
		if failure == "death": mako.state.damage(10000)
		elif failure == "source_death": anne.state.damage(10000)
		elif failure == "full": mako.state.heal(1000)
		elif failure == "range":
			anne.place(Vector2(-2.5, 2.5))
			mako.place(Vector2(2.5, -2.5))
			anne.mover.speed = 0
			mako.mover.speed = 0
		else: anne.action.cancel()
		for tick in range(120): app._physics_process(1.0/60.0)
		check(app.action_presenter.heals_played == 0, "no success visual after " + failure)
		check(anne.action.spent == 0, "no visual mana side effect after " + failure)
		main.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame
	# The origin follows a living model using copied presentation values only.
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	var target = app.simulation.hero(&"mako")
	target.appearance = target.appearance.duplicate()
	target.appearance.heal_effect_origin = Vector3(0, 0.2, 0)
	app.action_presenter.capture(app.simulation.all_units(), app.simulation.run_id)
	var resolution: Dictionary = event(1, 5)
	resolution.run_id = app.simulation.run_id
	resolution.target_id = target.combat_id
	resolution.target_position = target.position
	app.action_presenter.consume(resolution)
	var anchored = app.action_presenter.heal_effects[0].view
	check(anchored.position.is_equal_approx(target.position + Vector3(0, 0.2, 0)), "per-model origin is configurable")
	target.place(Vector2(1.5, 1.5))
	var no_events: Array[Dictionary] = []
	app.action_presenter.present(app.simulation.all_units(), no_events, 0.1, app.simulation.run_id)
	check(anchored.position.is_equal_approx(target.position + Vector3(0, 0.2, 0)), "local halo follows its living target")
	app.action_presenter.enabled = false
	app.action_presenter.present(app.simulation.all_units(), no_events, 0, app.simulation.run_id)
	check(app.action_presenter.heal_effects.is_empty(), "disabling adapter removes active halos")
	main.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	gallery._heal_preview()
	for tick in range(50): gallery._process(1.0/30.0)
	check(is_instance_valid(gallery.effect) and gallery.effect.amount == 30, "F6 sample previews successful heal")
	check(gallery.gallery_actors[0].state.health == gallery.gallery_actors[0].state.max_health, "F6 preview never changes health")
	var age: float = gallery.effect.age
	gallery.paused = true
	gallery._process(1)
	check(gallery.effect.age == age, "F6 also freezes halo while paused")
	gallery.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "no orphan effects")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
