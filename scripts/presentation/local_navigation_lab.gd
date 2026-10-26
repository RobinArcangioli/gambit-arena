extends Node
## Movement-only diagnostic using the real shared PartyUnit and PartySimulation._move.
const Main = preload("res://scenes/main.tscn")
const Marks = preload("res://scripts/presentation/local_navigation_marks.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Capture = preload("res://scripts/performance/performance_capture.gd")
const SCENARIOS = ["Un obstacle", "Deux corps", "Croisement", "Anneau ferme", "Bordure", "Cible mobile", "Contact au bord"]
const ROLES = ["Anne", "Mako", "Squelette A", "Squelette B"]
@export var autorun: bool = false
var app
var source
var target
var scenario: int = 0
var role: int = 0
var movers: Array = []
var panel: VBoxContainer
var shade: ColorRect
var caption: Label
var controls: Array[Button] = []
var marks := Marks.new()
var trail: Array[Vector2] = []
var elapsed: float = 0
var arrived: bool = false
var opened: bool = false
var safe: bool = true
var max_searches_tick: int = 0
var min_distance: float = INF
var cpu_ms := PackedFloat64Array()
var campaign_running: bool = false
var interrupted: bool = false
var results: Array[Dictionary] = []
var output_path: String = "user://gameplay002"
var benchmarking: bool = false
var main_capture := Capture.new()
var main_report: Dictionary = {}
var bench_max_search_ms: float = 0.0

func _ready() -> void:
	DisplayServer.screen_set_keep_on(true)
	var main = Main.instantiate()
	app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	app.footer_scroll.hide()
	for button in app.toolbar: button.hide()
	app.get_node("HUD/Title").text = "GAMEPLAY-002 / NAVIGATION"
	add_child(marks)
	shade = ColorRect.new()
	shade.color = Color("101f2c")
	add_child(shade)
	panel = VBoxContainer.new()
	add_child(panel)
	caption = Label.new()
	caption.add_theme_font_size_override("font_size", 15)
	panel.add_child(caption)
	var row := HBoxContainer.new()
	panel.add_child(row)
	_button(row, "Scenario suivant", _next_scenario)
	_button(row, "Personnage", _next_actor)
	row = HBoxContainer.new()
	panel.add_child(row)
	_button(row, "Ouvrir passage", _open_gate)
	_button(row, "Rejouer", _setup)
	row = HBoxContainer.new()
	panel.add_child(row)
	_button(row, "Arenes", app._open_arena_picker)
	_button(row, "Campagne", _run_campaign)
	get_viewport().size_changed.connect(_layout)
	_setup()
	_layout()
	if autorun: call_deferred("_run_campaign")

func _button(parent: Node, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 44
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func():
		if not app.application_guard.blocked and not campaign_running: action.call())
	parent.add_child(button)
	controls.append(button)

func _layout() -> void:
	if not is_instance_valid(app) or not app.ready_ui: return
	var footer: Rect2 = app.get_node("HUD/FooterPanel").get_global_rect()
	shade.position = footer.position
	shade.size = footer.size
	panel.position = footer.position + Vector2(8, 8)
	panel.size = footer.size - Vector2(16, 16)
	marks.position = app.render_box.position
	marks.camera = app.camera
	marks.view_size = Vector2(app.viewport_3d.size)
	marks.display_size = app.render_box.size

func _next_scenario() -> void:
	scenario = (scenario + 1) % SCENARIOS.size()
	_setup()

func _next_actor() -> void:
	role = (role + 1) % ROLES.size()
	_setup()

func _intend(actor, destination) -> void:
	actor.desired_target = destination
	actor.desired_skill = &"basic"
	actor.mover.set_target(destination)
	movers.append(actor)

func _setup() -> void:
	if app.application_guard.blocked: return
	app.paused = false
	app.application_guard.acknowledge_resume()
	app._reset()
	movers.clear()
	trail.clear()
	cpu_ms.clear()
	elapsed = 0
	arrived = false
	opened = false
	safe = true
	max_searches_tick = 0
	min_distance = INF
	var anne = app.simulation.hero(&"anne")
	var mako = app.simulation.hero(&"mako")
	app.simulation.add_enemy(Vector2(2, 0))
	var enemy = app.simulation.enemies[0]
	var blocker = mako if role != 1 else anne
	if role < 2:
		source = anne if role == 0 else mako
		target = enemy
	else:
		source = enemy
		target = anne
		source.set_appearance(load("res://resources/presentation/characters/skeleton.tres") if role == 2 else app.APPEARANCES[&"skeleton"])
	source.place(Vector2(-2, 0))
	target.place(Vector2(2, 0))
	blocker.place(Vector2.ZERO)
	_intend(source, target)
	if scenario == 1:
		blocker.place(Vector2(0, -0.4))
		app.simulation.navigation_obstacles.append(Vector2(0, 0.4))
	elif scenario == 2:
		blocker.place(Vector2(0, -2))
		app.simulation.add_enemy(Vector2(0, 2))
		_intend(blocker, app.simulation.enemies[-1])
	elif scenario == 3:
		source.place(Vector2.ZERO)
		target.place(Vector2(2.3, 0))
		blocker.place(Vector2(-2, -2))
		for i in range(6): app.simulation.navigation_obstacles.append(Vector2(cos(TAU*i/6), sin(TAU*i/6)) * 0.95)
	elif scenario == 4:
		source.place(Vector2(-2.25, -2.2))
		target.place(Vector2(2.25, -2.2))
		blocker.place(Vector2(0, -2.2))
	elif scenario == 5:
		target.place(Vector2(1, 0))
		if role < 2:
			blocker.place(Vector2(2, 2))
			_intend(target, blocker)
		else:
			blocker.place(Vector2(-2, -2))
			app.simulation.add_enemy(Vector2(2, 2))
			_intend(target, app.simulation.enemies[-1])
	if scenario == 6:
		source.place(Vector2(2.65, 0))
		target.place(Vector2(-2, 0))
		blocker.place(Vector2(1.95, 0))
	app._present()
	app._update_bars()
	_refresh_marks()

func _open_gate() -> void:
	if scenario == 3 and not opened and not app.simulation.navigation_obstacles.is_empty():
		app.simulation.navigation_obstacles.remove_at(0)
		opened = true

func _physics_process(delta: float) -> void:
	if benchmarking:
		if app.application_guard.blocked or app.application_guard.resume_required:
			interrupted = true
			main_capture.interrupt("application_background", Time.get_ticks_usec())
			return
		if app.simulation.result != "EN COURS":
			app._reset()
			for i in range(6): app.simulation.add_enemy(app.simulation.Pattern.spawn_position(i))
			source = app.simulation.hero(&"anne")
			main_capture.event(Time.get_ticks_usec(), "reset", app.simulation.run_id)
		var before_clock: float = app.simulation.clock.elapsed
		var start: int = Time.get_ticks_usec()
		app._physics_process(delta)
		var cpu: int = Time.get_ticks_usec() - start
		main_capture.tick(cpu, cpu, maxf(0, app.simulation.clock.elapsed - before_clock))
		for unit in app.simulation.all_units(): bench_max_search_ms = maxf(bench_max_search_ms, unit.navigation.max_search_usec / 1000.0)
		return
	if not is_instance_valid(source): return
	if app.application_guard.blocked or app.application_guard.resume_required:
		app.paused = true
		if campaign_running: interrupted = true
	app.simulation.clock.paused = app.paused
	if app.paused or app.application_guard.consume_return_step(): return
	var dt: float = app.simulation.clock.step(delta)
	if dt <= 0: return
	elapsed += dt
	if campaign_running and scenario == 3 and elapsed >= 2: _open_gate()
	var before: Vector2 = source.mover.ground_position
	var started: int = Time.get_ticks_usec()
	app.simulation._move(dt)
	if cpu_ms.size() < 4096: cpu_ms.append((Time.get_ticks_usec() - started) / 1000.0)
	max_searches_tick = maxi(max_searches_tick, app.simulation.navigation_searches_last_tick)
	var points: Array[Vector2] = app.simulation.navigation_obstacles.duplicate()
	for unit in app.simulation.all_units():
		points.append(unit.mover.ground_position)
		unit.present()
	min_distance = minf(min_distance, Crowd.minimum_distance(points))
	safe = safe and min_distance >= Crowd.DIAMETER - 0.0002 and source.mover.ground_position.distance_to(before) <= source.mover.speed * dt + 0.00001
	arrived = movers.all(func(unit): return Executor.distance_between(unit, unit.desired_target) <= 1.00001)
	if trail.size() >= 512: trail.pop_front()
	trail.append(source.mover.ground_position)
	app.action_presenter.capture(app.simulation.all_units(), app.simulation.run_id)
	var events: Array[Dictionary] = []
	app.action_presenter.present(app.simulation.all_units(), events, dt, app.simulation.run_id)

func _process(delta: float) -> void:
	if not is_instance_valid(source): return
	app._process(delta)
	if benchmarking:
		marks.hide()
		caption.text = "Combat reel / 2 heros + 6 ennemis
Mesure de navigation : " + main_capture.phase + "
Geometrie et echelles inchangees"
		main_capture.frame(Time.get_ticks_usec())
		main_capture.add_telemetry(Time.get_ticks_usec(), {"actors": app.simulation.all_units().size(), "searches_tick": app.simulation.navigation_searches_last_tick, "run_id": app.simulation.run_id, "max_search_ms": bench_max_search_ms, "orphans": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)})
		return
	var modal: bool = app._modal_open()
	panel.visible = not modal
	shade.visible = not modal
	marks.visible = not modal
	caption.text = "%s / %s\n%s / distance %.2f / %.1f s\nRecherches %d / %.2f ms max / rayon 0.35" % [ROLES[role], SCENARIOS[scenario], source.navigation.status, Executor.distance_between(source, target), elapsed, source.navigation.searches, source.navigation.max_search_usec / 1000.0]
	controls[2].disabled = campaign_running or scenario != 3 or opened
	_refresh_marks()
	_layout()

