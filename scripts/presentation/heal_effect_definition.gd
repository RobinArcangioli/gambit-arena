extends Resource
## Visual-only configuration. Replacing scene changes the art, never the spell.
@export var scene: PackedScene
@export_range(0.1, 3.0) var duration: float = 0.85
@export var color: Color = Color(0.3, 1.0, 0.58, 1.0)
@export_range(0.1, 1.5) var radius: float = 0.42
@export var amount_height: float = 1.55
