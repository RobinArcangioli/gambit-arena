extends "res://tests/test_area_gameplay.gd"
const Presenter=preload("res://scripts/presentation/meteor_presenter.gd")
func _ready() -> void:
	await fixture()
	var anne=sim.hero(&"anne");var action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	check(sim.projectiles.pending.size()==1 and sim.enemies[0].state.health==60,"one released projectile and no early damage")
	sim._collect_visual_events(sim.all_units())
	var launch:Dictionary=sim.events.filter(func(e):return e.kind=="area_launch")[0]
	var art:=Presenter.new();world.add_child(art);art.reset_run(sim.run_id);art.consume(launch)
	art.consume(launch);check(art.effects.size()==1,"duplicate release does not duplicate art")
	var view=art.effects.values()[0]
	art.advance_visual(.5);var position:Vector3=view.rock.position
	art.advance_visual(0);check(view.rock.position==position,"visual pause freezes flight")
	sim.projectiles.advance(1.0/1.3-.001,sim.all_units(),1)
	check(sim.enemies[0].state.health==60 and sim.projectiles.events.is_empty(),"no impact before thirty-percent faster flight ends")
	for i in range(3):sim.enemies[i].place(Vector2(-3,i))
	sim.enemies[3].place(Vector2.ZERO)
	anne.state.damage(10000)
	sim.projectiles.advance(.001,sim.all_units(),1.001)
	check(sim.enemies[3].state.health==20 and sim.enemies[0].state.health==60,"occupants chosen at impact after caster death")
	var events:Array[Dictionary]=sim.projectiles.take_events()
	for event in events:
		event.run_id=sim.run_id;art.consume(event)
	check(view.exploding and view.age==0 and is_equal_approx(view.radius,1.4),"explosion starts exactly on authoritative impact and uses full radius")
	art.advance_visual(.99);check(art.effects.size()==1,"explosion retained for one second")
	art.advance_visual(.01);check(art.effects.is_empty(),"explosion cleaned after one second")
	sim.projectiles.advance(10,sim.all_units(),11)
	check(sim.enemies[3].state.health==20 and sim.projectiles.events.is_empty(),"impact cannot repeat")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	sim.rules.anne=[]
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	var remaining:float=sim.projectiles.pending[0].remaining
	sim.advance(1,true);check(sim.projectiles.pending[0].remaining==remaining,"paused simulation freezes projectile")
	sim.clock.paused=true;sim.advance(1);check(sim.projectiles.pending[0].remaining==remaining,"clock pause freezes projectile")
	sim.clock.paused=false;anne.buffs.apply(Buffs.definition(&"booster"))
	sim.advance(1.0/30)
	check(is_equal_approx(sim.projectiles.pending[0].remaining,1.0/1.3-1.0/30),"Booster does not accelerate an already released meteor")
	sim.reset();check(sim.projectiles.pending.is_empty(),"new combat clears all released projectiles")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	sim._finish("DEFAITE");check(sim.projectiles.pending.is_empty(),"terminal combat clears in-flight spells")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	for target in sim.enemies.slice(0,3):target.state.damage(10000)
	sim.projectiles.advance(1,sim.all_units(),4)
	check(sim.projectiles.events.back().area_count==0 and action.spent==40,"empty impact still explodes without refund")
	await fixture();anne=sim.hero(&"anne");action=anne.action
	action.request_ground(&"meteor",Vector2.ZERO);action.advance(3,false,3)
	sim.enemies[0].state.damage(30)
	sim.enemies[0].state.died.connect(func():sim.projectiles.clear())
	sim.projectiles.advance(1,sim.all_units(),4)
	check(sim.enemies[1].state.health==60 and sim.projectiles.events.is_empty(),"reset during lethal callback prevents remaining stale impacts")
	sim.queue_free();world.queue_free();await settle();sim=null
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan effects or projectiles")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
