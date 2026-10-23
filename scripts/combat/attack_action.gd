extends RefCounted
## One executor per attacker. IDs are unique for the process, including resets.
const StatsActor = preload("res://scripts/combat/stats_actor.gd")
const ActorState = preload("res://scripts/combat/actor_state.gd")
const WINDUP: float = 0.6
const RECOVERY: float = 0.4
const REACH: float = 1.0
static var _next_id: int = 0
var action_id: int = 0
var active: bool = false
var elapsed: float = 0.0
var resolved: bool = false
var applied_damage: int = 0
var phase: String = "REPOS"
var outcome: String = "aucune"
var _source: StatsActor
var _target: StatsActor
var _source_state: ActorState
var _target_state: ActorState
var _attack: int = 0

static func living(actor: Variant) -> bool:
	return is_instance_valid(actor) and actor is StatsActor and not actor.is_queued_for_deletion() and actor.is_inside_tree() and actor.state.alive

static func distance_between(a: StatsActor, b: StatsActor) -> float:
	var offset: Vector3 = a.global_position - b.global_position
	return Vector2(offset.x, offset.z).length()

func begin(source: Variant, target: Variant) -> int:
	if active or not living(source) or not living(target) or not _valid_pair(source, target):
		return 0
	if distance_between(source, target) > REACH:
		return 0
	_disconnect_lifecycle()
	_next_id += 1
	action_id = _next_id
	_source = source
	_target = target
	_source_state = source.state
	_target_state = target.state
	_attack = source.state.attack
	active = true
	elapsed = 0.0
	resolved = false
	applied_damage = 0
	phase = "PREPARATION"
	outcome = "en attente"
	_connect_lifecycle()
	return action_id

func _participants_valid() -> bool:
	return living(_source) and living(_target) and _source.state == _source_state and _target.state == _target_state

func advance(delta: float, paused: bool = false) -> void:
	if not active or paused or not is_finite(delta) or delta <= 0.0:
		return
	# After an impact the target may be dead; recovery must still run.
	if not living(_source) or _source.state != _source_state:
		cancel()
		return
	if not resolved and not _participants_valid():
		cancel()
		return
	elapsed += delta
	if elapsed >= WINDUP and not resolved:
		try_impact(action_id)
	if active and elapsed >= WINDUP + RECOVERY:
		active = false
		phase = "TERMINEE"
		_disconnect_lifecycle()

func try_impact(expected_id: int) -> bool:
	# Single mutation gate, also safe against duplicate/stale callbacks.
	if not _effects_allowed() or not active or resolved or expected_id != action_id or elapsed < WINDUP:
		return false
	resolved = true
	phase = "RECUPERATION"
	if not _participants_valid():
		cancel()
		return false
	if distance_between(_source, _target) > REACH:
		outcome = "hors portee"
		return false
	# Latch before emitting any ActorState signal through damage().
	outcome = "impact"
	applied_damage = _apply_effect()
	return true

func cancel() -> void:
	_disconnect_lifecycle()
	if not active:
		return
	active = false
	resolved = true
	phase = "ANNULEE"
	if outcome == "en attente":
		outcome = "acteur invalide / annulation"

func _valid_pair(source: StatsActor, target: StatsActor) -> bool:
	return source != target

func _apply_effect() -> int:
	return _target_state.damage(maxi(1, _attack - _target_state.defense))

func _effects_allowed() -> bool:
	return true

func _connect_lifecycle() -> void:
	_source_state.died.connect(_on_source_lost)
	_source.tree_exiting.connect(_on_source_lost)
	if _target != _source:
		_target_state.died.connect(_on_target_lost)
		_target.tree_exiting.connect(_on_target_lost)

func _disconnect_lifecycle() -> void:
	if _source_state != null and _source_state.died.is_connected(_on_source_lost):
		_source_state.died.disconnect(_on_source_lost)
	if is_instance_valid(_source) and _source.tree_exiting.is_connected(_on_source_lost):
		_source.tree_exiting.disconnect(_on_source_lost)
	if _target_state != null and _target_state.died.is_connected(_on_target_lost):
		_target_state.died.disconnect(_on_target_lost)
	if is_instance_valid(_target) and _target.tree_exiting.is_connected(_on_target_lost):
		_target.tree_exiting.disconnect(_on_target_lost)

func _on_source_lost() -> void:
	cancel()

func _on_target_lost() -> void:
	# A target killed by our already-latched impact does not cancel recovery.
	if not resolved:
		cancel()
