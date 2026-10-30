extends Node
const Sim=preload("res://scripts/party/party_simulation.gd")
const Orders=preload("res://scripts/gambits/orders.gd")
const Codec=preload("res://scripts/gambits/configuration_codec.gd")
const Buffs=preload("res://scripts/buffs/buff_catalog.gd")
const App=preload("res://scenes/app/app_root.tscn")
var checks:int=0
var failures:int=0
var sim:Sim
var world:Node3D
func check(ok:bool,text:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func fixture() -> void:
	if sim!=null:sim.queue_free();world.queue_free();await settle()
	world=Node3D.new();add_child(world);sim=Sim.new();add_child(sim);sim.configure(world)
	sim.orders_enabled=true;sim.infinite_mode=true;sim.report.enabled=true;sim.rules=Orders.defaults();sim.reset()
	sim.rules.mako=[];sim.rules.nassau=[]
	sim.hero(&"anne").place(Vector2(-2,0));sim.hero(&"mako").place(Vector2(0,.6));sim.hero(&"nassau").place(Vector2(-2,-1))
	var positions:Array=[Vector2(-.85,0),Vector2.ZERO,Vector2(.85,0),Vector2(2.5,0),Vector2(2.5,1),Vector2(3.5,-1)]
	for i in range(6):sim.enemies[i].place(positions[i])
func order(skill:String="meteor",criterion:String="enemy_group_3") -> Dictionary:return {"enabled":true,"criterion":criterion,"skill":skill}
func impact() -> void:
	sim.projectiles.advance(1,sim.all_units(),sim.clock.elapsed+1)
	for event in sim.projectiles.take_events():sim._append_visual_event(event)
func _ready() -> void:
	await fixture();var anne=sim.hero(&"anne");var action=anne.action
	check(action.cost(&"meteor")==40 and action.cast_duration(&"meteor")==3 and action.cooldown(&"meteor")==4 and action.skill_reach(&"meteor")==4,"Meteor metadata and universal spell range")
	check(not sim.hero(&"mako").action.available(&"meteor"),"Meteor belongs to Anne")
	check(Orders.evaluate([order(),Orders.create()],sim.snapshot(anne)).has("target_point"),"group criterion produces detached ground intention")
	check(Orders.evaluate([order("basic"),Orders.create()],sim.snapshot(anne)).rule_index==0,"single-target capability uses global population guard")
	action.mana=39
	check(Orders.evaluate([order(),Orders.create()],sim.snapshot(anne)).rule_index==1,"insufficient mana skips before spatial selection")
	action.mana=60;action.cooldowns.meteor=1
	check(Orders.evaluate([order(),Orders.create()],sim.snapshot(anne)).rule_index==1,"cooldown skips")
	action.cooldowns.meteor=0
	check(not Orders.evaluate([order("meteor","self")],sim.snapshot(anne)).is_empty(),"ordinary criterion can aim AOE at selected actor position")
	var old:Dictionary=Orders.defaults();var decoded:Dictionary=Codec.decode(JSON.stringify({"version":4,"heroes":old}))
	check(decoded.error==OK and decoded.configuration==old and decoded.notes.is_empty(),"old v4 configuration remains unchanged without migration")
	old.anne.insert(0,order());check(Codec.decode(JSON.stringify({"version":4,"heroes":old})).error==OK,"new order saves through current codec")
	check(action.request_ground(&"meteor",Vector2(2.001,0))==0,"point beyond four-unit reach rejected")
	sim.enemies[0].state.defense=10000
	var hero_health:int=sim.hero(&"mako").state.health
	check(action.request_ground(&"meteor",Vector2.ZERO)>0,"valid ground cast starts")
	var id:int=action.action_id
	action.advance(2.99,false,2.99)
	check(action.casting() and action.spent==0 and action.mana==60 and action.remaining(&"meteor")==0,"no mana paid or cooldown running during cast")
	check(not action.try_impact(id+1),"wrong action ID cannot resolve")
	action.advance(.01,false,.01)
	check(action.spent==40 and action.mana==20 and action.remaining(&"meteor")==4,"one debit and full cooldown begin at release")
	check(sim.enemies[0].state.health==60,"release does not damage before flight")
	sim._collect_visual_events(sim.all_units());impact()
	check(sim.enemies.slice(0,3).all(func(e):return e.state.health==20),"exactly forty PV removed including high-defense target")
	check(sim.enemies.slice(3).all(func(e):return e.state.health==60) and sim.hero(&"mako").state.health==hero_health,"outside enemies and allied heroes untouched")
	check(action.spent==40 and action.mana==20 and action.remaining(&"meteor")==4,"one debit and full cooldown begin at release")
	check(sim.report.actors[anne.combat_id].dealt==120 and not action.try_impact(id),"single latched impact sums actual damage and cannot repeat")
	sim._collect_visual_events(sim.all_units())
	check(sim.report.actors[anne.combat_id].dealt==120 and sim.report.actors[sim.enemies[0].combat_id].received==40,"MVP statistics count per-target actual losses once")
	check(sim.events.filter(func(e):return e.kind=="area_hit").size()==3 and sim.events.filter(func(e):return e.kind=="area_launch" and e.skill=="meteor").size()==1,"per-target facts plus one payment summary")
	check(sim.report.recent.any(func(e):return "Météore" in e.text and "Zone" in e.text and "40 PM" in e.text),"player journal identifies ground spell and one cost")
	action.advance(1,false,1);check(action.remaining(&"meteor")==3,"cooldown advances after release in personal time")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	sim.enemies[0].state.damage(53)
	var repeated:Array=[]
	sim.enemies[0].state.died.connect(func():repeated.append(anne.action.try_impact(anne.action.action_id)))
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3);sim._collect_visual_events(sim.all_units());impact()
	check(not sim.enemies[0].state.alive and sim.report.actors[anne.combat_id].dealt==87,"lethal overkill counts actual PV and does not cancel remaining victims")
	check(repeated==[false] and action.spent==40 and sim.report.actors[anne.combat_id].dealt==87,"reentrant death callback cannot repeat payment or impacts")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(1,false,1)
	for i in range(3):sim.enemies[i].place(Vector2(-3,i))
	sim.enemies[3].place(Vector2.ZERO);anne.state.damage(100)
	sim.rules.anne=[order("heal","ally_hp_lt_50"),order()];sim._plan(anne)
	check(action.casting() and action.last_skill==&"meteor" and action.ground_point==Vector2.ZERO,"higher-priority heal cannot interrupt begun cast or move its point")
	action.advance(2,false,2);sim._collect_visual_events(sim.all_units());impact()
	check(sim.enemies[3].state.health==20 and sim.enemies.slice(0,3).all(func(e):return e.state.health==60),"impact uses current occupants, not original selection")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO)
	for enemy_unit in sim.enemies.slice(0,3):enemy_unit.state.damage(10000)
	sim._prune();check(action.casting(),"death and removal of original enemies never invalidate a ground target")
	action.advance(3,false,3)
	check(not action.active and action.spent==0 and action.remaining(&"meteor")==0,"empty cast zone cancels without mana or cooldown")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);anne.state.damage(10000)
	check(not action.active and action.spent==0 and action.remaining(&"meteor")==0,"caster death cancels unpaid cast without cooldown")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(10,true)
	check(action.elapsed==0 and action.spent==0,"pause freezes ground cast")
	action.cancel();anne.buffs.apply(Buffs.definition(&"booster"));action.request_ground(&"meteor",Vector2.ZERO)
	action.advance(2.3);check(action.casting(),"boosted cast does not release early")
	action.advance(.01);check(action.resolved and action.spent==40 and action.remaining(&"meteor")==4,"Booster accelerates three-second cast")
	action.advance(1);check(is_equal_approx(action.remaining(&"meteor"),2.7) and is_equal_approx(action.mana,25),"Booster accelerates cooldown, not mana regeneration")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	anne.place(Vector2(-3.5,0));sim.hero(&"mako").place(Vector2(-2,-1));sim.hero(&"nassau").place(Vector2(-2,1))
	var spread:Array=[Vector2(2.5,-.9),Vector2(2.5,0),Vector2(2.5,.9),Vector2(-3,-2),Vector2(-2,-3),Vector2(-3,2)]
	for i in range(6):sim.enemies[i].place(spread[i])
	sim.rules.anne=[order("heal","ally_hp_lt_50"),order(),Orders.create()]
	sim._plan(anne);check(anne.ground_intention and anne.desired_point.distance_to(anne.mover.ground_position)>4,"out-of-range optimal group is pursued")
	sim._move(1.0/30);check(anne.mover.ground_position.x>-3.5,"existing navigation moves toward cast range")
	sim.hero(&"mako").state.damage(120);sim._plan(anne)
	check(not anne.ground_intention and anne.desired_skill==&"heal" and anne.desired_target==sim.hero(&"mako"),"higher-priority gambit overrides Meteor DURING approach")
	sim.advance(1.0/30);check(action.last_skill==&"heal" and action.casting(),"priority heal actually begins instead of Meteor")
	action.advance(1.9,false,1.9);sim._plan(anne)
	check(anne.ground_intention and anne.desired_skill==&"meteor","Meteor reconsidered after urgent action when group still qualifies")
	for i in range(6):sim.enemies[i].place(Vector2.from_angle(TAU*float(i)/6.0)*3.6)
	sim._plan(anne);check(not anne.ground_intention and anne.desired_skill==&"basic","dissolved group stops approach and falls through to next order")
	sim.queue_free();world.queue_free();await settle();sim=null
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle()
		app.open_arena();var game=app.combat;game.set_process(false);game.set_physics_process(false);await settle()
		anne=game.simulation.hero(&"anne");anne.action.request_ground(&"meteor",anne.mover.ground_position);game._present()
		game.action_presenter.present(game.simulation.all_units(),game.simulation.events,0,game.simulation.run_id)
		var panel=game.hero_panels[game.team_slots.find(&"anne")]
		check(panel.bars.casting and panel.cast_text.text.begins_with("Météore") and panel.bars.cast_color==Color("8befff"),"Meteor uses existing cyan panel and overhead casting UI")
		check(anne.visual.cast_active,"Meteor uses common Duck animation")
		var presenter=game.action_presenter
		var no_events:Array[Dictionary]=[]
		check(presenter.area_zones.has(anne.combat_id) and is_equal_approx(presenter.area_zones[anne.combat_id].radius,1.4),"cast displays the actual AOE radius")
		var point:Vector3=presenter.area_zones[anne.combat_id].position
		var before:Array=[anne.action.elapsed,anne.action.spent]
		game._change_area_settings(false)
		check(presenter.area_zones.is_empty() and [anne.action.elapsed,anne.action.spent]==before,"hiding AOE immediately clears visuals without touching gameplay")
		game._change_area_settings(true)
		check(presenter.area_zones.has(anne.combat_id) and presenter.area_zones[anne.combat_id].position==point,"showing AOE during cast restores locked center")
		game.simulation.enemies[0].place(Vector2.ZERO)
		presenter.present(game.simulation.all_units(),no_events,0,game.simulation.run_id)
		check(presenter.area_zones[anne.combat_id].position==point,"enemy motion never moves displayed zone")
		game.paused=true;game.simulation.clock.paused=true;game._physics_process(1)
		check(presenter.area_zones.has(anne.combat_id) and anne.action.elapsed==before[0],"pause keeps a stationary cast indicator")
		anne.action.cancel();presenter.present(game.simulation.all_units(),no_events,0,game.simulation.run_id)
		check(presenter.area_zones.is_empty(),"cancel removes AOE indicator")
		game.paused=false;game.simulation.clock.paused=false;anne.state.damage(30);anne.action.request(&"heal",anne)
		presenter.present(game.simulation.all_units(),no_events,0,game.simulation.run_id)
		check(anne.action.casting() and presenter.area_zones.is_empty(),"single-target spells never create AOE circles")
		viewport.queue_free();await settle()
	var lab=load("res://scenes/debug/area_lab.tscn").instantiate();add_child(lab);lab.set_physics_process(false);await settle()
	for tick in range(240):lab._physics_process(1.0/30)
	check(lab.simulation.hero(&"anne").action.spent>=40 and lab.simulation.enemies.any(func(e):return e.state.health<200),"real laboratory resolves Meteor against high-defense enemies")
	lab.select_scenario(1)
	for tick in range(40):lab._physics_process(1.0/30)
	check(lab.simulation.hero(&"anne").action.last_skill==&"heal","laboratory demonstrates priority interruption during approach")
	lab.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan actors, targets or visual nodes including the laboratory")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
