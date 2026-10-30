extends Control
## Comparison uses real product pages in their own portrait viewport; no player files.
const App=preload("res://scenes/app/app_root.tscn")
const PROFILES=[preload("res://resources/ui/styles/trial_berserk.tres"),preload("res://resources/ui/styles/trial_dusk.tres"),preload("res://resources/ui/styles/trial_blood.tres"),preload("res://resources/ui/styles/trial_copper.tres")]
const Catalog=preload("res://scripts/presentation/arena_catalog.gd")
const BuffCatalog=preload("res://scripts/buffs/buff_catalog.gd")
const ARENAS=[&"ombres_beherit",&"ville_alexandrie",&"colisee_solaire"]
var holder:SubViewportContainer
var portrait_view:SubViewport
var sidebar:PanelContainer
var app:Control
var selected:int=0
var screen:StringName=&"arena"
var arena_index:int=0
var building:bool=false
var playing:bool=false
var choices:Array[Button]=[]
var title:Label
var arena_button:Button
func _ready() -> void:
	get_window().content_scale_size=Vector2i(900,960);get_window().size=Vector2i(900,960)
	get_window().title="Gambit Arena · Quatre palettes · Arène et menus"
	holder=SubViewportContainer.new();holder.size=Vector2(540,960);add_child(holder)
	portrait_view=SubViewport.new();portrait_view.size=Vector2i(540,960);portrait_view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;holder.add_child(portrait_view)
	sidebar=PanelContainer.new();sidebar.theme=preload("res://resources/ui/night_gold.tres");add_child(sidebar)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("111017");paint.set_content_margin_all(14);sidebar.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",8);sidebar.add_child(column)
	title=_label(column,"Quatre palettes",22)
	_label(column,"Même interface, mêmes valeurs.\nLe panneau de droite sert au comparatif.",14)
	var group:=ButtonGroup.new()
	for i in range(4):
		var button:=Button.new();button.text=["A · Berserk actuel","B · Crépuscule","C · Rouge et noir","D · Obsidienne cuivrée"][i]
		button.custom_minimum_size.y=46;button.add_theme_font_size_override("font_size",15);button.toggle_mode=true;button.button_group=group;column.add_child(button)
		button.pressed.connect(choose.bind(i));choices.append(button)
	_label(column,"Pages et fenêtres",17)
	for item in [["Arène",&"arena"],["Réglages de combat",&"settings"],["Statistiques",&"statistics"],["Journal de combat",&"journal"],["Menu / pause",&"menu"],["Accueil",&"home"],["Équipe",&"team"],["Fiche",&"hero"],["Gambits",&"gambits"]]:
		var button:=Button.new();button.text=item[0];button.add_theme_font_size_override("font_size",14);button.custom_minimum_size.y=34;column.add_child(button)
		button.pressed.connect(show_screen.bind(item[1]))
	arena_button=Button.new();arena_button.text="Décor : Ombres";arena_button.custom_minimum_size.y=38;column.add_child(arena_button);arena_button.pressed.connect(cycle_arena)
	var animate:=Button.new();animate.text="Animer / figer le combat";animate.custom_minimum_size.y=38;animate.add_theme_font_size_override("font_size",14);column.add_child(animate)
	animate.pressed.connect(func():
		playing=not playing
		if app!=null and app.combat!=null:app.combat.set_physics_process(playing))
	get_viewport().size_changed.connect(_layout);_layout();choose(0)
func _label(parent:Node,text:String,font_size:int) -> Label:
	var label:=Label.new();label.text=text;label.add_theme_font_size_override("font_size",font_size);parent.add_child(label);return label
func _layout() -> void:
	var view:Vector2=get_viewport_rect().size
	var zoom:float=maxf(.2,minf((view.x-330)/540,view.y/960))
	holder.scale=Vector2.ONE*zoom
	sidebar.position=Vector2(540*zoom+12,12);sidebar.size=Vector2(view.x-sidebar.position.x-12,view.y-24)
func current_screen() -> StringName:
	if app==null:return screen
	if app.combat!=null:
		if app.combat.pause_layer.visible:return &"menu"
		if app.combat.settings_menu.visible:return &"settings"
		if app.combat.statistics_menu.visible:return &"journal" if app.combat.statistics_menu.journal_mode else &"statistics"
		return &"arena"
	return app.route
func choose(index:int) -> void:
	if building:return
	screen=current_screen();selected=index;await _rebuild()
func show_screen(value:StringName) -> void:
	if building:return
	screen=value;await _rebuild()
func cycle_arena() -> void:
	if building:return
	screen=current_screen();arena_index=(arena_index+1)%ARENAS.size()
	arena_button.text="Décor : "+["Ombres","Alexandrie","Colisée"][arena_index];await _rebuild()
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func _rebuild() -> void:
	building=true
	if app!=null:portrait_view.remove_child(app);app.queue_free()
	app=App.instantiate();app.save_path="";app.appearance_path="";app.combat_settings_path="";portrait_view.add_child(app)
	app.interface_style=PROFILES[selected];app._apply_interface_style()
	for i in range(choices.size()):choices[i].set_pressed_no_signal(i==selected)
	await settle()
	if screen in [&"arena",&"settings",&"statistics",&"journal",&"menu"]:
		app.open_arena();await settle()
		var game=app.combat;game.set_physics_process(false)
		game.chosen_arena=ARENAS[arena_index];game.arena_definition=Catalog.definition(game.chosen_arena)
		game.floor_canvas.set_definition(game.arena_definition);game._sync_projection()
		_fixture(game);game._present()
		if screen==&"settings":game._open_settings()
		elif screen==&"statistics":game._open_statistics()
		elif screen==&"journal":game._open_journal()
		elif screen==&"menu":game._toggle_pause()
		game.set_physics_process(playing)
	elif screen!=&"home":
		app.open_team();await settle()
		if screen!=&"team":
			app._select_team_hero(&"anne");await settle()
			if screen==&"gambits":app.open_gambits();await settle()
	building=false
func _fixture(game) -> void:
	var actors:Array=game.simulation.heroes
	for i in range(actors.size()):
		var unit=actors[i];unit.state.damage(35+i*10);unit.action.mana=32+i*5
		unit.buffs.apply(BuffCatalog.definition(&"booster"))
	game.simulation.hero(&"anne").action.request(&"heal",actors[0]);game.simulation.hero(&"anne").action.elapsed=.55
	game.simulation.wave_number=7
	var report=game.simulation.report
	var enemy_id:int=game.simulation.enemies[0].combat_id
	for tick in range(1,12):
		for i in range(actors.size()):
			report.consume({"run_id":report.run_id,"kind":"resolve","source_id":actors[i].combat_id,"target_id":actors[0].combat_id if i==1 else enemy_id,"sequence":tick,"skill":"heal" if i==1 else "basic","game_time":tick*.735,"damage":0 if i==1 else 12+i*3,"healing":10 if i==1 else 0})
