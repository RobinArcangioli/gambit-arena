extends "res://scripts/waves/run_lifecycle_lab.gd"
const ApplicationGuard = preload("res://scripts/platform/application_guard.gd")
var application_guard := ApplicationGuard.new()

func _ready() -> void:
	super._ready()
	# Reverse depth-first _input dispatch: this child precedes the touch router and GUI.
	add_child(application_guard)
	_update_buttons()

func _notification(what: int) -> void:
	if not is_instance_valid(application_guard):
		return
	var relevant: bool = application_guard.observe(what)
	if relevant and application_guard.resume_required:
		paused = true
	if relevant and is_node_ready():
		if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
			# Also handles tests/embedders forwarding only the root notification.
			touch_router.notification(what)
		_update_buttons()
		if what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
			call_deferred("_update_layout")

func _toggle_pause() -> void:
	if application_guard.blocked:
		return
	var was_paused: bool = paused
	super._toggle_pause()
	if was_paused and not paused:
		application_guard.acknowledge_resume()

func _update_buttons() -> void:
	super._update_buttons()
	if setup_complete:
		pause_button.disabled = application_guard.blocked
		replay.disabled = application_guard.blocked

func _reset() -> void:
	if application_guard.blocked and simulation.run_id > 0:
		return
	super._reset()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	if application_guard.blocked:
		paused = true
		simulation.clock.paused = true
	if not paused and simulation.result == "EN COURS" and application_guard.consume_return_step():
		_present()
		return
	super._physics_process(delta)

func _present() -> void:
	super._present()
	if hud_ready and simulation.result == "EN COURS" and application_guard.resume_required:
		$HUD/Description.text = "PAUSE / retour"
		if editing_index < 0:
			action_label.text = "Reprendre pour continuer"
