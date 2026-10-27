extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Reference = preload("res://scripts/app/hero_reference.gd")
const Roster = preload("res://scripts/app/team_roster.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("HeroPage: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
	check(Reference.read(&"unknown").is_empty(),"unknown identity has no fallback hero")
	for id in [&"mako",&"anne"]:
		var data: Dictionary = Reference.read(id);var profile = Roster.PROFILES[id]
		check(data.id==id and data.name==profile.display_name,"identity comes from profile")
		check(data.health==profile.max_health and data.mana==profile.mana_capacity,"maximum resources come from profile")
		check(data.attack==profile.attack and data.defense==profile.defense and data.speed==profile.move_speed and data.regeneration==profile.mana_regeneration,"stats come from reference data")
		check(data.skills.size()==profile.abilities.size(),"only the hero abilities are listed")
		for i in range(data.skills.size()):
			var skill: Dictionary = data.skills[i];var key: StringName = profile.abilities[i]
			check(skill.id==key and skill.cost==Executor.cost(key) and skill.duration==Executor.cast_duration(key) and skill.cooldown==Executor.cooldown(key) and skill.reach==Executor.skill_reach(key),"metadata follows current executor")
		data.skills.clear();data.health=1
		check(Reference.read(id).skills.size()==2 and profile.max_health>1,"UI snapshot cannot mutate authored profile")
	var app = App.instantiate();app.save_path="";add_child(app);await settle()
	app.open_arena();await settle()
	for actor in app.combat.simulation.heroes:
		actor.state.damage(60);actor.action.mana=0
	app.return_home();await settle();app.open_team();await settle()
	app._select_team_hero(&"unknown");check(app.route==&"team" and app.hero_page==null,"invalid id cannot open a sheet")
	for id in [&"mako",&"anne"]:
		var team=app.team_page
		team._select(id);await settle();var page=app.hero_page
		check(app.route==&"hero" and app.combat==null and page.hero_id==id and page.title.text==Roster.caption(id),"correct sheet without combat")
		check(page.reference.health==Roster.PROFILES[id].max_health and page.health_bar.value==page.health_bar.max_value and page.mana_bar.value==60,"abandoned injuries and mana are not shown")
		check(page.skill_panels.size()==2 and page.gambits_button.disabled,"two skills and prepared Gambits button")
		check(not team.visible and not team.active and team.portraits.all(func(p):return not p.active and p.viewport_3d.render_target_update_mode==SubViewport.UPDATE_DISABLED),"team worlds stop behind sheet")
		app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);app.notification(NOTIFICATION_APPLICATION_PAUSED)
		check(not page.active and page.back_button.disabled,"background blocks page input")
		app.return_team();check(app.route==&"hero","background cannot navigate")
		app.notification(NOTIFICATION_APPLICATION_RESUMED);check(not page.active,"resume without focus stays blocked")
		app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
		check(page.active and not team.active,"resume enables only current page")
		app.return_team();app.return_team();await settle()
		check(not is_instance_valid(page) and app.hero_page==null and app.route==&"team" and team.active and team.visible and team.selected_id==id,"return keeps selection and frees only sheet")
	for cycle in range(12):
		app.team_page._select(&"mako" if cycle%2==0 else &"anne");await settle()
		app.return_team();await settle()
		check(app.hero_page==null and app.combat==null and app.team_page.portraits.size()==2,"repeated visits leave no sheet or combat")
	app.team_page._select(&"anne");await settle();await get_tree().create_timer(.2).timeout
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"team","Android Back returns exactly one level")
	await get_tree().create_timer(.2).timeout
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"home" and app.team_page==null and app.hero_page==null,"second Back releases team")
	app.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan pages or previews")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