func _refresh_marks() -> void:
	marks.obstacles.assign(app.simulation.navigation_obstacles)
	marks.actors.clear()
	for unit in app.simulation.all_units(): marks.actors.append(unit.mover.ground_position)
	marks.trail.assign(trail)
	marks.route = [source.mover.ground_position]
	marks.route.append_array(source.navigation.path)
	marks.queue_redraw()

func _run_campaign() -> void:
	if campaign_running: return
	campaign_running = true
	interrupted = false
	results.clear()
	for button in controls: button.disabled = true
	DirAccess.make_dir_recursive_absolute(output_path)
	for actor_index in range(4):
		if interrupted: break
		for scene_index in range(SCENARIOS.size()):
			if interrupted: break
			role = actor_index
			scenario = scene_index
			_setup()
			while elapsed < 12 and (not arrived or elapsed < 0.2) and not interrupted: await get_tree().process_frame
			app.paused = true
			app._update_buttons()
			for i in range(3): await get_tree().process_frame
			var name: String = "role%d-case%d.png" % [role, scenario]
			get_viewport().get_texture().get_image().save_png(output_path.path_join(name))
			results.append({"role": ROLES[role], "scenario": SCENARIOS[scenario], "passed": arrived and safe and max_searches_tick <= 1 and not interrupted,
				"seconds": elapsed, "min_distance": min_distance, "distance_travelled": source.navigation.distance_travelled,
				"searches": source.navigation.searches, "failed_searches": source.navigation.failed_searches,
				"max_search_ms": source.navigation.max_search_usec / 1000.0, "max_searches_tick": max_searches_tick, "waiting_seconds": source.navigation.waiting_seconds,
				"movement_cpu_ms": Capture.distribution(cpu_ms), "capture": name})
			_write_results()
	if not interrupted: await _benchmark_main()
	_setup()
	campaign_running = false
	app.paused = true
	for button in controls: button.disabled = false
	_write_results()

