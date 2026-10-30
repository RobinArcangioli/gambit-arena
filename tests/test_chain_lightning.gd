extends "res://tests/test_area_gameplay.gd"
const Chain = preload("res://scripts/skills/chain_skills.gd")
const ChainArt = preload("res://scripts/presentation/chain_lightning_presenter.gd")
func chain_order(criterion: String="enemy_group_3") -> Dictionary:
	return order("chain_lightning",criterion)
func ready_nassau():
	await fixture()
	sim.rules={"mako":[],"anne":[],"nassau":[]}
	var nassau=sim.hero(&"nassau");nassau.place(Vector2(-2,0))
	var points:Array=[Vector2.ZERO,Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(-3,-3),Vector2(3,-3)]
	for i in range(sim.enemies.size()):
		var unit=sim.enemies[i];unit.place(points[i]);unit.mover.speed=0
		var profile=sim.ENEMY.duplicate();profile.max_health=1000;profile.defense=9999
		unit.configure_party(profile);unit.mover.speed=0;unit.state.died.connect(sim._record_death.bind(unit))
	return nassau
func release(nassau) -> void:
	check(nassau.action.request(Chain.ID,sim.enemies[0])>0,"chain cast accepted")
	nassau.action.advance(2,false,2);sim._collect_visual_events(sim.all_units())
func bounce(dt: float, time: float) -> void:
	sim.projectiles.advance(dt,sim.all_units(),time)
	for event in sim.projectiles.take_events():sim._append_visual_event(event)
