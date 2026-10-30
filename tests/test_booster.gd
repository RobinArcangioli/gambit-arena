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
	sim.team_slots=[&"nassau",&"anne",&"",&""]
	sim.rules={"anne":[],"nassau":[]};sim.reset();sim.wave.cap=0
	return sim
func dispose(sim: Simulation) -> void:sim.clear();sim.world.queue_free()
func facts(events: Array[Dictionary]) -> Array[Dictionary]:return events.filter(func(e):return e.kind=="buff_applied")
func _ready() -> void:
	var orphans:int=int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	check(Executor.cost(&"booster")==20 and near(Executor.cast_duration(&"booster"),1.5) and near(Executor.cooldown(&"booster"),0) and near(Executor.skill_reach(&"booster"),4),"Booster cost cast recharge reach match approved values")
	check(Catalog.definition(&"booster").is_read_only() and Catalog.definition(&"unknown").is_empty(),"buff definition is shared immutable metadata")
	check(Orders.PROFILES[&"nassau"].abilities==[&"basic",&"booster"] and Orders.PROFILES[&"anne"].abilities==[&"basic",&"heal",&"meteor"] and not &"booster" in Orders.PROFILES[&"mako"].abilities,"Nassau owns Booster; Anne adds Meteor and Mako retains lightning")
	for criterion in Criteria.IDS:
		check(Orders.valid_order(order(String(criterion)),&"nassau") and not Orders.valid_order(order(String(criterion)),&"anne"),"every criterion can be paired with Nassau's buff")
	var reference:Dictionary=Reference.read(&"nassau");var buff:Dictionary=reference.skills[1]
	check(buff.name=="Booster" and buff.cost==20 and near(buff.duration,1.5) and buff.description.contains("60 s") and buff.description.contains("30 %"),"hero sheet exposes Booster and reference values")
	var defaults:Dictionary=Orders.defaults();var before:Dictionary=defaults.duplicate(true);var preset:Dictionary=Preset.create(defaults)
	check(defaults==before and preset.nassau[0]==order() and preset.nassau.slice(1)==defaults.nassau and preset.anne==defaults.anne,"preset prepends exactly one order and preserves all others without mutating input")
	await test_sequence()
	await test_rejections()
	await test_targeting_and_store()
	await test_lab()
	await settle();check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==orphans,"no orphan actors editors or laboratory views")
	var summary:String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
func test_sequence() -> void:
	for hz in [30,60,120]:
		var sim:=fixture();var nassau=sim.hero(&"nassau");var anne=sim.hero(&"anne")
		sim.rules.nassau=[order()];var applied:Array[Dictionary]=[];var starts:Array[Dictionary]=[]
		for i in range(5*hz):
			sim.advance(1.0/hz)
			applied.append_array(facts(sim.events))
			for event in sim.events:
				if event.kind=="start":starts.append(event)
		check(applied.size()==2 and applied[0].target_id==nassau.combat_id and applied[1].target_id==anne.combat_id,"Allié buffs Nassau then Anne exactly once")
		check(nassau.action.spent==40 and nassau.buffs.has(&"booster") and anne.buffs.has(&"booster"),"two successes pay twice and both targets receive buff")
		check(absf(applied[0].game_time-1.5)<=2.0/hz,"first release uses normal base cast")
		check(starts.size()==2 and absf((applied[1].game_time-starts[1].game_time)-1.5/1.3)<=2.0/hz,"second release uses accelerated cast")
		check(absf((starts[1].game_time-applied[0].game_time)-0.4/1.3)<=2.0/hz,"normal recovery separates casts on personal clock")
		check(Orders.evaluate(sim.rules.nassau,sim.snapshot(nassau)).is_empty() and near(nassau.action.remaining(&"booster"),0),"fully buffed team leaves no buff target and no artificial cooldown")
		check(applied.all(func(e):return e.buff_id=="booster" and near(e.buff_duration,60) and near(e.time_multiplier,1.3)),"successful events carry only authoritative buff values")
		var copy:Dictionary=applied[0].duplicate(true);copy.time_multiplier=100
		check(near(nassau.buffs.multiplier(),1.3),"presentation cannot mutate the applied state")
		# Let real 60 second lifetimes expire; no fake TTL or wall-time timer.
		for i in range(61*hz):
			sim.advance(1.0/hz);applied.append_array(facts(sim.events))
		check(applied.size()==4 and applied[2].target_id==nassau.combat_id and applied[3].target_id==anne.combat_id,"expiry makes both allies eligible again in roster order")
		check(applied[2].game_time-applied[0].game_time>=60 and applied[3].game_time-applied[1].game_time>=60,"active buffs are never refreshed early")
		dispose(sim);await settle()
