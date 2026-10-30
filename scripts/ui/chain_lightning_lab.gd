extends Control
## Isolated product combat: memory-only orders and settings; no player save writes.
const Game = preload("res://scenes/app/arena_page.tscn")
const Style = preload("res://resources/ui/styles/berserk.tres")
var portrait_view: SubViewport
var holder: SubViewportContainer
var sidebar: PanelContainer
var game: Control
var info: Label
var scenario: int = 0
var variant: int = 2
var elapsed: float = 0
var changed: bool = false
var loop_enabled: bool = true
const SCENARIOS = ["Chaîne de quatre impacts", "Plus proche isolé · un impact", "Seuil 3 · deux ennemis seulement", "Cible changée au rebond", "Principale tuée par l’éclair", "Mort pendant l’incantation", "Approche et priorité Booster", "Lanceur mort après lancement"]
const VARIANTS = ["A · Filament carmin", "B · Arc écarlate", "C · Foudre déchaînée"]
func _ready() -> void:
	get_window().content_scale_size=Vector2i(930,960);get_window().size=Vector2i(930,960)
	get_window().title="Gambit Arena · Chaîne d’éclairs · Rebonds dynamiques"
	holder=SubViewportContainer.new();holder.size=Vector2(540,960);add_child(holder)
	portrait_view=SubViewport.new();portrait_view.size=Vector2i(540,960);portrait_view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;holder.add_child(portrait_view)
	sidebar=PanelContainer.new();sidebar.theme=Style.palette;add_child(sidebar)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("10090b");paint.set_content_margin_all(14);sidebar.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",6);sidebar.add_child(column)
	label(column,"Chaîne d’éclairs",23)
	label(column,"Nassau · 30 PM · 30 / 24 / 19 / 15 dégâts\n2 s de cast · 4 s de recharge\nPortée 4 · rebonds 2,5 · intervalle 0,1 s",15)
	var icon:=preload("res://scripts/presentation/skill_icons.gd").rect(&"chain_lightning",48);column.add_child(icon)
	label(column,"Animation · rejouer une variante",17)
	for i in range(3): button(column,VARIANTS[i],select_variant.bind(i))
	label(column,"Scénarios de ciblage",17)
	for i in range(SCENARIOS.size()): button(column,SCENARIOS[i],select_scenario.bind(i))
	button(column,"Rejouer le scénario",restart)
	button(column,"Boucle : activer / désactiver",func():loop_enabled=not loop_enabled)
	button(column,"Pause / lecture",func():
		game.paused=not game.paused;game.simulation.clock.paused=game.paused
		if not game.paused:
			game.pause_layer.hide();game.application_guard.acknowledge_resume())
	info=label(column,"",14)
	get_viewport().size_changed.connect(layout);layout();restart()
func label(parent:Node,text:String,font_size:int) -> Label:
	var item:=Label.new();item.text=text;item.add_theme_font_size_override("font_size",font_size);parent.add_child(item);return item
func button(parent:Node,text:String,callback:Callable) -> void:
	var item:=Button.new();item.text=text;item.custom_minimum_size.y=34;item.add_theme_font_size_override("font_size",14);parent.add_child(item);item.pressed.connect(callback)
func layout() -> void:
	var view:Vector2=get_viewport_rect().size
	var zoom:float=maxf(.2,minf((view.x-380)/540,view.y/960))
	holder.scale=Vector2.ONE*zoom;sidebar.position=Vector2(540*zoom+10,10);sidebar.size=Vector2(view.x-sidebar.position.x-10,view.y-20)
func select_variant(index:int) -> void:variant=index;restart()
func select_scenario(index:int) -> void:scenario=index;restart()
func restart() -> void:
	if game!=null:portrait_view.remove_child(game);game.queue_free()
	game=Game.instantiate();game.save_path="";game.settings_path="";game.infinite_mode=true
	game.theme=Style.palette;game.hud_style=Style.arena_hud
	game.chooser=func():return &"ville_alexandrie"
	portrait_view.add_child(game);game.set_physics_process(false)
	game.paused=false;game.simulation.clock.paused=false;game.pause_layer.hide();game.application_guard.acknowledge_resume()
	var paint:Resource=preload("res://resources/presentation/effects/chain_lightning.tres").duplicate()
	paint.width=[.10,.16,.21][variant];paint.strength=[.65,.85,1.1][variant]
	paint.branches=[2,4,7][variant];paint.impact_radius=[.30,.42,.49][variant]
	game.action_presenter.chain.profile=paint
	game.simulation.navigation_enabled=false
	game.simulation.rules={"nassau":[{"enabled":true,"criterion":"enemy_group_3","skill":"chain_lightning"}],"anne":[],"mako":[]}
	var nassau=game.simulation.hero(&"nassau");nassau.place(Vector2(-2,2))
	game.simulation.hero(&"anne").place(Vector2(-3,3));game.simulation.hero(&"mako").place(Vector2(-1,3))
	var points:Array=[Vector2(-1,0),Vector2(.5,-.4),Vector2(2,-.2),Vector2(2.8,-1.6),Vector2(-3,-3),Vector2(3,2.6)]
	var count:int=2 if scenario==2 else 6
	if scenario==1:points=[Vector2(-1,1),Vector2(2.4,-1),Vector2(3.2,-2),Vector2(1.8,-2.8),Vector2(-3,-3),Vector2(3,3)]
	if scenario==6:nassau.place(Vector2(-2.5,3));points=[Vector2(1,-2),Vector2(2,-2),Vector2(1,-3),Vector2(3,-2),Vector2(3,0),Vector2(2,0)]
	for i in range(game.simulation.enemies.size()):
		var enemy_unit=game.simulation.enemies[i]
		if i>=count:enemy_unit.state.damage(10000);continue
		enemy_unit.place(points[i])
		var profile=game.simulation.ENEMY.duplicate();profile.max_health=150;profile.defense=9999
		enemy_unit.configure_party(profile);enemy_unit.state.died.connect(game.simulation._record_death.bind(enemy_unit))
		enemy_unit.mover.speed=0;enemy_unit.action.cooldowns.basic=999
		if scenario==4 and i==0:enemy_unit.state.damage(130)
	game.simulation._prune();game._present();elapsed=0;changed=false
func _physics_process(dt:float) -> void:
	if game==null:return
	var before:float=game.simulation.clock.elapsed
	game._physics_process(dt)
	elapsed+=maxf(0,game.simulation.clock.elapsed-before)
	var nassau=game.simulation.hero(&"nassau")
	if not changed and scenario==3 and not game.simulation.projectiles.chains.pending.is_empty():
		game.simulation.enemies[1].place(Vector2(3,3));game.simulation.enemies[4].place(Vector2(.1,.2));changed=true
	if not changed and scenario==5 and nassau.action.casting() and nassau.action.elapsed>=.8:
		nassau.action._target.state.damage(10000);changed=true
	if not changed and scenario==6 and elapsed>=.6:
		game.simulation.rules.nassau.insert(0,{"enabled":true,"criterion":"self","skill":"booster"});changed=true
	if not changed and scenario==7 and not game.simulation.projectiles.chains.pending.is_empty():
		nassau.state.damage(10000);changed=true
	info.text="%s\n%s\nPM %d · recharge %.1f s\n%s"%[VARIANTS[variant],SCENARIOS[scenario],floori(nassau.action.mana),nassau.action.remaining(&"chain_lightning"),"Incantation" if nassau.action.casting() else "Rebonds en cours" if not game.simulation.projectiles.chains.pending.is_empty() else "Approche / attente"]
	if loop_enabled and elapsed>=6:restart()
