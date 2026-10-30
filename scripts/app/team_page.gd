extends Control
signal home_requested
signal hero_selected(hero_id: StringName)
const Roster = preload("res://scripts/app/team_roster.gd")
const Illustration = preload("res://scripts/presentation/hero_illustration.gd")
const Portrait = preload("res://scripts/presentation/hero_portrait.gd")
const Body = preload("res://scripts/crowd/ground_crowd.gd")
const Layout = preload("res://scripts/ui/hud_layout.gd")
const Art = preload("res://assets/art/ui/team.png")
const ThemeResource = preload("res://resources/ui/night_gold.tres")
var background: TextureRect
var content: Control
var back_button: Button
var title: Label
var cards: Array[Button] = []
var names: Array[Label] = []
var portraits: Array[Portrait] = []
var illustrations:Array[Illustration]=[]
var idle_frames:Array[PanelContainer]=[]
var team_slots:Array[StringName]=Roster.SLOTS.duplicate()
var slot_views:Dictionary={}
var empty_frames:Dictionary={}
var active: bool = true
var discard_next_step: bool = true
var visual_time: float = 0
var safe_area_override := Rect2()

func _ready() -> void:
	theme = ThemeResource
	background = TextureRect.new();background.texture = Art
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE;add_child(background)
	content = Control.new();content.mouse_filter = Control.MOUSE_FILTER_IGNORE;add_child(content)
	back_button = Button.new();back_button.text = "‹ Accueil";content.add_child(back_button)
	back_button.pressed.connect(func():
		if active:home_requested.emit())
	title = _label("Équipe",28)
	for slot in range(team_slots.size()):
		var id:StringName=team_slots[slot]
		var card := Button.new();card.toggle_mode = false
		card.focus_mode = Control.FOCUS_ALL if id!=&"" else Control.FOCUS_NONE
		card.disabled = id==&""
		content.add_child(card);cards.append(card)
		# The illustration owns the thin rectangular frame, as in the approved cards.
		# Never add a second rounded Button panel behind or around it.
		for state in ["normal","hover","pressed","focus","disabled"]:
			card.add_theme_stylebox_override(state,StyleBoxEmpty.new())
		var name_label := Label.new();name_label.text = Roster.caption(id)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size",22)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(name_label);names.append(name_label)
		if id!=&"":
			var illustration:=Illustration.new();illustration.hero_id=id
			card.add_child(illustration);illustrations.append(illustration)
			var frame:=PanelContainer.new();frame.mouse_filter=Control.MOUSE_FILTER_IGNORE
			var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182fed");paint.border_color=Color("a68349")
			paint.set_border_width_all(1);paint.set_corner_radius_all(6);paint.set_content_margin_all(2)
			paint.shadow_color=Color(0,0,0,.45);paint.shadow_size=4
			frame.add_theme_stylebox_override("panel",paint);card.add_child(frame);idle_frames.append(frame)
			var window:=Control.new();window.mouse_filter=Control.MOUSE_FILTER_IGNORE;window.clip_contents=true;frame.add_child(window)
			var portrait := Portrait.new();portrait.definition = Roster.APPEARANCES[id]
			portrait.ground_radius = Body.RADIUS;window.add_child(portrait);portraits.append(portrait)
			slot_views[slot]={"illustration":illustration,"frame":frame,"portrait":portrait}
			card.move_child(name_label,-1)
			var name_paint:=StyleBoxFlat.new();name_paint.bg_color=Color("10182fcf");name_paint.set_corner_radius_all(4)
			name_label.add_theme_stylebox_override("normal",name_paint);name_label.add_theme_color_override("font_color",Color("ffd16a"))
			card.pressed.connect(_select.bind(id))
		else:
			var empty:=PanelContainer.new();empty.mouse_filter=Control.MOUSE_FILTER_IGNORE
			var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182fcf")
			paint.border_color=Color("a68349");paint.set_border_width_all(1)
			empty.add_theme_stylebox_override("panel",paint);card.add_child(empty)
			card.move_child(name_label,-1);empty_frames[slot]=empty
	get_viewport().size_changed.connect(_layout)
	_layout();set_active(active)

func _label(text: String, font_size: int) -> Label:
	var label := Label.new();label.text = text;label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size",font_size);content.add_child(label);return label

func _select(id: StringName) -> void:
	if not active or not Roster.PROFILES.has(id):return
	hero_selected.emit(id)

func _layout() -> void:
	if background == null:return
	var view: Rect2 = get_viewport_rect();background.size = view.size
	var candidate: Rect2 = safe_area_override
	if not candidate.has_area() and OS.get_name()=="Android":candidate = get_viewport().get_screen_transform().affine_inverse()*Rect2(DisplayServer.get_display_safe_area())
	var safe: Rect2 = Layout.usable_rect(view,candidate)
	content.position = safe.position;content.size = safe.size
	back_button.position = Vector2(16,16);back_button.size = Vector2(116,48)
	title.position = Vector2(148,20);title.size = Vector2(safe.size.x-164,44)
	var gap: float = 14
	var width: float = (safe.size.x-48-gap)*0.5
	var height: float = minf(340,(safe.size.y-180-gap)*0.5)
	var top: float = 94 + maxf(0,(safe.size.y-180-gap-height*2)*0.28)
	for i in range(4):
		cards[i].position = Vector2(24+(i%2)*(width+gap),top+int(i/2.0)*(height+gap))
		cards[i].size = Vector2(width,height)
		if slot_views.has(i):
			var illustration:Control=slot_views[i].illustration
			var idle_frame:Control=slot_views[i].frame
			var portrait:Portrait=slot_views[i].portrait
			illustration.position=Vector2.ZERO;illustration.size=Vector2(width-12,height-12)
			names[i].position=Vector2(10,10);names[i].size=Vector2(width-32,32)
			var original_size:=Vector2(clampf(width*.4,64,96),clampf(height*.36,88,132))
			var idle_size:Vector2=(original_size*Vector2(.74,.72)).ceil()
			idle_frame.position=Vector2(width,height)-idle_size;idle_frame.size=idle_size
			# Crop the former viewport, preserving its projection and on-screen model size.
			portrait.size=original_size-Vector2.ONE*6
			portrait.position=(idle_size-Vector2.ONE*4-portrait.size)*.5-Vector2(0,original_size.y*portrait.definition.team_idle_vertical_bias)
		else:
			empty_frames[i].position=Vector2.ZERO;empty_frames[i].size=Vector2(width-12,height-12)
			names[i].position = Vector2(10,(height-12-40)*0.5);names[i].size = Vector2(width-32,40)

func set_active(enabled: bool) -> void:
	if active != enabled:discard_next_step = true
	active = enabled
	if enabled:
		for card in cards:card.release_focus()
	for portrait in portraits:portrait.set_active(enabled)
	for i in range(cards.size()):cards[i].disabled = not enabled or team_slots[i]==&""
	if back_button != null:back_button.disabled = not enabled

func _process(delta: float) -> void:
	if not active or not is_visible_in_tree() or not is_finite(delta) or delta<=0:return
	if discard_next_step:discard_next_step=false;return
	var dt: float = minf(delta,1.0/30.0)
	visual_time += dt
	for portrait in portraits:portrait.advance_visual(dt)
