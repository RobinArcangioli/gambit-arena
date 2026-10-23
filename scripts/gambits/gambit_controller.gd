extends RefCounted
## The hero's only automatic movement/skill caller. Evaluator remains value-only.
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Action = preload("res://scripts/combat/attack_action.gd")
const ActorState = preload("res://scripts/combat/actor_state.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const PERIOD: float = 0.1
var rules: Array[Rule] = []
var evaluations: int = 0
var launched: int = 0
var basic_starts: int = 0
var heal_starts: int = 0
var special_starts: int = 0
var last_rule: int = -1
var _remaining: float = 0.0
var _first: bool = true
var _consumed: bool = false
var _decision: Dictionary = {}
var _signature: Array = []
var _source: Unit
var _target: Unit
var _source_state: ActorState
var _target_state: ActorState
var decision: Dictionary:
	get: return _decision.duplicate()

func _init() -> void:
	# Historical combat fixtures still use basic only, through the same controller.
	rules.append(Rule.new())

static func standard_rules() -> Array[Rule]:
	var result: Array[Rule] = []
	for skill in ["heal", "special", "basic"]:
		var rule := Rule.new()
		rule.skill = skill
		if skill == "heal":
			rule.target = "self"
			rule.condition = "hp_below"
		result.append(rule)
	return result

func reset() -> void:
	# Rule configuration belongs to the run owner and survives replay.
	_source = null
	_target = null
	_source_state = null
	_target_state = null
	_decision.clear()
	_signature.clear()
	_remaining = 0.0
	_first = true
	_consumed = false
	evaluations = 0
	launched = 0
	basic_starts = 0
	heal_starts = 0
	special_starts = 0
	last_rule = -1

static func _row(unit: Unit) -> Dictionary:
	return {"id": unit.combat_id, "health": unit.state.health, "max_health": unit.state.max_health, "position": Vector2(unit.position.x, unit.position.z)}

static func capture(hero: Unit, enemies: Array[Unit], clock: Clock) -> Snapshot:
	var view := Snapshot.new()
	if not Action.living(hero):
		return view
	view.source = _row(hero)
	for unit in enemies:
		if Action.living(unit):
			view.enemies.append(_row(unit))
	view.energy = hero.action.energy
	view.heal_cooldown = hero.action.remaining(&"heal")
	view.special_cooldown = hero.action.remaining(&"special")
	view.busy = hero.action.active
	view.paused = clock.paused
	view.stopped = clock.stopped
	return view

func _rule_signature(rule: Rule) -> Array:
	if rule == null:
		return []
	return [rule.enabled, rule.target, rule.condition, rule.threshold, rule.skill]

func _participants_valid(hero: Unit, enemies: Array[Unit]) -> bool:
	if not Action.living(hero) or hero != _source or hero.state != _source_state or not Action.living(_target) or _target.state != _target_state:
		return false
	if _target != hero and _target not in enemies:
		return false
	var index: int = int(_decision.get("rule_index", -1))
	return index >= 0 and index < rules.size() and rules.size() <= 3 and _rule_signature(rules[index]) == _signature

func _forget(hero: Unit) -> void:
	if is_instance_valid(hero):
		hero.mover.clear_target()
	_source = null
	_target = null
	_source_state = null
	_target_state = null
	_decision.clear()
	_signature.clear()
	_consumed = false

func stop(hero: Unit) -> void:
	_forget(hero)
	_first = true

func plan(delta: float, hero: Unit, enemies: Array[Unit], clock: Clock) -> void:
	if not clock.permits_gameplay() or not is_finite(delta) or delta <= 0.0:
		return
	if not Action.living(hero):
		stop(hero)
		return
	_remaining = maxf(0.0, _remaining - delta)
	# Once committed, the executor owns the locked target until completion/cancel.
	if hero.action.active:
		return
	var stale: bool = _decision.get("kind", "none") == "intent" and not _participants_valid(hero, enemies)
	if not _first and not stale and _remaining > 0.000001:
		return
	_first = false
	_remaining = PERIOD
	var next: Dictionary = Evaluator.evaluate(rules, capture(hero, enemies, clock))
	evaluations += 1
	_forget(hero)
	_decision = next
	if next["kind"] != "intent":
		return
	_source = hero
	_source_state = hero.state
	if next["target_id"] == hero.combat_id:
		_target = hero
	else:
		for unit in enemies:
			if Action.living(unit) and unit.combat_id == next["target_id"]:
				_target = unit
				break
	if not Action.living(_target):
		stop(hero)
		return
	_target_state = _target.state
	_signature = _rule_signature(rules[next["rule_index"]])
	if _target != hero:
		hero.mover.set_target(_target)

func execute(hero: Unit, enemies: Array[Unit], clock: Clock) -> int:
	if not clock.permits_gameplay() or not Action.living(hero) or hero.action.active or _consumed or _decision.get("kind", "none") != "intent":
		return 0
	if not _participants_valid(hero, enemies):
		stop(hero)
		return 0
	# Revalidate only the selected rule/target against current values. This does not
	# replan or switch targets between 10 Hz decisions, and does not mutate gameplay.
	var view: Snapshot = capture(hero, enemies, clock)
	view.enemies.clear()
	if _target != hero:
		view.enemies.append(_row(_target))
	var selected: Array[Rule] = [rules[_decision["rule_index"]]]
	var validation: Dictionary = Evaluator.evaluate(selected, view)
	if validation["kind"] != "intent" or validation["target_id"] != _decision["target_id"] or validation["skill"] != _decision["skill"]:
		stop(hero)
		return 0
	if validation["approach"]:
		return 0
	var id: int = hero.action.request(StringName(_decision["skill"]), _target)
	if id > 0:
		_consumed = true
		launched += 1
		last_rule = _decision["rule_index"]
		match _decision["skill"]:
			"basic": basic_starts += 1
			"heal": heal_starts += 1
			"special": special_starts += 1
		if _target != hero:
			var offset: Vector3 = _target.position - hero.position
			hero.mover.facing = Vector2(offset.x, offset.z).normalized()
	return id
