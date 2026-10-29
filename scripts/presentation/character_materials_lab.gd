extends Control
## Four genuine animated models and the product arena, with isolated preferences.
const Portrait = preload("res://scripts/presentation/hero_portrait.gd")
const View = preload("res://scripts/presentation/character_view.gd")
const Arena = preload("res://scenes/app/arena_page.tscn")
const Profile = preload("res://scripts/presentation/character_surface_profile.gd")
const PRESETS = [
	preload("res://resources/presentation/surfaces/painted_contrast.tres"),
	preload("res://resources/presentation/surfaces/contrast_shadows.tres"),
	preload("res://resources/presentation/surfaces/contrast_illustrated.tres"),
	preload("res://resources/presentation/surfaces/contrast_moonlight.tres")
]
const DEFINITIONS = [
	preload("res://resources/presentation/characters/mako.tres"),
	preload("res://resources/presentation/characters/anne.tres"),
	preload("res://resources/presentation/characters/skeleton.tres"),
	preload("res://resources/presentation/characters/skeleton_variant.tres")
]
var profiles: Array[Resource] = []
var selected: int = 0
var portraits: Array = []
var stage: Control
var models: GridContainer
var combat: Control
var caption: Label
var walking: bool = false
var dark_arena: bool = true

func _ready() -> void:
	get_window().title="Gambit Arena · Variantes du peint contrasté"
	theme=preload("res://resources/ui/night_gold.tres")
	profiles.assign(PRESETS)
	var original:=Profile.new();original.display_name="Original";original.use_imported_materials=true
	original.ambient_color=Color.WHITE;original.ambient_energy=.65
	original.light_color=Color.WHITE;original.light_energy=.9;profiles.append(original)
	var background:=TextureRect.new();background.texture=preload("res://assets/art/ui/team.png")
	background.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;background.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(background)
	var shade:=ColorRect.new();shade.color=Color(0,0,0,.35)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(shade)
	var margin:=MarginContainer.new();margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left","right","top","bottom"]:margin.add_theme_constant_override("margin_"+side,12)
	add_child(margin)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",8);margin.add_child(column)
	var title:=Label.new();title.text="PEINT CONTRASTÉ · VARIANTES";title.add_theme_font_size_override("font_size",20);column.add_child(title)
	var choice:=HBoxContainer.new();column.add_child(choice)
	for i in range(profiles.size()):
		var button:=Button.new();button.text=["C · Réf.","C1 · Ombres","C2 · Illustré","C3 · Lunaire","Original"][i]
		button.size_flags_horizontal=Control.SIZE_EXPAND_FILL;button.custom_minimum_size.y=44
		button.add_theme_font_size_override("font_size",12);choice.add_child(button);button.pressed.connect(choose.bind(i))
	var navigation:=HBoxContainer.new();column.add_child(navigation)
	for item in ["Modèles","Combat","Idle / Marche","Clair / Sombre"]:
		var button:=Button.new();button.text=item;button.add_theme_font_size_override("font_size",13)
		button.custom_minimum_size.y=40;button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		navigation.add_child(button);button.pressed.connect(navigate.bind(item))
	caption=Label.new();caption.add_theme_font_size_override("font_size",14);column.add_child(caption)
	stage=Control.new();stage.size_flags_vertical=Control.SIZE_EXPAND_FILL;column.add_child(stage)
	models=GridContainer.new();models.columns=2;models.add_theme_constant_override("h_separation",8);models.add_theme_constant_override("v_separation",8)
	models.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);stage.add_child(models)
	for definition in DEFINITIONS:
		var card:=PanelContainer.new();card.size_flags_horizontal=Control.SIZE_EXPAND_FILL;card.size_flags_vertical=Control.SIZE_EXPAND_FILL;models.add_child(card)
		var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182fbe");paint.border_color=Color("ba934b")
		paint.set_border_width_all(1);paint.set_content_margin_all(8);card.add_theme_stylebox_override("panel",paint)
		var stack:=VBoxContainer.new();card.add_child(stack)
		var name_label:=Label.new();name_label.text=definition.display_name;stack.add_child(name_label)
		var portrait:=Portrait.new();portrait.definition=definition;portrait.custom_minimum_size=Vector2(120,180)
		portrait.size_flags_vertical=Control.SIZE_EXPAND_FILL;stack.add_child(portrait);portraits.append(portrait)
	models.resized.connect(_fit_cards)
	call_deferred("_fit_cards");choose(0)

func _fit_cards() -> void:
	for card in models.get_children():card.custom_minimum_size.y=maxf(180,(models.size.y-8)*.5)

func choose(index: int) -> void:
	selected=clampi(index,0,profiles.size()-1)
	caption.text=profiles[selected].display_name+" · textures d’origine"
	for portrait in portraits:
		portrait.character.apply_surface_profile(profiles[selected])
		profiles[selected].apply_lighting(portrait.character.get_parent())
	if is_instance_valid(combat):_apply_combat()
	print("MATERIALS_PREVIEW "+profiles[selected].display_name)

func _apply_combat() -> void:
	profiles[selected].apply_lighting(combat.world)
	for view in combat.world.find_children("*","Node3D",true,false):
		if view is View and view.surface_profile!=profiles[selected]:view.apply_surface_profile(profiles[selected])

func navigate(item: String) -> void:
	if item=="Modèles":
		models.show()
		if is_instance_valid(combat):combat.hide();combat.set_process(false);combat.set_physics_process(false)
	elif item=="Combat":
		models.hide()
		if not is_instance_valid(combat):
			combat=Arena.instantiate();combat.infinite_mode=true;combat.save_path="";combat.settings_path=""
			combat.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);stage.add_child(combat)
		combat.show();combat.set_process(true);combat.set_physics_process(true);_apply_combat()
	elif item=="Idle / Marche":
		walking=not walking
		for portrait in portraits:portrait.character.pose(0,walking,Vector2.DOWN)
	elif item=="Clair / Sombre":
		dark_arena=not dark_arena
		if is_instance_valid(combat):
			combat.arena_definition=combat.Catalog.definition(&"arcane_bleu_sombre" if dark_arena else &"lumiere_angelique")
			combat.floor_canvas.set_definition(combat.arena_definition);combat._sync_projection()

func _process(delta: float) -> void:
	for portrait in portraits:
		portrait.set_active(models.visible)
		if models.visible:portrait.advance_visual(delta)
	# New enemies inherit the selected trial too, including after a wave restart.
	if is_instance_valid(combat) and combat.visible:_apply_combat()
