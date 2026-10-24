extends "res://scripts/combat/battle_lab.gd"
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const Scenarios = preload("res://scripts/gambits/gambit_scenarios.gd")
const LABELS: Dictionary = {"condition": "condition fausse", "selected": "choisie", "approach": "approche requise", "lower_priority": "priorite inferieure", "energy": "energie insuffisante", "cooldown": "cooldown actif", "full_health": "PV pleins", "no_target": "aucune cible", "disabled": "desactivee", "invalid_rule": "regle invalide"}
var view_button: Button
var trace_button: Button
var show_journal: bool = false
var fixture: Dictionary = {}
var fixture_report: Dictionary = {}
var fixture_reads: int = 0
var cadence: float = 0.0

func _ready() -> void:
	simulation.controller.rules = Controller.standard_rules()
	super._ready()
	view_button = Button.new()
	view_button.focus_mode = Control.FOCUS_NONE
	view_button.pressed.connect(_toggle_view)
	hud.add_child(view_button)
	trace_button = Button.new()
	trace_button.focus_mode = Control.FOCUS_NONE
	trace_button.pressed.connect(_toggle_trace)
	hud.add_child(trace_button)
	$HUD/Title.text = "STEP-018 / DIAGNOSTIC"
	_update_layout()
	_update_buttons()
	_present()

func _update_layout() -> void:
	super._update_layout()
	if not is_instance_valid(view_button) or not is_instance_valid(trace_button):
		return
	var cell: float = (safe_rect.size.x - 64.0) / 3.0
	var buttons: Array[Button] = [replay, view_button, trace_button]
	for index in range(3):
		buttons[index].position = Vector2(28 + index * (cell + 4), 124)
		buttons[index].size = Vector2(cell, 44)
		buttons[index].add_theme_font_size_override("font_size", 17)

func _reset() -> void:
	simulation.reset(0)
	cadence = 0.0
	fixture_reads = 0
	fixture.clear()
	fixture_report.clear()
	if mode_index > 0:
		fixture = Scenarios.make(mode_index - 1)
		# Initial preview, not a time tick and not a journal event while paused.
		fixture_report = Evaluator.explain(fixture["rules"], fixture["view"])
	_present()
	_update_buttons()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	simulation.clock.paused = paused
	if mode_index == 0:
		simulation.advance(delta, paused)
	else:
		var dt: float = simulation.clock.step(delta)
		if dt > 0.0:
			cadence += dt
			if cadence + 0.000001 >= 0.1:
				cadence = maxf(0.0, cadence - 0.1)
				fixture_report = Evaluator.explain(fixture["rules"], fixture["view"])
				fixture_reads += 1
				if simulation.controller.diagnostics_enabled:
					simulation.controller.trace.record("decision", simulation.clock.elapsed, fixture_report["decision"], 0, fixture_report["decision"]["reason"], fixture_report["rules"])
	_present()

func _present() -> void:
	if not setup_complete or not is_instance_valid(simulation.hero):
		return
	if mode_index == 0:
		super._present()
	render_box.visible = mode_index == 0
	floor_canvas.visible = mode_index == 0
	rings.visible = mode_index == 0 and floor_canvas.show_marks
	var pilot = simulation.controller
	var report: Dictionary = pilot.explanation if mode_index == 0 else fixture_report
	var intro: String
	if mode_index == 0:
		intro = "%s | %.1f s | PV %d/%d\nEnergie %d | lances %d | depense %d" % [simulation.result, simulation.elapsed, simulation.hero.state.health, simulation.hero.state.max_health, simulation.hero.action.energy, pilot.launched, simulation.hero.action.spent]
	else:
		intro = "%s | lecture seule\nPV %d/100 | energie %d | lectures %d" % [fixture["name"], fixture["view"].source["health"], fixture["view"].energy, fixture_reads]
		intro += "\nCibles %d | CD H %.0f / S %.0f" % [fixture["view"].enemies.size(), fixture["view"].heal_cooldown, fixture["view"].special_cooldown]
	var text: String = intro + "\n"
	if show_journal:
		text += "Journal %d/64 | anciens retires %d\n" % [pilot.trace.size(), pilot.trace.dropped]
		for entry in pilot.trace.latest(4):
			text += "%.1f %s R%d %s\n" % [entry["time"], entry["event"], entry["rule_index"] + 1, entry["reason"]]
	else:
		var choice: Dictionary = report.get("decision", {})
		text += "Derniere lecture : %s\n" % ("R%d %s -> #%d" % [choice["rule_index"] + 1, choice["skill"], choice["target_id"]] if choice.get("kind", "none") == "intent" else choice.get("reason", "en attente"))
		for detail in report.get("rules", []):
			text += "R%d : %s\n" % [detail["rule_index"] + 1, LABELS.get(detail["reason"], detail["reason"])]
		if not pilot.diagnostics_enabled and mode_index == 0:
			text += "Trace coupee : combat toujours actif\n"
	readout.text = text.strip_edges()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % (Scenarios.NAMES.size() + 1)
	_reset()

func _toggle_view() -> void:
	show_journal = not show_journal
	_present()
	_update_buttons()

func _toggle_trace() -> void:
	if paused:
		return
	simulation.controller.diagnostics_enabled = not simulation.controller.diagnostics_enabled
	_present()
	_update_buttons()

func _update_buttons() -> void:
	simulation.clock.paused = paused
	pause_button.text = "Reprendre" if paused else "Pause"
	position_button.disabled = paused
	marks_button.text = "Reperes : oui" if floor_canvas.show_marks else "Reperes : non"
	if setup_complete:
		position_button.text = "1/9 Combat" if mode_index == 0 else "%d/9 %s" % [mode_index + 1, Scenarios.NAMES[mode_index - 1]]
		position_button.add_theme_font_size_override("font_size", 16)
		$HUD/Description.text = "Combat reel / journal limite a 64 entrees" if mode_index == 0 else "Cas fixe : decisions sans execution\nRejouer reproduit les memes choix"
	if is_instance_valid(view_button) and is_instance_valid(trace_button):
		view_button.text = "Vue raisons" if show_journal else "Vue journal"
		trace_button.text = "Trace oui" if simulation.controller.diagnostics_enabled else "Trace non"
		trace_button.disabled = paused

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_V:
			_toggle_view()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_T:
			_toggle_trace()
			get_viewport().set_input_as_handled()
			return
	super._unhandled_key_input(event)
