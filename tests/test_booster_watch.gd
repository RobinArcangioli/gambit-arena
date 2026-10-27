extends Node
const Fade = preload("res://resources/presentation/effects/common_fade.tres")
const Profile = preload("res://resources/presentation/effects/booster.tres")
const Heal = preload("res://resources/presentation/effects/heal.tres")
const Watch = preload("res://scripts/presentation/booster_effect.gd")
const Adapter = preload("res://scripts/presentation/booster_presenter.gd")
const ActualLab = preload("res://scenes/debug/booster_lab.tscn")
const ArtLab = preload("res://scenes/debug/booster_watch_lab.tscn")
const Catalog = preload("res://scripts/buffs/buff_catalog.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("BoosterWatch: "+message)
func near(a: float,b: float) -> bool:return absf(a-b)<0.00001
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func fact(sequence: int, target: int=2, kind: String="buff_applied") -> Dictionary:
	return {"run_id":1,"sequence":sequence,"source_id":1,"target_id":target,"kind":kind,"skill":"booster","buff_id":"booster","outcome":"booster"}
func _ready() -> void:
	var orphans:int=int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	check(Heal.fade==Profile.fade and Heal.fade==Fade and near(Heal.duration,1) and near(Profile.duration,2),"heal and watch share a fade while retaining separate durations")
	for i in range(101):
		var p:float=float(i)/100
		check(near(Fade.sample(p),smoothstep(0,.06,p)*(1-smoothstep(.36,1,p))),"extracted fade exactly matches the old heal envelope")
	check(near(Fade.sample(-1),0) and near(Fade.sample(2),0) and near(Fade.sample(NAN),0),"invalid or outside progress produces no stray opacity")
	var viewport:=SubViewport.new();viewport.size=Vector2i(540,960);add_child(viewport)
	var world:=Node3D.new();viewport.add_child(world);var camera:=Camera3D.new();world.add_child(camera);camera.make_current();camera.rotation=Vector3(-.8,.3,0)
	var first=Profile.scene.instantiate();world.add_child(first);first.setup(Profile)
	var second=Profile.scene.instantiate();world.add_child(second);second.setup(Profile)
	check(first.materials[0]!=second.materials[0] and first.materials[1]!=second.materials[1],"simultaneous watches own separate materials")
	check(first.age==0 and first.opacity==0 and first.materials.all(func(m):return near(m.albedo_color.a,0)),"new watch starts completely transparent")
	first.advance_visual(.3)
	check(near(first.opacity,Profile.opacity) and second.opacity==0,"one watch fade cannot alter another")
	check(first.face.global_basis.is_equal_approx(camera.global_basis),"watch face stays readable toward the active camera")
	check(first.hands.size()==2 and first.angles.y>first.angles.x and first.angles.x>0,"two distinct hands turn clockwise with different speeds")
	var early:float=Watch.integrated_turns(.10,.3,3.5,.45)-Watch.integrated_turns(0,.3,3.5,.45)
	var late:float=Watch.integrated_turns(.40,.3,3.5,.45)-Watch.integrated_turns(.30,.3,3.5,.45)
	check(late>early*2,"hands accelerate visibly early in the two-second effect")
	check(near(Watch.integrated_turns(.45,.3,3.5,.45),Watch.integrated_turns(.45-.0000001,.3,3.5,.45)),"analytic integral is continuous at ramp end")
	var angles:Vector2=first.angles;var alpha:float=first.opacity
	for dt in [0,-1,INF,NAN]:first.advance_visual(dt)
	check(first.angles==angles and first.opacity==alpha and near(first.age,.3),"zero paused and invalid deltas cannot spin or fade")
	first.advance_visual(1.7)
	check(near(first.age,2) and near(first.opacity,0) and first.materials.all(func(m):return near(m.albedo_color.a,0)),"two-second watch fades to complete transparency")
	for hz in [30,60,120,144]:
		var sample=Profile.scene.instantiate();world.add_child(sample);sample.setup(Profile)
		for i in range(hz):sample.advance_visual(1.0/hz)
		check(near(sample.age,1) and near(sample.angles.y,TAU*Watch.integrated_turns(1,.3,3.5,.45)),"hand rotation independent of visual tick frequency")
		sample.queue_free()
	var heal=Heal.scene.instantiate();world.add_child(heal);heal.setup(Heal,30);heal.advance_visual(.4)
	check(near(heal.opacity,Fade.sample(.4)) and near(heal.duration,1) and heal.turns==Heal.turns and heal.amount==30,"heal extraction preserves duration rings amount and fade")
	viewport.queue_free();await settle()
	await test_adapter()
	await test_actual_combat()
	await test_art_lab()
	await settle();check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==orphans,"all watches trials actors and adapters are freed")
	var summary:String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
