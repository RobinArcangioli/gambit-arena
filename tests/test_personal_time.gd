extends Node
const Definition = preload("res://scripts/buffs/buff_definition.gd")
const Buffs = preload("res://scripts/buffs/buff_state.gd")
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Crowd = preload("res://scripts/crowd/ground_crowd.gd")
const Unit = preload("res://scripts/party/party_unit.gd")
const Profile = preload("res://data/party/mako.tres")
const Appearance = preload("res://resources/presentation/characters/mako.tres")
const Presenter = preload("res://scripts/presentation/combat_presenter.gd")
const Lab = preload("res://scenes/debug/personal_time_lab.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error("PersonalTime: " + message)
func near(a: float, b: float) -> bool: return absf(a-b) < 0.00001
func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
func fixture() -> Simulation:
	var world := Node3D.new(); add_child(world)
	var sim := Simulation.new(); world.add_child(sim); sim.configure(world)
	sim.orders_enabled = true; sim.rules = {"anne": [], "mako": []}; sim.reset(); sim.wave.cap = 0
	return sim
func dispose(sim: Simulation) -> void:
	sim.clear(); sim.world.queue_free()
func actor(world: Node3D, at: Vector2) -> Unit:
	var unit := Unit.new(); unit.presentation_enabled = false; unit.configure_party(Profile)
	world.add_child(unit); unit.place(at)
	return unit
func _ready() -> void:
	var initial_orphans: int = int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var definition: Dictionary = Definition.create(&"haste", 60.0, 1.30)
	check(definition.is_read_only(), "shared definition is immutable")
	for invalid in [Definition.create(&"",60,1.3),Definition.create(&"bad",0,1.3),Definition.create(&"bad",INF,1.3),Definition.create(&"bad",60,NAN),Definition.create(&"bad",60,-1)]:
		check(invalid.is_empty(), "invalid definitions rejected")
	var buffs := Buffs.new()
	check(near(buffs.advance(1),1) and near(buffs.multiplier(),1), "default clock is unchanged")
	check(not buffs.apply({}) and not buffs.apply({"id":&"bad","duration":"60","time_multiplier":1.3,"stacking":&"reject_active"}), "malformed values cannot become runtime buffs")
	check(buffs.apply(definition), "first application accepted")
	check(near(buffs.advance(10),13) and near(buffs.remaining(&"haste"),50), "personal time accelerated, duration on normal time")
	check(not buffs.apply(definition) and near(buffs.remaining(&"haste"),50), "active buff cannot stack or refresh")
	var detached: Dictionary = buffs.snapshot(); detached.haste.remaining = 1000; detached.clear()
	check(near(buffs.remaining(&"haste"),50), "snapshots are detached values")
	check(near(buffs.advance(51),66) and not buffs.has(&"haste") and near(buffs.multiplier(),1), "expiry splits boosted and normal portions")
	check(buffs.apply(definition), "expired buff can be applied again")
	for dt in [0.0,-1.0,INF,NAN]: check(near(buffs.advance(dt),0) and near(buffs.remaining(&"haste"),60), "invalid time never progresses")
	buffs.clear(); check(buffs.snapshot().is_empty(), "reset removes all runtime states")
	for hz in [30,60,120,144]:
		buffs.apply(definition); var total: float = 0
		for i in range(60*hz): total += buffs.advance(1.0/hz)
		check(near(total,78) and not buffs.has(&"haste"), "sixty seconds independent of tick frequency")
		check(near(buffs.advance(1.0/hz),1.0/hz), "next step is exactly normal")
	buffs.apply(Definition.create(&"short",0.01,1.3)); buffs.apply(Definition.create(&"long",0.02,2))
	check(near(buffs.advance(0.03),0.056) and buffs.snapshot().is_empty(), "multiple expiry boundaries integrate in stable order")
	await test_actions()
	await test_movement()
	await test_presentation()
	await test_lab()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == initial_orphans, "no orphan units or visual tails")
	print("%s : %d controles, %d echecs" % ["OK" if failures==0 else "ECHEC", checks, failures])
	var label:=Label.new();label.text="%d controles, %d echecs" % [checks,failures];add_child(label)