func _write_results() -> void:
	var file := FileAccess.open(output_path.path_join("report.json"), FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify({"schema": 1, "interrupted": interrupted, "godot": Engine.get_version_info().string,
			"os": OS.get_name(), "model": OS.get_model_name(), "body_radius": Crowd.RADIUS, "complete": not campaign_running, "results": results, "combat_benchmark": main_report}, "\t"))

func _benchmark_main() -> void:
	app.paused = false
	app._reset()
	for i in range(6): app.simulation.add_enemy(app.simulation.Pattern.spawn_position(i))
	source = app.simulation.hero(&"anne")
	bench_max_search_ms = 0
	main_capture.start(Time.get_ticks_usec(), {"build": "0.1.0-gameplay002-lab", "fixture": "current Main, two heroes, up to six enemies; cyclic combat", "physics_hz": Engine.physics_ticks_per_second, "renderer": RenderingServer.get_current_rendering_method(), "viewport": str(app.viewport_3d.size), "metric": "process callback intervals; not GPU or presentation timing; physical Main callback CPU"}, 5, 20)
	benchmarking = true
	while main_capture.busy() and not interrupted: await get_tree().process_frame
	benchmarking = false
	main_report = main_capture.report()
	main_report["max_navigation_search_ms"] = bench_max_search_ms
	main_report.summary["main_step_cpu"] = main_report.summary.tick_cpu_including_hud
	main_report.summary.erase("simulation_cpu_including_actor_presentation")
	main_report.summary.erase("tick_cpu_including_hud")
	main_report.raw.erase("simulation_cpu_ms")
	app.paused = true
