extends Resource
## Artwork only; duration and playback here never set buff lifetime or actor time.
@export var scene: PackedScene
@export var fade: Resource = preload("res://resources/presentation/effects/common_fade.tres")
@export_range(0.1, 4.0) var duration: float = 2.0
@export_range(0.1, 1.0) var radius: float = 0.47
@export var origin: Vector3 = Vector3(0, 0.72, 0)
@export var gold: Color = Color(1.0, 0.72, 0.27, 0.80)
@export var highlights: Color = Color(1.0, 0.93, 0.68, 0.88)
@export var face_color: Color = Color(0.055, 0.035, 0.012, 0.22)
@export_range(0.1, 1.0) var opacity: float = 0.85
@export var initial_turns_per_second: Vector2 = Vector2(0.10, 0.30)
@export var final_turns_per_second: Vector2 = Vector2(1.40, 3.50)
@export_range(0.05, 1.0) var acceleration_time: float = 0.45