func test_actions() -> void:
	var sim := fixture(); var anne = sim.hero(&"anne"); var mako = sim.hero(&"mako")
	for unit in sim.heroes:
		unit.abilities.assign([&"basic",&"heal",&"lightning"]); unit.action.mana=20; unit.state.damage(35)
		check(unit.action.request(&"heal",unit)>0, "same base cast accepted for either hero")
	mako.buffs.apply(Definition.create(&"haste",60,1.3))
	for i in range(30): sim.advance(1.0/60)
	check(near(mako.action.elapsed,0.65) and near(anne.action.elapsed,0.5), "casts progress at x1.30 with identical reference duration")
	check(near(mako.action.mana,22.5) and near(anne.action.mana,22.5), "mana regeneration is not accelerated")
	check(near(mako.action.remaining(&"heal"),3.35) and near(anne.action.remaining(&"heal"),3.5), "cooldowns use personal time")
	check(near(mako.action.cast_progress(),0.65/1.5), "cast bar reads actual executor progress")
	var elapsed: float=mako.action.elapsed; var remaining: float=mako.buffs.remaining(&"haste"); var mana: float=mako.action.mana
	for i in range(100): sim.advance(10,true)
	check(near(mako.action.elapsed,elapsed) and near(mako.buffs.remaining(&"haste"),remaining) and near(mako.action.mana,mana), "pause freezes all clocks and mana")
	sim.clock.paused=true; sim.advance(1); sim.clock.paused=false
	check(near(mako.action.elapsed,elapsed), "shared clock gate also freezes personal time")
	for i in range(40): sim.advance(1.0/60)
	check(mako.action.resolved and not anne.action.resolved and mako.action.spent==20 and anne.action.spent==0, "buffed heal resolves at base duration / 1.30, pays only once at release")
	for i in range(21): sim.advance(1.0/60)
	check(anne.action.resolved and anne.action.spent==20, "normal caster keeps base duration")
	var state: Dictionary=sim.snapshot(mako);state.source.buffs.clear()
	check(mako.buffs.has(&"haste"), "combat snapshots cannot mutate buffs")
	sim.reset(); anne=sim.hero(&"anne");mako=sim.hero(&"mako");sim.wave.cap=0
	check(mako.buffs.snapshot().is_empty() and near(mako.personal_elapsed,0), "replay starts fresh at normal speed")
	mako.state.damage(40);mako.abilities.assign([&"heal"]);mako.action.request(&"heal",mako)
	for i in range(30):sim.advance(1.0/60)
	mako.buffs.apply(Definition.create(&"short",0.01,1.3));sim.advance(0.02)
	check(near(mako.action.elapsed,0.523) and near(mako.personal_delta,0.023) and near(mako.buffs.multiplier(),1), "cast continues without restart across mid-step expiration")
	mako.buffs.apply(Definition.create(&"haste",60,1.3));mako.state.damage(10000)
	check(mako.buffs.snapshot().is_empty() and near(mako.death_time_scale,1.3), "death clears logical buffs immediately and retains presentation rate")
	var deaths: Array[Dictionary]=[]
	sim.advance(1.0/60)
	for event in sim.events:
		if event.kind=="death":deaths.append(event)
	check(deaths.size()==1 and near(deaths[0].time_scale,1.3), "death event carries copied rate")
	dispose(sim);await settle()
	# A buff arriving from an earlier actor's release must not affect time already accepted.
	sim=fixture();anne=sim.hero(&"anne");mako=sim.hero(&"mako")
	anne.place(Vector2.ZERO);mako.place(Vector2(0.8,0));mako.state.damage(35)
	anne.action.request(&"heal",mako);anne.action.elapsed=1.49
	mako.abilities.assign([&"heal"]);mako.action.request(&"heal",mako)
	mako.state.health_changed.connect(func(_current,_maximum):mako.buffs.apply(Definition.create(&"arriving",60,1.3)))
	sim.advance(0.02)
	check(mako.buffs.has(&"arriving") and near(mako.action.elapsed,0.02) and near(mako.buffs.remaining(&"arriving"),60), "application during resolution is effective on the next accepted step only")
	sim.advance(0.02);check(near(mako.action.elapsed,0.046), "following step uses newly acquired rate once")
	sim.heroes[0].buffs.apply(Definition.create(&"haste",60,1.3));sim.clear()
	check(anne.buffs.snapshot().is_empty() and mako.buffs.snapshot().is_empty(), "abandon clears buffs before freeing units")
	sim.world.queue_free();await settle()
	# Raw executor adapter still separates combat mana and personal action time.
	sim=fixture();mako=sim.hero(&"mako");anne=sim.hero(&"anne");mako.place(Vector2.ZERO);anne.place(Vector2(0.8,0))
	mako.buffs.apply(Definition.create(&"haste",60,1.3));mako.action.request(&"basic",anne)
	mako.action.advance(0.3);check(near(mako.action.elapsed,0.39) and not mako.action.resolved,"attack windup uses actor time")
	mako.action.advance(0.17);check(mako.action.resolved and mako.action.active,"accelerated attack reaches impact")
	mako.action.advance(0.3);check(not mako.action.active and mako.action.phase=="TERMINEE","recovery uses same personal clock")
	dispose(sim);await settle()
	# Full combat clock, not only the buff container; oversized input is accepted once.
	sim=fixture();mako=sim.hero(&"mako");anne=sim.hero(&"anne")
	mako.buffs.apply(Definition.create(&"haste",60,1.3));mako.action.mana=0;anne.action.mana=0
	sim.advance(10)
	check(near(sim.clock.elapsed,1.0/30) and near(mako.personal_elapsed,1.3/30) and near(mako.buffs.remaining(&"haste"),60-1.0/30),"clock clamp is applied once before personal acceleration")
	for i in range(1799):sim.advance(1.0/30)
	check(near(sim.clock.elapsed,60) and near(mako.personal_elapsed,78) and near(anne.personal_elapsed,60),"real simulation runs 60 combat seconds with only buffed actor accelerated")
	check(mako.buffs.snapshot().is_empty() and near(mako.action.mana,anne.action.mana),"full lifetime expires independently of personal time and mana")
	dispose(sim);await settle()
	# Foudre uses the same local clock as heal without changing its base 2 seconds.
	sim=fixture();mako=sim.hero(&"mako");anne=sim.hero(&"anne")
	mako.place(Vector2.ZERO);anne.place(Vector2(0.8,0));mako.buffs.apply(Definition.create(&"haste",60,1.3))
	mako.action.request(&"lightning",anne)
	for i in range(92):sim.advance(1.0/60)
	check(not mako.action.resolved and near(mako.action.cast_progress(),(92.0/60)*1.3/2),"lightning remains pending until accelerated two-second cast completes")
	sim.advance(1.0/60)
	check(mako.action.resolved and mako.action.spent==30,"lightning resolves near 1.538 real seconds with original cost")
	dispose(sim);await settle()
