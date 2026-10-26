extends Node
const Presenter = preload("res://scripts/presentation/combat_presenter.gd")
const Main = preload("res://scenes/main.tscn")
const Gallery = preload("res://scenes/debug/lightning_lab.tscn")
const Profile = preload("res://resources/presentation/effects/lightning.tres")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("LightningPresentation: " + message)

func event(sequence: int, kind: String = "resolve", damage: int = 35) -> Dictionary:
	return {"run_id": 1, "sequence": sequence, "source_id": 1, "target_id": 2,
		"action_id": 11, "kind": kind, "skill": "lightning", "damage": damage,
		"source_position": Vector3.ZERO, "target_position": Vector3(1, 0, 2)}

func _ready() -> void:
	var presenter := Presenter.new()
	add_child(presenter)
	presenter.reset_run(1)
	presenter.consume(event(1, "start"))
	check(presenter.lightning.preparations.size() == 1 and presenter.lightning.strikes_played == 0, "start creates only preparation")
	presenter.consume(event(1, "start"))
	check(presenter.lightning.preparations.size() == 1, "duplicate start cannot stack preparations")
	presenter.consume(event(2, "cancel"))
	check(presenter.lightning.preparations.is_empty() and presenter.lightning.strikes.is_empty(), "cancellation removes preparation without success")
	presenter.consume(event(3, "start"))
	presenter.consume(event(4, "resolve", 0))
	check(presenter.lightning.preparations.is_empty() and presenter.lightning.strikes_played == 0, "failed resolution clears preparation without strike")
	presenter.consume(event(5, "start"))
	presenter.consume(event(6))
	presenter.consume(event(7, "end"))
	check(presenter.lightning.preparations.is_empty() and presenter.lightning.strikes_played == 1, "full action between snapshots still gives one strike")
	var bolt = presenter.lightning.strikes[0].view
	check(bolt.position == Vector3(1, 0, 2), "strike uses captured resolution location")
	check(bolt.path_points[0].y > 4 and is_equal_approx(bolt.path_points[-1].y, Profile.impact_height), "forked bolt descends from sky to real impact")
	check(bolt.bolt.material_override.shader != null and bolt.bolt.material_override.get_shader_parameter("visibility") > 0, "glowing strike is visible from its first frame")
	check(bolt.bolt.mesh.get_surface_count() == 1 and bolt.sparks.mesh.get_surface_count() == 1, "branches and sparks are batched in small meshes")
	presenter.consume(event(7))
	check(presenter.lightning.strikes_played == 1, "duplicate resolve cannot replay a strike")
	presenter.present([], [], 0, 1)
	check(bolt.age == 0, "paused visual time freezes strike")
	presenter.present([], [], 0.07, 1)
	check(is_equal_approx(bolt.age, 0.07) and bolt.bolt.visible, "quick strike remains visible at early samples")
	presenter.present([], [], 2, 1)
	check(presenter.lightning.strikes.is_empty(), "large accepted step releases strike")
	for i in range(20): presenter.consume(event(10 + i))
	check(presenter.lightning.strikes.size() == presenter.lightning.MAX_STRIKES, "successful burst remains bounded")
	presenter.reset_run(2)
	presenter.consume(event(100))
	check(presenter.lightning.strikes.is_empty(), "old run is ignored after reset")
	presenter.reset_run(1)
	presenter.consume({"kind": "death", "run_id": 1, "actor_id": 2})
	presenter.consume(event(1))
	check(presenter.lightning.strikes_played == 1, "a lethal resolution still presents impact after a same-tick death")
	presenter.lightning.definition = Profile.duplicate()
	presenter.lightning.definition.cast_scene = null
	presenter.consume(event(2, "start"))
	check(presenter.lightning.preparations.is_empty(), "optional preparation can be removed")
	presenter.lightning.definition.strike_scene = null
	presenter.consume(event(3))
	check(presenter.lightning.strikes_played == 1, "missing strike asset is safe")
	presenter.lightning.definition = Profile
	for replay in range(10):
		presenter.reset_run(replay + 3)
		var value: Dictionary = event(1)
		value.run_id = replay + 3
		presenter.consume(value)
		check(presenter.lightning.strikes.size() == 1, "one strike and no retained art in replay %d" % replay)
	presenter.enabled = false
	presenter.present([], [], 0, 13)
	check(presenter.lightning.strikes.is_empty(), "disabled adapter clears old strikes")
	presenter.queue_free()
	await settle()
	for manual in [false, true]:
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		var mako = app.simulation.hero(&"mako")
		check(app.simulation.add_enemy(Vector2(2, 0)), "fixture adds real target")
		var target = app.simulation.enemies[0]
		target.state.damage(40)
		for unit in app.simulation.all_units(): unit.mover.speed = 0
		if manual:
			for row in app.simulation.rules.mako: row.enabled = false
			check(app.simulation.request_manual(&"mako", &"lightning"), "manual lightning accepted")
		for tick in range(60): app._physics_process(1.0/60.0)
		var art = app.action_presenter.lightning
		check(mako.action.casting() and art.preparations.size() == 1 and art.strikes_played == 0, "actual cast has only preparation after one second")
		check(mako.action.spent == 0, "preparation cannot debit mana")
		var preparation = art.preparations.values()[0].view
		target.place(Vector2(2.3, 0.4))
		app._physics_process(1.0/60.0)
		check(preparation.target_ring.position.is_equal_approx(target.position + Vector3(0, 0.035, 0)), "preparation follows actual moving target")
		var before_age: float = preparation.age
		app.paused = true
		app._physics_process(1)
		check(preparation.age == before_age, "Main pause freezes preparation")
		app._open_arena_picker()
		app._close_arena_picker()
		app._physics_process(1)
		check(preparation.age == before_age and app.paused, "closing menu cannot resume preparation")
		app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
		app.notification(NOTIFICATION_APPLICATION_PAUSED)
		app._physics_process(1)
		app.notification(NOTIFICATION_APPLICATION_RESUMED)
		app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
		app._toggle_pause()
		app._physics_process(1)
		check(preparation.age == before_age, "background and return frame cannot jump preparation")
		var target_id: int = target.combat_id
		var impact_position: Vector3 = target.position
		var spent_before: int = mako.action.spent
		for tick in range(65): app._physics_process(1.0/60.0)
		check(art.strikes_played == 1 and art.preparations.is_empty(), "manual and gambit lightning have one identical success path")
		check(mako.action.spent - spent_before == 30 and app.simulation.defeated == 1, "real lightning keeps mana cost and lethal damage")
		check(art.strikes.size() == 1 and art.strikes[0].view.position.is_equal_approx(impact_position), "lethal impact remains at captured point after target removal")
		check(not app.action_presenter.bindings.has(target_id), "art does not retain the removed logical target")
		var strike = art.strikes[0].view
		before_age = strike.age
		app.paused = true
		app._physics_process(1)
		check(strike.age == before_age, "Main pause freezes successful strike and glow")
		app._reset()
		check(art.preparations.is_empty() and art.strikes.is_empty(), "replay clears preparation and strike immediately")
		main.queue_free()
		await settle()
	for failure in ["target_death", "source_death", "range", "cancel", "mana"]:
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		app.simulation.add_enemy(Vector2(2, 0))
		var mako = app.simulation.hero(&"mako")
		var target = app.simulation.enemies[0]
		for unit in app.simulation.all_units(): unit.mover.speed = 0
		app._physics_process(1.0/60.0)
		for row in app.simulation.rules.mako: row.enabled = false
		if failure == "target_death": target.state.damage(10000)
		elif failure == "source_death": mako.state.damage(10000)
		elif failure == "range":
			mako.place(Vector2(-2.5, -2.5))
			target.place(Vector2(2.5, 2.5))
		elif failure == "mana": mako.action.mana = 0
		else: mako.action.cancel()
		for tick in range(150): app._physics_process(1.0/60.0)
		check(app.action_presenter.lightning.strikes_played == 0, "no false success after " + failure)
		check(app.action_presenter.lightning.preparations.is_empty(), "preparation cleaned after " + failure)
		check(mako.action.spent == 0, "visual cannot spend mana after " + failure)
		main.queue_free()
		await settle()
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	gallery._lightning_preview()
	for tick in range(30): gallery._process(1.0/30.0)
	check(is_instance_valid(gallery.preparation) and not is_instance_valid(gallery.strike), "F6 previews preparation first")
	gallery._refresh_characters()
	check(not is_instance_valid(gallery.preparation) and not is_instance_valid(gallery.strike), "F6 cancellation cleans up immediately")
	gallery._lightning_preview()
	for tick in range(63): gallery._process(1.0/30.0)
	check(is_instance_valid(gallery.strike), "F6 previews sky strike after Duck")
	check(gallery.gallery_actors[1].state.health == gallery.gallery_actors[1].state.max_health, "F6 never mutates health")
	var age: float = gallery.strike.age
	gallery.paused = true
	gallery._process(1)
	check(gallery.strike.age == age, "F6 pause freezes glow")
	gallery.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "no orphan strikes, preparations or views")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
