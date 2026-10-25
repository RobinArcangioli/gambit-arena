extends "res://scripts/ui/skill_slots_lab.gd"
var manual_ready: bool = false
var command_feedback: String = "Appui : commander. Une attente, remplacee au prochain appui."

func _ready() -> void:
	simulation.manual_enabled = true
	super._ready()
	manual_ready = true
	_present()

func _select_slot(index: int) -> void:
	if not manual_ready or editing_index >= 0 or index < 0 or index >= 3:
		return
	selected_slot = index
	var skills: Array[StringName] = [&"basic", &"heal", &"special"]
	if simulation.request_manual(skills[index]):
		command_feedback = "Commande recue : " + _skill_name(String(skills[index])) + "."
	else:
		command_feedback = "Refus : " + _reason_text(simulation.manual.last_rejection) + "."
	_present()

func _reset() -> void:
	command_feedback = "Appui : commander. Une attente, remplacee au prochain appui."
	super._reset()

func _skill_tooltip() -> String:
	return "Commander / remplacer l'attente (3 s de jeu)"

func _details_caption(selected: Dictionary) -> String:
	var queue: Dictionary = simulation.manual.snapshot()
	var text: String = "%s / cout %d E / delai %.1f s\n%s\n" % [selected["name"], selected["cost"], selected["cooldown"], Availability.explanation(selected["state"])]
	if not queue.is_empty():
		text += "Attente : %s / %.1f s / %s.\n" % [_skill_name(queue["skill"]), ceilf(queue["remaining"] * 10.0) / 10.0, _reason_text(queue["reason"])]
	else:
		text += "Commande : %s.\n" % _event_text(simulation.manual.last_event)
	return text + command_feedback + "\nPriorite manuelle ; aucune interruption. Pause : appuis refuses."

func _present() -> void:
	super._present()
	if not manual_ready:
		return
	var queue: Dictionary = simulation.manual.snapshot()
	if not queue.is_empty():
		$HUD/Description.text = "%s %s %.1f s" % ["PAUSE" if paused else "ATTENTE", _skill_name(queue["skill"]), ceilf(queue["remaining"] * 10.0) / 10.0]
		if not simulation.hero.action.active:
			action_label.text = "Manuel : " + _reason_text(queue["reason"])

static func _reason_text(reason: String) -> String:
	match reason:
		"next_tick": return "prochain pas de jeu"
		"paused": return "combat en pause"
		"busy": return "action en cours"
		"cooldown": return "delai de competence"
		"full_health": return "PV pleins"
		"energy": return "energie insuffisante"
		"out_of_range": return "approche de la cible"
		"no_target": return "aucune cible"
		"ready": return "prete"
		"unknown": return "commande inconnue"
		"executor_rejected": return "execution refusee"
	return "combat termine / acteur indisponible"

static func _event_text(event: String) -> String:
	match event:
		"launched": return "lancee une seule fois"
		"expired": return "expiree / gambits repris"
		"target_lost": return "cible perdue / gambits repris"
		"source_lost", "terminal": return "annulee / fin du combat"
	return "aucune attente"
