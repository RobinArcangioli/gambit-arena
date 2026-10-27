extends Resource
## Art coordinates refer only to the supplied Home illustration.
@export var reference_size: Vector2 = Vector2(941,1672)
@export var candles: PackedVector2Array = PackedVector2Array()
@export var braziers: PackedVector2Array = PackedVector2Array()
@export var candle_radius: Vector2 = Vector2(28,38)
@export var brazier_radius: Vector2 = Vector2(72,90)
@export var candle_color: Color = Color(1.0,0.57,0.15,1.0)
@export var brazier_color: Color = Color(0.16,0.58,1.0,1.0)
@export_range(0.0,1.0) var candle_strength: float = 0.30
@export_range(0.0,1.0) var brazier_strength: float = 0.46
@export_range(0.0,0.7) var flicker: float = 0.34