func test_rejections() -> void:
	for amount in [0,19,20]:
		var sim:=fixture();var nassau=sim.hero(&"nassau");nassau.action.mana=amount;nassau.mana_regeneration=0
		check((nassau.action.request(&"booster",nassau)>0)==(amount==20),"0 and 19 mana rejected, 20 accepted")
		check(nassau.action.spent==0 and near(nassau.action.mana,amount),"engagement never spends mana")
		nassau.action.advance(1.5)
		check(nassau.buffs.has(&"booster")== (amount==20) and nassau.action.spent==(20 if amount==20 else 0),"debit only on successful release")
		dispose(sim);await settle()
	for scenario in ["dead","replaced","range","buffed","buff_state_replaced","mana_lost","source_dead","paused"]:
		var sim:=fixture();var nassau=sim.hero(&"nassau");var anne=sim.hero(&"anne")
		nassau.mana_regeneration=0;check(nassau.action.request(&"booster",anne)>0,"cancellation fixture begins a real cast")
		var spent:int=nassau.action.spent;var mana:float=nassau.action.mana
		match scenario:
			"dead":anne.state.damage(10000)
			"replaced":anne.configure(Simulation.ANNE)
			"range":anne.place(Vector2(-2.5,2.5));nassau.place(Vector2(2.5,-2.5))
			"buffed":anne.buffs.apply(Catalog.definition(&"booster"))
			"buff_state_replaced":anne.buffs=BuffState.new()
			"mana_lost":nassau.action.mana=19;mana=19
			"source_dead":nassau.state.damage(10000)
			"paused":sim.clock.paused=true
		nassau.action.advance(2)
		check(nassau.action.spent==spent and near(nassau.action.mana,mana),"invalid resolution cannot debit: "+scenario)
		check(facts(nassau.action.take_visual_events()).is_empty(),"no buff application fact for rejected resolution: "+scenario)
		if scenario=="buffed":check(near(anne.buffs.remaining(&"booster"),60),"concurrent application is not refreshed")
		dispose(sim);await settle()
	# Concurrent independent casters share the same target and buff eligibility gate.
	var sim:=fixture();var nassau=sim.hero(&"nassau");var anne=sim.hero(&"anne")
	anne.abilities.append(&"booster");nassau.mana_regeneration=0;anne.mana_regeneration=0
	nassau.action.request(&"booster",nassau);anne.action.request(&"booster",nassau)
	nassau.action.advance(1.5);anne.action.advance(1.5)
	check(nassau.action.spent==20 and anne.action.spent==0 and near(nassau.buffs.remaining(&"booster"),60),"only one concurrent caster applies and pays")
	var events:Array[Dictionary]=nassau.action.take_visual_events();events.append_array(anne.action.take_visual_events())
	check(facts(events).size()==1,"exactly one application event for concurrent casts")
	check(not nassau.action.try_impact(nassau.action.action_id) and facts(nassau.action.take_visual_events()).is_empty(),"duplicate resolution cannot apply or notify twice")
	nassau.action.advance(1);check(nassau.action.request(&"booster",nassau)==0 and nassau.action.spent==20,"already buffed target rejected at engagement")
	dispose(sim);await settle()
