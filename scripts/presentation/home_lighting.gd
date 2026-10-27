extends Control
## Decorative only. Map the same centered cover crop as Home's TextureRect.
const Profile = preload("res://scripts/presentation/home_lighting_profile.gd")
const Glow = preload("res://assets/shaders/home_glow.gdshader")
@export var profile: Profile = preload("res://resources/presentation/home_lights.tres")
var elapsed: float = 0.0
var active: bool = true
var lights: Array[ColorRect] = []
var anchors: Array[Vector2] = []
var radii: Array[Vector2] = []
var strengths: Array[float] = []
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE;clip_contents = true
	for point in profile.candles:_add_light(point,profile.candle_radius,profile.candle_color,profile.candle_strength)
	for point in profile.braziers:_add_light(point,profile.brazier_radius,profile.brazier_color,profile.brazier_strength)
	resized.connect(_layout)
	_layout();_animate();set_active(active)
func _add_light(anchor: Vector2, radius: Vector2, color: Color, strength: float) -> void:
	var light := ColorRect.new();light.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var effect := ShaderMaterial.new();effect.shader = Glow
	effect.set_shader_parameter("tint",color)
	light.material = effect
	anchors.append(anchor);radii.append(radius);strengths.append(strength);lights.append(light);add_child(light)
func image_rect() -> Rect2:
	var scale_factor: float = maxf(size.x/profile.reference_size.x,size.y/profile.reference_size.y)
	var image_size: Vector2 = profile.reference_size*scale_factor
	return Rect2((size-image_size)*0.5,image_size)
func _layout() -> void:
	var image: Rect2 = image_rect();var scale_factor: float = image.size.x/profile.reference_size.x
	for i in range(lights.size()):
		lights[i].size = radii[i]*2.0*scale_factor
		lights[i].position = image.position+anchors[i]*scale_factor-lights[i].size*0.5
func _animate() -> void:
	for i in range(lights.size()):
		var phase: float = float(i)*2.39996
		var pulse: float = 0.55*sin(elapsed*2.6+phase)+0.30*sin(elapsed*5.1+phase*1.7)+0.15*sin(elapsed*9.3+phase*0.8)
		lights[i].material.set_shader_parameter("strength",strengths[i]*(1.0+profile.flicker*pulse))
func _process(delta: float) -> void:
	if not active or not is_visible_in_tree() or not is_finite(delta) or delta<=0:return
	elapsed += minf(delta,0.05)
	_animate()
func set_active(value: bool) -> void:
	active = value;set_process(value)
