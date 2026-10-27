extends Node3D
## Logical actor. The optional child view owns every mesh, rig and animation.
const GroundBody = preload("res://scripts/crowd/ground_crowd.gd")
const ActorState = preload("res://scripts/combat/actor_state.gd")
const ActorProfile = preload("res://scripts/combat/actor_profile.gd")
const Mannequin = preload("res://scripts/hybrid/proxy_actor.gd")
const CharacterView = preload("res://scripts/presentation/character_view.gd")
const CharacterDefinition = preload("res://scripts/presentation/character_definition.gd")
@export var enemy: bool = false
var state := ActorState.new()
var visual: Node3D
var appearance: CharacterDefinition
var presentation_enabled: bool = true
var _gait: float = 0.0
var _walking: bool = false
var _facing := Vector2.ZERO
# Compatibility for historical mannequin diagnostics only.
var left_leg: Node3D:
	get: return visual.left_leg if visual is Mannequin else null
var right_leg: Node3D:
	get: return visual.right_leg if visual is Mannequin else null

func _ready() -> void:
	set_appearance(appearance, presentation_enabled)

func configure(profile: ActorProfile) -> void:
	state = ActorState.new(profile)

func set_appearance(profile: CharacterDefinition, enabled: bool = true) -> void:
	appearance = profile
	presentation_enabled = enabled
	if is_instance_valid(visual):
		remove_child(visual)
		visual.queue_free()
	visual = null
	if not enabled:
		return
	if profile != null:
		var candidate := CharacterView.new()
		candidate.definition = profile
		candidate.ground_radius = GroundBody.RADIUS
		add_child(candidate)
		if candidate.valid:
			visual = candidate
		else:
			remove_child(candidate)
			candidate.queue_free()
	if visual == null:
		var fallback := Mannequin.new()
		fallback.enemy = enemy
		add_child(fallback)
		visual = fallback
	visual.name = "Presentation"
	pose(_gait, _walking, _facing)

func pose(time: float, walking: bool, facing: Vector2) -> void:
	_gait = time
	_walking = walking
	_facing = facing
	if is_instance_valid(visual):
		visual.pose(time, walking, facing)

func advance_visual(dt: float) -> void:
	if visual is CharacterView:
		visual.advance_visual(dt)

func release_visual() -> Node3D:
	# Presentation-only transfer. Death views never keep the logical actor in combat.
	var released: Node3D = visual
	visual = null
	if is_instance_valid(released): remove_child(released)
	return released
