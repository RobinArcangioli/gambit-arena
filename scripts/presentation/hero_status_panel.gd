extends PanelContainer
## Passive value view: illustrated portrait gutter and a bottom row of active buffs.
const Illustration=preload("res://scripts/presentation/hero_illustration.gd")
var portrait:Illustration
const Icons = preload("res://scripts/presentation/skill_icons.gd")
var icon_style: Resource = Icons.DEFAULT_STYLE
var cast_icon: TextureRect
var buff_tray: Control
var buff_row: HBoxContainer
var buff_icons: Dictionary = {}
const Bars = preload("res://scripts/presentation/overhead_bars.gd")
var hero_id: StringName
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
		portrait=Illustration.new();portrait.hero_id=hero_id;portrait.close_up=true;content.add_child(portrait)
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
		cast_icon=Icons.rect(&"",icon_style.cast_size);content.add_child(cast_icon);cast_icon.hide()
		buff_tray=Control.new();buff_tray.mouse_filter=Control.MOUSE_FILTER_IGNORE
		buff_tray.clip_contents=true;content.add_child(buff_tray)
		buff_row=HBoxContainer.new();buff_row.mouse_filter=Control.MOUSE_FILTER_IGNORE
		buff_row.add_theme_constant_override("separation",4);buff_row.clip_contents=true;buff_tray.add_child(buff_row)
	resized.connect(_layout);_layout()
func _layout() -> void:
	if caption==null:return
	if hero_id==&"":
		caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		caption.position=Vector2(0,14);caption.size=Vector2(maxf(1,size.x-28),28)
		return
	caption.position=Vector2(50,-6);caption.size=Vector2(maxf(1,size.x-80),23)
	bars.bar_width=maxf(25,size.x-83);bars.position=Vector2(50+bars.bar_width*.5,32)
	var row_pitch:float=bars.bar_height+bars.bar_gap
	for i in range(3):
		var text:Label=[health_text,mana_text,cast_text][i]
		text.add_theme_font_size_override("font_size",9 if bars.bar_width<100 else 11)
		text.position=Vector2(50,14+i*row_pitch);text.size=Vector2(bars.bar_width,14)
	var cast_y:float=bars.position.y+2*row_pitch+bars.bar_height*.5
	cast_icon.custom_minimum_size=Vector2.ONE*icon_style.cast_size;cast_icon.size=cast_icon.custom_minimum_size
	cast_icon.position=Vector2(50+bars.bar_width-icon_style.cast_size,cast_y-icon_style.cast_size*.5)
	cast_text.size.x=bars.bar_width if bars.attacking else maxf(1,bars.bar_width-icon_style.cast_size-4)
	portrait.position=Vector2.ZERO;portrait.size=Vector2(42,76)
	buff_tray.position=Vector2(0,80);buff_tray.size=Vector2(maxf(1,size.x-28),icon_style.buff_size)
	buff_row.position=Vector2.ZERO
	buff_row.size=buff_tray.size
	for icon in buff_icons.values():
		icon.custom_minimum_size=Vector2.ONE*icon_style.buff_size;icon.size=icon.custom_minimum_size
	bars.queue_redraw()
func show_actor(actor) -> void:
	if bars==null or not is_instance_valid(actor):return
	bars.selected=false
	bars.set_values(actor.state.health,actor.state.max_health,actor.action.mana,actor.mana_capacity,actor.action.casting(),actor.action.cast_progress())
	bars.set_attack(actor.action.active and actor.action.last_skill==&"basic",actor.action.elapsed,actor.action._windup(),actor.action._recovery())
	health_text.text="%d / %d"%[actor.state.health,actor.state.max_health]
	mana_text.text="%d / %d"%[floori(actor.action.mana),actor.mana_capacity]
	cast_text.visible=actor.action.casting() or bars.attacking
	cast_icon.texture=Icons.texture(actor.action.last_skill)
	cast_icon.visible=actor.action.casting() and cast_icon.texture!=null
	var statuses:Dictionary=actor.buffs.snapshot()
	for id in buff_icons.keys():
		if not statuses.has(id):
			var icon:TextureRect=buff_icons[id];buff_row.remove_child(icon);icon.queue_free();buff_icons.erase(id)
	for id in statuses:
		if Icons.texture(id)==null:continue
		if not buff_icons.has(id):
			var icon:TextureRect=Icons.rect(id,icon_style.buff_size);icon.size_flags_horizontal=Control.SIZE_SHRINK_BEGIN;buff_row.add_child(icon);buff_icons[id]=icon
		buff_icons[id].tooltip_text="%s · %d s"%[String(id).capitalize(),ceili(statuses[id].remaining)]
	buff_row.visible=not buff_icons.is_empty()
	if bars.attacking:
		var phase_left:float=maxf(0,(actor.action._windup()+actor.action._recovery() if actor.action.resolved else actor.action._windup())-actor.action.elapsed)
		var attack_seconds:float=remaining_cast_seconds(phase_left,actor.buffs.snapshot())
		cast_text.text="%s : %ss"%["Récup." if actor.action.resolved else "Attaque",("%.1f"%(ceilf(attack_seconds*10-0.000001)/10)).replace(".",",")]
	elif cast_text.visible:
		var names:Dictionary={&"heal":"Soin",&"lightning":"Foudre",&"booster":"Booster"}
		var local_left:float=maxf(0,actor.action.cast_duration(actor.action.last_skill)-actor.action.elapsed)
		var seconds:float=remaining_cast_seconds(local_left,actor.buffs.snapshot())
		cast_text.text="%s : %ss"%[names.get(actor.action.last_skill,String(actor.action.last_skill)),("%.1f"%(ceilf(seconds*10-0.000001)/10)).replace(".",",")]
	caption.modulate=Color.WHITE if actor.state.alive else Color(0.5,0.5,0.5,0.75)

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

func apply_icon_style(profile: Resource) -> void:
	icon_style=profile
	if is_node_ready():_layout()
