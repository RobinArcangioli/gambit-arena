extends Node
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
const Roster = preload("res://scripts/party/party_roster.gd")
const TeamRoster = preload("res://scripts/app/team_roster.gd")
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Store = preload("res://scripts/gambits/configuration_store.gd")
const Page = preload("res://scenes/app/gambits_page.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, text: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("RosterTargeting: "+text)
func row(id: int, slot: int, health: int=100, x: float=0) -> Dictionary:
	return {"id":id,"team_slot":slot,"health":health,"max_health":100,"position":Vector2(x,0)}
func order(skill: String="basic") -> Dictionary:
	return {"enabled":true,"criterion":"ally_roster","skill":skill}
func ids(rows: Array[Dictionary]) -> Array:
	return rows.map(func(item):return item.id)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func tap(viewport: Viewport, at: Vector2) -> void:
	for pressed in [true,false]:
		var finger:=InputEventScreenTouch.new();finger.index=0;finger.pressed=pressed;finger.position=at;viewport.push_input(finger,true)
		var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.position=at;mouse.global_position=at;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0;mouse.pressed=pressed;viewport.push_input(mouse,true)
func _ready() -> void:
	check(Roster.SLOTS==[&"mako",&"anne",&"nassau",&""] and TeamRoster.SLOTS==Roster.SLOTS,"logical and visible roster share one order")
	check(Roster.rank(&"mako")==0 and Roster.rank(&"anne")==1 and Roster.rank(&"")==-1 and Roster.rank(&"missing")==-1,"empty and absent slots are not actors")
	check(Criteria.label(&"ally_roster")=="Allié" and Criteria.threshold(&"ally_roster")==0,"Allié has no threshold")
	var view: Dictionary={"key":&"anne","source":row(10,1,5,0),"allies":[row(99,0,100,4)],"enemies":[row(2,0,100,.1)],"mana":60.0,"abilities":[&"basic",&"heal"],"cooldowns":{}}
	check(ids(Criteria.candidates(&"ally_roster",view))==[99,10],"team slot beats identity proximity and low health of source")
	check(Criteria.choose(&"ally_roster",view).id==99,"Anne chooses Mako first")
	view.source=row(99,0,100,0);view.allies=[row(10,1,5,.1)]
	check(Criteria.choose(&"ally_roster",view).id==99,"Mako includes himself and comes before Anne")
	for slot in [2,3,4]:view.allies.append(row(20+slot,slot,100,float(slot)))
	view.allies.reverse()
	check(ids(Criteria.candidates(&"ally_roster",view))==[99,10,22,23,24],"future occupied slots retain roster order independently of input order")
	view.allies.append(row(30,5,0));view.allies.append(row(31,-1,100));view.allies.append({})
	var bad: Dictionary=row(32,0);bad.team_slot="0";view.allies.append(bad)
	check(ids(Criteria.candidates(&"ally_roster",view))==[99,10,22,23,24],"dead absent and malformed ranks excluded")
	var detached: Array[Dictionary]=Criteria.candidates(&"ally_roster",view)
	detached[0].health=0;detached.reverse();detached.clear()
	check(view.source.health==100 and Criteria.choose(&"ally_roster",view).id==99,"candidate values and list are detached")
	var remaining: Array[Dictionary]=Criteria.candidates(&"ally_roster",view);remaining.remove_at(0)
	check(remaining[0].id==10 and Criteria.choose(&"ally_roster",view).id==99,"future eligibility filtering can skip a candidate without changing the criterion")
	view.source.health=0;check(Criteria.candidates(&"ally_roster",view).is_empty(),"dead source cannot act")
	view.source=row(99,0);view.allies=[]
	check(ids(Criteria.candidates(&"ally_roster",view))==[99],"source alone is still an ally")
	view.source.team_slot=-1;check(Criteria.candidates(&"ally_roster",view).is_empty(),"no ranked ally produces no target")
	check(Criteria.candidates(&"unknown",view).is_empty(),"unknown criterion gives no candidates")
	view.source=row(99,0);view.allies=[row(10,1,30)]
	check(Orders.evaluate([order("heal"),{"enabled":true,"criterion":"self","skill":"basic"}],view).rule_index==1,"full first ally skips heal rather than choosing wounded second ally")
	view.source.health=70
	check(Orders.evaluate([order("heal")],view).target_id==99,"injured first ally permits heal")
	view.mana=0
	check(Orders.evaluate([order("heal"),{"enabled":true,"criterion":"self","skill":"basic"}],view).rule_index==1,"insufficient mana skips the order")
	view.mana=60;view.cooldowns={"heal":1.0}
	check(Orders.evaluate([order("heal"),order()],view).rule_index==1,"cooldown skips to next available order")
	view.source=row(50,0);view.allies=[row(9,1,30),row(7,1,30)]
	check(ids(Criteria.candidates(&"ally_roster",view))==[50,7,9],"duplicate slot ties use stable combat ID")
	view.enemies=[row(7,0,80,2),row(8,1,20,4),row(9,2,60,1)]
	for pair in [[&"enemy_hp_max",[7,9,8]],[&"enemy_hp_min",[8,9,7]],[&"enemy_near",[9,7,8]],[&"enemy_far",[8,7,9]],[&"self",[50]]]:
		check(ids(Criteria.candidates(pair[0],view))==pair[1],"all candidate lists preserve the criterion's complete ranking")
	var world:=Node3D.new();add_child(world);var sim:=Simulation.new();add_child(sim);sim.configure(world);sim.orders_enabled=true;sim.rules=Orders.defaults();sim.reset()
	var anne=sim.hero(&"anne");var mako=sim.hero(&"mako")
	check(sim.heroes.map(func(actor):return actor.actor_key)==[&"mako",&"anne",&"nassau"] and mako.combat_id<anne.combat_id,"simulation creation follows explicit team order")
	check(anne.team_slot==1 and mako.team_slot==0,"runtime actor ranks follow roster rather than creation")
	for actor in sim.heroes:
		var snapshot: Dictionary=sim.snapshot(actor)
		check(Criteria.choose(&"ally_roster",snapshot).id==mako.combat_id,"actual simulation resolves Mako first for either caster")
		check(ids(Criteria.candidates(&"ally_roster",snapshot))==[mako.combat_id,anne.combat_id,sim.hero(&"nassau").combat_id],"actual snapshot ranks all three members")
	mako.place(Vector2(2,0));anne.place(Vector2(-2,0));mako.state.damage(30);anne.state.damage(100)
	sim.rules.anne=[order("heal")];sim._plan(anne)
	check(anne.desired_target==mako,"real heal chooses roster before lowest HP")
	sim.heroes.reverse();check(Criteria.choose(&"ally_roster",sim.snapshot(anne)).id==mako.combat_id,"roster independent of array order")
	mako.state.damage(1000)
	check(Criteria.choose(&"ally_roster",sim.snapshot(anne)).id==anne.combat_id,"living Anne chosen when Mako is dead")
	check(Criteria.candidates(&"ally_roster",sim.snapshot(mako)).is_empty(),"dead Mako never chooses a target")
	sim.reset();check(sim.hero(&"mako").team_slot==0 and sim.hero(&"anne").team_slot==1,"replay reassigns roster ranks")
	sim.clear();sim.queue_free();world.queue_free();await settle()
	var path: String="user://gambits003-roster.json"
	if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
	var initial: Dictionary=Orders.defaults();check(Codec.save(path,initial)==OK,"existing v3 fixture")
	var store=Store.new(path);check(store.load_configuration()==OK and store.configuration==initial,"old criteria reload unchanged")
	check(store.save_hero(&"anne",[order("heal")])==OK,"new criterion immediately persisted")
	var saved: Dictionary=Codec.read(path)
	check(saved.source_version==Codec.VERSION and saved.configuration.anne[0]==order("heal") and saved.configuration.mako==initial.mako,"schema v3 and other hero preserved")
	check(saved.configuration.anne[0].keys().size()==3 and not saved.configuration.anne[0].has("team_slot"),"rank is runtime data not editable order data")
	var largest: Array=[]
	for i in range(100):largest.append(order("heal"))
	check(store.save_hero(&"anne",largest)==OK and Codec.read(path).configuration.anne.size()==100,"hundred new criteria round trip")
	largest.append(order("heal"));var before: String=FileAccess.get_file_as_string(path)
	check(store.save_hero(&"anne",largest)==ERR_INVALID_DATA and FileAccess.get_file_as_string(path)==before,"101st row cannot overwrite file")
	var viewport:=SubViewport.new();viewport.size=Vector2i(540,960);add_child(viewport)
	var page=Page.instantiate();page.hero_id=&"anne";page.save_path=path;viewport.add_child(page);await settle();viewport.notify_mouse_entered()
	var editor=page.editor
	check(editor.controls[0].criterion.item_count==12 and editor.controls[0].criterion.text=="Allié","catalogue including group criterion visible in real editor")
	tap(viewport,editor.controls[0].criterion.get_global_rect().get_center());await settle()
	check(editor.popup_open() and editor.controls[0].criterion.get_popup().get_item_text(Criteria.IDS.find(&"ally_roster"))=="Allié","touch opens menu containing exact label")
	editor.close_popup();editor.change(editor.tokens[0],"criterion","enemy_far");await settle()
	editor.change(editor.tokens[0],"criterion","ally_roster");await settle()
	check(Codec.read(path).configuration.anne[0].criterion=="ally_roster" and editor.controls[0].criterion.text=="Allié","menu callback immediately saves Allié")
	viewport.queue_free();await settle();DirAccess.remove_absolute(path)
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan actors or editors")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
