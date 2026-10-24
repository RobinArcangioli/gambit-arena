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
