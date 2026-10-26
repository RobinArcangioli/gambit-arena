extends Node
const Main = preload("res://scenes/main.tscn")
const Gallery = preload("res://scenes/debug/local_navigation_lab.tscn")
const SkeletonA = preload("res://resources/presentation/characters/skeleton.tres")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("PartyNavigation: " + message)

func _ready() -> void:
	for role in range(4):
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		var anne = app.simulation.hero(&"anne")
		var mako = app.simulation.hero(&"mako")
		for key in ["anne", "mako"]:
			for row in app.simulation.rules[key]: row.enabled = false
		var source
		var target
		if role < 2:
			source = anne if role == 0 else mako
			var blocker = mako if role == 0 else anne
			source.place(Vector2(-2, 0))
			blocker.place(Vector2.ZERO)
			app.simulation.add_enemy(Vector2(2, 0))
			target = app.simulation.enemies[0]
			target.mover.speed = 0
			for row in app.simulation.rules[String(source.actor_key)]: row.enabled = row.skill == "basic"
		else:
			anne.place(Vector2(2, 0))
			mako.place(Vector2(2.6, 2.6))
			app.simulation.add_enemy(Vector2(-2, 0))
			source = app.simulation.enemies[0]
			if role == 2: source.set_appearance(SkeletonA)
			app.simulation.add_enemy(Vector2.ZERO)
			app.simulation.enemies[1].mover.speed = 0
			target = anne
		app.simulation.wave.issued = app.simulation.wave.total
		var max_side: float = 0
		for tick in range(420):
			app._physics_process(1.0/60.0)
			max_side = maxf(max_side, absf(source.position.z))
			if source.action.active: break
		check(source.action.active and source.action._target == target, "actual Main reaches the intended combat target for role %d" % role)
		check(source.navigation.searches > 0 and max_side > 0.65, "actual planning retains and follows detour for role %d" % role)
		var fixed: Vector3 = source.position
		for tick in range(20): app._physics_process(1.0/60.0)
		check(source.position == fixed and source.navigation.path.is_empty(), "engaged action does not keep walking or following old waypoints")
		check(is_equal_approx(source.appearance.model_scale, 0.65), "all existing models keep original scale")
		main.queue_free()
		await settle()
	# Pause/background/replay exercise a real partially followed route in Main.
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	var anne = app.simulation.hero(&"anne")
	var mako = app.simulation.hero(&"mako")
	anne.place(Vector2(-2, 0))
	mako.place(Vector2.ZERO)
	for row in app.simulation.rules.mako: row.enabled = false
	app.simulation.add_enemy(Vector2(2, 0))
	app.simulation.enemies[0].mover.speed = 0
	app.simulation.wave.issued = app.simulation.wave.total
	for tick in range(30): app._physics_process(1.0/60.0)
	check(not anne.navigation.path.is_empty(), "fixture has a current route to freeze")
	var frozen: Array = [anne.position, anne.navigation.cooldown, anne.navigation.searches, anne.navigation.path.duplicate(), app.simulation.clock.elapsed]
	app.paused = true
	app._physics_process(1)
	check(frozen == [anne.position, anne.navigation.cooldown, anne.navigation.searches, anne.navigation.path, app.simulation.clock.elapsed], "Main pause freezes navigation and clock")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	app.notification(NOTIFICATION_APPLICATION_PAUSED)
	app._physics_process(1)
	check(frozen == [anne.position, anne.navigation.cooldown, anne.navigation.searches, anne.navigation.path, app.simulation.clock.elapsed], "background cannot recalculate or advance a route")
	app.notification(NOTIFICATION_APPLICATION_RESUMED)
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	app._toggle_pause()
	app._physics_process(1)
	check(frozen[0] == anne.position and frozen[4] == app.simulation.clock.elapsed, "first return tick cannot jump along a route")
	app._physics_process(1.0/60.0)
	check(anne.position != frozen[0], "explicit resume continues current detour")
	for replay in range(10):
		app._reset()
		check(app.simulation.heroes.all(func(unit): return unit.navigation.path.is_empty() and unit.navigation.searches == 0) and app.simulation.navigation_obstacles.is_empty(), "new run clears cached routes and diagnostic obstacles")
	main.queue_free()
	await settle()
	# The gallery uses the same real movement with both skeleton visual variants.
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	gallery.set_physics_process(false)
	for role in range(4):
		for scenario in range(gallery.SCENARIOS.size()):
			gallery.role = role
			gallery.scenario = scenario
			gallery._setup()
			for tick in range(720):
				if scenario == 3 and tick == 120: gallery._open_gate()
				gallery._physics_process(1.0/60.0)
				if gallery.arrived and gallery.elapsed > 0.2: break
			check(gallery.arrived and gallery.safe and gallery.max_searches_tick <= 1, "F6 real-model role %d / scenario %d is reachable and safe" % [role, scenario])
	gallery.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "actual Main and gallery release actors and navigation state")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
