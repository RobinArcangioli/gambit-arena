extends Control
## Value-only visual. Order is always health, mana, then optional cast.
@export var bar_width: float = 42.0
@export var bar_height: float = 3.5
@export var bar_gap: float = 2.0
@export var health_color := Color("e44949")
@export var mana_color := Color("479fe7")
@export var cast_color := Color("e6bc42")
var health_ratio: float = 1.0
var mana_ratio: float = 1.0
var cast_ratio: float = 0.0
var casting: bool = false
var selected: bool = false

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_values(health: int, max_health: int, mana: float, max_mana: int, is_casting: bool, progress: float) -> void:
	health_ratio = clampf(float(health) / maxf(1, max_health), 0.0, 1.0)
	mana_ratio = clampf(mana / maxf(1, max_mana), 0.0, 1.0)
	casting = is_casting
	cast_ratio = clampf(progress, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var ratios: Array[float] = [health_ratio, mana_ratio, cast_ratio]
	var colors: Array[Color] = [health_color, mana_color, cast_color]
	for index in range(3 if casting else 2):
		var rect := Rect2(-bar_width * 0.5, index * (bar_height + bar_gap), bar_width, bar_height)
		draw_rect(rect.grow(1.0), Color("101b26"))
		draw_rect(Rect2(rect.position, Vector2(bar_width * ratios[index], bar_height)), colors[index])
	if selected:
		draw_circle(Vector2(0, -5), 2.0, cast_color)
