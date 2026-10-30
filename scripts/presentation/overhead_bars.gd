extends Control
## Value-only visual. Order is always health, mana, then optional cast.
const DEFAULT_STYLE = preload("res://resources/presentation/status_bars/neon.tres")
const NeonShader = preload("res://shaders/presentation/neon_status_bars.gdshader")
const ORIGINAL_WORLD_WIDTH: float = 42.0
const WORLD_WIDTH_RATIO: float = 0.70
@export var bar_width: float = ORIGINAL_WORLD_WIDTH * WORLD_WIDTH_RATIO
@export var bar_height: float = 1.25
@export var bar_gap: float = 2.25
@export var health_color := Color("e44949")
@export var mana_color := Color("479fe7")
@export var cast_color := Color("8befff")
var segments: int = 0
var segment_gap: float = 1.2
var empty_brightness: float = 0.22
var style_resource: Resource
var glow_radius: float = 1.0
var glow_strength: float = 0.22
var track_color: Color
var health_ratio: float = 1.0
var mana_ratio: float = 1.0
var mana_visible: bool = true
var cast_ratio: float = 0.0
var casting: bool = false
var selected: bool = false
var attacking:bool=false
var attack_ratio:float=0.0
var attack_split:float=.6
var panel_mode:bool=false
var attack_marker:TextureRect
const ATTACK_ICON=preload("res://assets/ui/normal_attack_sword.svg")

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var paint := ShaderMaterial.new();paint.shader = NeonShader;material = paint
	attack_marker=TextureRect.new();attack_marker.texture=ATTACK_ICON
	attack_marker.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	attack_marker.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	attack_marker.mouse_filter=Control.MOUSE_FILTER_IGNORE
	attack_marker.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(attack_marker);attack_marker.hide()
	apply_style(DEFAULT_STYLE)

func apply_style(profile: Resource, in_panel: bool = false) -> void:
	panel_mode=in_panel
	segments = profile.panel_segments if panel_mode else 0
	segment_gap = profile.segment_gap
	empty_brightness = profile.panel_empty_brightness
	style_resource = profile
	bar_height = profile.panel_height if panel_mode else profile.world_height
	bar_gap = profile.panel_gap if panel_mode else profile.world_gap
	glow_radius = profile.panel_glow_radius if panel_mode else profile.glow_radius
	glow_strength = profile.panel_glow_strength if panel_mode else profile.glow_strength
	health_color = profile.health_color;mana_color = profile.mana_color;cast_color = profile.cast_color
	track_color = profile.track_color
	queue_redraw()

func set_values(health: int, max_health: int, mana: float, max_mana: int, is_casting: bool, progress: float) -> void:
	attacking=false;attack_marker.hide()
	health_ratio = clampf(float(health) / maxf(1, max_health), 0.0, 1.0)
	mana_visible = max_mana > 0
	mana_ratio = clampf(mana / maxf(1, max_mana), 0.0, 1.0) if mana_visible else 0.0
	casting = is_casting
	cast_ratio = clampf(progress, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var paint := material as ShaderMaterial
	if paint == null:return
	paint.set_shader_parameter("segments",segments)
	paint.set_shader_parameter("segment_gap",segment_gap)
	paint.set_shader_parameter("empty_brightness",empty_brightness)
	paint.set_shader_parameter("bar_width",maxf(0.1,bar_width))
	paint.set_shader_parameter("bar_height",maxf(0.1,bar_height))
	paint.set_shader_parameter("bar_gap",maxf(0.0,bar_gap))
	paint.set_shader_parameter("glow_radius",glow_radius)
	paint.set_shader_parameter("glow_strength",glow_strength)
	paint.set_shader_parameter("ratios",Vector3(health_ratio,mana_ratio,attack_ratio if attacking else cast_ratio))
	paint.set_shader_parameter("attacking",attacking);paint.set_shader_parameter("attack_split",attack_split)
	_update_attack_marker()
	paint.set_shader_parameter("mana_visible",mana_visible)
	paint.set_shader_parameter("casting",casting);paint.set_shader_parameter("selected",selected)
	paint.set_shader_parameter("health_color",health_color);paint.set_shader_parameter("mana_color",mana_color)
	paint.set_shader_parameter("cast_color",cast_color);paint.set_shader_parameter("track_color",track_color)
	var padding: float = ceilf(maxf(0.1,glow_radius)*3.0)+1.0
	var top: float = minf(-padding,-8.0) if selected else -padding
	var rows: int = 1 + int(mana_visible) + int(casting or attacking)
	var bottom: float = rows*bar_height+(rows-1)*bar_gap+padding
	draw_rect(Rect2(-bar_width*.5-padding,top,bar_width+padding*2,bottom-top),Color.WHITE)

func set_attack(active:bool,elapsed:float,preparation:float,recovery:float) -> void:
	# Personal-time values come from the executor; this view never advances an action.
	attacking=active and not casting
	var duration:float=maxf(0.000001,preparation+recovery)
	attack_split=clampf(preparation/duration,0.0,1.0)
	attack_ratio=clampf(elapsed/duration,0.0,1.0) if attacking else 0.0
	_update_attack_marker();queue_redraw()

func _update_attack_marker() -> void:
	attack_marker.visible=attacking
	var extent:float=12.0 if panel_mode else 6.0
	attack_marker.size=Vector2.ONE*extent
	var row:int=2 if mana_visible else 1
	attack_marker.position=Vector2((attack_split-.5)*bar_width,row*(bar_height+bar_gap)+bar_height*.5)-Vector2.ONE*extent*.5
