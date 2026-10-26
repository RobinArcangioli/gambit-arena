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
