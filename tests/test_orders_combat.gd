extends Node
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
var checks: int=0
var failures: int=0
func check(ok: bool, text: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func _ready() -> void:
	var world:=Node3D.new();add_child(world)
	var sim:=Simulation.new();add_child(sim);sim.configure(world);sim.orders_enabled=true;sim.rules=Orders.defaults();sim.reset()
	var anne=sim.hero(&"anne");var mako=sim.hero(&"mako")
	anne.place(Vector2.ZERO);mako.place(Vector2(0.8,0))
	sim.add_enemy(Vector2(0,0.8));sim.add_enemy(Vector2(-2,0))
	var near=sim.enemies[0];var far=sim.enemies[1]
	mako.offensive_focus=near;mako.focus_state=near.state
	sim.rules.mako=[{"enabled":true,"criterion":"enemy_far","skill":"basic"}];sim._plan(mako)
	check(mako.desired_target==far,"far criterion beats remembered near focus")
	near.state.damage(30);sim.rules.mako[0].criterion="enemy_hp_max";sim._plan(mako)
	check(mako.desired_target==far,"absolute maximum PV beats near focus")
	anne.state.damage(100);mako.state.damage(100)
	sim.rules.mako[0].criterion="ally_hp_lt_90";sim.rules.mako[0].skill="lightning";sim._plan(mako)
	check(mako.desired_target==anne,"offensive ability uses lowest allied percentage")
	check(mako.action.request(&"lightning",anne)>0,"friendly lightning accepted")
	var hp: int=anne.state.health;mako.action.advance(1.99)
	check(anne.state.health==hp and mako.action.spent==0,"no damage or debit before two seconds")
	mako.action.advance(.01);check(anne.state.health<hp and mako.action.spent==30,"friendly damage and debit at resolution")
	check(anne.action.request(&"heal",near)>0,"enemy heal accepted")
	var enemy_hp: int=near.state.health;anne.action.advance(1.49)
	check(near.state.health==enemy_hp and anne.action.spent==0,"heal preparation preserves mana")
	anne.action.advance(.01);check(near.state.health==enemy_hp+30 and anne.action.spent==20,"enemy healed after 1.5 seconds")
	anne.action.advance(5);anne.state.heal(140)
	check(anne.action.request(&"basic",anne)>0,"self attack accepted")
	var self_hp: int=anne.state.health;anne.action.advance(.6);check(anne.state.health==self_hp-maxi(1,anne.state.attack-anne.state.defense),"self damage resolves once")
	anne.action.advance(1);near.state.damage(10)
	check(anne.action.request(&"heal",near)>0,"new heal accepted")
	var spent: int=anne.action.spent;near.state.damage(1000);anne.action.advance(2)
	check(anne.action.spent==spent and not anne.action.active,"dead target cancels without debit")
	mako.action.advance(8);sim.rules.mako=[];sim._plan(mako)
	check(mako.desired_target==null,"empty list has no hidden fallback")
	sim.rules.mako=[{"enabled":false,"criterion":"enemy_near","skill":"basic"}];sim._plan(mako)
	check(mako.desired_target==null,"disabled list has no hidden fallback")
	sim.clear();sim.queue_free();world.queue_free();await get_tree().process_frame;await get_tree().process_frame
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no leaked units")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
