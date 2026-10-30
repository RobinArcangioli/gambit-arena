extends Node
const App=preload("res://scenes/app/app_root.tscn")
const Sim=preload("res://scripts/party/party_simulation.gd")
const Roster=preload("res://scripts/party/party_roster.gd")
const Team=preload("res://scripts/party/team_composition.gd")
const Orders=preload("res://scripts/gambits/orders.gd")
const Codec=preload("res://scripts/gambits/configuration_codec.gd")
const Store=preload("res://scripts/gambits/configuration_store.gd")
const Bounds=preload("res://scripts/arena/arena_bounds.gd")
const Formation=preload("res://scripts/waves/infinite_schedule.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,text:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(text)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func write(path:String,value:String) -> void:
	var file:=FileAccess.open(path,FileAccess.WRITE);file.store_string(value);file.close()
func remove(path:String) -> void:
	if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
func _ready() -> void:
	check(not &"booster" in Roster.PROFILES[&"mako"].abilities and Roster.PROFILES[&"nassau"].abilities==[&"basic",&"booster"],"Booster belongs exclusively to Nassau among current heroes")
	var original:Dictionary={"anne":[Orders.create()],"mako":[{"enabled":false,"criterion":"self","skill":"booster"},Orders.create(),{"enabled":true,"criterion":"ally_roster","skill":"booster"}]}
	var path:String="user://team001-migration.json";remove(path);remove(path+".v3.bak")
	var bytes:String=JSON.stringify({"version":3,"heroes":original});write(path,bytes)
	var store:=Store.new(path)
	check(store.load_configuration()==OK,"v3 configuration upgrades on first load")
	check(FileAccess.get_file_as_string(path+".v3.bak")==bytes,"original configuration protected byte for byte")
	check(store.configuration.mako==[Orders.create()] and store.configuration.anne==original.anne,"unrelated gambits and relative order preserved")
	check(store.configuration.nassau.slice(0,2)==[original.mako[0],original.mako[2]],"Booster criteria and active flags transferred in exact order")
	check(store.configuration.nassau[2]==Orders.create(),"Nassau receives fallback attack when space permits")
	check(Codec.read(path).source_version==4,"saved format is v4")
	var saved:String=FileAccess.get_file_as_string(path);store=Store.new(path);store.load_configuration()
	check(FileAccess.get_file_as_string(path)==saved and FileAccess.get_file_as_string(path+".v3.bak")==bytes,"migration is idempotent")
	var largest:Dictionary=original.duplicate(true);largest.mako=[]
	for i in range(100):largest.mako.append({"enabled":bool(i%2),"criterion":"ally_roster","skill":"booster"})
	var converted:Dictionary=Codec.upgrade_three(largest)
	check(converted.error==OK and converted.configuration.nassau.size()==100 and converted.configuration.mako.is_empty(),"100 Booster orders transfer without loss or overflow")
	check(converted.configuration.nassau==largest.mako,"full transferred list preserves every flag")
	write(path,bytes);write(path+".v3.bak","other backup")
	check(Store.new(path).load_configuration()==ERR_ALREADY_EXISTS and FileAccess.get_file_as_string(path)==bytes,"conflicting backup blocks migration safely")
	remove(path);remove(path+".v3.bak")
	var team_path:String="user://team001-composition.json";remove(team_path)
	var team:=Team.new(team_path);check(team.load_or_create()==OK and FileAccess.file_exists(team_path),"initial four-slot composition persisted")
	var rearranged:Array=[&"nassau",&"",&"anne",&"mako"]
	check(team.save_slots(rearranged)==OK,"composition can represent holes before drag UI")
	var reload:=Team.new(team_path);check(reload.load_or_create()==OK and reload.slots==rearranged,"composition persists across launches")
	check(team.save_slots([&"mako",&"mako",&"anne",&""])==ERR_INVALID_DATA and team.slots==rearranged,"invalid duplicate does not replace composition")
	remove(team_path)
	var world:=Node3D.new();add_child(world)
	var simulation:=Sim.new();add_child(simulation);simulation.configure(world)
	simulation.orders_enabled=true;simulation.infinite_mode=true;simulation.rules=Orders.defaults();simulation.reset()
	check(simulation.heroes.size()==3,"three active heroes created")
	var previous:float=-INF;var depth:float=Formation.hero_position(0).x+Formation.hero_position(0).y
	for slot in range(4):
		var point:Vector2=Formation.hero_position(slot)
		check(Bounds.contains_ground(point) and point.x-point.y>previous,"four legal left-to-right places respect footprint margin")
		check(is_equal_approx(point.x+point.y,depth),"all four places align at same screen depth")
		previous=point.x-point.y
	for unit in simulation.heroes:
		check(unit.mover.ground_position==Formation.hero_position(unit.team_slot),"initial position follows logical slot")
	var nassau=simulation.hero(&"nassau")
	for id in [&"mako",&"anne",&"nassau"]:
		var choice:Dictionary=Orders.evaluate(simulation.rules.nassau,simulation.snapshot(nassau))
		check(choice.skill==&"booster" and choice.target_id==simulation.hero(id).combat_id,"Allié buffs team order including Nassau last")
		check(nassau.action.request(&"booster",simulation.hero(id))>0,"Nassau can start genuine Booster cast")
		nassau.action.advance(1.5)
		check(simulation.hero(id).buffs.has(&"booster"),"Booster applied at cast completion")
		nassau.action.advance(.4)
	check(Orders.evaluate(simulation.rules.nassau,simulation.snapshot(nassau)).skill==&"basic","next gambit runs once whole team buffed")
	check(simulation.hero(&"mako").action.request(&"booster",nassau)==0,"executor rejects removed Mako ability")
	simulation.clear();simulation.queue_free();world.queue_free();await settle()
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle()
		app.open_team();await settle();var page=app.team_page
		check(page.portraits.size()==3 and page.names[2].text=="Nassau" and page.names[3].text=="Vide","team has three illustrated Idle heroes and one empty")
		check(page.cards[3].get_theme_stylebox("disabled") is StyleBoxEmpty and page.cards[0].get_theme_stylebox("normal") is StyleBoxEmpty,"no second rounded panel around occupied or empty cards")
		check(page.illustrations[0].position==Vector2.ZERO and page.illustrations[0].size==page.cards[0].size-Vector2(12,12),"approved occupied-card image placement preserved")
		check(page.empty_frames[3].size==page.illustrations[0].size and page.empty_frames[3].get_theme_stylebox("panel").border_color==Color("a68349"),"empty uses same thin gold rectangular frame and dimensions")
		var portrait=page.portraits[2]
		check(is_equal_approx(portrait.definition.team_idle_vertical_bias,.04) and is_equal_approx(page.portraits[0].definition.team_idle_vertical_bias,.1) and is_equal_approx(page.portraits[1].definition.team_idle_vertical_bias,.1),"only Nassau Idle shifts slightly down at unchanged model size")
		check(portrait.character.valid and portrait.character.active_clip==portrait.definition.idle_clip,"Nassau real rig and Idle imported")
		for clip in [portrait.definition.move_clip,portrait.definition.attack_clip,portrait.definition.cast_clip,portrait.definition.hit_clip,portrait.definition.death_clip]:check(portrait.character.player.has_animation(clip),"Nassau action animation present")
		check(page.cards[2].get_global_rect().encloses(page.idle_frames[2].get_global_rect()),"Nassau overlay contained in card")
		page.cards[2].pressed.emit();await settle()
		check(app.hero_page.hero_id==&"nassau" and app.hero_page.reference.health==160,"Nassau opens correct reference sheet")
		app.return_team();await settle();app.return_home();await settle()
		app.composition.slots.assign(rearranged);app.open_arena();await settle()
		var game=app.combat;game.set_process(false);game.set_physics_process(false)
		check(game.hero_panels.map(func(p):return p.hero_id)==rearranged,"panels follow composition with middle hole")
		check(game.simulation.hero(&"mako").team_slot==3 and game.simulation.hero(&"nassau").team_slot==0,"runtime indices follow composition snapshot")
		check(game.hero_panels[0].portrait.hero_id==&"nassau" and game.hero_panels[1].portrait==null,"combat portrait follows hero identity")
		viewport.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan hero or portrait nodes")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
