extends "res://scripts/manual/manual_command_lab.gd"
const WAVE_MODES: Array[String] = ["Vague 12", "Soin 12", "Charge 24"]

func _ready() -> void:
	simulation.wave_enabled = true
	super._ready()
	_present()

func _update_buttons() -> void:
	super._update_buttons()
	if setup_complete:
		position_button.text = "%d/3 %s" % [mode_index + 1, WAVE_MODES[mode_index]]

func _present() -> void:
	super._present()
	if not hud_ready:
		return
	var schedule = simulation.wave
	enemies_label.text = "Vivants %d/%d / arrives %d/%d" % [simulation.enemies.size(), schedule.cap, simulation.spawned, simulation.budget]
	if simulation.manual.snapshot().is_empty():
		$HUD/Description.text = "%s / %s" % ["PAUSE" if paused else simulation.result, WAVE_MODES[mode_index]]
	if simulation.result == "EN COURS" and simulation.enemies.is_empty() and simulation.spawned < simulation.budget and not simulation.manual.pending:
		action_label.text = "Vague : prochaine arrivee"

func _details_caption(selected: Dictionary) -> String:
	return super._details_caption(selected) + "\nVague unique : %d vaincus, %d a venir. Pic %d/%d." % [simulation.defeated, simulation.budget - simulation.spawned, simulation.peak_alive, simulation.wave.cap]
