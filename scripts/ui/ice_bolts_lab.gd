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
var variant: int = 1
var elapsed: float = 0
var changed: bool = false
var loop_enabled: bool = true
const SCENARIOS = ["Trois victimes · seuil 2", "Deux victimes · seuil 2", "Seuil 4 · seulement 3 présents", "Seuil 4 · 4 présents, 3 touchés", "Mort pendant l’incantation", "Mort pendant le vol", "Approche et priorité Foudre"]
const VARIANTS = ["A · Cristal discret", "B · Givre lumineux", "C · Éclats intenses"]
func _ready() -> void:
	get_window().content_scale_size=Vector2i(930,960);get_window().size=Vector2i(930,960)
	get_window().title="Gambit Arena · Traits de glace · Multi-cibles"
	holder=SubViewportContainer.new();holder.size=Vector2(540,960);add_child(holder)
	portrait_view=SubViewport.new();portrait_view.size=Vector2i(540,960);portrait_view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;holder.add_child(portrait_view)
	sidebar=PanelContainer.new();sidebar.theme=Style.palette;add_child(sidebar)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("10090b");paint.set_content_margin_all(14);sidebar.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",7);sidebar.add_child(column)
	label(column,"Traits de glace",23)
	label(column,"Mako · 20 PM · 30 dégâts par victime\n1,5 s de cast · 3 s de recharge\nPortée 4 · portée multi 2,5 · max. 3",15)
	var icon:=preload("res://scripts/presentation/skill_icons.gd").rect(&"ice_bolts",64);column.add_child(icon)
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
	var item:=Button.new();item.text=text;item.custom_minimum_size.y=36;item.add_theme_font_size_override("font_size",14);parent.add_child(item);item.pressed.connect(callback)
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
	game.action_presenter.ice.strength=[.5,.8,1.15][variant]
	game.simulation.navigation_enabled=false
	game.simulation.rules={"mako":[{"enabled":true,"criterion":"enemy_group_%d"%(4 if scenario in [2,3] else 2),"skill":"ice_bolts"}],"anne":[],"nassau":[]}
	var mako=game.simulation.hero(&"mako");mako.place(Vector2(-1.8,1.7))
	game.simulation.hero(&"anne").place(Vector2(-2.8,2.6));game.simulation.hero(&"nassau").place(Vector2(-.5,2.7))
	var points:Array=[Vector2(.0,0),Vector2(.95,0),Vector2(.25,-.95),Vector2(3,-2)]
	var count:int=2 if scenario==1 else 4 if scenario==3 else 3
	if scenario==6:mako.place(Vector2(-2.5,3));points=[Vector2(1,-2),Vector2(2,-2),Vector2(1,-3)]
	for i in range(game.simulation.enemies.size()):
		var enemy_unit=game.simulation.enemies[i]
		if i>=count:enemy_unit.state.damage(10000);continue
		enemy_unit.place(points[i]);enemy_unit.mover.speed=0;enemy_unit.action.cooldowns.basic=999
		enemy_unit.state.max_health=150;enemy_unit.state.health=150;enemy_unit.state.defense=999
	game.simulation._prune();game._present();elapsed=0;changed=false
func _physics_process(dt:float) -> void:
	if game==null:return
	var before:float=game.simulation.clock.elapsed
	game._physics_process(dt)
	elapsed+=maxf(0,game.simulation.clock.elapsed-before)
	var mako=game.simulation.hero(&"mako")
	if not changed and scenario==4 and mako.action.casting() and mako.action.elapsed>=.7:
		mako.action._target.state.damage(10000);changed=true
	if not changed and scenario==5 and not game.simulation.projectiles.pending.is_empty():
		var shots:Array=game.simulation.projectiles.pending
		if shots.size()>1:shots[1].actor.get_ref().state.damage(10000);changed=true
	if not changed and scenario==6 and elapsed>=.6:
		game.simulation.rules.mako.insert(0,{"enabled":true,"criterion":"enemy_near","skill":"lightning"});changed=true
	info.text="%s\n%s\nPM %d · recharge %.1f s\n%s"%[VARIANTS[variant],SCENARIOS[scenario],floori(mako.action.mana),mako.action.remaining(&"ice_bolts"),"Incantation" if mako.action.casting() else "Projectiles lancés" if not game.simulation.projectiles.pending.is_empty() else "Approche / attente"]
	if loop_enabled and elapsed>=6:restart()
