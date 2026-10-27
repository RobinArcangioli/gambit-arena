extends Control
signal team_requested
const Reference = preload("res://scripts/app/hero_reference.gd")
const Router = preload("res://scripts/ui/touch_scroll_router.gd")
const Layout = preload("res://scripts/ui/hud_layout.gd")
const Art = preload("res://assets/art/ui/team.png")
const Palette = preload("res://resources/ui/night_gold.tres")
var hero_id: StringName
var reference: Dictionary
var active: bool = true
var background: TextureRect
var content: Control
var back_button: Button
var title: Label
var scroll: ScrollContainer
var column: VBoxContainer
var gambits_button: Button
var health_bar: ProgressBar
var mana_bar: ProgressBar
var skill_panels: Array[PanelContainer] = []
var touch_router := Router.new()
var safe_area_override := Rect2()

func _ready() -> void:
	theme = Palette
	reference = Reference.read(hero_id)
	background = TextureRect.new();background.texture = Art
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE;add_child(background)
	content = Control.new();content.mouse_filter = Control.MOUSE_FILTER_IGNORE;add_child(content)
	back_button = Button.new();back_button.text = "‹ Équipe";content.add_child(back_button)
	back_button.pressed.connect(func():
		if active:team_requested.emit())
	title = Label.new();title.text = reference.get("name","Héros")
	title.add_theme_font_size_override("font_size",28);content.add_child(title)
	scroll = ScrollContainer.new();scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.scroll_deadzone = 12;content.add_child(scroll)
	column = VBoxContainer.new();column.add_theme_constant_override("separation",16)
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL;scroll.add_child(column)
	if not reference.is_empty():_build_reference()
	touch_router.active_scrollers = func():return [scroll] if active and is_visible_in_tree() else []
	add_child(touch_router)
	get_viewport().size_changed.connect(_layout)
	_layout();set_active(active)

func _label(parent: Node, text: String, font_size: int = 18) -> Label:
	var label := Label.new();label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size",font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE;parent.add_child(label);return label

func _panel() -> VBoxContainer:
	var panel := PanelContainer.new()
	var style := get_theme_stylebox("normal","Button").duplicate() as StyleBoxFlat
	style.bg_color.a = 0.87
	style.content_margin_left = 18;style.content_margin_right = 18
	style.content_margin_top = 16;style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel",style);column.add_child(panel)
	var box := VBoxContainer.new();box.add_theme_constant_override("separation",12)
	panel.add_child(box);return box

func _bar(parent: Node, maximum: int, color: Color) -> ProgressBar:
	var bar := ProgressBar.new();bar.max_value = maximum;bar.value = maximum
	bar.show_percentage = false;bar.custom_minimum_size.y = 9
	var fill := StyleBoxFlat.new();fill.bg_color = color
	fill.corner_radius_top_left = 4;fill.corner_radius_top_right = 4
	fill.corner_radius_bottom_left = 4;fill.corner_radius_bottom_right = 4
	var base := fill.duplicate() as StyleBoxFlat;base.bg_color = Color(0.03,0.05,0.1,0.9)
	bar.add_theme_stylebox_override("fill",fill);bar.add_theme_stylebox_override("background",base)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE;parent.add_child(bar);return bar

func _build_reference() -> void:
	var stats := _panel()
	_label(stats,"Valeurs de référence",20)
	_label(stats,"PV maximums   %d" % reference.health,22)
	health_bar = _bar(stats,reference.health,Color(0.82,0.13,0.16))
	_label(stats,"Mana maximum   %d" % reference.mana,22)
	mana_bar = _bar(stats,reference.mana,Color(0.12,0.42,0.95))
	var grid := GridContainer.new();grid.columns = 2
	grid.add_theme_constant_override("h_separation",16);grid.add_theme_constant_override("v_separation",12);stats.add_child(grid)
	for pair in [["Attaque",str(reference.attack)],["Défense",str(reference.defense)],
		["Vitesse",Reference.number(reference.speed)],["Régénération mana",Reference.number(reference.regeneration)+" / s"]]:
		var caption := _label(grid,pair[0]);caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var value_label := _label(grid,pair[1]);value_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_label(column,"Compétences",24)
	for skill in reference.skills:
		var box := _panel();skill_panels.append(box.get_parent())
		_label(box,skill.name,22)
		_label(box,skill.description)
		_label(box,"Mana : %d   ·   Portée : %s" % [skill.cost,Reference.number(skill.reach)])
		if skill.id==&"basic":
			_label(box,"Préparation : %s s   ·   Récupération : %s s" % [Reference.number(skill.duration),Reference.number(skill.recovery)])
		else:
			_label(box,"Incantation : %s s   ·   Recharge : %s s" % [Reference.number(skill.duration),Reference.number(skill.cooldown)])
		if skill.id!=&"basic":_label(box,"Mana dépensée à la résolution du sort.",16)
	gambits_button = Button.new();gambits_button.text = "Gambits"
	gambits_button.custom_minimum_size.y = 56;gambits_button.disabled = true
	gambits_button.tooltip_text = "Bientôt disponible";column.add_child(gambits_button)

func _layout() -> void:
	if background == null:return
	var view: Rect2 = get_viewport_rect();background.size = view.size
	var candidate: Rect2 = safe_area_override
	if not candidate.has_area() and OS.get_name()=="Android":candidate = get_viewport().get_screen_transform().affine_inverse()*Rect2(DisplayServer.get_display_safe_area())
	var safe: Rect2 = Layout.usable_rect(view,candidate)
	content.position = safe.position;content.size = safe.size
	back_button.position = Vector2(16,16);back_button.size = Vector2(116,48)
	title.position = Vector2(148,20);title.size = Vector2(safe.size.x-164,44)
	scroll.position = Vector2(24,86);scroll.size = Vector2(safe.size.x-48,maxf(1,safe.size.y-110))
	touch_router.cancel_gesture()

func set_active(enabled: bool) -> void:
	active = enabled
	if not enabled:touch_router.cancel_gesture()
	if back_button != null:back_button.disabled = not enabled
