extends Node
## Diagnostic composition only. Main and saved gambits are never modified.
const Main = preload("res://scenes/main.tscn")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
const Rules = preload("res://scripts/party/party_rules.gd")
const Capture = preload("res://scripts/performance/performance_capture.gd")
const Skeletons = [preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
const MakoAsAnne = preload("res://resources/presentation/examples/mako_as_anne.tres")
const Violet = preload("res://resources/presentation/examples/lightning_violet.tres")
const DEFAULT_HEAL = preload("res://resources/presentation/effects/heal.tres")
const DEFAULT_LIGHTNING = preload("res://resources/presentation/effects/lightning.tres")
const WARM_SECONDS: float = 5.0
const CAPTURE_SECONDS: float = 20.0
@export var autorun: bool = false
var app
var main: Node
var caption: Label
var busy: bool = false
var measuring: bool = false
var capture := Capture.new()
var reports: Array[Dictionary] = []
var matrix: Array[Dictionary] = []
var output_path: String = "user://graphics007"
var sample_count: int = 6
var sample_mode: String = "full"
var interrupted: bool = false
var mode_buttons: Array[Button] = []

func _ready() -> void:
	DisplayServer.screen_set_keep_on(true)
	main = Main.instantiate()
	app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	var panel := VBoxContainer.new()
	panel.position = Vector2(12, get_viewport().get_visible_rect().size.y - 190)
	panel.size = Vector2(get_viewport().get_visible_rect().size.x - 24, 175)
	var shade := ColorRect.new()
	shade.position = panel.position - Vector2(6, 6)
	shade.size = panel.size + Vector2(12, 12)
	shade.color = Color("101f2c")
	add_child(shade)
	add_child(panel)
	caption = Label.new()
	caption.text = "GRAPHICS-007 / Qualification\nLaboratoire isole ; fichiers user://graphics007"
	caption.add_theme_font_size_override("font_size", 15)
	panel.add_child(caption)
	for entry in [["Matrice + mesures", _run_all], ["Demo : arene / modele / eclair", _demo]]:
		var button := Button.new()
		button.text = entry[0]
		button.custom_minimum_size.y = 44
		button.pressed.connect(entry[1])
		panel.add_child(button)
		mode_buttons.append(button)
	if autorun: call_deferred("_run_all")

func _fixture(enemies: int, mode: String, arena_id: StringName = &"colisee_solaire", skeleton_index: int = 1) -> void:
	app.paused = false
	app.application_guard.acknowledge_resume()
	app.characters_enabled = mode in ["models", "full"]
	app.simulation.max_alive = enemies
	app.simulation.rules = {"anne": Rules.defaults(&"anne"), "mako": Rules.defaults(&"mako")}
	app._reset()
	app.floor_canvas.set_definition(Catalog.definition(arena_id))
	app.floor_canvas.set_presentation_enabled(mode != "logic")
	app._sync_projection()
	app.action_presenter.heal_definition = DEFAULT_HEAL if mode == "full" else null
	app.action_presenter.lightning.definition = DEFAULT_LIGHTNING if mode == "full" else null
	app.action_animations_enabled = mode in ["models", "full"]
	for i in range(enemies): app.simulation.add_enemy(app.simulation.Pattern.spawn_position(i))
	for unit in app.simulation.all_units():
		unit.set_appearance(Skeletons[skeleton_index] if unit.team != app.simulation.heroes[0].team else app.APPEARANCES.get(unit.actor_key), mode in ["models", "full"])
	app.simulation.hero(&"mako").state.damage(110)
	app._present()
	app._update_bars()
	sample_count = enemies
	sample_mode = mode

func _step(delta: float) -> void:
	if app.simulation.result != "EN COURS": _fixture(sample_count, sample_mode)
	app._physics_process(delta)

func _physics_process(delta: float) -> void:
	if not measuring or app.application_guard.blocked or app.application_guard.resume_required: return
	var before: int = Time.get_ticks_usec()
	var clock_before: float = app.simulation.clock.elapsed
	_step(delta)
	var cpu_usec: int = Time.get_ticks_usec() - before
	var game_step: float = app.simulation.clock.elapsed - clock_before
	if game_step < 0: game_step = app.simulation.clock.elapsed
	capture.tick(cpu_usec, cpu_usec, game_step)

func _process(delta: float) -> void:
	if not measuring: return
	if app.application_guard.blocked or app.application_guard.resume_required:
		interrupted = true
		capture.interrupt("application_background", Time.get_ticks_usec())
		measuring = false
		return
	app._process(delta)
	capture.frame(Time.get_ticks_usec())
	capture.add_telemetry(Time.get_ticks_usec(), _telemetry())

func _telemetry() -> Dictionary:
	return {"static_bytes": Performance.get_monitor(Performance.MEMORY_STATIC),
		"nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"orphans": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT),
		"draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"primitives": Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
		"objects": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"video_bytes": Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED),
		"texture_bytes": Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED),
		"heal_effects": app.action_presenter.heal_effects.size(),
		"lightning_preparations": app.action_presenter.lightning.preparations.size(),
		"lightning_strikes": app.action_presenter.lightning.strikes.size(),
		"enemies": app.simulation.enemies.size()}

