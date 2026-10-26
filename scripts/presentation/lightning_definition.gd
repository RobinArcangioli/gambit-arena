extends Resource
## Art-only contract; no damage, mana, cooldown or cast duration.
@export var strike_scene: PackedScene
@export var cast_scene: PackedScene
@export var glow_color: Color = Color(0.16, 0.48, 1.0)
@export var core_color: Color = Color(0.88, 0.98, 1.0)
@export_range(0.1, 2.0) var duration: float = 0.52
@export_range(0.05, 0.5) var strike_duration: float = 0.26
@export_range(1.5, 8.0) var sky_height: float = 4.5
@export_range(0.05, 0.8) var glow_width: float = 0.36
@export var impact_height: float = 0.55
@export var impact_radius: float = 0.75