func test_movement() -> void:
	for navigation in [false,true]:
		var distances: Array[float]=[]
		for boosted in [false,true]:
			var sim:=fixture();sim.navigation_enabled=navigation
			var mako=sim.hero(&"mako");sim.hero(&"anne").place(Vector2(2,2));mako.place(Vector2(-2,-2))
			var target:=actor(sim.world,Vector2(2,-2));mako.desired_target=target;mako.desired_skill=&"basic";mako.mover.set_target(target)
			if boosted:mako.buffs.apply(Definition.create(&"haste",60,1.3))
			for i in range(6):sim._move(1.0/60)
			distances.append(mako.mover.ground_position.distance_to(Vector2(-2,-2)))
			check(sim.navigation_searches_last_tick<=Simulation.MAX_NAV_SEARCHES_PER_TICK,"search budget is global and bounded")
			dispose(sim);await settle()
		check(near(distances[0],0.12) and near(distances[1],0.156),"direct and routed travel lift the fixed 1.2 speed clamp")
	var points: Array[Vector2]=[Vector2(0,0),Vector2(0.71,0)]
	var moved: Array[Vector2]=Crowd.solve(points,[Vector2.RIGHT,Vector2.ZERO],[false,false],1.0/30,[0.052,0.0])
	check(moved[0].distance_to(moved[1])>=Crowd.DIAMETER-0.00001,"faster requested travel still obeys swept disk collision")
	moved=Crowd.solve([Vector2(2.5,0)],[Vector2.RIGHT],[false],1.0/30,[0.052])
	check(moved[0].x<=2.6,"movement remains inside terrain bounds")
