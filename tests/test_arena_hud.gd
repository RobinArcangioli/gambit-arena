extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
var checks: int=0
var failures: int=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("ArenaHUD: "+text)
func settle() -> void:
	await get_tree().process_frame;await get_tree().process_frame
func tap(viewport: Viewport,button: Control) -> void:
	var at: Vector2=button.get_global_rect().get_center()
	for pressed in [true,false]:
		var finger:=InputEventScreenTouch.new();finger.position=at;finger.index=0;finger.pressed=pressed;viewport.push_input(finger,true)
		var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.position=at;mouse.global_position=at;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=pressed;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0;viewport.push_input(mouse,true)
func buttons(node: Node) -> Array:
	var found: Array=[]
	for child in node.get_children():
		if child is Button and child.is_visible_in_tree():found.append(child)
		found.append_array(buttons(child))
	return found
func _ready() -> void:
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="user://arena001-hud-%d.json"%resolution.y
		Codec.save(app.save_path,Orders.defaults());viewport.add_child(app);await settle();viewport.notify_mouse_entered()
		app.notification(NOTIFICATION_APPLICATION_FOCUS_IN);app.open_arena();await settle()
		var game=app.combat;game.set_physics_process(false);game.set_process(false)
		check(buttons(game)==[game.pause_button,game.settings_button,game.statistics_button,game.journal_button],"Pause and combat settings are visible in the arena")
		check(game.hud.get_child_count()==11 and game.hero_panels.size()==4,"Menu, shared surfaces, four passive hero panels and wave counter in HUD")
		check(game.hero_panels.map(func(panel):return panel.hero_id)==[&"mako",&"anne",&"nassau",&""],"Mako Anne and two empty slots in 2x2 order")
		check(game.hero_panels.all(func(panel):return panel.mouse_filter==Control.MOUSE_FILTER_IGNORE),"panels do not select heroes")
		check(game.skill_buttons.is_empty() and game.hero_buttons.is_empty() and game.toolbar.is_empty() and game.footer_scroll==null and game.arena_picker==null,"old commands are not built")
		check(game.selected_hero==&"" and game.overhead.values().all(func(bar):return not bar.selected),"no yellow selected marker")
		game._command(&"heal");game._select_hero(&"mako");game._show_tab("rules")
		check(game.selected_hero==&"" and game.orders_editor==null and game.simulation.heroes.all(func(actor):return actor.pending.is_empty()),"removed controls cannot enqueue manual commands")
		game.safe_area_override=Rect2(8,24,resolution.x-16,resolution.y-44);game._update_layout();await settle()
		var safe: Rect2=game.safe_area_override
		check(safe.encloses(game.pause_button.get_global_rect()) and game.hero_panels.all(func(panel):return safe.encloses(panel.get_global_rect())),"panels and Pause respect safe area")
		check(game.hero_panels[0].position.y==game.hero_panels[1].position.y and game.hero_panels[2].position.y>game.hero_panels[0].position.y,"two panel rows")
		check(game.hero_panels[0].get_global_rect().position.y>resolution.y*.5,"hero grid occupies bottom of screen")
		var anne=game.simulation.hero(&"anne");var mako=game.simulation.hero(&"mako")
		anne.place(Vector2.ZERO);mako.place(Vector2(.8,0));mako.state.damage(110)
		check(anne.action.request(&"heal",mako)>0,"real cast fixture")
		anne.action.advance(.75);game._present();await settle()
		var panel=game.hero_panels[1];var overhead=game.overhead[anne.combat_id]
		check(panel.bars.casting and is_equal_approx(panel.bars.cast_ratio,.5) and overhead.casting and overhead.cast_ratio==panel.bars.cast_ratio,"panel and overhead cast bars follow real executor")
		check(game.hero_panels[0].bars.health_ratio==float(mako.state.health)/mako.state.max_health and panel.bars.mana_ratio==anne.action.mana/anne.mana_capacity,"health and mana follow actual actor values")
		tap(viewport,game.pause_button);await settle()
		check(game.paused and game.pause_layer.visible and buttons(game).filter(func(button):return not button.disabled).map(func(button):return button.text)==["Reprendre","Rejouer","Abandonner"],"Pause opens exactly three actions through actual touch")
		var frozen: Array=[game.simulation.clock.elapsed,anne.action.elapsed,anne.action.mana,anne.action.spent]
		for i in range(10):game._physics_process(.1)
		check(frozen==[game.simulation.clock.elapsed,anne.action.elapsed,anne.action.mana,anne.action.spent],"pause freezes time cast and mana")
		check(safe.encloses(game.pause_card.get_global_rect()),"small pause menu remains inside safe area")
		tap(viewport,game.abandon_button);await settle()
		check(game.confirming_abandon and app.route==&"arena" and game.paused,"abandon asks confirmation without leaving combat")
		check(game.pause_card.size.y<=280 and safe.encloses(game.pause_card.get_global_rect()),"confirmation stays small and inside safe area")
		tap(viewport,game.cancel_abandon_button);await settle()
		check(not game.confirming_abandon and game.paused and game.pause_layer.visible,"cancel keeps pause menu")
		tap(viewport,game.resume_button);await settle()
		check(not game.paused and not game.pause_layer.visible,"Resume returns to combat")
		game._physics_process(.01);check(anne.action.elapsed>frozen[1],"cast continues after explicit resume")
		game.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);game.notification(NOTIFICATION_APPLICATION_PAUSED);await settle()
		frozen=[game.simulation.clock.elapsed,anne.action.elapsed]
		game._resume_combat();game._replay_combat();game._physics_process(1)
		check(game.paused and game.pause_layer.visible and frozen==[game.simulation.clock.elapsed,anne.action.elapsed],"background blocks menu actions and clock")
		game.notification(NOTIFICATION_APPLICATION_RESUMED);game.notification(NOTIFICATION_APPLICATION_FOCUS_IN);await settle()
		check(game.paused and game.pause_layer.visible,"return from OS stays in pause awaiting Resume")
		var runs: int=game.simulation.run_id;var draws: int=app.arena_choice.draws
		tap(viewport,game.replay_button);await settle()
		check(game.simulation.run_id==runs+1 and app.arena_choice.draws==draws+1 and not game.paused and not game.pause_layer.visible,"Replay resets once and chooses one random arena")
		check(game.simulation.hero(&"mako").state.health==180 and game.simulation.hero(&"anne").state.health==140,"Replay resets actor values")
		game.simulation._finish("DEFAITE");game._toggle_pause();await settle()
		check(game.resume_button.disabled and not game.replay_button.disabled,"ended combat keeps Replay available without an extra HUD")
		runs=game.simulation.run_id;tap(viewport,game.replay_button);await settle()
		check(game.simulation.run_id==runs+1 and game.simulation.result=="EN COURS","Replay recovers from terminal combat")
		var saved: String=FileAccess.get_file_as_string(app.save_path)
		await get_tree().create_timer(.2).timeout;app.go_back();await settle()
		check(game.paused and game.pause_layer.visible,"Android Back opens pause without abandonment")
		tap(viewport,game.abandon_button);await settle()
		await get_tree().create_timer(.2).timeout;app.go_back();await settle()
		check(not game.confirming_abandon and game.paused,"Back from confirmation returns to pause")
		tap(viewport,game.abandon_button);await settle();tap(viewport,game.confirm_abandon_button);await settle()
		check(app.route==&"home" and app.combat==null and not is_instance_valid(game),"confirmed abandonment frees combat and returns Home")
		check(FileAccess.get_file_as_string(app.save_path)==saved,"pause replay and abandon preserve saved gambits")
		DirAccess.remove_absolute(app.save_path);viewport.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan portraits menus or actors")
	var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures];print(summary)
	var label:=Label.new();label.text=summary;add_child(label)
