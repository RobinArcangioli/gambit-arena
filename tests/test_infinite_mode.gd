extends Node
const Sim = preload("res://scripts/party/party_simulation.gd")
const Schedule = preload("res://scripts/waves/infinite_schedule.gd")
const Bounds = preload("res://scripts/arena/arena_bounds.gd")
const Buffs = preload("res://scripts/buffs/buff_catalog.gd")
const App = preload("res://scenes/app/app_root.tscn")
const Choice = preload("res://scripts/app/arena_choice.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error("Infinite: " + message)
func near(a: float,b: float) -> bool: return absf(a-b)<0.00001
func settle() -> void:
	await get_tree().process_frame; await get_tree().process_frame
func kill_wave(sim: Sim) -> void:
	for enemy in sim.enemies: enemy.state.damage(100000)
	sim.advance(1.0/60)
func wait_wave(sim: Sim) -> void:
	for i in range(90): sim.advance(1.0/30)
func _ready() -> void:
	var world := Node3D.new(); add_child(world)
	var sim := Sim.new(); world.add_child(sim); sim.configure(world)
	sim.infinite_mode=true; sim.orders_enabled=true; sim.rules={"mako":[],"anne":[]}; sim.reset()
	var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
	check(sim.wave_number==1 and sim.enemies.size()==6 and sim.wave.issued==6,"six enemies appear together at the initial wave")
	check(sim.heroes.all(func(h):return h.position.z>absf(h.position.x)),"heroes start southwest in the isometric camera")
	check(sim.enemies.all(func(e):return e.position.x>=e.position.z and e.position.x+e.position.z<=0),"enemies start northeast")
	var rng:=RandomNumberGenerator.new();rng.seed=8192
	var formations_ok:bool=true
	for sample in range(100):
		var occupied:Array[Vector2]=[Vector2(rng.randf_range(-2.65,2.65),rng.randf_range(-2.65,2.65)),Vector2(rng.randf_range(-2.65,2.65),rng.randf_range(-2.65,2.65))]
		var group:Array[Vector2]=Schedule.formation(occupied)
		formations_ok=formations_ok and group.size()==6
		for p in group:
			formations_ok=formations_ok and Bounds.contains_ground(p) and p.x>=p.y and p.x+p.y<=0.00001
			for q in occupied: formations_ok=formations_ok and p.distance_to(q)>=0.71
			for q in group:
				if q!=p: formations_ok=formations_ok and p.distance_to(q)>=0.71
	check(formations_ok,"six safe NE slots remain available even when heroes occupy the spawn area")
	# No new arrivals while any of the six enemies is still alive.
	for e in sim.enemies: e.abilities.clear();e.mover.speed=0
	for i in range(5): sim.enemies[i].state.damage(100000)
	sim.advance(1.0/60)
	for i in range(120):sim.advance(1.0/30)
	check(sim.enemies.size()==1 and sim.wave_number==1 and not sim.infinite.waiting,"no partial replacement before the final enemy dies")
	mako.state.damage(37);mako.action.mana=17;mako.buffs.apply(Buffs.definition(&"booster"));mako.action.cooldowns[&"lightning"]=2.0
	var hp:int=mako.state.health;var positions:Array=[mako.position,anne.position];var run:int=sim.run_id
	kill_wave(sim)
	var mana:float=mako.action.mana;var buff_left:float=mako.buffs.remaining(&"booster")
	check(sim.enemies.is_empty() and sim.infinite.waiting and near(sim.infinite.remaining,3),"last death starts a full three-second wait")
	var frozen:Array=[sim.clock.elapsed,sim.infinite.remaining,mako.action.mana,mako.buffs.remaining(&"booster")]
	sim.advance(30,true);sim.clock.paused=true;sim.advance(30);sim.clock.paused=false
	sim.advance(NAN);sim.advance(-1)
	check(frozen==[sim.clock.elapsed,sim.infinite.remaining,mako.action.mana,mako.buffs.remaining(&"booster")],"pause and invalid deltas cannot consume countdown or actor time")
	for i in range(89):sim.advance(1.0/30)
	check(sim.enemies.is_empty() and sim.wave_number==1 and sim.infinite.remaining>0,"no early spawn before three accepted seconds")
	sim.advance(1.0/30)
	check(sim.wave_number==2 and sim.enemies.size()==6 and not sim.infinite.waiting,"exactly six enemies appear when three seconds elapse")
	check(sim.hero(&"mako")==mako and sim.hero(&"anne")==anne and sim.run_id==run,"wave transition preserves actor identity and run")
	check(mako.state.health==hp and [mako.position,anne.position]==positions,"health and positions are not reset")
	check(near(mako.action.mana,mana+15) and near(mako.buffs.remaining(&"booster"),buff_left-3) and mako.action.remaining(&"lightning")==0,"mana regeneration buff lifetime and personal cooldown continue through intermission")
	for expected in range(3,26):
		kill_wave(sim);wait_wave(sim)
		check(sim.wave_number==expected and sim.enemies.size()==6 and sim.result=="EN COURS","endless waves continue beyond the former three-wave victory")
	check(sim._death_ids.size()<=2,"completed enemy lifetime bookkeeping stays bounded")
	kill_wave(sim);mako.state.damage(100000);anne.state.damage(100000);sim.advance(1.0/30)
	check(sim.result=="DEFAITE" and sim.clock.stopped,"hero defeat terminates the endless run during countdown")
	var wave_number:int=sim.wave_number
	for i in range(100):sim.advance(1.0/30)
	check(sim.wave_number==wave_number and sim.enemies.is_empty(),"no wave appears after defeat")
	sim.reset()
	check(sim.wave_number==1 and sim.enemies.size()==6 and not sim.infinite.waiting and sim.hero(&"mako").state.health==180,"replay restores a fresh wave one")
	sim.clear();world.queue_free();await settle()
	# Actual product routing, layout, art-only rotation, pause, replay and abandonment.
	for resolution in [Vector2i(540,960),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="user://infinite001-test.json";viewport.add_child(app);await settle()
		check(app.arena_button.text=="Mode Infini" and app.combat==null,"Home exposes only Mode Infini without starting combat")
		app.open_arena();await settle()
		var page=app.combat;page.set_process(false);page.set_physics_process(false)
		page.simulation.rules={"mako":[],"anne":[]}
		check(page.infinite_mode and page.simulation.infinite_mode and page.simulation.enemies.size()==6,"product route enables infinite mode while legacy labs stay separate")
		check(page.wave_counter.text=="Vague 1" and page.wave_counter.get_rect().end.y<=page.hero_panels[0].position.y,"wave counter sits just above bottom grid")
		mako=page.simulation.hero(&"mako");mako.state.damage(20);mako.action.mana=21;mako.buffs.apply(Buffs.definition(&"booster"))
		var state=mako.state;var buffs=mako.buffs;var at:Vector3=mako.position;var initial:StringName=page.chosen_arena;var draws:int=app.arena_choice.draws
		page.simulation.wave_number=10;page._present()
		check(page.chosen_arena==initial and app.arena_choice.draws==draws,"same arena is retained through wave ten")
		kill_wave(page.simulation);page._present();await settle()
		check(page.countdown.visible and page.countdown.text=="3" and page.countdown.get_global_rect().end.y<page.wave_counter.get_global_rect().position.y,"gold countdown is visible in arena below wave counter")
		check(page.countdown.get_theme_color("font_color")==Color("ffd16a") and page.countdown.get_theme_color("font_outline_color")==Color("173a70"),"countdown respects gold and blue palette")
		page._toggle_pause();var left:float=page.simulation.infinite.remaining
		page._physics_process(3);check(page.simulation.infinite.remaining==left,"product pause freezes wave countdown")
		page._resume_combat();await settle();page.application_guard.consume_return_step()
		wait_wave(page.simulation);page._present();await settle()
		check(page.simulation.wave_number==11 and page.chosen_arena!=initial and app.arena_choice.draws==draws+1,"wave eleven chooses a different random arena exactly once")
		check(page.simulation.hero(&"mako").state==state and mako.buffs==buffs and mako.state.health==160 and mako.position==at and mako.buffs.has(&"booster"),"art rotation preserves actual health mana buff container and position")
		check(not page.countdown.visible and page.wave_counter.text=="Vague 11","countdown disappears and counter advances with batch spawn")
		page._present();check(app.arena_choice.draws==draws+1,"ordinary redraws never reroll arena")
		page.simulation.wave_number=20;page._present();initial=page.chosen_arena
		kill_wave(page.simulation);wait_wave(page.simulation);page._present()
		check(page.chosen_arena!=initial and app.arena_choice.draws==draws+2,"rotation repeats at wave twenty-one")
		check(page.action_presenter._sequences.size()<=8 and page.action_presenter._dead_ids.size()<=2 and page.action_presenter.booster._dead.size()<=2,"presentation history retires completed enemy lifetimes")
		page._toggle_pause();page._replay_combat();await settle()
		check(page.simulation.wave_number==1 and page.simulation.enemies.size()==6 and not page.countdown.visible,"product Replay restarts mode and countdown")
		page._toggle_pause();page._ask_abandon();page._confirm_abandon();await settle()
		check(app.route==&"home" and app.combat==null,"confirmed abandonment returns to Home and destroys infinite combat")
		viewport.queue_free();await settle()
	var choice:=Choice.new();var no_repeats:bool=true;var previous:StringName=choice.next()
	for i in range(100):
		var next:StringName=choice.next_excluding(previous);no_repeats=no_repeats and next!=previous and next!=&"reference";previous=next
	check(no_repeats,"random rotation excludes current arena and reference arena")
	var summary:="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	var label:=Label.new();label.text=summary;add_child(label);print(summary)
