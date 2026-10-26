extends Node
const Session = preload("res://scripts/performance/performance_capture.gd")
const Lab = preload("res://scenes/performance/performance_lab.tscn")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("Performance: " + message)

func _ready() -> void:
	var session := Session.new()
	check(not session.start(0, {}, NAN) and not session.start(0, {}, 0, 121), "invalid duration rejected")
	check(session.start(1000000, {"scenario": "fixture"}, 1, 1), "bounded capture starts")
	check(not session.start(1000000, {}), "active capture cannot be replaced")
	session.frame(1500000)
	check(session.frames_ms.is_empty() and session.phase == "warmup", "warmup has no samples")
	session.frame(2000000)
	check(session.phase == "capture" and session.frames_ms.is_empty(), "capture has a fresh wall-time anchor")
	session.tick(2000, 1000, 1.0 / 30.0)
	session.frame(2500000)
	session.add_telemetry(2500000, {"alive": 20})
	session.add_telemetry(2500001, {"alive": 0})
	session.frame(3000000)
	var result: Dictionary = session.report()
	check(session.phase == "complete" and result.summary.wall_seconds == 1.0, "completion follows real monotonic time")
	check(result.summary.frame_interval.mean_ms == 500.0 and result.summary.mean_fps == 2.0, "FPS independent from bounded game delta")
	check(absf(result.summary.game_seconds - 1.0 / 30.0) < 0.000001, "simulation time reported separately")
	check(result.summary.tick_cpu_including_hud.mean_ms == 2.0 and result.summary.simulation_cpu_including_actor_presentation.mean_ms == 1.0, "CPU units are milliseconds")
	check(session.telemetry.size() == 1, "telemetry sampled at most once per second")
	result.metadata.scenario = "mutated"
	result.raw.telemetry[0].alive = 0
	check(session.metadata.scenario == "fixture" and session.telemetry[0].alive == 20, "reports own their values")
	var stats: Dictionary = Session.distribution(PackedFloat64Array([1, 2, 3, 4, 100]))
	check(stats.p50_ms == 3 and stats.p95_ms == 100 and stats.p99_ms == 100 and stats.over_50_ms == 1 and stats.over_100_ms == 0, "nearest-rank quantiles and strict thresholds")
	session.start(0, {}, 0, 120)
	session.frame(0)
	for index in range(Session.MAX_FRAMES + 1):
		session.frame(index + 1)
	check(session.frames_ms.size() == Session.MAX_FRAMES and session.reason == "frame_capacity" and session.phase == "interrupted", "frame capacity never silently drops slow or fast frames")
	session.start(0, {}, 0, 120)
	session.frame(0)
	for index in range(Session.MAX_TICKS + 1):
		session.tick(2, 1, 0.01)
	check(session.tick_ms.size() == Session.MAX_TICKS and session.reason == "tick_capacity", "tick memory bounded")
	session.start(0, {}, 0, 120)
	session.frame(0)
	for index in range(Session.MAX_EVENTS + 1):
		session.event(index, "reset", index)
	check(session.events.size() == Session.MAX_EVENTS and session.reason == "event_capacity", "event memory bounded")
	session.start(0, {}, 0, 120)
	session.frame(0)
	for index in range(Session.MAX_TELEMETRY + 1):
		session.add_telemetry(index * 1000000, {"alive": 20})
	check(session.telemetry.size() == Session.MAX_TELEMETRY and session.reason == "telemetry_capacity", "telemetry memory bounded")
	session.start(0, {}, 0, 1)
	session.frame(0)
	session.frame(10000)
	session.interrupt("background", 15000)
	session.frame(90000000)
	check(session.frames_ms.size() == 1 and session.reason == "background", "background never introduces a catch-up interval")
	# Real Main layer: saturated fixture, lifecycle, gameplay hand-back and export.
	var lab = Lab.instantiate()
	add_child(lab)
	lab.set_physics_process(false)
	lab.set_process(false)
	await get_tree().process_frame
	check(lab.start_benchmark("saturated20") and lab.simulation.enemies.size() == 20, "fixture truly has twenty living enemies")
	check(lab.simulation.hero.state.max_health == 1000000 and lab.simulation.enemies[0].state.max_health == 1000000, "durable profiles are fixture-only")
	var point: Vector3 = lab.simulation.hero.position
	for index in range(180):
		lab._physics_process(1.0 / 60.0)
	check(lab.simulation.enemies.size() == 20 and lab.simulation.hits > 0, "saturated combat executes real skills")
	check(lab.simulation.hero.position != point, "fixture still uses automatic approach")
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(lab.capture.phase == "interrupted" and lab.capture.reason == "application_background" and lab.paused, "background interrupts capture and retains explicit pause")
	await get_tree().process_frame
	check(FileAccess.file_exists(lab.last_export), "interrupted capture is exported")
	var exported = JSON.parse_string(FileAccess.get_file_as_string(lab.last_export))
	check(exported.phase == "interrupted" and exported.metadata.scenario == "saturated20", "export is parseable and labeled incomplete")
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	lab._close_performance()
	lab._reset()
	check(lab.simulation.wave_enabled and lab.simulation.sequence_enabled and lab.simulation.hero.state.max_health == 2500, "replay leaves diagnostic fixture for stock Charge mode")
	check(lab.paused and not lab.measure_simulation, "replay stays paused and timing disabled")
	check(lab.start_benchmark("normal"), "normal benchmark starts after interrupted fixture")
	check(lab.mode_index == 0 and lab.simulation.wave.cap == 6 and lab.simulation.budget == 36 and lab.skills_visible and not lab.floor_canvas.show_marks, "normal scenario uses ordinary three waves and controlled HUD")
	lab._toggle_pause()
	check(lab.capture.phase == "interrupted" and lab.capture.reason == "pause_requested", "manual pause invalidates comparison")
	await get_tree().process_frame
	lab._close_performance()
	check(lab.start_benchmark("resets10"), "reset campaign starts")
	lab.capture.phase = "capture"
	lab.capture.capture_usec = Time.get_ticks_usec() - 60000000
	for index in range(10):
		lab._physics_process(1.0 / 60.0)
		await get_tree().process_frame
	check(lab._reset_count == 10 and lab.capture.events.size() == 10, "ten scheduled resets are recorded without depending on game time")
	lab._abort_capture("test_finished")
	await get_tree().process_frame
	lab._close_performance()
	lab.editor.toggle(0)
	check(not lab.start_benchmark("normal"), "nonstandard rules cannot silently alter the protocol")
	lab.queue_free()
	await get_tree().process_frame
	var summary_text: String = "STEP-028 / mesures\n%s : %d controles, %d echecs\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.text = summary_text
	add_child(label)
	if "--test-exit" in OS.get_cmdline_user_args():
		get_tree().quit(0 if failures == 0 else 1)
