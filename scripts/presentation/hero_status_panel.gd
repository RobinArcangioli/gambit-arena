extends PanelContainer
## Passive value view; fixed model portraits add no runtime 3D renderers.
const Bars = preload("res://scripts/presentation/overhead_bars.gd")
const PORTRAITS = {&"mako":preload("res://assets/art/portraits/mako.png"),&"anne":preload("res://assets/art/portraits/anne.png")}
var hero_id: StringName
var portrait: TextureRect
var caption: Label
var bars: Bars
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := get_theme_stylebox("normal","Button").duplicate() as StyleBoxFlat
	style.bg_color.a=0.72 if hero_id!=&"" else 0.38;style.set_corner_radius_all(8)
	style.border_color=Color("a68349") if hero_id!=&"" else Color("605a4c")
	add_theme_stylebox_override("panel",style)
	var content:=Control.new();content.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(content)
	caption=Label.new();caption.text=String(hero_id).capitalize() if hero_id!=&"" else "Vide"
	caption.add_theme_font_size_override("font_size",16);caption.mouse_filter=Control.MOUSE_FILTER_IGNORE
	content.add_child(caption)
	if hero_id!=&"":
		portrait=TextureRect.new();portrait.texture=PORTRAITS[hero_id]
		portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.mouse_filter=Control.MOUSE_FILTER_IGNORE;content.add_child(portrait)
		bars=Bars.new();bars.apply_style(Bars.DEFAULT_STYLE,true);content.add_child(bars)
	resized.connect(_layout);_layout()
func _layout() -> void:
	if caption==null:return
	if hero_id==&"":
		caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		caption.position=Vector2(0,14);caption.size=Vector2(maxf(1,size.x-28),28)
		return
	portrait.position=Vector2(-6,-5);portrait.size=Vector2(55,61)
	caption.position=Vector2(50,-2);caption.size=Vector2(maxf(1,size.x-80),23)
	bars.bar_width=maxf(25,size.x-83);bars.position=Vector2(50+bars.bar_width*.5,25)
	bars.queue_redraw()
func show_actor(actor) -> void:
	if bars==null or not is_instance_valid(actor):return
	bars.selected=false
	bars.set_values(actor.state.health,actor.state.max_health,actor.action.mana,actor.mana_capacity,actor.action.casting(),actor.action.cast_progress())
	portrait.modulate=Color.WHITE if actor.state.alive else Color(0.5,0.5,0.5,0.75)
