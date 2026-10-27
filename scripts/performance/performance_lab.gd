extends "res://scripts/platform/application_lab.gd"
## Main's optional measurement layer. Normal gameplay delegates to ApplicationLab unchanged.
const CaptureSession = preload("res://scripts/performance/performance_capture.gd")
const Pattern = preload("res://scripts/enemies/enemy_director.gd")
const EXPORT_SLOTS: int = 12
var capture := CaptureSession.new()
var performance_ready: bool = false
var performance_menu: ColorRect
var performance_scroll: ScrollContainer
var performance_content: VBoxContainer
var performance_status: Label
var performance_button: Button
var condition_note: LineEdit
var scenario: String = "normal"
var last_export: String = ""
var _internal_reset: bool = false
var _reset_count: int = 0
var _last_status_usec: int = 0
var _finishing: bool = false

func _ready() -> void:
	super._ready()
	performance_button = _button("GAMBIT / Mesures", _open_performance)
	performance_button.add_theme_font_size_override("font_size", 18)
	$HUD/Title.hide()
	performance_menu = ColorRect.new()
	performance_menu.color = Color("142736")
	add_child(performance_menu)
	performance_scroll = _scroll(performance_menu)
	performance_content = VBoxContainer.new()
	performance_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	performance_content.add_theme_constant_override("separation", 12)
	performance_scroll.add_child(performance_content)
	performance_status = Label.new()
	performance_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	performance_status.mouse_filter = Control.MOUSE_FILTER_IGNORE
	performance_status.add_theme_font_size_override("font_size", 17)
	performance_content.add_child(performance_status)
	condition_note = LineEdit.new()
	condition_note.placeholder_text = "Essai / batterie / luminosite / conditions"
	condition_note.max_length = 240
	condition_note.custom_minimum_size.y = 48
	performance_menu.add_child(condition_note)
	for choice in ["normal", "saturated20", "resets10"]:
		var caption: String = {"normal": "Normal / 30 s + 60 s", "saturated20": "20 ennemis / 30 s + 60 s", "resets10": "10 redemarrages / 30 s + 60 s"}[choice]
		_menu_button(caption, start_benchmark.bind(choice))
	_menu_button("Exporter le dernier resultat", export_capture)
	_menu_button("Fermer / rester en pause", _close_performance)
	performance_menu.hide()
	performance_ready = true
	# The guard must still run before TouchScrollRouter and every GUI input.
	move_child(application_guard, get_child_count() - 1)
	_update_layout()
	_refresh_performance_status()
	call_deferred("_consume_request")

