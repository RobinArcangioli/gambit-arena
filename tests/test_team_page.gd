extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Simulation = preload("res://scripts/party/party_simulation.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("TeamPage: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func count_simulations(node: Node) -> int:
	var count: int=1 if node.get_script()==Simulation else 0
	for child in node.get_children():count+=count_simulations(child)
	return count
func _ready() -> void:
	var app=App.instantiate();app.save_path="";add_child(app);await settle()
	check(not app.team_button.disabled,"Team entry is enabled on Home")
	app.open_team();app.open_team();await settle()
	var page=app.team_page;page.set_process(false)
	check(app.route==&"team" and app.combat==null and count_simulations(app)==0,"team and its models never create a combat")
	check(page.cards.size()==4 and page.portraits.size()==3 and page.find_children('*','SubViewport',true,false).size()==3,"four slots and three rendering contexts")
	check(page.names[0].text=='Mako' and page.names[1].text=='Anne',"presentation order is Mako then Anne")
	check(not page.cards[2].disabled and page.cards[3].disabled and page.names[2].text=='Nassau' and page.names[3].text=='Vide',"Nassau occupies third slot and empty stays inactive")
	check(page.cards[3].find_children('*','SubViewport',true,false).is_empty(),"no hidden model or viewport under empty slot")
	var emitted: Array[StringName]=[]
	app.hero_selected.connect(func(id):emitted.append(id))
	page.cards[0].pressed.emit();await settle();app.return_team();await settle()
	page.cards[1].pressed.emit();await settle();app.return_team();await settle()
	check(emitted==[&"mako",&"anne"] and app.selected_hero_id==&"anne", "selection emits stable identity and returns from each sheet")
	check(page.cards.all(func(c):return not c.toggle_mode and not c.button_pressed),"cards are direct links without persistent selection")
	var before: Array=[]
	for portrait in page.portraits:
		check(portrait.character.valid and portrait.character.active_clip==portrait.definition.idle_clip,"actual imported idle is selected")
		before.append(portrait.character.sample_time)
	page.discard_next_step=false
	for tick in range(10):page._process(1.0/30.0)
	for i in range(2):check(is_equal_approx(page.portraits[i].character.sample_time,before[i]+1.0/3.0),"both manual animation players follow page time")
	var frozen: float=page.visual_time
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);app.notification(NOTIFICATION_APPLICATION_PAUSED)
	page._process(12)
	check(page.visual_time==frozen and page.portraits.all(func(p):return not p.active and p.viewport_3d.render_target_update_mode==SubViewport.UPDATE_DISABLED),"background stops animation and GPU updates")
	page._select(&"mako")
	check(app.selected_hero_id==&"anne","background cannot change selected hero")
	app.notification(NOTIFICATION_APPLICATION_RESUMED)
	page._process(12)
	check(page.visual_time==frozen,"resume without focus still freezes page")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	page._process(12)
	check(page.visual_time==frozen,"first return delta is discarded")
	page._process(12)
	check(page.visual_time-frozen<=1.0/30.0+0.000001,"long resumed delta is bounded")
	app.return_home();await settle()
	check(not is_instance_valid(page) and app.team_page==null and app.combat==null,"Home frees both portrait worlds")
	for cycle in range(20):
		app.open_team();await settle()
		check(app.team_page.cards.all(func(c):return not c.button_pressed) and app.arena_choice.draws==0,"menu cycles leave no selected card or arena draw")
		app.return_home();await settle()
		check(app.team_page==null and count_simulations(app)==0,"twenty team visits leave no active preview or simulation")
	app.open_arena();await settle()
	check(app.combat.simulation.heroes.map(func(h):return h.actor_key)==[&"mako",&"anne",&"nassau"],"combat uses roster order")
	app.return_home();await settle()
	app.open_team();await settle()
	await get_tree().create_timer(0.2).timeout
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"home" and app.team_page==null,"Android Back abandons only the team page")
	app.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan models, cameras or viewports")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
