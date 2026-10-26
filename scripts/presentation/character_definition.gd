extends Resource
## Art only: no health, skills, reach or movement speed.
@export var character_id: StringName
@export var display_name: String
@export var model: PackedScene
@export var model_scale: float = 0.65
@export var model_offset: Vector3 = Vector3.ZERO
@export var forward_rotation: float = 0.0
@export var idle_clip: StringName
@export var move_clip: StringName
@export var move_playback: float = 1.0
@export var overhead_height: float = 1.3

@export var attack_clip: StringName
@export var attack_contact: float = 0.5
@export var hit_clip: StringName
@export var hit_duration: float = 0.26
@export var flash_duration: float = 0.10
@export var death_clip: StringName
@export var death_duration: float = 0.75
@export var death_hold: float = 0.25

@export var cast_clip: StringName
@export var cast_release: float = 1.25
