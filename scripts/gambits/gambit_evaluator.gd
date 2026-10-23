extends RefCounted
## Pure decision: no signals, timers, mutation, RNG or action execution.
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Executor = preload("res://scripts/skills/skill_executor.gd")

static func evaluate(rules: Array[Rule], view: Snapshot) -> Dictionary:
	if view == null or not view.valid() or rules.size() > 3:
		return _none("invalid_input")
	if view.paused or view.stopped or view.busy or view.source["health"] == 0:
		return _none("unavailable")
	for index in range(rules.size()):
		var rule: Rule = rules[index]
		if rule == null or not rule.enabled or not rule.valid() or not _ready_skill(rule.skill, view):
			continue
		var candidate: Dictionary = {}
		if rule.target == "self":
			if view.source["health"] < view.source["max_health"] and _matches(rule, view.source):
				candidate = view.source
		else:
			var nearest: float = INF
			for row in view.enemies:
				if row["health"] == 0 or not _matches(rule, row):
					continue
				var distance: float = _distance_squared(view.source, row)
				if candidate.is_empty() or distance < nearest or (distance == nearest and row["id"] < candidate["id"]):
					candidate = row
					nearest = distance
		if not candidate.is_empty():
			var approach: bool = _distance_squared(view.source, candidate) > Executor.REACH * Executor.REACH
			return {"kind": "intent", "reason": "matched", "rule_index": index, "source_id": view.source["id"], "target_id": candidate["id"], "skill": rule.skill, "approach": approach}
	return _none("no_match")

static func _ready_skill(skill: String, view: Snapshot) -> bool:
	match skill:
		"heal": return view.energy >= Executor.HEAL_COST and view.heal_cooldown == 0.0
		"special": return view.energy >= Executor.SPECIAL_COST and view.special_cooldown == 0.0
	return true

static func _matches(rule: Rule, row: Dictionary) -> bool:
	# Strict boundary, exact integer ratio; no rounded percent in decisions.
	return rule.condition == "always" or row["health"] * 100 < row["max_health"] * rule.threshold

static func _distance_squared(a: Dictionary, b: Dictionary) -> float:
	var point: Vector2 = a["position"]
	return point.distance_squared_to(b["position"])

static func _none(reason: String) -> Dictionary:
	return {"kind": "none", "reason": reason, "rule_index": -1, "source_id": 0, "target_id": 0, "skill": "", "approach": false}