func _ready() -> void:
	var nassau=await ready_nassau();var action=nassau.action
	var step:float=Chain.INTERVAL
	check(action.available(Chain.ID) and not sim.hero(&"mako").action.available(Chain.ID),"Nassau owns Chain exclusively")
	check(action.cost(Chain.ID)==30 and action.cast_duration(Chain.ID)==2 and action.cooldown(Chain.ID)==4 and action.skill_reach(Chain.ID)==4,"chain metadata")
	check([Chain.damage(0),Chain.damage(1),Chain.damage(2),Chain.damage(3)]==[30,24,19,15],"compound twenty-percent damage rounded per hit")
	check(Orders.defaults().nassau[0].skill=="booster" and Orders.defaults().nassau[1]==chain_order(),"Booster retained first, Chain test order second")
	var config:Dictionary=Orders.defaults();var encoded:Dictionary=Codec.decode(JSON.stringify({"version":Codec.VERSION,"heroes":config}))
	check(encoded.error==OK and encoded.configuration==config,"chain order round-trips current save codec")
	for i in range(1,6):sim.enemies[i].place(Vector2(3,3))
	check(Orders.evaluate([chain_order()],sim.snapshot(nassau)).get("target_id")==sim.enemies[0].combat_id,"isolated nearest primary chosen without local coverage constraint")
	var view:Dictionary=sim.snapshot(nassau);view.enemies=view.enemies.slice(0,2)
	check(Orders.evaluate([chain_order()],view).is_empty(),"global population two rejects threshold three")
	view.enemies=view.enemies.slice(0,1);check(Orders.evaluate([chain_order("enemy_near")],view).target_id==sim.enemies[0].combat_id,"ordinary nearest criterion permits single victim")
	view=sim.snapshot(nassau);view.mana=29
	check(Orders.evaluate([chain_order(),Orders.create()],view).rule_index==1,"insufficient mana skips")
	view.mana=60;view.cooldowns.chain_lightning=1
	check(Orders.evaluate([chain_order(),Orders.create()],view).rule_index==1,"cooldown skips")
	nassau=await ready_nassau();action=nassau.action
	check(action.request(Chain.ID,sim.enemies[0])>0,"two-second cast starts")
	action.advance(1.99,false,1.99)
	check(action.casting() and action.spent==0 and action.remaining(Chain.ID)==0 and sim.enemies[0].state.health==1000,"no damage, cost or cooldown before release")
	action.advance(.01,false,.01);sim._collect_visual_events(sim.all_units())
	check(action.spent==30 and action.mana==30 and action.remaining(Chain.ID)==4,"one payment and full cooldown at release")
	check(sim.enemies[0].state.health==970 and sim.enemies[1].state.health==1000,"primary hit immediately on release, fixed damage ignores defense")
	check(not action.try_impact(action.action_id) and sim.projectiles.chains.pending.size()==1,"duplicate resolve does not duplicate chain")
	check(sim.events.filter(func(e):return e.kind=="chain_launch").size()==1 and sim.events.filter(func(e):return e.kind=="chain_hit").size()==1,"single release fact and per-victim first hit")
	bounce(step-.001,step-.001);check(sim.enemies[1].state.health==1000,"no premature rebound")
	bounce(.001,step);check(sim.enemies[1].state.health==976,"first rebound at exact configured interval")
	bounce(step,step*2);check(sim.enemies[2].state.health==981,"second rebound at twice configured interval")
	bounce(step,step*3);check(sim.enemies[3].state.health==985 and sim.projectiles.chains.pending.is_empty(),"last rebound at three configured intervals; three rebounds only")
	check(sim.enemies[4].state.health==1000 and sim.enemies[5].state.health==1000,"fifth and sixth enemies untouched")
	check(sim.report.actors[nassau.combat_id].dealt==88 and sim.hits==4,"actual damage stats and four hits")
	check(sim.report.recent.any(func(e):return "Chaîne d’éclairs" in e.text and "30 PM" in e.text) and sim.report.recent.any(func(e):return "rebond 3/3" in e.text),"player journal names skill, cost and rebound")
	var moments:Array=[]
	for e in sim.events:
		if e.kind=="chain_hit":moments.append(float(e.game_time))
	check(moments.size()==4 and is_equal_approx(moments[1],step) and is_equal_approx(moments[3],step*3),"combat facts retain exact rebound times")
	var art:=ChainArt.new();world.add_child(art);art.reset_run(sim.run_id)
	var first:Dictionary=sim.events.filter(func(e):return e.kind=="chain_hit")[0]
	art.consume(first);art.consume(first);check(art.effects.size()==1,"visual fact deduplication")
	art.advance_visual(.1);var age:float=art.effects[0].view.age;art.advance_visual(0)
	check(art.effects[0].view.age==age,"pause freezes procedural electrical segment")
	check(is_equal_approx(age,.1),"visual speed retained while rebound pauses shrink")
	art.advance_visual(1);check(art.effects.is_empty() and art.played.is_empty(),"completed visual resources and dedup history pruned")
	bounce(20,20);check(sim.report.actors[nassau.combat_id].dealt==88,"chain cannot strike a fifth time or revisit")
	nassau=await ready_nassau();action=nassau.action;release(nassau)
	for i in range(1,6):sim.enemies[i].place(Vector2(3,3))
	bounce(step*.5,step*.5);sim.enemies[4].place(Vector2(.6,0));bounce(step*.5,step)
	check(sim.enemies[4].state.health==976 and sim.enemies[1].state.health==1000,"next victim calculated at rebound, including newly nearby enemy")
	sim.enemies[2].place(Vector2(1.2,0));sim.enemies[4].state.damage(10000)
	bounce(step,step*2);check(sim.enemies[2].state.health==981,"chain continues from previous victim corpse location")
	nassau=await ready_nassau();action=nassau.action
	for i in range(1,6):sim.enemies[i].place(Vector2(3,3))
	sim.enemies[1].place(Vector2(2.5,0));release(nassau);bounce(step,step)
	check(sim.enemies[1].state.health==976,"closed 2.5-unit bounce boundary included")
	nassau=await ready_nassau();action=nassau.action
	for i in range(1,6):sim.enemies[i].place(Vector2(3,3))
	sim.enemies[1].place(Vector2(2.5001,0));release(nassau);bounce(step,step)
	check(sim.projectiles.chains.pending.is_empty() and sim.enemies[1].state.health==1000,"no nearby candidate ends chain rather than jumping too far")
	nassau=await ready_nassau();action=nassau.action
	sim.enemies[1].place(Vector2(.8,0));sim.enemies[2].place(Vector2(-.8,0));release(nassau);bounce(step,step)
	check(sim.enemies[1].state.health==976 and sim.enemies[2].state.health==1000,"equidistant next targets use stable combat ID")
	nassau=await ready_nassau();action=nassau.action
	action.request(Chain.ID,sim.enemies[0]);action.advance(.5,false,.5)
	for i in range(1,6):sim.enemies[i].state.damage(10000)
	action.advance(1.5,false,1.5)
	check(action.spent==30 and sim.enemies[0].state.health==970,"population falling below threshold during cast does not cancel")
	bounce(step,step);check(sim.projectiles.chains.pending.is_empty(),"single remaining victim gives a single hit")
	nassau=await ready_nassau();action=nassau.action
	action.request(Chain.ID,sim.enemies[0]);sim.enemies[0].state.damage(10000)
	check(not action.active and action.spent==0 and action.remaining(Chain.ID)==0,"primary death during cast cancels without mana or cooldown")
	check(action.request(Chain.ID,sim.enemies[1])>0,"retarget immediately after cancellation")
	sim.enemies[1].place(Vector2(3,0));action.advance(.01,false,.01)
	check(not action.active and action.spent==0 and action.remaining(Chain.ID)==0,"primary out of range cancels without recovery")
	nassau=await ready_nassau();action=nassau.action
	sim.enemies[0].state.damage(sim.enemies[0].state.health-10);release(nassau)
	sim._prune();await settle();nassau.state.damage(10000)
	bounce(step,step);check(sim.enemies[0].state.health==976,"released chain survives freed primary and dead caster")
	nassau=await ready_nassau();action=nassau.action
	action.request(Chain.ID,sim.enemies[0]);action.advance(10,true,10)
	check(action.elapsed==0 and action.spent==0,"paused cast unchanged")
	nassau.buffs.apply(Buffs.definition(&"booster"));action.advance(1.53)
	check(action.casting(),"boosted cast does not release early")
	action.advance(.01);check(action.spent==30 and action.remaining(Chain.ID)==4,"Booster accelerates cast")
	action.advance(.1);check(is_equal_approx(action.remaining(Chain.ID),3.87),"Booster accelerates cooldown")
	var remaining:float=sim.projectiles.chains.pending[0].remaining
	sim.advance(10,true);check(sim.projectiles.chains.pending[0].remaining==remaining,"pause freezes rebound clock")
	bounce(step-.001,step-.001);check(sim.enemies[1].state.health==1000,"Booster does not accelerate released chain")
	bounce(.001,step);check(sim.enemies[1].state.health==976,"rebound uses normal combat time with Booster")
	sim.reset();check(sim.projectiles.chains.pending.is_empty(),"new combat clears chain")
	nassau=await ready_nassau();action=nassau.action;release(nassau)
	sim._finish("DEFAITE");check(sim.projectiles.chains.pending.is_empty(),"terminal combat clears chain")
	nassau=await ready_nassau();action=nassau.action
	sim.enemies[0].state.damage(sim.enemies[0].state.health-10);sim.enemies[0].state.died.connect(func():sim.projectiles.clear())
	release(nassau);bounce(10,10)
	check(sim.enemies[1].state.health==1000 and sim.projectiles.chains.pending.is_empty(),"reset during primary lethal callback cancels all pending rebounds")
	nassau=await ready_nassau();action=nassau.action;release(nassau)
	sim.enemies[1].state.damage(sim.enemies[1].state.health-10);sim.enemies[1].state.died.connect(func():sim.projectiles.clear())
	bounce(1,1);check(sim.enemies[2].state.health==1000 and sim.projectiles.chains.pending.is_empty(),"reset during rebound lethal callback prevents stale later hits")
	nassau=await ready_nassau();action=nassau.action;release(nassau)
	sim.enemies[1].state.damage(sim.enemies[1].state.health-10);sim.enemies[1].state.died.connect(func():sim.projectiles.advance(10,sim.all_units(),10))
	bounce(step,step);check(sim.enemies[2].state.health==1000,"reentrant advance cannot consume later bounces")
	bounce(step*2,step*3);check(sim.enemies[2].state.health==981 and sim.enemies[3].state.health==985,"large accepted step resolves remaining checkpoints once")
	nassau=await ready_nassau();nassau.place(Vector2(-3,3))
	for i in range(6):sim.enemies[i].place(Vector2(2,-2))
	sim.rules.nassau=[chain_order(),Orders.create()];sim._plan(nassau)
	check(nassau.desired_skill==Chain.ID and not nassau.action.active,"out-of-range chain primary pursued")
	sim._move(1.0/30);check(nassau.position.x> -3,"navigation approaches nearest enemy")
	sim.rules.nassau.insert(0,order("booster","self"));sim._plan(nassau)
	check(nassau.desired_skill==&"booster" and nassau.desired_target==nassau,"priority buff interrupts chain approach")
	sim.queue_free();world.queue_free();await settle();sim=null
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan actors or chain visuals")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
