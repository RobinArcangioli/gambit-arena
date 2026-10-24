extends RefCounted
## Session-only three-row configuration; copies never share mutable Resources.
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
signal changed
var _rules: Array[Rule] = []

func _init() -> void:
	_rules = Controller.standard_rules()

func snapshot() -> Array[Rule]:
	var result: Array[Rule] = []
	for rule in _rules:
		result.append(rule.duplicate() as Rule)
	return result

static func validate_fields(fields: Dictionary) -> String:
	if fields.size() != 4 or not fields.has_all(["target", "condition", "threshold", "skill"]):
		return "Les quatre champs sont requis."
	if typeof(fields["target"]) != TYPE_STRING or fields["target"] not in ["self", "enemy"]:
		return "Cible inconnue."
	if typeof(fields["condition"]) != TYPE_STRING or fields["condition"] not in ["always", "hp_below"]:
		return "Condition inconnue."
	if typeof(fields["threshold"]) != TYPE_INT or fields["threshold"] < 0 or fields["threshold"] > 100:
		return "Le seuil doit etre un entier de 0 a 100."
	if typeof(fields["skill"]) != TYPE_STRING or fields["skill"] not in ["basic", "heal", "special"]:
		return "Action inconnue."
	if fields["skill"] == "heal" and fields["target"] != "self":
		return "Soin demande la cible Soi."
	if fields["skill"] != "heal" and fields["target"] != "enemy":
		return "Attaque et Speciale demandent Ennemi."
	return ""

func update_fields(index: int, fields: Dictionary) -> bool:
	if index < 0 or index >= _rules.size() or not validate_fields(fields).is_empty():
		return false
	var previous: Rule = _rules[index]
	if previous.target == fields["target"] and previous.condition == fields["condition"] and previous.threshold == fields["threshold"] and previous.skill == fields["skill"]:
		return true
	var replacement := Rule.new()
	replacement.enabled = previous.enabled
	replacement.target = fields["target"]
	replacement.condition = fields["condition"]
	replacement.threshold = fields["threshold"]
	replacement.skill = fields["skill"]
	_rules[index] = replacement
	changed.emit()
	return true

func toggle(index: int) -> bool:
	if index < 0 or index >= _rules.size():
		return false
	_rules[index].enabled = not _rules[index].enabled
	changed.emit()
	return true

func move(index: int, direction: int) -> bool:
	var destination: int = index + direction
	if direction not in [-1, 1] or index < 0 or index >= _rules.size() or destination < 0 or destination >= _rules.size():
		return false
	var rule: Rule = _rules[index]
	_rules[index] = _rules[destination]
	_rules[destination] = rule
	changed.emit()
	return true
