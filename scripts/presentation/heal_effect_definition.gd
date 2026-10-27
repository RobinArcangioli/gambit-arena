extends Resource
## Visual-only configuration. Replacing scene changes the art, never the spell.
@export var fade: Resource = preload("res://resources/presentation/effects/common_fade.tres")
@export var scene: PackedScene
@export_range(0.1, 3.0) var duration: float = 1.0
@export var color: Color = Color(0.04, 1.0, 0.16, 1.0)
@export var ring_color: Color = Color(0.88, 1.0, 0.93, 0.72)
@export var inner_ring_color: Color = Color(0.65, 1.0, 0.76, 0.64)
@export_range(0.1, 1.5) var radius: float = 0.62
@export var center_height: float = 0.72
@export_range(0.3, 0.9) var inner_radius_ratio: float = 0.72
@export var outer_spin_axis: Vector3 = Vector3(1.0, 0.3, 0.15)
@export var inner_spin_axis: Vector3 = Vector3(0.15, 0.2, 1.0)
@export var turns: Vector2 = Vector2(1.1, -1.35)
@export var amount_height: float = 1.55
