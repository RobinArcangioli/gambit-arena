extends "res://scripts/waves/wave_sequence_lab.gd"

func _present() -> void:
	super._present()
	if not hud_ready:
		return
	var summary: Dictionary = simulation.final_report
	if summary.is_empty():
		return
	# The existing status panel stays readable without hiding the board or adding a modal.
	$HUD/Description.text = String(summary.result)
	action_label.text = "Partie terminee / Rejouer"
	cooldown_label.text = "Vagues %d/%d / vaincus %d/%d" % [summary.completed, summary.waves, summary.defeated, summary.budget]
	enemies_label.text = "Arrives %d / vivants %d" % [summary.spawned, summary.alive]

func _details_caption(selected: Dictionary) -> String:
	var text: String = super._details_caption(selected)
	var summary: Dictionary = simulation.final_report
	if summary.is_empty():
		return text
	return text + "\nBilan : %s, vague %d/%d, %.1f s de jeu.\nVagues terminees %d, vaincus %d, retires %d, impacts %d.\nRejouer : partie neuve, gambits et pause conserves." % [summary.result, summary.wave, summary.waves, summary.elapsed, summary.completed, summary.defeated, summary.removed, summary.hits]
