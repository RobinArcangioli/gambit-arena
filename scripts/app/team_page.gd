extends Control
signal home_requested
signal hero_selected(hero_id: StringName)
const Roster = preload("res://scripts/app/team_roster.gd")
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
	for id in Roster.SLOTS:
		var card := Button.new();card.toggle_mode = false
		card.focus_mode = Control.FOCUS_ALL if id!=&"" else Control.FOCUS_NONE
		card.disabled = id==&""
		content.add_child(card);cards.append(card)
		# Inherit the common palette; adapt only the opacity for broad portrait cards.
		for state in ["normal","hover","pressed","focus","disabled"]:
			var style := card.get_theme_stylebox(state).duplicate() as StyleBoxFlat
			style.bg_color.a = 0.45 if id==&"" else 0.76
			card.add_theme_stylebox_override(state,style)
		var name_label := Label.new();name_label.text = Roster.caption(id)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size",22)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(name_label);names.append(name_label)
		if id!=&"":
			var portrait := Portrait.new();portrait.definition = Roster.APPEARANCES[id]
			portrait.ground_radius = Body.RADIUS;card.add_child(portrait);portraits.append(portrait)
			card.pressed.connect(_select.bind(id))
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
		if i<2:
			names[i].position = Vector2(10,14);names[i].size = Vector2(width-20,34)
			portraits[i].position = Vector2(8,52);portraits[i].size = Vector2(width-16,maxf(1,height-64))
		else:
			names[i].position = Vector2(10,(height-40)*0.5);names[i].size = Vector2(width-20,40)

func set_active(enabled: bool) -> void:
	if active != enabled:discard_next_step = true
	active = enabled
	if enabled:
		for card in cards:card.release_focus()
	for portrait in portraits:portrait.set_active(enabled)
	for i in range(cards.size()):cards[i].disabled = not enabled or Roster.SLOTS[i]==&""
	if back_button != null:back_button.disabled = not enabled

func _process(delta: float) -> void:
	if not active or not is_visible_in_tree() or not is_finite(delta) or delta<=0:return
	if discard_next_step:discard_next_step=false;return
	var dt: float = minf(delta,1.0/30.0)
	visual_time += dt
	for portrait in portraits:portrait.advance_visual(dt)
