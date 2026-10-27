extends PanelContainer
## Passive value view; fixed model portraits add no runtime 3D renderers.
const Bars = preload("res://scripts/presentation/overhead_bars.gd")
const PORTRAITS = {&"mako":preload("res://assets/art/portraits/mako.png"),&"anne":preload("res://assets/art/portraits/anne.png")}
var hero_id: StringName
var portrait: TextureRect
var caption: Label
var bars: Bars
var health_text: Label
var mana_text: Label
var cast_text: Label
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
		for key in ["health","mana","cast"]:
			var value:=Label.new();value.mouse_filter=Control.MOUSE_FILTER_IGNORE
			value.add_theme_color_override("font_color",Color.WHITE)
			value.add_theme_color_override("font_shadow_color",Color(0.01,0.02,0.04,0.9))
			value.add_theme_constant_override("shadow_offset_y",1)
			value.clip_text=true;content.add_child(value)
			if key=="health":health_text=value
			elif key=="mana":mana_text=value
			else:cast_text=value;value.hide()
	resized.connect(_layout);_layout()
func _layout() -> void:
	if caption==null:return
	if hero_id==&"":
		caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		caption.position=Vector2(0,14);caption.size=Vector2(maxf(1,size.x-28),28)
		return
	portrait.position=Vector2(-6,-5);portrait.size=Vector2(55,61)
	caption.position=Vector2(50,-2);caption.size=Vector2(maxf(1,size.x-80),23)
	bars.bar_width=maxf(25,size.x-83);bars.position=Vector2(50+bars.bar_width*.5,36)
	var row_pitch:float=bars.bar_height+bars.bar_gap
	for i in range(3):
		var text:Label=[health_text,mana_text,cast_text][i]
		text.add_theme_font_size_override("font_size",9 if bars.bar_width<100 else 11)
		text.position=Vector2(50,18+i*row_pitch);text.size=Vector2(bars.bar_width,14)
	bars.queue_redraw()
func show_actor(actor) -> void:
	if bars==null or not is_instance_valid(actor):return
	bars.selected=false
	bars.set_values(actor.state.health,actor.state.max_health,actor.action.mana,actor.mana_capacity,actor.action.casting(),actor.action.cast_progress())
	health_text.text="%d / %d"%[actor.state.health,actor.state.max_health]
	mana_text.text="%d / %d"%[floori(actor.action.mana),actor.mana_capacity]
	cast_text.visible=actor.action.casting()
	if cast_text.visible:
		var names:Dictionary={&"heal":"Soin",&"lightning":"Foudre",&"booster":"Booster"}
		var local_left:float=maxf(0,actor.action.cast_duration(actor.action.last_skill)-actor.action.elapsed)
		var seconds:float=remaining_cast_seconds(local_left,actor.buffs.snapshot())
		cast_text.text="%s : %ss"%[names.get(actor.action.last_skill,String(actor.action.last_skill)),("%.1f"%(ceilf(seconds*10-0.000001)/10)).replace(".",",")]
	portrait.modulate=Color.WHITE if actor.state.alive else Color(0.5,0.5,0.5,0.75)

static func remaining_cast_seconds(personal_left: float, statuses: Dictionary) -> float:
	# Invert the copied personal-clock segments; a buff can expire before the release.
	var boundaries:Array[float]=[]
	for effect in statuses.values():boundaries.append(float(effect.remaining))
	boundaries.sort()
	var elapsed:float=0.0
	var left:float=maxf(0,personal_left)
	for boundary in boundaries:
		var rate:float=1.0
		for effect in statuses.values():
			if float(effect.remaining)>elapsed+0.000000001:rate*=float(effect.time_multiplier)
		var duration:float=maxf(0,boundary-elapsed)
		if left<=duration*rate:return elapsed+left/rate
		left-=duration*rate;elapsed=boundary
	return elapsed+left
