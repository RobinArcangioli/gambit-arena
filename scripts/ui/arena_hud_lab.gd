extends "res://scripts/app/arena_page.gd"
## Graphic choices only; no player files and no automatic combat progression.
const MENU_ICONS=[preload("res://assets/ui/combat_menu_lines.svg"),preload("res://assets/ui/combat_menu_dots.svg"),preload("res://assets/ui/combat_menu_diamonds.svg")]
const BuffCatalog=preload("res://scripts/buffs/buff_catalog.gd")
var choices_panel:VBoxContainer
var menu_choice:int=0
var separator_choice:int=1
var menu_choices:Array[Button]=[]
var separator_choices:Array[Button]=[]
func _ready() -> void:
	infinite_mode=true;save_path="";settings_path=""
	chooser=func():return &"colisee_solaire"
	super._ready();set_physics_process(false)
	get_window().title="Gambit Arena · HUD · Icônes et séparateurs"
	var column:=VBoxContainer.new();choices_panel=column;column.position=Vector2(16,84);column.size.x=get_viewport_rect().size.x-32;column.z_index=40
	column.add_theme_constant_override("separation",5);add_child(column)
	for category in range(2):
		var title:=Label.new();title.text="Icône du menu" if category==0 else "Séparation des héros"
		title.add_theme_font_size_override("font_size",12);title.add_theme_color_override("font_color",Color("ffd16a"));column.add_child(title)
		var row:=HBoxContainer.new();row.add_theme_constant_override("separation",6);column.add_child(row)
		for i in range(3):
			var button:=Button.new();button.custom_minimum_size=Vector2(128,36);button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
			button.add_theme_font_size_override("font_size",12);button.toggle_mode=true;row.add_child(button)
			if category==0:
				button.text=["A · Traits","B · Points","C · Losanges"][i];button.icon=MENU_ICONS[i]
				button.pressed.connect(choose_menu.bind(i));menu_choices.append(button)
			else:
				button.text=["A · Filets fondus","B · Losange or","C · Bleu et or"][i]
				button.pressed.connect(choose_separator.bind(i));separator_choices.append(button)
	var mako=simulation.hero(&"mako");var anne=simulation.hero(&"anne");var nassau=simulation.hero(&"nassau")
	mako.state.damage(55);anne.state.damage(35);nassau.state.damage(40)
	mako.action.mana=42;anne.action.mana=38;nassau.action.mana=32
	mako.buffs.apply(BuffCatalog.definition(&"booster"));mako.buffs.advance(15)
	anne.action.request(&"heal",anne);anne.action.elapsed=.55
	nassau.action.request(&"booster",anne);nassau.action.elapsed=.7
	simulation.wave_number=7
	choose_menu(0);choose_separator(1);_present()
func choose_menu(index:int) -> void:
	menu_choice=index
	var profile:Resource=hud_style.duplicate();profile.menu_icon=MENU_ICONS[index];apply_hud_style(profile)
	for i in range(menu_choices.size()):menu_choices[i].set_pressed_no_signal(i==index)
func choose_separator(index:int) -> void:
	separator_choice=index
	var profile:Resource=hud_style.duplicate();profile.separator=index;apply_hud_style(profile)
	for i in range(separator_choices.size()):separator_choices[i].set_pressed_no_signal(i==index)