func test_presentation() -> void:
	var sim:=fixture();var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
	mako.set_appearance(Appearance);anne.set_appearance(Appearance)
	var presenter:=Presenter.new();sim.world.add_child(presenter)
	mako.buffs.apply(Definition.create(&"haste",60,1.3))
	for i in range(30):
		sim.advance(1.0/60);presenter.present(sim.all_units(),sim.events,1.0/60,sim.run_id)
	check(near(mako.visual.sample_time,0.65) and near(anne.visual.sample_time,0.5),"idle animation receives actor time exactly once")
	check(near(mako.visual.player.speed_scale,1),"no double multiplier on AnimationPlayer")
	mako.visual.react_hit();var hit:float=mako.visual.hit_remaining
	sim.advance(1.0/60);presenter.present(sim.all_units(),sim.events,1.0/60,sim.run_id)
	check(near(mako.visual.hit_remaining,hit-1.3/60),"HitReact uses same personal time while idle")
	presenter._heal({"target_id":mako.combat_id,"target_position":mako.position,"healing":30})
	presenter.present(sim.all_units(),[],0.1,sim.run_id)
	check(presenter.heal_effects.size()==1 and near(presenter.heal_effects[0].age,0.1),"autonomous heal VFX stays on normal time even on a buffed target")
	presenter.capture(sim.all_units(),sim.run_id);mako.state.damage(10000);sim.advance(1.0/60)
	presenter.present(sim.all_units(),sim.events,1.0/60,sim.run_id)
	check(presenter.ghosts.size()==1 and near(presenter.ghosts[0].time_scale,1.3),"death view keeps rate after logical buff was cleared")
	var ghost:Dictionary=presenter.ghosts[0]
	presenter.present(sim.all_units(),[],0.1,sim.run_id)
	check(near(ghost.view.death_elapsed,0.13) and near(ghost.age,0.13),"death clip and removal use the same accelerated clock")
	presenter.present(sim.all_units(),[],0,sim.run_id)
	check(near(ghost.view.death_elapsed,0.13),"paused death tail is frozen")
	presenter.reset_run(sim.run_id+1);check(presenter.ghosts.is_empty(),"reset removes accelerated visual tails")
	dispose(sim);await settle()
func test_lab() -> void:
	var lab=Lab.instantiate();add_child(lab);lab.set_physics_process(false);lab.set_process(false);await settle()
	check(lab.save_path=="user://buffs001_isolated_lab.json" and lab.simulation.wave.cap==0,"F6 laboratory is isolated from player configuration")
	lab.apply_haste(&"mako");lab.compare_casts()
	for i in range(30):lab._physics_process(1.0/60)
	check(near(lab.simulation.hero(&"mako").action.elapsed,0.65) and near(lab.simulation.hero(&"anne").action.elapsed,0.5),"laboratory comparison uses real simulation and cast bars")
	lab._toggle_pause();var before:float=lab.simulation.hero(&"mako").personal_elapsed
	for i in range(20):lab._physics_process(1.0/30)
	check(near(lab.simulation.hero(&"mako").personal_elapsed,before),"product pause menu freezes accelerated lab")
	lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	check(lab.paused,"return to foreground requires explicit resume")
	lab.queue_free();await settle()