func test_targeting_and_store() -> void:
	var sim:=fixture();var nassau=sim.hero(&"nassau");var anne=sim.hero(&"anne")
	nassau.buffs.apply(Catalog.definition(&"booster"));var rows:Array=[order(),order("self","basic")]
	check(Orders.evaluate(rows,sim.snapshot(nassau)).target_id==anne.combat_id,"eligible second ally selected when first has same buff")
	anne.buffs.apply(Definition.create(&"other_buff",60,1))
	check(Orders.evaluate(rows,sim.snapshot(nassau)).target_id==anne.combat_id,"other buff IDs never exclude an eligible target")
	anne.buffs.apply(Catalog.definition(&"booster"))
	check(Orders.evaluate(rows,sim.snapshot(nassau)).rule_index==1,"all buffed means skip to next order")
	nassau.buffs.clear();anne.buffs.clear()
	for mana in [0,19,20]:
		nassau.action.mana=mana
		check(Orders.evaluate(rows,sim.snapshot(nassau)).rule_index==(0 if mana==20 else 1),"insufficient mana always skips the gambit")
	nassau.action.mana=60
	for criterion in [&"self",&"ally_roster",&"ally_hp_lt_90",&"ally_hp_lt_70",&"ally_hp_lt_50",&"ally_hp_lt_30",&"ally_hp_lt_10"]:
		nassau.state.damage(maxi(0,nassau.state.health-1));anne.state.damage(maxi(0,anne.state.health-1));nassau.buffs.apply(Catalog.definition(&"booster"));anne.buffs.apply(Catalog.definition(&"booster"))
		check(Orders.evaluate([order(String(criterion)),order("self","basic")],sim.snapshot(nassau)).rule_index==1,"buff filtering applies to every allied criterion")
	sim.wave.cap=1;check(sim.add_enemy(Vector2(2,2)),"enemy fixture")
	var enemy=sim.enemies[0];nassau.place(Vector2.ZERO);enemy.place(Vector2(1,0));nassau.buffs.clear()
	for criterion in [&"enemy_near",&"enemy_far",&"enemy_hp_max",&"enemy_hp_min"]:
		check(Orders.evaluate([order(String(criterion))],sim.snapshot(nassau)).target_id==enemy.combat_id,"enemy criteria allow buffing an enemy")
	check(nassau.action.request(&"booster",enemy)>0,"enemy buff cast accepted")
	nassau.action.advance(1.5)
	check(enemy.buffs.has(&"booster") and nassau.action.spent==20,"enemy receives actual same time buff")
	check(Orders.evaluate([order("enemy_near")],sim.snapshot(nassau)).is_empty(),"already buffed enemy also excluded")
	# Heal semantics are deliberately not changed by buff filtering.
	nassau.state.heal(1000);anne.state.damage(1)
	var view:Dictionary=sim.snapshot(anne);check(Orders.evaluate([order("ally_roster","heal")],view).is_empty(),"full first ally still skips heal rather than auto-selecting another")
	dispose(sim);await settle()
	var path:String="user://buffs002-orders.json";var config:Dictionary=Preset.create(Orders.defaults())
	check(Codec.save(path,config)==OK and Codec.read(path).source_version==Codec.VERSION and Codec.read(path).configuration==config,"Booster orders persist in current schema")
	var store=Store.new(path);check(store.load_configuration()==OK,"configuration store loads new ability")
	var viewport:=SubViewport.new();viewport.size=Vector2i(540,960);add_child(viewport)
	var page=Page.instantiate();page.hero_id=&"nassau";page.save_path=path;viewport.add_child(page);await settle()
	check(page.editor.controls[0].skill.text=="Booster" and page.editor.controls[0].skill.item_count==2,"real editor lists Nassau abilities")
	page.editor.change(page.editor.tokens[0],"criterion","enemy_far");await settle()
	check(Codec.read(path).configuration.nassau[0]==order("enemy_far") and Codec.read(path).configuration.anne==config.anne,"Booster autosave preserves other hero")
	viewport.queue_free();await settle()
	var hundred:Array=[]
	for i in range(100):hundred.append(order())
	check(store.save_hero(&"nassau",hundred)==OK and Codec.read(path).configuration.nassau.size()==100,"hundred Booster rows persist")
	check(Preset.create(Codec.read(path).configuration).is_empty(),"preset cannot silently exceed or truncate a hundred orders")
	hundred.append(order());check(store.save_hero(&"nassau",hundred)==ERR_INVALID_DATA and Codec.read(path).configuration.nassau.size()==100,"101st buff order cannot overwrite the valid configuration")
	DirAccess.remove_absolute(path)
func test_lab() -> void:
	var lab=Lab.instantiate();add_child(lab);lab.set_process(false);lab.set_physics_process(false);await settle()
	check(lab.save_path=="user://buffs002_isolated_lab.json" and lab.simulation.rules.nassau[0]==order(),"lab activates the real preset without loading player rules")
	for i in range(210):lab._physics_process(1.0/60)
	check(lab.journal.size()==2 and lab.simulation.hero(&"nassau").action.spent==40,"lab observes two authoritative applications")
	check(lab.simulation.hero(&"nassau").visual.player.current_animation==lab.simulation.hero(&"nassau").appearance.idle_clip,"after both buffs the idle state resumes")
	lab._toggle_pause();var remaining:float=lab.simulation.hero(&"nassau").buffs.remaining(&"booster")
	for i in range(20):lab._physics_process(1.0/30)
	check(near(lab.simulation.hero(&"nassau").buffs.remaining(&"booster"),remaining),"pause freezes actual buff duration")
	lab.queue_free();await settle()
