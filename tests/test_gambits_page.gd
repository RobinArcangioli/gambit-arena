extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Legacy = preload("res://scripts/party/party_rules.gd")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("GambitsPage: "+message)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func read(path: String) -> Dictionary:return Codec.read(path).configuration
func tap(button: Control) -> void:
	var viewport: Viewport=button.get_viewport()
	var at: Vector2=button.get_global_rect().get_center()
	for pressed in [true,false]:
		var event := InputEventScreenTouch.new();event.index=0;event.pressed=pressed;event.position=at;viewport.push_input(event,true)
		var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=pressed;mouse.position=event.position;viewport.push_input(mouse,true)
func _ready() -> void:
	var path: String = "user://gambits002-editor.json"
	for suffix in ["",".v2.bak"]:
		if FileAccess.file_exists(path+suffix):DirAccess.remove_absolute(path+suffix)
	var initial: Dictionary = {"anne":Legacy.defaults(&"anne"),"mako":Legacy.defaults(&"mako")};initial.anne[0].threshold=80
	check(Legacy.save_configuration(path,initial)==OK,"legacy fixture saved")
	var original: PackedByteArray=FileAccess.get_file_as_bytes(path)
	var app=App.instantiate();app.save_path=path;add_child(app);await settle()
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	app.open_team();await settle();app.team_page._select(&"anne");await settle()
	var sheet=app.hero_page;app.open_gambits();app.open_gambits();await settle()
	var page=app.gambits_page;var editor=page.editor
	check(app.route==&"gambits" and editor.hero_id==&"anne" and editor.controls.size()==3 and app.combat==null,"one correct editor without combat")
	check(not sheet.visible and not sheet.active and not app.team_page.active,"hidden pages inactive")
	check(editor.rows[0].criterion=="ally_hp_lt_70" and editor.message.text.contains("80"),"80 to 70 migration visible")
	var token: int=editor.tokens[0]
	tap(editor.controls[0].enabled);await settle()
	check(not editor.rows[0].enabled and read(path).anne==editor.rows,"raw touch plus emulated mouse saves exactly one toggle")
	check(FileAccess.get_file_as_bytes(path+".v2.bak")==original and Codec.read(path).source_version==3,"first change backs up original and writes v3")
	tap(editor.controls[0].criterion);await settle()
	check(editor.popup_open(),"touch opens criterion dropdown")
	editor.close_popup();editor.change(token,"criterion","enemy_far");await settle()
	check(read(path).anne[0].criterion=="enemy_far" and read(path).anne[0].skill=="heal","healing enemy saved without paired restriction")
	editor.change(token,"skill","basic");check(read(path).anne[0].skill=="basic","capability immediately saved")
	editor.move_order(token,1);check(read(path).anne==editor.rows and editor.tokens[1]==token,"priority immediately saved and identity retained")
	var before: Dictionary=read(path)
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);editor.toggle(token);editor.add_order()
	check(read(path)==before and not editor.active,"background blocks all changes")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	check(editor.active and not sheet.active and not app.team_page.active,"resume only editor")
	editor.add_order();check(read(path).anne.size()==4 and editor.rows[-1]==Orders.create(),"new active enemy near attack saved")
	var deleted: int=editor.tokens[-1];editor.remove_order(deleted);editor.toggle(deleted)
	check(read(path).anne.size()==3 and read(path).anne==editor.rows,"stale callback cannot edit another row")
	var other: Array=read(path).mako.duplicate(true)
	var saved: Array=editor.rows.duplicate(true)
	page.back_button.pressed.emit();await settle()
	check(app.route==&"hero" and app.hero_page==sheet and sheet.active and app.gambits_page==null,"back returns same sheet with saved changes")
	app.open_gambits();await settle();editor=app.gambits_page.editor
	check(editor.rows==saved and read(path).mako==other,"reopen and independent heroes")
	await get_tree().create_timer(.2).timeout;app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"hero" and read(path).anne==saved,"Android Back retains changes")
	app.return_team();await settle()
	check(app.team_page.cards.all(func(c):return not c.toggle_mode and not c.button_pressed and not c.has_focus()),"no persistent team selection")
	app.return_home();await settle();app.open_arena();await settle()
	check(app.combat.simulation.rules==read(path) and app.combat.simulation.orders_enabled,"arena reloads v3")
	app.combat._select_hero(&"anne");app.combat._show_tab("rules");app.combat._command(&"heal");await settle()
	check(app.combat.orders_editor==null and app.combat.selected_hero==&"" and app.combat.simulation.rules==read(path),"sparse combat offers no editor, hero selection or manual skill")
	saved=read(path).anne.duplicate(true)
	app.return_home();await settle();app.open_team();await settle();app.team_page._select(&"anne");await settle();app.open_gambits();await settle()
	editor=app.gambits_page.editor
	check(editor.rows==saved,"menu retains configuration after readonly combat")
	# Load a meaningful 99-row fixture then exercise both bounds through UI mutations.
	var config: Dictionary=read(path);config.anne=[]
	for i in range(99):config.anne.append(Orders.create())
	check(Codec.save(path,config)==OK,"99-row fixture")
	app.return_home();await settle();app.open_team();await settle();app.team_page._select(&"anne");await settle();app.open_gambits();await settle()
	editor=app.gambits_page.editor;editor.add_order();editor.add_order();await settle()
	check(editor.rows.size()==100 and editor.add_button.disabled and read(path).anne.size()==100,"100 bound persisted")
	var last: int=editor.tokens[-1];editor.change(last,"criterion","self");editor.move_order(last,-1)
	check(read(path).anne[98].criterion=="self","last rows edit and reorder correctly")
	config=read(path);config.anne=[];Codec.save(path,config)
	app.return_home();await settle();app.open_team();await settle();app.team_page._select(&"anne");await settle();app.open_gambits();await settle()
	editor=app.gambits_page.editor
	check(editor.rows.is_empty() and editor.empty_label.visible and not editor.add_button.disabled,"empty list can add")
	editor.add_order();editor.remove_order(editor.tokens[0]);check(read(path).anne.is_empty(),"zero orders saved")
	app.return_home();await settle()
	for cycle in range(10):
		app.open_team();await settle();app.team_page._select(&"mako");await settle();app.open_gambits();await settle()
		check(app.gambits_page.editor.rows.all(func(row):return row.skill in ["basic","lightning","booster"]),"Mako abilities only")
		app.return_home();await settle();check(app.gambits_page==null and app.hero_page==null and app.team_page==null,"nested pages freed")
	app.queue_free();await settle()
	var fresh=App.instantiate();fresh.save_path=path;add_child(fresh);await settle();fresh.open_team();await settle();fresh.team_page._select(&"anne");await settle();fresh.open_gambits();await settle()
	check(fresh.gambits_page.editor.rows.is_empty(),"fresh application persistence")
	fresh.queue_free();await settle()
	var failure_page=load("res://scenes/app/gambits_page.tscn").instantiate();failure_page.hero_id=&"mako";failure_page.save_path="user://nonexistent-gambits002/rules.json";add_child(failure_page);await settle()
	editor=failure_page.editor;var unchanged: Array=editor.rows.duplicate(true);editor.toggle(editor.tokens[0]);await settle()
	check(editor.rows==unchanged and editor.message.visible and editor.message.text.begins_with("Enregistrement impossible"),"write failure rolls back UI")
	failure_page.queue_free();await settle()
	for suffix in ["",".v2.bak"]:DirAccess.remove_absolute(path+suffix)
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan pages or viewports")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
	print(summary);var label:=Label.new();label.text=summary;add_child(label)
