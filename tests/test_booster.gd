extends Node
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Catalog = preload("res://scripts/buffs/buff_catalog.gd")
const Definition = preload("res://scripts/buffs/buff_definition.gd")
const BuffState = preload("res://scripts/buffs/buff_state.gd")
const Preset = preload("res://scripts/buffs/booster_preset.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Store = preload("res://scripts/gambits/configuration_store.gd")
const Reference = preload("res://scripts/app/hero_reference.gd")
const Page = preload("res://scenes/app/gambits_page.tscn")
const Lab = preload("res://scenes/debug/booster_lab.tscn")
const Executor = preload("res://scripts/party/party_executor.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("Booster: "+message)
func near(a: float,b: float) -> bool:return absf(a-b)<0.00001
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func order(criterion: String="ally_roster",skill: String="booster") -> Dictionary:
	return {"enabled":true,"criterion":criterion,"skill":skill}
func fixture() -> Simulation:
	var world:=Node3D.new();add_child(world)
	var sim:=Simulation.new();world.add_child(sim);sim.configure(world);sim.orders_enabled=true
	sim.rules={"anne":[],"mako":[]};sim.reset();sim.wave.cap=0
	return sim
func dispose(sim: Simulation) -> void:sim.clear();sim.world.queue_free()
func facts(events: Array[Dictionary]) -> Array[Dictionary]:return events.filter(func(e):return e.kind=="buff_applied")
func _ready() -> void:
	var orphans:int=int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	check(Executor.cost(&"booster")==20 and near(Executor.cast_duration(&"booster"),1.5) and near(Executor.cooldown(&"booster"),0) and near(Executor.skill_reach(&"booster"),4),"Booster cost cast recharge reach match approved values")
	check(Catalog.definition(&"booster").is_read_only() and Catalog.definition(&"unknown").is_empty(),"buff definition is shared immutable metadata")
	check(Orders.PROFILES[&"mako"].abilities==[&"basic",&"lightning",&"booster"] and Orders.PROFILES[&"anne"].abilities==[&"basic",&"heal"],"only Mako gains Booster, old skills retained")
	for criterion in Criteria.IDS:
		check(Orders.valid_order(order(String(criterion)),&"mako") and not Orders.valid_order(order(String(criterion)),&"anne"),"every criterion can be paired with Mako's buff")
	var reference:Dictionary=Reference.read(&"mako");var buff:Dictionary=reference.skills[2]
	check(buff.name=="Booster" and buff.cost==20 and near(buff.duration,1.5) and buff.description.contains("60 s") and buff.description.contains("30 %"),"hero sheet exposes Booster and reference values")
	var defaults:Dictionary=Orders.defaults();var before:Dictionary=defaults.duplicate(true);var preset:Dictionary=Preset.create(defaults)
	check(defaults==before and preset.mako[0]==order() and preset.mako.slice(1)==defaults.mako and preset.anne==defaults.anne,"preset prepends exactly one order and preserves all others without mutating input")
	await test_sequence()
	await test_rejections()
	await test_targeting_and_store()
	await test_lab()
	await settle();check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==orphans,"no orphan actors editors or laboratory views")
	var summary:String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
func test_sequence() -> void:
	for hz in [30,60,120]:
		var sim:=fixture();var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
		sim.rules.mako=[order()];var applied:Array[Dictionary]=[];var starts:Array[Dictionary]=[]
		for i in range(5*hz):
			sim.advance(1.0/hz)
			applied.append_array(facts(sim.events))
			for event in sim.events:
				if event.kind=="start":starts.append(event)
		check(applied.size()==2 and applied[0].target_id==mako.combat_id and applied[1].target_id==anne.combat_id,"Allié buffs Mako then Anne exactly once")
		check(mako.action.spent==40 and mako.buffs.has(&"booster") and anne.buffs.has(&"booster"),"two successes pay twice and both targets receive buff")
		check(absf(applied[0].game_time-1.5)<=2.0/hz,"first release uses normal base cast")
		check(starts.size()==2 and absf((applied[1].game_time-starts[1].game_time)-1.5/1.3)<=2.0/hz,"second release uses accelerated cast")
		check(absf((starts[1].game_time-applied[0].game_time)-0.4/1.3)<=2.0/hz,"normal recovery separates casts on personal clock")
		check(Orders.evaluate(sim.rules.mako,sim.snapshot(mako)).is_empty() and near(mako.action.remaining(&"booster"),0),"fully buffed team leaves no buff target and no artificial cooldown")
		check(applied.all(func(e):return e.buff_id=="booster" and near(e.buff_duration,60) and near(e.time_multiplier,1.3)),"successful events carry only authoritative buff values")
		var copy:Dictionary=applied[0].duplicate(true);copy.time_multiplier=100
		check(near(mako.buffs.multiplier(),1.3),"presentation cannot mutate the applied state")
		# Let real 60 second lifetimes expire; no fake TTL or wall-time timer.
		for i in range(61*hz):
			sim.advance(1.0/hz);applied.append_array(facts(sim.events))
		check(applied.size()==4 and applied[2].target_id==mako.combat_id and applied[3].target_id==anne.combat_id,"expiry makes both allies eligible again in roster order")
		check(applied[2].game_time-applied[0].game_time>=60 and applied[3].game_time-applied[1].game_time>=60,"active buffs are never refreshed early")
		dispose(sim);await settle()
func test_rejections() -> void:
	for amount in [0,19,20]:
		var sim:=fixture();var mako=sim.hero(&"mako");mako.action.mana=amount;mako.mana_regeneration=0
		check((mako.action.request(&"booster",mako)>0)==(amount==20),"0 and 19 mana rejected, 20 accepted")
		check(mako.action.spent==0 and near(mako.action.mana,amount),"engagement never spends mana")
		mako.action.advance(1.5)
		check(mako.buffs.has(&"booster")== (amount==20) and mako.action.spent==(20 if amount==20 else 0),"debit only on successful release")
		dispose(sim);await settle()
	for scenario in ["dead","replaced","range","buffed","buff_state_replaced","mana_lost","source_dead","paused"]:
		var sim:=fixture();var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
		mako.mana_regeneration=0;check(mako.action.request(&"booster",anne)>0,"cancellation fixture begins a real cast")
		var spent:int=mako.action.spent;var mana:float=mako.action.mana
		match scenario:
			"dead":anne.state.damage(10000)
			"replaced":anne.configure(Simulation.ANNE)
			"range":anne.place(Vector2(-2.5,2.5));mako.place(Vector2(2.5,-2.5))
			"buffed":anne.buffs.apply(Catalog.definition(&"booster"))
			"buff_state_replaced":anne.buffs=BuffState.new()
			"mana_lost":mako.action.mana=19;mana=19
			"source_dead":mako.state.damage(10000)
			"paused":sim.clock.paused=true
		mako.action.advance(2)
		check(mako.action.spent==spent and near(mako.action.mana,mana),"invalid resolution cannot debit: "+scenario)
		check(facts(mako.action.take_visual_events()).is_empty(),"no buff application fact for rejected resolution: "+scenario)
		if scenario=="buffed":check(near(anne.buffs.remaining(&"booster"),60),"concurrent application is not refreshed")
		dispose(sim);await settle()
	# Concurrent independent casters share the same target and buff eligibility gate.
	var sim:=fixture();var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
	anne.abilities.append(&"booster");mako.mana_regeneration=0;anne.mana_regeneration=0
	mako.action.request(&"booster",mako);anne.action.request(&"booster",mako)
	mako.action.advance(1.5);anne.action.advance(1.5)
	check(mako.action.spent==20 and anne.action.spent==0 and near(mako.buffs.remaining(&"booster"),60),"only one concurrent caster applies and pays")
	var events:Array[Dictionary]=mako.action.take_visual_events();events.append_array(anne.action.take_visual_events())
	check(facts(events).size()==1,"exactly one application event for concurrent casts")
	check(not mako.action.try_impact(mako.action.action_id) and facts(mako.action.take_visual_events()).is_empty(),"duplicate resolution cannot apply or notify twice")
	mako.action.advance(1);check(mako.action.request(&"booster",mako)==0 and mako.action.spent==20,"already buffed target rejected at engagement")
	dispose(sim);await settle()
func test_targeting_and_store() -> void:
	var sim:=fixture();var mako=sim.hero(&"mako");var anne=sim.hero(&"anne")
	mako.buffs.apply(Catalog.definition(&"booster"));var rows:Array=[order(),order("self","basic")]
	check(Orders.evaluate(rows,sim.snapshot(mako)).target_id==anne.combat_id,"eligible second ally selected when first has same buff")
	anne.buffs.apply(Definition.create(&"other_buff",60,1))
	check(Orders.evaluate(rows,sim.snapshot(mako)).target_id==anne.combat_id,"other buff IDs never exclude an eligible target")
	anne.buffs.apply(Catalog.definition(&"booster"))
	check(Orders.evaluate(rows,sim.snapshot(mako)).rule_index==1,"all buffed means skip to next order")
	mako.buffs.clear();anne.buffs.clear()
	for mana in [0,19,20]:
		mako.action.mana=mana
		check(Orders.evaluate(rows,sim.snapshot(mako)).rule_index==(0 if mana==20 else 1),"insufficient mana always skips the gambit")
	mako.action.mana=60
	for criterion in [&"self",&"ally_roster",&"ally_hp_lt_90",&"ally_hp_lt_70",&"ally_hp_lt_50",&"ally_hp_lt_30",&"ally_hp_lt_10"]:
		mako.state.damage(maxi(0,mako.state.health-1));anne.state.damage(maxi(0,anne.state.health-1));mako.buffs.apply(Catalog.definition(&"booster"));anne.buffs.apply(Catalog.definition(&"booster"))
		check(Orders.evaluate([order(String(criterion)),order("self","basic")],sim.snapshot(mako)).rule_index==1,"buff filtering applies to every allied criterion")
	sim.wave.cap=1;check(sim.add_enemy(Vector2(2,2)),"enemy fixture")
	var enemy=sim.enemies[0];mako.place(Vector2.ZERO);enemy.place(Vector2(1,0));mako.buffs.clear()
	for criterion in [&"enemy_near",&"enemy_far",&"enemy_hp_max",&"enemy_hp_min"]:
		check(Orders.evaluate([order(String(criterion))],sim.snapshot(mako)).target_id==enemy.combat_id,"enemy criteria allow buffing an enemy")
	check(mako.action.request(&"booster",enemy)>0,"enemy buff cast accepted")
	mako.action.advance(1.5)
	check(enemy.buffs.has(&"booster") and mako.action.spent==20,"enemy receives actual same time buff")
	check(Orders.evaluate([order("enemy_near")],sim.snapshot(mako)).is_empty(),"already buffed enemy also excluded")
	# Heal semantics are deliberately not changed by buff filtering.
	mako.state.heal(1000);anne.state.damage(1)
	var view:Dictionary=sim.snapshot(anne);check(Orders.evaluate([order("ally_roster","heal")],view).is_empty(),"full first ally still skips heal rather than auto-selecting another")
	dispose(sim);await settle()
	var path:String="user://buffs002-orders.json";var config:Dictionary=Preset.create(Orders.defaults())
	check(Codec.save(path,config)==OK and Codec.read(path).source_version==3 and Codec.read(path).configuration==config,"Booster orders persist in schema v3 without migration")
	var store=Store.new(path);check(store.load_configuration()==OK,"configuration store loads new ability")
	var viewport:=SubViewport.new();viewport.size=Vector2i(540,960);add_child(viewport)
	var page=Page.instantiate();page.hero_id=&"mako";page.save_path=path;viewport.add_child(page);await settle()
	check(page.editor.controls[0].skill.text=="Booster" and page.editor.controls[0].skill.item_count==3,"real editor lists three correctly named Mako abilities")
	page.editor.change(page.editor.tokens[0],"criterion","enemy_far");await settle()
	check(Codec.read(path).configuration.mako[0]==order("enemy_far") and Codec.read(path).configuration.anne==config.anne,"Booster autosave preserves other hero")
	viewport.queue_free();await settle()
	var hundred:Array=[]
	for i in range(100):hundred.append(order())
	check(store.save_hero(&"mako",hundred)==OK and Codec.read(path).configuration.mako.size()==100,"hundred Booster rows persist")
	check(Preset.create(Codec.read(path).configuration).is_empty(),"preset cannot silently exceed or truncate a hundred orders")
	hundred.append(order());check(store.save_hero(&"mako",hundred)==ERR_INVALID_DATA and Codec.read(path).configuration.mako.size()==100,"101st buff order cannot overwrite the valid configuration")
	DirAccess.remove_absolute(path)
func test_lab() -> void:
	var lab=Lab.instantiate();add_child(lab);lab.set_process(false);lab.set_physics_process(false);await settle()
	check(lab.save_path=="user://buffs002_isolated_lab.json" and lab.simulation.rules.mako[0]==order(),"lab activates the real preset without loading player rules")
	for i in range(210):lab._physics_process(1.0/60)
	check(lab.journal.size()==2 and lab.simulation.hero(&"mako").action.spent==40,"lab observes two authoritative applications")
	check(lab.simulation.hero(&"mako").visual.player.current_animation==lab.simulation.hero(&"mako").appearance.idle_clip,"after both buffs the idle state resumes")
	lab._toggle_pause();var remaining:float=lab.simulation.hero(&"mako").buffs.remaining(&"booster")
	for i in range(20):lab._physics_process(1.0/30)
	check(near(lab.simulation.hero(&"mako").buffs.remaining(&"booster"),remaining),"pause freezes actual buff duration")
	lab.queue_free();await settle()
