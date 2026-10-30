extends "res://tests/test_area_gameplay.gd"
func vacate() -> void:
	for target in sim.enemies:target.place(Vector2(3,2))
func _ready() -> void:
	await fixture()
	var anne=sim.hero(&"anne");var action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);vacate()
	action.advance(.49,false,.49)
	check(action.casting() and action.spent==0,"empty zone kept until first 0.5 s checkpoint")
	action.advance(.01,false,.01)
	check(not action.active and action.spent==0 and action.remaining(&"meteor")==0 and sim.projectiles.pending.is_empty(),"empty zone at 0.5 s cancels without launch, mana or cooldown")
	sim._collect_visual_events(sim.all_units())
	check(sim.events.filter(func(e):return e.kind=="cancel" and e.outcome=="zone vide").size()==1,"single explicit empty-zone cancellation fact")
	check(sim.report.recent.any(func(e):return e.kind=="cancel" and "zone vide" in e.text),"player journal explains empty-zone cancellation")
	sim.rules.anne=[order(),Orders.create()];sim._plan(anne)
	check(anne.desired_skill==&"meteor" and anne.ground_intention and anne.desired_point.distance_to(Vector2(3,2))<.001,"gambits reconsidered immediately and may aim at a new valid group")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(.5,false,.5);vacate()
	action.advance(.49,false,.49);check(action.casting(),"second checkpoint not premature after occupied first check")
	action.advance(.01,false,.01);check(not action.active and action.spent==0,"repeated checkpoint cancels at one second")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);vacate()
	action.advance(.4,false,.4);sim.enemies[0].place(Vector2.ZERO);action.advance(.1,false,.1)
	check(action.casting(),"one enemy is enough even if initial group of three dispersed")
	sim.enemies[0].state.damage(10000);sim.hero(&"mako").place(Vector2.ZERO)
	action.advance(.5,false,.5);check(not action.active,"dead enemies and living allies do not keep an empty enemy zone valid")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(.25,false,.25);vacate()
	action.advance(10,true,10);sim.clock.paused=true;action.advance(10,false,10)
	check(action.casting(),"pause does not consume check interval")
	sim.clock.paused=false;action.advance(.249,false,.249);check(action.casting(),"interval resumes without skipping remaining combat time")
	action.advance(.001,false,.001);check(not action.active,"empty check resumes at exact half-second boundary")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	anne.buffs.apply(Buffs.definition(&"booster"));action.request_ground(&"meteor",Vector2.ZERO);vacate()
	action.advance(.49);check(action.casting(),"Booster does not accelerate half-second combat check")
	action.advance(.01);check(not action.active and action.spent==0,"boosted cast cancels at half-second combat time")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(.5,false,.5)
	vacate();action.advance(1.0/30,false,1.0/30)
	check(action.casting(),"floating-point boundary does not repeat check on next frame")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	sim.enemies[0].place(Vector2(1.4,0))
	for i in range(1,6):sim.enemies[i].place(Vector2(3,2))
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	check(action.spent==40 and sim.projectiles.pending.size()==1,"enemy exactly at AOE boundary allows release")
	vacate();sim.projectiles.advance(1.0/1.3,sim.all_units(),4)
	check(sim.projectiles.events.back().kind=="area_impact" and sim.projectiles.events.back().area_count==0,"no empty-zone cancellation after release")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);vacate();action.advance(.5,false,.5)
	sim.enemies[0].place(Vector2.ZERO)
	check(action.request_ground(&"meteor",Vector2.ZERO)>0,"new ground cast accepted immediately after cancellation")
	action.advance(.49,false,.49);vacate();check(action.casting(),"new cast restarts check schedule")
	action.advance(.01,false,.01);check(not action.active,"new cast independent checkpoint cancels correctly")
	sim.queue_free();world.queue_free();await settle();sim=null
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan nodes after cancellation cases")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