func _menu_button(caption: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = caption
	button.focus_mode = Control.FOCUS_NONE
	button.custom_minimum_size.y = 52
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.pressed.connect(callback)
	performance_content.add_child(button)

func _update_layout() -> void:
	super._update_layout()
	if not performance_ready:
		return
	if capture.busy() and capture.metadata.get("viewport", "") != str(get_viewport_rect().size):
		_abort_capture("viewport_changed")
	_rect(performance_button, Rect2(24, 18, safe_rect.size.x - 172, 28))
	_rect(performance_menu, safe_rect)
	_rect(condition_note, Rect2(12, 12, safe_rect.size.x - 24, 48))
	_rect(performance_scroll, Rect2(12, 72, safe_rect.size.x - 24, safe_rect.size.y - 84))

func _touch_scrollers() -> Array[ScrollContainer]:
	if performance_ready and performance_menu.visible:
		return [performance_scroll]
	return super._touch_scrollers()

func _open_performance() -> void:
	if not performance_ready or editing_index >= 0 or application_guard.blocked:
		return
	_abort_capture("menu_opened")
	paused = true
	touch_router.cancel_gesture()
	_update_buttons()
	performance_menu.show()
	_refresh_performance_status()

func _close_performance() -> void:
	performance_menu.hide()
	touch_router.cancel_gesture()
	_update_buttons()

func _refresh_performance_status() -> void:
	var text: String = "STEP-028 / Mesures\n30 s de chauffe, 60 s de capture.\nGambits standards requis. Interface Competences, reperes coupes.\nPause, geste de commande ou perte de focus : capture interrompue.\nLes essais recommencent la partie.\n12 exports maximum, puis remplacement circulaire."
	if capture.phase != "idle":
		var result: Dictionary = capture.report()
		text += "\n\n%s / %s\n%s" % [scenario, capture.phase, capture.reason]
		var summary: Dictionary = result.summary
		if summary.frame_interval.count > 0:
			text += "\n%.1f FPS moyens / p95 %.2f ms / p99 %.2f ms\n%d frames > 50 ms / %.1f s reelles / %.1f s de jeu" % [summary.mean_fps, summary.frame_interval.p95_ms, summary.frame_interval.p99_ms, summary.frame_interval.over_50_ms, summary.wall_seconds, summary.game_seconds]
	if not last_export.is_empty():
		text += "\n\nExport : " + last_export
	performance_status.text = text

func _standard_rules() -> bool:
	var actual = editor.snapshot()
	var standard = Capture.standard_rules()
	for index in range(3):
		for field in ["enabled", "target", "condition", "threshold", "skill"]:
			if actual[index].get(field) != standard[index].get(field):
				return false
	return true

func start_benchmark(choice: String) -> bool:
	if choice not in ["normal", "saturated20", "resets10"] or capture.busy() or application_guard.blocked or editing_index >= 0:
		return false
	if not _standard_rules():
		performance_status.text = "Remettre les trois gambits standards : Soin soi PV < 50 %, Speciale ennemi Toujours, Attaque ennemi Toujours ; tous actifs, dans cet ordre."
		return false
	scenario = choice
	_reset_count = 0
	_internal_reset = true
	mode_index = 2 if scenario == "saturated20" else 0
	simulation.wave_enabled = scenario != "saturated20"
	simulation.sequence_enabled = scenario != "saturated20"
	paused = false
	application_guard.acknowledge_resume()
	# The first active tick after a real background return remains discarded.
	_reset()
	_internal_reset = false
	_show_skills(true)
	condition_note.release_focus()
	if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		DisplayServer.virtual_keyboard_hide()
	floor_canvas.show_marks = false
	performance_menu.hide()
	touch_router.cancel_gesture()
	last_export = ""
	var metadata: Dictionary = {"scenario": scenario, "build": "0.1.0-step028-v1", "base_commit": "cc91c79b0bcf82df6fb852d9b792fce63aa32148", "godot": Engine.get_version_info().string, "os": OS.get_name(), "os_version": OS.get_version(), "model": OS.get_model_name(), "debug": OS.is_debug_build(), "display": DisplayServer.get_name(), "renderer": RenderingServer.get_current_rendering_method(), "adapter": RenderingServer.get_video_adapter_name(), "viewport": str(get_viewport_rect().size), "subviewport": str(viewport_3d.size), "vsync_mode": DisplayServer.window_get_vsync_mode(), "physics_hz": Engine.physics_ticks_per_second, "max_fps": Engine.max_fps, "note": condition_note.text.left(240), "rules": "heal:self:hp_below:50,special:enemy:always,basic:enemy:always", "diagnostics": simulation.controller.diagnostics_enabled, "utc_started": Time.get_datetime_string_from_system(true), "frame_metric": "monotonic intervals between _process callbacks; not GPU or display presentation timing", "simulation_metric": "CombatSimulation.advance including actor presentation", "tick_metric": "physics callback including simulation, HUD and benchmark resets"}
	metadata["build"] = "0.1.0-ui004"
	metadata["base_commit"] = "c8497aac5760bc4672c80cdff7f80745749e3a49"
	metadata["combat_fixture"] = "historical-single-hero; not PartySimulation"
	metadata["arena_id"] = str(floor_canvas.definition.arena_id)
	metadata["arena_presentation_enabled"] = floor_canvas.presentation_enabled
	var started: bool = capture.start(Time.get_ticks_usec(), metadata)
	measure_simulation = started
	return started

func _reset() -> void:
	if not _internal_reset:
		_abort_capture("manual_replay")
		# Leaving the saturated fixture restores the ordinary three-wave game.
		simulation.wave_enabled = true
		simulation.sequence_enabled = true
	super._reset()
	if _internal_reset and scenario == "saturated20":
		# Diagnostic fixture only: durable actors, unchanged movement/skills/executor.
		var durable = simulation.HERO.duplicate()
		durable.max_health = 1000000
		simulation.hero.configure(durable)
		for index in range(20):
			var at: Vector2 = Pattern.spawn_position(index % 4)
			var offset: float = (int(index / 4.0) - 2) * 0.8
			if index % 2 == 0:
				at.y = offset
			else:
				at.x = offset
			if not simulation.add_enemy(at):
				push_error("STEP-028: cannot create saturated fixture")
		var enemy_profile = simulation.ENEMY.duplicate()
		enemy_profile.max_health = 1000000
		for unit in simulation.enemies:
			unit.configure(enemy_profile)
		_present()
	if _internal_reset and capture.busy():
		capture.event(Time.get_ticks_usec(), "reset", simulation.run_id)

func _physics_process(delta: float) -> void:
	if not capture.busy():
		super._physics_process(delta)
		return
	var before_usec: int = Time.get_ticks_usec()
	var reset_due: bool = scenario == "resets10" and capture.phase == "capture" and _reset_count < 10 and before_usec - capture.capture_usec >= (_reset_count + 1) * 5500000
	if simulation.result != "EN COURS" or reset_due:
		_internal_reset = true
		_reset()
		_internal_reset = false
		if reset_due:
			_reset_count += 1
	var before_game: float = simulation.clock.elapsed
	last_simulation_usec = 0
	super._physics_process(delta)
	var after_usec: int = Time.get_ticks_usec()
	capture.tick(after_usec - before_usec, last_simulation_usec, simulation.clock.elapsed - before_game)
	if not capture.busy():
		_queue_finish()
	if scenario == "saturated20" and simulation.enemies.size() != 20:
		_abort_capture("saturation_lost")

func _process(delta: float) -> void:
	super._process(delta)
	if not performance_ready or not capture.busy():
		return
	if paused or application_guard.blocked:
		_abort_capture("paused_or_background")
		return
	var now_usec: int = Time.get_ticks_usec()
	capture.frame(now_usec)
	if capture.phase == "capture" and now_usec - capture._last_telemetry_usec >= 1000000:
		capture.add_telemetry(now_usec, {"static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC) if OS.is_debug_build() else -1, "objects": Performance.get_monitor(Performance.OBJECT_COUNT), "nodes": Performance.get_monitor(Performance.OBJECT_NODE_COUNT), "orphans": Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT), "resources": Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT), "engine_process_ms": Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0, "engine_physics_ms": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0, "draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), "alive": simulation.enemies.size(), "run_id": simulation.run_id, "reset_count": _reset_count})
	if now_usec - _last_status_usec >= 1000000:
		_last_status_usec = now_usec
		performance_button.text = "%s %d s" % ["Chauffe" if capture.phase == "warmup" else "Mesure", int((now_usec - capture.started_usec) / 1000000)]
	if not capture.busy():
		_queue_finish()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		_abort_capture("application_background")

