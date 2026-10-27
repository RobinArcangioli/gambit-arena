extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Rules = preload("res://scripts/party/party_rules.gd")
const Draft = preload("res://scripts/app/gambits_draft.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("GambitsPage: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
	var path: String = "user://ui004-gambits-tests.json"
	if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
	var initial: Dictionary = {"anne":Rules.defaults(&"anne"),"mako":Rules.defaults(&"mako")}
	check(Rules.save_configuration(path,initial)==OK,"fixture saved through existing codec")
	var draft=Draft.new();draft.open(&"mako",path);draft.rows[0].threshold=31
	check(Rules.load_configuration(path)==initial,"draft never mutates stored rules")
	var newer: Dictionary = initial.duplicate(true);newer.anne[0].threshold=42
	Rules.save_configuration(path,newer)
	check(draft.apply()==OK and Rules.load_configuration(path).anne[0].threshold==42 and Rules.load_configuration(path).mako[0].threshold==31,"apply preserves newer other-hero configuration")
	draft.rows[0].skill="heal"
	check(draft.apply()==ERR_INVALID_DATA and Rules.load_configuration(path).mako[0].skill=="lightning","wrong hero ability cannot be saved")
	var app=App.instantiate();app.save_path=path;add_child(app);await settle()
	app.open_team();await settle();app.team_page._select(&"anne");await settle()
	var sheet=app.hero_page;app.open_gambits();app.open_gambits();await settle()
	var page=app.gambits_page
	check(app.route==&"gambits" and page.hero_id==&"anne" and page.controls.size()==3 and app.combat==null,"one editor for the correct hero without simulation")
	check(not sheet.visible and not sheet.active and not app.team_page.active,"hidden pages remain inactive")
	check(page.draft.rows[0].threshold==42,"editor reloads persisted rules")
	page._cycle_skill(0);check(page.draft.rows[0].skill=="basic" and page.draft.rows[0].target=="enemy","cycle changes paired target to enemy")
	page._cycle_skill(0);check(page.draft.rows[0].skill=="heal" and page.draft.rows[0].target=="ally","Anne gets heal and ally including herself")
	page._threshold(0,-1000);check(page.draft.rows[0].threshold==0,"lower threshold bound")
	page._threshold(0,1000);check(page.draft.rows[0].threshold==100,"upper threshold bound")
	page._cycle_condition(0);page._threshold(0,-10)
	check(page.draft.rows[0].condition=="always" and page.draft.rows[0].threshold==100 and page.controls[0].adjust.all(func(b):return b.disabled),"always disables unused threshold edits")
	page._cycle_condition(0);page._threshold(0,-45)
	page._move(0,1);page._toggle(2)
	var expected: Array = page.draft.rows.duplicate(true)
	var before: Dictionary = Rules.load_configuration(path)
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);page._toggle(0);page._apply()
	check(page.draft.rows==expected and Rules.load_configuration(path)==before and not page.active,"background blocks mutation and save")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	check(page.active and not sheet.active and not app.team_page.active,"resume activates only editor")
	page.apply_button.pressed.emit();await settle()
	check(app.route==&"hero" and app.hero_page==sheet and sheet.active and app.gambits_page==null,"apply returns to same sheet")
	var saved: Dictionary = Rules.load_configuration(path)
	check(saved.anne==expected and saved.mako==before.mako,"three ordered rules persisted, other hero unchanged")
	app.open_gambits();await settle();page=app.gambits_page
	check(page.draft.rows==expected,"reopened editor sees saved order and values")
	page._toggle(0);page.cancel_button.pressed.emit();await settle()
	check(Rules.load_configuration(path)==saved and app.route==&"hero","Cancel discards entire draft")
	app.open_gambits();await settle();app.gambits_page._toggle(0)
	await get_tree().create_timer(.2).timeout;app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"hero" and Rules.load_configuration(path)==saved,"Android Back cancels one page only")
	app.return_team();await settle()
	check(app.team_page.cards.all(func(c):return not c.toggle_mode and not c.button_pressed and not c.has_focus()),"return has no selected or focused hero")
	app.return_home();await settle();app.open_arena();await settle()
	check(app.combat.simulation.rules==saved,"new arena reloads editor configuration")
	app.combat._select_hero(&"anne");app.combat._open_rule(0);app.combat.draft.threshold=27;app.combat._apply_rule()
	var combat_saved: Dictionary = Rules.load_configuration(path)
	check(combat_saved.anne[0].threshold==27,"combat editor still writes same file")
	app.return_home();await settle();app.open_team();await settle();app.team_page._select(&"anne");await settle();app.open_gambits();await settle()
	check(app.gambits_page.draft.rows==combat_saved.anne,"menu reloads changes from combat editor")
	app.return_home();await settle()
	for cycle in range(10):
		app.open_team();await settle();app.team_page._select(&"mako");await settle();app.open_gambits();await settle()
		check(app.gambits_page.draft.rows.all(func(r):return r.skill in ["basic","lightning"]),"Mako cannot select Anne's heal")
		app.return_home();await settle()
		check(app.gambits_page==null and app.hero_page==null and app.team_page==null,"all nested pages freed on Home")
	app.queue_free();await settle()
	var fresh=App.instantiate();fresh.save_path=path;add_child(fresh);await settle();fresh.open_team();await settle();fresh.team_page._select(&"anne");await settle();fresh.open_gambits();await settle()
	check(fresh.gambits_page.draft.rows==combat_saved.anne,"fresh application keeps file persistence")
	fresh.queue_free();await settle()
	var broken: String = "user://ui004-corrupt.json";var file=FileAccess.open(broken,FileAccess.WRITE);file.store_string("{}");file.close()
	draft=Draft.new();draft.open(&"anne",broken)
	check(not draft.readable and draft.apply()==ERR_FILE_CORRUPT and FileAccess.get_file_as_string(broken)=="{}","corrupt configuration never silently overwritten")
	var failure_page=load("res://scenes/app/gambits_page.tscn").instantiate()
	failure_page.hero_id=&"mako";failure_page.save_path="user://ui004-nonexistent-parent/rules.json";add_child(failure_page);await settle()
	failure_page._toggle(0);var failed_draft: Array=failure_page.draft.rows.duplicate(true);failure_page._apply();await settle()
	check(failure_page.is_inside_tree() and failure_page.draft.rows==failed_draft and failure_page.message.visible and failure_page.message.text.begins_with("Enregistrement impossible"),"write failure keeps draft open with feedback")
	failure_page.queue_free();await settle()
	DirAccess.remove_absolute(broken);DirAccess.remove_absolute(path)
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan pages or viewports")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
