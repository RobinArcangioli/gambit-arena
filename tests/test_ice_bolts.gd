extends "res://tests/test_area_gameplay.gd"
const Multi = preload("res://scripts/skills/multi_skills.gd")
const IceArt = preload("res://scripts/presentation/ice_bolts_presenter.gd")
func ice_order(minimum: int = 2) -> Dictionary:
	return order("ice_bolts", "enemy_group_%d" % minimum)
func arrange(points: Array) -> void:
	for i in range(sim.enemies.size()):
		if i < points.size(): sim.enemies[i].place(points[i])
		else: sim.enemies[i].state.damage(10000)
func ready_mako():
	await fixture()
	sim.hero(&"mako").place(Vector2(-2,0))
	sim.rules = {"mako":[],"anne":[],"nassau":[]}
	return sim.hero(&"mako")
func release(mako) -> void:
	mako.action.advance(1.5,false,1.5)
	sim._collect_visual_events(sim.all_units())
func _ready() -> void:
	var mako = await ready_mako()
	var action = mako.action
	check(action.available(Multi.ID) and not sim.hero(&"anne").action.available(Multi.ID),"Ice belongs only to Mako")
	check(action.cost(Multi.ID)==20 and action.cast_duration(Multi.ID)==1.5 and action.cooldown(Multi.ID)==3 and action.skill_reach(Multi.ID)==4,"Ice metadata")
	check(Orders.defaults().mako[0]==ice_order(),"fresh Mako starts with two-enemy Ice gambit")
	var config: Dictionary = Orders.defaults()
	config.mako.insert(0,ice_order(4))
	var encoded: Dictionary = Codec.decode(JSON.stringify({"version":Codec.VERSION,"heroes":config}))
	check(encoded.error==OK and encoded.configuration==config,"two- and four-enemy Ice orders survive current save codec")
	arrange([Vector2.ZERO])
	check(Orders.evaluate([ice_order()],sim.snapshot(mako)).is_empty(),"one enemy never satisfies the two-enemy gambit")
	mako = await ready_mako(); action=mako.action
	arrange([Vector2(-1,0),Vector2(1.5,0)])
	var choice: Dictionary = Orders.evaluate([ice_order()],sim.snapshot(mako))
	check(choice.get("target_id")==sim.enemies[0].combat_id,"two enemies and exact multi boundary qualify")
	check(Orders.evaluate([ice_order(4)],sim.snapshot(mako)).is_empty(),"four-enemy criterion rejects a population of two")
	arrange([Vector2(-1,0),Vector2(1.5001,0)])
	check(Orders.evaluate([ice_order()],sim.snapshot(mako)).is_empty(),"isolated enemies fail even when global minimum reached")
	mako = await ready_mako(); action=mako.action
	arrange([Vector2(-1.3,-2),Vector2(1,0),Vector2(1.8,0),Vector2(2.6,0)])
	choice=Orders.evaluate([ice_order()],sim.snapshot(mako))
	check(choice.get("target_id")==sim.enemies[1].combat_id,"nearest isolated enemy skipped for nearest qualifying primary")
	choice=Orders.evaluate([ice_order(4)],sim.snapshot(mako))
	check(choice.get("target_id")==sim.enemies[1].combat_id,"four present, three-coverable primary chosen")
	mako=await ready_mako(); action=mako.action
	arrange([Vector2(-1,0),Vector2(-1,1),Vector2(2,0),Vector2(2,1),Vector2(2,-1)])
	choice=Orders.evaluate([ice_order()],sim.snapshot(mako))
	check(choice.get("target_id")==sim.enemies[0].combat_id,"nearest valid pair beats more distant triplet; no maximization")
	choice=Orders.evaluate([ice_order(4)],sim.snapshot(mako))
	check(choice.get("target_id")==sim.enemies[2].combat_id,"four threshold requires k=3 rather than four local victims")
	action.mana=19
	check(Orders.evaluate([ice_order(),Orders.create()],sim.snapshot(mako)).rule_index==1,"insufficient PM skips to next gambit")
	action.mana=60; action.cooldowns.ice_bolts=1
	check(Orders.evaluate([ice_order(),Orders.create()],sim.snapshot(mako)).rule_index==1,"cooldown skips to next gambit")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8),Vector2(1.6,0)])
	for enemy_unit in sim.enemies: enemy_unit.state.defense=9999
	check(action.request(Multi.ID,sim.enemies[0])>0,"cast accepted")
	action.advance(1.49,false,1.49)
	check(action.casting() and action.spent==0 and action.remaining(Multi.ID)==0,"no debit or cooldown before release")
	check(sim.projectiles.pending.is_empty(),"no early projectiles")
	action.advance(.01,false,.01);sim._collect_visual_events(sim.all_units())
	check(action.spent==20 and action.remaining(Multi.ID)==3 and sim.projectiles.pending.size()==3,"one cost, full cooldown and at most three projectiles at release")
	check(sim.enemies[0].state.health==60,"no damage at launch")
	check(not action.try_impact(action.action_id),"duplicate impact cannot launch twice")
	var launched: Dictionary = sim.events.filter(func(e):return e.kind=="multi_launch")[0]
	check(launched.victims.size()==3 and launched.victims[0].target_id==sim.enemies[0].combat_id,"primary retained and nearest distinct secondaries selected")
	var art := IceArt.new();world.add_child(art);art.reset_run(sim.run_id);art.consume(launched);art.consume(launched)
	check(art.effects.size()==1,"duplicate launch cannot duplicate ice art")
	art.advance_visual({},.2);var visual_age:float=art.effects.values()[0].age
	art.advance_visual({},0);check(art.effects.values()[0].age==visual_age,"visual pause")
	sim.projectiles.advance(Multi.ORBIT+Multi.FLIGHT-.001,sim.all_units(),2)
	check(sim.enemies[0].state.health==60,"damage waits until flight impact")
	sim.projectiles.advance(.001,sim.all_units(),2.001)
	for e in sim.projectiles.take_events():
		sim._append_visual_event(e);e=e.duplicate(true);e.run_id=sim.run_id;art.consume(e)
	check(sim.enemies.slice(0,3).all(func(e):return e.state.health==30),"three fixed thirty-HP impacts ignore defense")
	check(sim.enemies[3].state.health==60 and sim.report.actors[mako.combat_id].dealt==90,"fourth unhit; stats sum actual damage once")
	check(sim.report.recent.any(func(e):return "Traits de glace" in e.text and "20 PM" in e.text),"journal has spell and payment")
	art.advance_visual({},1);check(art.effects.is_empty(),"finished ice art cleaned")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8),Vector2(1.6,0)])
	action.request(Multi.ID,sim.enemies[0]);action.advance(.5,false,.5)
	sim.enemies[1].place(Vector2(3,3));sim.enemies[2].state.damage(10000)
	release(mako)
	check(action.spent==20 and sim.projectiles.pending.size()==2,"dispersal and falling population do not cancel cast; final selection at release")
	var survivor_id:int=sim.enemies[3].combat_id
	sim.enemies[3].state.damage(10000);sim.enemies[1].place(Vector2(.5,0))
	impact()
	check(sim.enemies[0].state.health==30 and sim.enemies[1].state.health==60,"dead locked secondary never replaced by newly nearby enemy")
	check(sim.events.any(func(e):return e.kind=="multi_miss" and e.target_id==survivor_id),"dead victim produces a harmless projectile fact")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8)])
	action.request(Multi.ID,sim.enemies[0]);sim.enemies[0].state.damage(10000)
	check(not action.active and action.spent==0 and action.remaining(Multi.ID)==0,"primary death during cast cancels immediately without cost or cooldown")
	check(action.request(Multi.ID,sim.enemies[1])>0,"can immediately retarget after cancellation")
	sim.enemies[1].place(Vector2(3,0));action.advance(.01,false,.01)
	check(not action.active and action.spent==0 and action.remaining(Multi.ID)==0,"primary out of range cancels without recovery")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8)])
	action.request(Multi.ID,sim.enemies[0]);release(mako)
	sim.enemies[0].state.damage(10000);mako.state.damage(10000);sim._prune();await settle();impact()
	check(sim.enemies.size()==2 and sim.enemies.all(func(e):return e.state.health==30),"released projectiles survive primary and caster death, including freed primary")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8)])
	action.request(Multi.ID,sim.enemies[0]);action.advance(10,true,10)
	check(action.elapsed==0 and action.spent==0,"cast pause")
	mako.buffs.apply(Buffs.definition(&"booster"));action.advance(1.15)
	check(action.casting(),"boosted cast not early")
	action.advance(.01);check(action.spent==20 and action.remaining(Multi.ID)==3,"Booster accelerates cast, cooldown starts at release")
	action.advance(.1);check(is_equal_approx(action.remaining(Multi.ID),2.87),"Booster accelerates cooldown")
	var left:float=sim.projectiles.pending[0].remaining
	sim.advance(10,true);check(sim.projectiles.pending[0].remaining==left,"combat pause freezes released projectiles")
	sim.reset();check(sim.projectiles.pending.is_empty(),"reset clears released targets")
	mako=await ready_mako();action=mako.action
	arrange([Vector2(0,0),Vector2(.8,0),Vector2(0,.8)])
	action.request(Multi.ID,sim.enemies[0]);release(mako)
	sim.enemies[0].state.damage(40);sim.enemies[0].state.died.connect(func():sim.projectiles.clear())
	impact();check(sim.enemies[1].state.health==60 and sim.projectiles.pending.is_empty(),"reentrant reset prevents remaining stale impacts")
	mako=await ready_mako()
	mako.place(Vector2(-3.5,0));arrange([Vector2(2,0),Vector2(2,1)])
	sim.rules.mako=[ice_order(),Orders.create()];sim._plan(mako)
	check(mako.desired_skill==Multi.ID and mako.desired_target==sim.enemies[0] and not mako.action.active,"out-of-range nearest valid primary pursued")
	sim._move(1.0/30);check(mako.position.x> -3.5,"normal navigation approaches")
	sim.rules.mako.insert(0,order("lightning","enemy_near"));sim._plan(mako)
	check(mako.desired_skill==&"lightning","higher gambit immediately preempts approach")
	sim.queue_free();world.queue_free();await settle();sim=null
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan nodes or projectile views")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
