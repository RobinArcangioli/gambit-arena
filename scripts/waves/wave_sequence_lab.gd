extends "res://scripts/waves/wave_lab.gd"
const SEQUENCE_MODES: Array[String] = ["3 x 12", "Soin 3 x 12", "Charge 3 x 24"]

func _ready() -> void:
	simulation.sequence_enabled = true
	super._ready()

func _update_buttons() -> void:
	super._update_buttons()
	if setup_complete:
		position_button.text = "%d/3 %s" % [mode_index + 1, SEQUENCE_MODES[mode_index]]

func _present() -> void:
	super._present()
	if not hud_ready:
		return
	var current: Dictionary = simulation.wave_snapshot()
	enemies_label.text = "Vague %d/%d / vivants %d/%d" % [simulation.wave_number, simulation.wave_count, current.alive, simulation.wave.cap]
	if not simulation.manual.pending:
		$HUD/Description.text = "%s | %d/%d" % ["PAUSE" if paused else simulation.result, simulation.defeated, simulation.budget]

	$HUD/Description.tooltip_text = "Etat et ennemis vaincus sur le total de la partie. Details dans Competences."

func _details_caption(selected: Dictionary) -> String:
	var current: Dictionary = simulation.wave_snapshot()
	return super._details_caption(selected).get_slice("\nVague unique", 0) + "\nVague %d/%d : arrives %d/%d, vaincus %d, a venir %d.\nPartie : arrives %d/%d, vaincus %d, retires %d. Pic %d/%d." % [simulation.wave_number, simulation.wave_count, current.spawned, current.total, current.defeated, current.remaining, simulation.spawned, simulation.budget, simulation.defeated, simulation.removed, simulation.peak_alive, simulation.wave.cap]
