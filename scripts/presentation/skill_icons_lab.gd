extends "res://scripts/app/arena_page.gd"
## Isolated visual choices. Real references/orders and value snapshots, no player saves.
const BuffCatalog = preload("res://scripts/buffs/buff_catalog.gd")
const HeroSheet = preload("res://scenes/app/hero_page.tscn")
const GambitsSheet = preload("res://scenes/app/gambits_page.tscn")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
var trials: Array[Resource] = []
var selected: int = 0
var lab_panel: PanelContainer
var caption: Label
var page: Control
var active_tab: String = "Combat"
var show_booster: bool = false
var preview_hero: StringName = &"mako"
var context_button: Button
func _ready() -> void:
	infinite_mode=true;save_path="user://icons001-lab.json"
	theme=preload("res://resources/ui/night_gold.tres")
	for i in range(3):
		var profile:Resource=HeroPanel.Icons.DEFAULT_STYLE.duplicate()
		profile.cast_size=[16,20,24][i];profile.buff_size=[14,18,22][i]
		profile.reference_size=[40,48,56][i];profile.picker_size=[16,20,24][i]
		profile.panel_height=106;trials.append(profile)
	icon_style=trials[selected]
	Codec.save(save_path,Orders.defaults())
	super._ready();set_physics_process(false)
	lab_panel=PanelContainer.new();add_child(lab_panel)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182ff5");paint.border_color=Color("d9a64c")
	paint.set_border_width_all(1);paint.set_content_margin_all(10);lab_panel.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",6);lab_panel.add_child(column)
	caption=_label(column,14)
	var profiles:=HBoxContainer.new();column.add_child(profiles)
	for i in range(3):_button(profiles,["A · Discret","B · Équilibré","C · Lisible"][i],choose_trial.bind(i))
	var tabs:=HBoxContainer.new();column.add_child(tabs)
	for tab in ["Combat","Fiche","Gambits"]:_button(tabs,tab,show_tab.bind(tab))
	context_button=_button(tabs,"Sort Mako",context_action)
	_snapshot();choose_trial(0)
func _snapshot() -> void:
	simulation.reset();simulation.rules={"mako":[],"anne":[]};action_presenter.reset_run(simulation.run_id)
	var mako=simulation.hero(&"mako");var anne=simulation.hero(&"anne")
	mako.state.damage(50);anne.state.damage(65)
	mako.action.mana=42;anne.action.mana=38
	mako.buffs.apply(BuffCatalog.definition(&"booster"));mako.buffs.advance(15.0)
	anne.action.request(&"heal",anne);anne.action.elapsed=.45
	mako.action.request(&"booster" if show_booster else &"lightning",anne if show_booster else simulation.enemies[3]);mako.action.elapsed=.7
	super._physics_process(0);_present()
func cycle_spell() -> void:
	if paused or application_guard.blocked:return
	show_booster=not show_booster;_snapshot()
func choose_trial(index: int) -> void:
	if paused or application_guard.blocked:return
	selected=clampi(index,0,2);icon_style=trials[selected]
	for panel in hero_panels:panel.apply_icon_style(icon_style)
	_update_layout();_present();_refresh_caption()
	if page!=null:show_tab(active_tab)
func _refresh_caption() -> void:
	if caption!=null:caption.text="%s · Incantation %d px · Buffs %d px · %s"%[["A","B","C"][selected],icon_style.cast_size,icon_style.buff_size,active_tab]
func show_tab(tab: String) -> void:
	if paused or application_guard.blocked:return
	if page!=null:
		remove_child(page);page.queue_free();page=null
	active_tab=tab
	if tab!="Combat":
		page=(HeroSheet if tab=="Fiche" else GambitsSheet).instantiate()
		page.hero_id=preview_hero;page.icon_style=icon_style
		if tab=="Gambits":page.save_path=save_path;page.hero_requested.connect(show_tab.bind("Combat"))
		else:page.team_requested.connect(show_tab.bind("Combat"));page.gambits_requested.connect(show_tab.bind("Gambits"))
		add_child(page);move_child(page,lab_panel.get_index())
	context_button.text="Sort Mako" if tab=="Combat" else "Mako ↔ Anne"
	_refresh_caption();_update_layout()
	if tab=="Fiche":call_deferred("_scroll_skills")
func _update_layout() -> void:
	super._update_layout()
	if lab_panel!=null:
		lab_panel.position=Vector2(12,80 if active_tab=="Combat" else get_viewport_rect().size.y-164);lab_panel.size=Vector2(get_viewport_rect().size.x-24,150)
	if page!=null and page.scroll!=null:
		page.scroll.size.y=maxf(60,lab_panel.position.y-page.scroll.get_global_rect().position.y-12)

func context_action() -> void:
	if active_tab=="Combat":cycle_spell()
	else:
		preview_hero=&"anne" if preview_hero==&"mako" else &"mako"
		show_tab(active_tab)
func _scroll_skills() -> void:
	await get_tree().process_frame
	if active_tab=="Fiche" and is_instance_valid(page):page.scroll.scroll_vertical=300