func test_adapter() -> void:
	var adapter:=Adapter.new();add_child(adapter);adapter.reset_run(1)
	adapter.advance_visual({2:{"position":Vector3(1,0,2),"alive":true}},0)
	for kind in ["start","resolve","cancel","end"]:adapter.consume(fact(1,2,kind))
	check(adapter.effects.is_empty(),"start resolve cancel end never substitute for a successful buff fact")
	var invalid:Dictionary=fact(1);invalid.buff_id="other";adapter.consume(invalid)
	invalid=fact(1);invalid.outcome="cancelled";adapter.consume(invalid)
	check(adapter.played==0,"other buffs and rejected applications never spawn a watch")
	adapter.consume(fact(1));check(adapter.played==1 and adapter.effects.size()==1,"one genuine success fact creates one watch")
	adapter.consume(fact(1));check(adapter.played==1,"replayed event cannot duplicate a watch")
	var view=adapter.effects[0].view
	check(view.position.is_equal_approx(Vector3(1,0,2)+Profile.origin),"watch starts at target effect anchor")
	adapter.advance_visual({2:{"position":Vector3(2,0,1),"alive":true,"time_scale":1.3}},.5)
	check(near(view.age,.5) and view.position.is_equal_approx(Vector3(2,0,1)+Profile.origin),"watch follows moving target while staying on world visual time")
	adapter.advance_visual({2:{"position":Vector3(2,0,1),"alive":true}},0)
	check(near(view.age,.5),"paused adapter freezes watch")
	adapter.advance_visual({},0);check(adapter.effects.is_empty(),"vanished target removes its existing watch")
	adapter.consume(fact(2));check(adapter.played==1,"missing target cannot gain a late watch")
	adapter.advance_visual({2:{"position":Vector3.ZERO,"alive":true}},0)
	for i in range(20):adapter.consume(fact(10+i))
	check(adapter.effects.size()==Adapter.MAX_EFFECTS,"watch count bounded under burst")
	adapter.consume({"run_id":1,"kind":"death","actor_id":2})
	check(adapter.effects.is_empty(),"death clears target watches synchronously")
	adapter.consume(fact(40));check(adapter.effects.is_empty(),"post-death success facts cannot create a watch")
	adapter.reset_run(2);adapter.consume(fact(41));check(adapter.effects.is_empty(),"old combat facts ignored after reset")
	adapter.reset_run(1);adapter.advance_visual({2:{"position":Vector3.ZERO,"alive":true}},0)
	adapter.definition=Profile.duplicate();adapter.definition.scene=null;adapter.consume(fact(1))
	check(adapter.effects.is_empty(),"missing optional scene is safe")
	adapter.queue_free();await settle()
func test_actual_combat() -> void:
	for enabled in [true,false]:
		var app=ActualLab.instantiate();add_child(app);app.set_process(false);app.set_physics_process(false);app.action_animations_enabled=enabled;await settle()
		for i in range(94):app._physics_process(1.0/60)
		var mako=app.simulation.hero(&"mako");var anne=app.simulation.hero(&"anne")
		check(mako.buffs.has(&"booster") and mako.action.spent==20 and not anne.buffs.has(&"booster"),"visual toggle never changes first buff or payment")
		check(app.action_presenter.booster.played==(1 if enabled else 0),"optional watches respond only to real first success")
		if enabled:
			var view=app.action_presenter.booster.effects[0].view;var age:float=view.age
			for i in range(30):app._physics_process(1.0/60)
			check(near(view.age-age,.5),"buffed target does not speed up its own watch")
			app._toggle_pause();age=view.age
			for i in range(30):app._physics_process(1.0/30)
			check(near(view.age,age),"product pause freezes existing success art")
			app._resume_combat();app._physics_process(1.0/60)
			var empty_events: Array[Dictionary] = []
			app.action_presenter.enabled=false;app.action_presenter.present(app.simulation.all_units(),empty_events,0,app.simulation.run_id)
			check(app.action_presenter.booster.effects.is_empty() and mako.buffs.has(&"booster"),"disabling art removes watch without removing logical buff")
		app.queue_free();await settle()
	var app=ActualLab.instantiate();add_child(app);app.set_process(false);app.set_physics_process(false);await settle()
	for i in range(188):app._physics_process(1.0/60)
	check(app.action_presenter.booster.played==2 and app.action_presenter.booster.effects.size()==2,"real two-ally sequence supports overlapping independent watches")
	for i in range(130):app._physics_process(1.0/60)
	check(app.action_presenter.booster.effects.is_empty() and app.simulation.hero(&"anne").buffs.has(&"booster"),"two-second art ends while sixty-second buff remains")
	app._reset();check(app.action_presenter.booster.effects.is_empty(),"replay clears all old art immediately")
	app.queue_free();await settle()
	for reason in ["death","range","mana","duplicate"]:
		app=ActualLab.instantiate();add_child(app);app.set_process(false);app.set_physics_process(false);await settle()
		app.simulation.rules.mako=[]
		var mako=app.simulation.hero(&"mako");var target=app.simulation.hero(&"anne")
		mako.action.request(&"booster",target)
		match reason:
			"death":target.state.damage(10000)
			"range":target.place(Vector2(-2.5,2.5));mako.place(Vector2(2.5,-2.5))
			"mana":mako.action.mana=0;mako.mana_regeneration=0
			"duplicate":target.buffs.apply(Catalog.definition(&"booster"))
		for i in range(130):app._physics_process(1.0/60)
		check(app.action_presenter.booster.played==0 and mako.action.spent==0,"cancelled or duplicate cast has no watch or debit: "+reason)
		app.queue_free();await settle()
func test_art_lab() -> void:
	var lab=ArtLab.instantiate();add_child(lab);lab.set_process(false);lab.set_physics_process(false);await settle()
	for trial in range(3):
		lab.choose_trial(trial)
		for i in range(30):lab._physics_process(1.0/60)
		check(lab.action_presenter.booster.effects.size()==1 and lab.selected==trial,"trial selection previews a configured watch")
		check(lab.simulation.heroes.all(func(u):return u.buffs.snapshot().is_empty() and u.action.spent==0 and u.state.health==u.state.max_health),"art trial never changes buffs mana or health")
	lab.queue_free();await settle()