func _abort_capture(why: String) -> void:
	if capture.busy():
		capture.interrupt(why, Time.get_ticks_usec())
		_queue_finish()

func _queue_finish() -> void:
	measure_simulation = false
	if not _finishing:
		_finishing = true
		call_deferred("_finish_capture")

func _finish_capture() -> void:
	_finishing = false
	paused = true
	_update_buttons()
	export_capture()
	performance_button.text = "GAMBIT / Mesures"
	performance_menu.show()
	_refresh_performance_status()

func export_capture() -> bool:
	if capture.busy() or capture.phase == "idle":
		return false
	var directory: String = "user://performance"
	if DirAccess.make_dir_recursive_absolute(directory) != OK:
		last_export = "ECHEC creation du dossier"
		return false
	var slot: int = 0
	if FileAccess.file_exists(directory + "/next-slot.txt"):
		slot = posmod(FileAccess.get_file_as_string(directory + "/next-slot.txt").to_int(), EXPORT_SLOTS)
	var path: String = directory + "/capture-%02d.json" % slot
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		last_export = "ECHEC ecriture : %s" % FileAccess.get_open_error()
		return false
	file.store_string(JSON.stringify(capture.report()))
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	if write_error != OK:
		last_export = "ECHEC ecriture : %s" % write_error
		return false
	var index_file := FileAccess.open(directory + "/next-slot.txt", FileAccess.WRITE)
	if index_file == null:
		last_export = "ECHEC index des exports"
		return false
	index_file.store_string(str((slot + 1) % EXPORT_SLOTS))
	index_file.close()
	last_export = ProjectSettings.globalize_path(path)
	print("STEP-028 export: ", last_export)
	if performance_ready:
		_refresh_performance_status()
	return true

func _consume_request() -> void:
	# Optional single-use request for reproducible CLI/ADB runs, never shipped in sources.
	var choice: String = ""
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--performance="):
			choice = argument.trim_prefix("--performance=")
	var request: String = "user://performance-request.txt"
	if FileAccess.file_exists(request):
		choice = FileAccess.get_file_as_string(request).strip_edges().left(32)
		DirAccess.remove_absolute(request)
	if not choice.is_empty():
		start_benchmark(choice)

func _toggle_pause() -> void:
	_abort_capture("pause_requested")
	if not performance_ready or not performance_menu.visible:
		super._toggle_pause()

func _next_placement() -> void:
	_abort_capture("scenario_changed")
	if not performance_ready or not performance_menu.visible:
		super._next_placement()

func _open_editor(index: int) -> void:
	_abort_capture("rules_editor")
	if not performance_ready or not performance_menu.visible:
		super._open_editor(index)

func _select_slot(index: int) -> void:
	_abort_capture("manual_command")
	super._select_slot(index)

func _show_skills(value: bool) -> void:
	_abort_capture("tab_changed")
	super._show_skills(value)

func _apply_rules() -> void:
	_abort_capture("rules_changed")
	super._apply_rules()

func _toggle_marks() -> void:
	_abort_capture("marks_changed")
	super._toggle_marks()

func _unhandled_key_input(event: InputEvent) -> void:
	if performance_ready and performance_menu.visible:
		if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
			_close_performance()
		get_viewport().set_input_as_handled()
		return
	super._unhandled_key_input(event)
