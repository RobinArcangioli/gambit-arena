extends RefCounted
## Pure decision: no signals, timers, mutation, RNG or action execution.
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")

static func evaluate(rules: Array[Rule], view: Snapshot) -> Dictionary:
	var ignored: Array[Dictionary] = []
	return _run(rules, view, ignored, false)

static func explain(rules: Array[Rule], view: Snapshot) -> Dictionary:
	var details: Array[Dictionary] = []
	var decision: Dictionary = _run(rules, view, details, true)
	return {"decision": decision, "rules": details}

static func _run(rules: Array[Rule], view: Snapshot, details: Array[Dictionary], diagnostic: bool) -> Dictionary:
	if view == null or not view.valid() or rules.size() > 3:
		return _none("invalid_input")
	if view.paused or view.stopped or view.busy or view.source["health"] == 0:
		return _none("unavailable")
	for index in range(rules.size()):
		var rule: Rule = rules[index]
		var refusal: String = _rule_refusal(rule, view)
		if not refusal.is_empty():
			if diagnostic:
				details.append({"rule_index": index, "reason": refusal})
			continue
		var candidate: Dictionary = {}
		var miss: String = "condition"
		if rule.target == "self":
			if view.source["health"] >= view.source["max_health"]:
				miss = "full_health"
			if view.source["health"] < view.source["max_health"] and _matches(rule, view.source):
				candidate = view.source
		else:
			var nearest: float = INF
			miss = "no_target"
			for row in view.enemies:
				if row["health"] == 0:
					continue
				miss = "condition"
				if not _matches(rule, row):
					continue
				var distance: float = _distance_squared(view.source, row)
				if candidate.is_empty() or distance < nearest or (distance == nearest and row["id"] < candidate["id"]):
					candidate = row
					nearest = distance
		if not candidate.is_empty():
			var approach: bool = _distance_squared(view.source, candidate) > Executor.REACH * Executor.REACH
			if diagnostic:
				details.append({"rule_index": index, "reason": "approach" if approach else "selected"})
				for lower in range(index + 1, rules.size()):
					details.append({"rule_index": lower, "reason": "lower_priority"})
			return {"kind": "intent", "reason": "matched", "rule_index": index, "source_id": view.source["id"], "target_id": candidate["id"], "skill": rule.skill, "approach": approach}
		if diagnostic:
			details.append({"rule_index": index, "reason": miss})
	return _none("no_match")

static func _rule_refusal(rule: Rule, view: Snapshot) -> String:
	if rule == null:
		return "invalid_rule"
	if not rule.enabled:
		return "disabled"
	if not rule.valid():
		return "invalid_rule"
	var cost: int = Executor.HEAL_COST if rule.skill == "heal" else Executor.SPECIAL_COST if rule.skill == "special" else 0
	if view.energy < cost:
		return "energy"
	if (rule.skill == "heal" and view.heal_cooldown > 0.0) or (rule.skill == "special" and view.special_cooldown > 0.0):
		return "cooldown"
	return ""

static func _matches(rule: Rule, row: Dictionary) -> bool:
	# Strict boundary, exact integer ratio; no rounded percent in decisions.
	return rule.condition == "always" or row["health"] * 100 < row["max_health"] * rule.threshold

static func _distance_squared(a: Dictionary, b: Dictionary) -> float:
	var point: Vector2 = a["position"]
	return point.distance_squared_to(b["position"])

static func _none(reason: String) -> Dictionary:
	return {"kind": "none", "reason": reason, "rule_index": -1, "source_id": 0, "target_id": 0, "skill": "", "approach": false}
