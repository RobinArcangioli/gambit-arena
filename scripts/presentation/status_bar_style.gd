extends Resource
## Shared art settings only; panel mode changes thickness, never length or actor values.
@export var world_height: float = 1.25
@export var panel_height: float = 2.2
@export var world_gap: float = 2.25
@export var panel_gap: float = 18.1
@export var glow_radius: float = 1.0
@export_range(0.0, 0.5) var glow_strength: float = 0.22
@export var health_color: Color = Color("ff4545")
@export var mana_color: Color = Color("399fff")
@export var cast_color: Color = Color("ffd24a")
@export var track_color: Color = Color(0.025,0.05,0.09,0.38)

@export var panel_segments: int = 10
@export var segment_gap: float = 1.2
@export_range(0.0, 1.0) var panel_empty_brightness: float = 0.40
@export var panel_glow_radius: float = 1.15
@export_range(0.0, 0.5) var panel_glow_strength: float = 0.30