func _run_all() -> void:
	if busy: return
	busy = true
	interrupted = false
	for button in mode_buttons: button.disabled = true
	reports.clear()
	matrix.clear()
	DirAccess.make_dir_recursive_absolute(output_path)
	await _matrix()
	if not interrupted:
		var cases: Array = []
		for count in [2, 6]:
			for mode in ["logic", "decor", "models", "full"]: cases.append([count, mode])
		# Reverse the final pair once to expose order/temperature sensitivity.
		cases.append([6, "full"])
		cases.append([6, "models"])
		for index in range(cases.size()):
			if interrupted: break
			var count: int = cases[index][0]
			var mode: String = cases[index][1]
			_fixture(count, mode)
			for i in range(5): await get_tree().process_frame
			caption.text = "GRAPHICS-007 / Mesure %d/%d\n2 heros + %d ennemis / %s\n5 s chauffe + 20 s mesure" % [index + 1, cases.size(), count, mode]
			capture.start(Time.get_ticks_usec(), {"build": "0.1.0-graphics007-qualification", "base_commit": "834f532912a9ee0092133a6761ff40bc70a32933", "variant": mode, "enemy_fixture": count, "heroes": 2, "pass": index,
				"godot": Engine.get_version_info().string, "os": OS.get_name(), "model": OS.get_model_name(),
				"renderer": RenderingServer.get_current_rendering_method(), "adapter": RenderingServer.get_video_adapter_name(),
				"viewport": str(app.viewport_3d.size), "physics_input": "normal engine physics callback at 60 Hz; Main physics and process callbacks both driven", "fixture": "current PartySimulation; cyclic real combat, not historical single hero; no gameplay resource changes", "frame_metric": "monotonic process callback intervals, not GPU/present timing"}, WARM_SECONDS, CAPTURE_SECONDS)
			measuring = true
			while capture.busy(): await get_tree().process_frame
			measuring = false
			var report: Dictionary = capture.report()
			report.summary["main_step_cpu"] = report.summary.tick_cpu_including_hud
			report.summary.erase("tick_cpu_including_hud")
			report.summary.erase("simulation_cpu_including_actor_presentation")
			report.raw.erase("simulation_cpu_ms")
			app._reset()
			for i in range(5): await get_tree().process_frame
			report["cleanup"] = _telemetry()
			reports.append(report)
			_write_results()
	app.paused = true
	app._update_buttons()
	busy = false
	caption.text = "GRAPHICS-007 / %s\n%d captures / %d cas visuels\nuser://graphics007/report.json" % ["INTERROMPU" if interrupted else "TERMINE", reports.size(), matrix.size()]
	for button in mode_buttons: button.disabled = false
	_write_results()

func _matrix() -> void:
	for id in Catalog.ids():
		if id == &"reference": continue
		for skeleton_index in range(2):
			if app.application_guard.blocked:
				interrupted = true
				return
			_fixture(1, "full", id, skeleton_index)
			# Both heroes in the actual composition; the enemy model varies independently.
			var enemy = app.simulation.enemies[0]
			var anne = app.simulation.hero(&"anne")
			var mako = app.simulation.hero(&"mako")
			anne.place(Vector2(-0.7, 0))
			mako.place(Vector2(0.7, 0))
			enemy.place(Vector2(0, 0.65))
			for unit in app.simulation.all_units(): unit.mover.speed = 0
			for row in app.simulation.rules.anne: row.enabled = row.skill == &"basic"
			for row in app.simulation.rules.mako: row.enabled = row.skill == &"basic"
			for tick in range(42): app._physics_process(1.0/60.0)
			await _matrix_capture(id, skeleton_index, "attack")
			_fixture(1, "full", id, skeleton_index)
			enemy = app.simulation.enemies[0]
			enemy.place(Vector2(2, 0))
			for unit in app.simulation.all_units(): unit.mover.speed = 0
			for tick in range(123): app._physics_process(1.0/60.0)
			await _matrix_capture(id, skeleton_index, "spells")
			enemy.state.damage(100000)
			for tick in range(18): app._physics_process(1.0/60.0)
			await _matrix_capture(id, skeleton_index, "death")

func _matrix_capture(id: StringName, skeleton_index: int, action: String) -> void:
	caption.text = "GRAPHICS-007 / %s\nAnne + Mako / squelette %d / %s" % [Catalog.title(id), skeleton_index + 1, action]
	app._present()
	app._update_bars()
	for i in range(3): await get_tree().process_frame
	var file_name: String = "%s-%d-%s.png" % [id, skeleton_index, action]
	get_viewport().get_texture().get_image().save_png(output_path.path_join(file_name))
	matrix.append({"arena": String(id), "skeleton": skeleton_index, "heroes": ["anne", "mako"], "action": action, "capture": file_name})
	_write_results()

func _write_results() -> void:
	var file := FileAccess.open(output_path.path_join("report.json"), FileAccess.WRITE)
	if file == null: return
	file.store_string(JSON.stringify({"schema": 1, "interrupted": interrupted, "matrix": matrix, "captures": reports}, "\t"))

func _demo() -> void:
	if busy: return
	_fixture(1, "full", &"sanctuaire_polaire")
	app.simulation.hero(&"mako").set_appearance(MakoAsAnne)
	app.action_presenter.lightning.definition = Violet
	for unit in app.simulation.all_units(): unit.mover.speed = 0
	for tick in range(123): app._physics_process(1.0/60.0)
	app._present()
	app._update_bars()
	caption.text = "DEMO / Sanctuaire, Mako avec apparence Anne\nFoudre violette : scenes/profils remplaces\nStatistiques et competences de Mako conservees"
