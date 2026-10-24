extends RefCounted
## Fresh, deterministic value fixtures. No mutation of a running combat.
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const NAMES: Array[String] = ["Soin prioritaire", "Seuil 50%", "Energie vide", "Cooldowns", "Sans cible", "Egalite", "Hors portee", "Desactivees"]

static func make(index: int) -> Dictionary:
	if index < 0 or index >= NAMES.size():
		return {}
	var view := Snapshot.new()
	view.source = {"id": 1, "health": 60, "max_health": 100, "position": Vector2.ZERO}
	view.enemies = [{"id": 2, "health": 100, "max_health": 100, "position": Vector2(0.8, 0)}]
	var rules = Controller.standard_rules()
	var skill: String = "special"
	var target: int = 2
	var selected: int = 1
	var approach: bool = false
	var reasons: Array[String] = ["condition", "selected", "lower_priority"]
	match index:
		0:
			view.source["health"] = 40
			skill = "heal"
			target = 1
			selected = 0
			reasons = ["selected", "lower_priority", "lower_priority"]
		1:
			view.source["health"] = 50
		2:
			view.energy = 0
			skill = "basic"
			selected = 2
			reasons = ["energy", "energy", "selected"]
		3:
			view.source["health"] = 40
			view.heal_cooldown = 4.0
			view.special_cooldown = 6.0
			skill = "basic"
			selected = 2
			reasons = ["cooldown", "cooldown", "selected"]
		4:
			view.source["health"] = 100
			view.enemies.clear()
			skill = ""
			target = 0
			selected = -1
			reasons = ["full_health", "no_target", "no_target"]
		5:
			view.enemies.push_front({"id": 3, "health": 100, "max_health": 100, "position": Vector2(-0.8, 0)})
		6:
			view.enemies[0]["position"] = Vector2(2, 0)
			approach = true
			reasons = ["condition", "approach", "lower_priority"]
		7:
			for rule in rules:
				rule.enabled = false
			skill = ""
			target = 0
			selected = -1
			reasons = ["disabled", "disabled", "disabled"]
	var expected: Dictionary = {"kind": "none" if selected == -1 else "intent", "reason": "no_match" if selected == -1 else "matched", "rule_index": selected, "source_id": 0 if selected == -1 else 1, "target_id": target, "skill": skill, "approach": approach}
	return {"name": NAMES[index], "view": view, "rules": rules, "expected": expected, "reasons": reasons}
