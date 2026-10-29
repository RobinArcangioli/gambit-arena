extends "res://scripts/party/party_application.gd"
## Sparse product HUD. Legacy diagnostics keep their controls through the base hooks.
signal home_requested
const CombatSettings = preload("res://scripts/app/combat_settings.gd")
const StatisticsMenu=preload("res://scripts/ui/combat_statistics_menu.gd")
var statistics_button:Button
var journal_button:Button
var statistics_menu:Control
const SettingsMenu = preload("res://scripts/ui/combat_settings_menu.gd")
@export var settings_path: String = ""
var combat_settings: RefCounted
var settings_button: Button
var settings_menu: PanelContainer
const Choice = preload("res://scripts/app/arena_choice.gd")
const HeroPanel = preload("res://scripts/presentation/hero_status_panel.gd")
@export var infinite_mode: bool = false
var rotation_chooser: Callable
var icon_style: Resource = HeroPanel.Icons.DEFAULT_STYLE
var wave_counter: Label
var countdown: Label
var _arena_epoch: int = 0
var _history_wave: int = 0
var combat_rect := Rect2()
var arena_backdrop: ShaderMaterial
const ARENA_ZOOM_OUT: float = 1.08
var chooser: Callable
var fallback_choice := Choice.new()
var chosen_arena: StringName
var hero_panels: Array[HeroPanel] = []
var pause_layer: Control
var pause_card: PanelContainer
var pause_title: Label
var abandon_message: Label
var resume_button: Button
var replay_button: Button
var abandon_button: Button
var cancel_abandon_button: Button
var confirm_abandon_button: Button
var confirming_abandon: bool = false
var action_pending: bool = false
var exit_requested: bool = false

func _ready() -> void:
	combat_settings=CombatSettings.new(settings_path);combat_settings.load_preferences()
	simulation.report.enabled=true
	simulation.infinite_mode=infinite_mode
	orders_enabled=true
	selected_hero=&""
	super._ready()
	_apply_text_preferences()
	# These inherited laboratory decorations are never part of the product HUD.
	for child in hud.get_children():
		if child!=pause_button and child!=wave_counter and child!=settings_button and child!=statistics_button and child!=journal_button and not child is HeroPanel:
			hud.remove_child(child);child.queue_free()
	_update_layout();_present()

func _build_party_controls() -> void:
	settings_button=_button(hud,"",_open_settings)
	settings_button.icon=preload("res://assets/ui/combat_settings_gear.svg");settings_button.icon_alignment=HORIZONTAL_ALIGNMENT_CENTER
	settings_button.tooltip_text="Réglages de combat"
	for state in ["normal","hover","pressed","focus","disabled"]:
		settings_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	statistics_button=_button(hud,"",_open_statistics)
	statistics_button.icon=preload("res://assets/ui/combat_statistics.svg");statistics_button.icon_alignment=HORIZONTAL_ALIGNMENT_CENTER;statistics_button.tooltip_text="Statistiques"
	for state in ["normal","hover","pressed","focus","disabled"]:statistics_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	journal_button=_button(hud,"",_open_journal)
	journal_button.icon=preload("res://assets/ui/combat_journal.svg");journal_button.icon_alignment=HORIZONTAL_ALIGNMENT_CENTER;journal_button.tooltip_text="Journal de combat"
	for state in ["normal","hover","pressed","focus","disabled"]:journal_button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	if infinite_mode:
		wave_counter=_mode_label(22);hud.add_child(wave_counter)
		countdown=_mode_label(64);countdown.add_theme_constant_override("outline_size",6)
		add_child(countdown);countdown.hide()
	for id in [&"mako",&"anne",&"",&""]:
		var panel:=HeroPanel.new();panel.hero_id=id;panel.icon_style=icon_style;hud.add_child(panel);hero_panels.append(panel)

func _build_party_overlays() -> void:
	pause_layer=Control.new();pause_layer.mouse_filter=Control.MOUSE_FILTER_STOP;add_child(pause_layer)
	var shade:=ColorRect.new();shade.color=Color(0.02,0.03,0.07,0.48)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);pause_layer.add_child(shade)
	pause_card=PanelContainer.new();pause_layer.add_child(pause_card)
	var style:=get_theme_stylebox("normal","Button").duplicate() as StyleBoxFlat
	style.bg_color=Color("10182ff5");style.set_content_margin_all(18)
	pause_card.add_theme_stylebox_override("panel",style)
	var column:=VBoxContainer.new();column.add_theme_constant_override("separation",10);pause_card.add_child(column)
	pause_title=_label(column,22);pause_title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	abandon_message=_label(column,15);abandon_message.text="Le combat en cours sera perdu."
	abandon_message.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	resume_button=_button(column,"Reprendre",_resume_combat)
	replay_button=_button(column,"Rejouer",_replay_combat)
	abandon_button=_button(column,"Abandonner",_ask_abandon)
	cancel_abandon_button=_button(column,"Annuler",_cancel_abandon)
	confirm_abandon_button=_button(column,"Abandonner",_confirm_abandon)
	pause_layer.hide();_refresh_pause_menu()
	settings_menu=SettingsMenu.new();add_child(settings_menu)
	settings_menu.text_display_changed.connect(_change_text_settings)
	settings_menu.display_changed.connect(_change_settings);settings_menu.closed.connect(_close_settings)
	settings_menu.reflect(combat_settings.hero_bars,combat_settings.enemy_bars,combat_settings.damage_dealt_text,combat_settings.damage_received_text,combat_settings.healing_text);settings_menu.hide()
	statistics_menu=StatisticsMenu.new();add_child(statistics_menu)
	statistics_menu.playback_requested.connect(_toggle_journal_pause)

func _present() -> void:
	if not is_inside_tree():return
	if not ready_ui or simulation.heroes.is_empty():return
	for panel in hero_panels:
		if panel.hero_id!=&"":panel.show_actor(simulation.hero(panel.hero_id))
	_present_infinite()
	floor_canvas.feet.clear()
	for unit in simulation.all_units():
		if unit.state.alive:floor_canvas.feet.append(unit.position)
	floor_canvas.queue_redraw();_update_bars()
	if statistics_menu!=null:statistics_menu.sync_playback(paused,simulation.result=="EN COURS")
	if pause_layer!=null and pause_layer.visible:_refresh_pause_menu()

func _rebuild_footer() -> void:
	_present()
func _select_hero(_key: StringName) -> void:pass
func _command(_skill: StringName) -> void:pass
func _show_tab(_tab: String) -> void:pass
func _open_arena_picker() -> void:pass
func _open_rule(_index: int) -> void:pass
func _touch_scrollers() -> Array[ScrollContainer]:
	if settings_menu!=null and settings_menu.visible:return [settings_menu.scroller]
	return statistics_menu.scrollers() if statistics_menu!=null else []
func _modal_open() -> bool:return (pause_layer!=null and pause_layer.visible) or (settings_menu!=null and settings_menu.visible) or (statistics_menu!=null and statistics_menu.visible)

func _reset() -> void:
	if not ready_ui or application_guard.blocked:return
	_close_statistics()
	_arena_epoch=0;_history_wave=0
	var id: StringName=chooser.call() if chooser.is_valid() else fallback_choice.next()
	if id==&"reference" or not Catalog.ENTRIES.has(id):id=&"colisee_solaire"
	chosen_arena=id;arena_definition=Catalog.definition(id);floor_canvas.set_definition(arena_definition)
	super._reset();_sync_projection()

func _toggle_pause() -> void:
	if not ready_ui or application_guard.blocked or action_pending:return
	_close_settings();_close_statistics()
	if not paused:simulation.report.system(simulation.clock.elapsed,"Combat en pause.")
	paused=true;simulation.clock.paused=true;confirming_abandon=false
	pause_layer.show();_refresh_pause_menu();_update_layout();_update_buttons()

func _resume_combat() -> void:
	if application_guard.blocked or action_pending or confirming_abandon or not pause_layer.visible or simulation.result!="EN COURS":return
	_lock_actions();pause_layer.hide();paused=false
	simulation.report.system(simulation.clock.elapsed,"Combat repris.")
	application_guard.acknowledge_resume();simulation.clock.paused=false;_update_buttons()

func _replay_combat() -> void:
	if application_guard.blocked or action_pending or confirming_abandon or not pause_layer.visible:return
	_lock_actions();pause_layer.hide();paused=false;application_guard.acknowledge_resume()
	_reset();_update_buttons()

func _ask_abandon() -> void:
	if application_guard.blocked or action_pending or not pause_layer.visible:return
	confirming_abandon=true;_refresh_pause_menu();_update_layout()
func _cancel_abandon() -> void:
	if application_guard.blocked or action_pending:return
	confirming_abandon=false;_refresh_pause_menu();_update_layout()
func _confirm_abandon() -> void:
	if application_guard.blocked or action_pending or not confirming_abandon or exit_requested:return
	simulation.report.system(simulation.clock.elapsed,"Combat abandonné.")
	exit_requested=true;_lock_actions();home_requested.emit()
func _request_home() -> void:_ask_abandon()
func handle_back() -> void:
	if application_guard.blocked or action_pending:return
	if statistics_menu.visible:_close_statistics()
	elif settings_menu.visible:_close_settings()
	elif confirming_abandon:_cancel_abandon()
	elif _modal_open():_resume_combat()
	else:_toggle_pause()
func _lock_actions() -> void:
	action_pending=true;call_deferred("_unlock_actions")
func _unlock_actions() -> void:
	if not exit_requested:action_pending=false
	_update_buttons()
func _refresh_pause_menu() -> void:
	if pause_title==null:return
	pause_title.text="Abandonner le combat ?" if confirming_abandon else "Défaite" if infinite_mode and simulation.result=="DEFAITE" else "Pause"
	pause_title.add_theme_font_size_override("font_size",19 if confirming_abandon else 22)
	abandon_message.visible=confirming_abandon
	for button in [resume_button,replay_button,abandon_button]:button.visible=not confirming_abandon
	for button in [cancel_abandon_button,confirm_abandon_button]:button.visible=confirming_abandon
	for button in [resume_button,replay_button,abandon_button,cancel_abandon_button,confirm_abandon_button]:
		button.disabled=application_guard.blocked or action_pending or exit_requested
	resume_button.disabled=resume_button.disabled or simulation.result!="EN COURS"
func _update_buttons() -> void:
	if not is_inside_tree():return
	if not ready_ui:
		super._update_buttons();return
	pause_button.text="Pause";pause_button.disabled=application_guard.blocked or (pause_layer!=null and pause_layer.visible) or action_pending or exit_requested
	if settings_button!=null:settings_button.disabled=application_guard.blocked or (pause_layer!=null and pause_layer.visible) or action_pending or exit_requested
	if settings_menu!=null:settings_menu.set_blocked(application_guard.blocked or action_pending or exit_requested)
	if journal_button!=null:journal_button.disabled=application_guard.blocked or (pause_layer!=null and pause_layer.visible) or action_pending or exit_requested
	if wave_counter!=null:wave_counter.visible=statistics_menu==null or not statistics_menu.visible
	if statistics_button!=null:statistics_button.disabled=application_guard.blocked or (pause_layer!=null and pause_layer.visible) or action_pending or exit_requested
	if statistics_menu!=null:statistics_menu.set_blocked(application_guard.blocked or action_pending or exit_requested)
	simulation.clock.paused=paused;_refresh_pause_menu()
func _notification(what: int) -> void:
	if not ready_ui or pause_layer==null:return
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED]:
		_close_settings();_close_statistics()
		if not paused:simulation.report.system(simulation.clock.elapsed,"Combat en pause : application en arrière-plan.")
		paused=true;simulation.clock.paused=true;pause_layer.show()
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED,NOTIFICATION_APPLICATION_FOCUS_IN,NOTIFICATION_APPLICATION_RESUMED]:
		call_deferred("_update_buttons")
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode==KEY_SPACE:
		if statistics_menu.visible:_close_statistics()
		elif settings_menu.visible:_close_settings()
		elif _modal_open():_resume_combat()
		else:_toggle_pause()
		get_viewport().set_input_as_handled()

func _update_layout() -> void:
	if not is_inside_tree():return
	if not ready_ui:
		super._update_layout();return
	var view: Rect2=get_viewport_rect()
	var candidate: Rect2=safe_area_override
	if not candidate.has_area() and OS.get_name()=="Android":candidate=get_viewport().get_screen_transform().affine_inverse()*Rect2(DisplayServer.get_display_safe_area())
	safe_rect=Layout.usable_rect(view,candidate)
	$Backdrop.size=view.size;hud.position=safe_rect.position;hud.size=safe_rect.size
	render_box.position=Vector2.ZERO;render_box.size=view.size;floor_canvas.position=Vector2.ZERO
	bars_layer.position=Vector2.ZERO;bars_layer.size=view.size;bars_layer.clip_contents=true
	pause_button.position=Vector2(safe_rect.size.x-116,12);pause_button.size=Vector2(104,48)
	pause_button.add_theme_font_size_override("font_size",16)
	var width: float=(safe_rect.size.x-32)*0.5
	var grid_top:float=safe_rect.size.y-12-(2*icon_style.panel_height+8)
	combat_rect=Rect2(safe_rect.position+Vector2(12,72),Vector2(safe_rect.size.x-24,maxf(110,grid_top-120)))
	settings_button.position=combat_rect.position-safe_rect.position+Vector2(combat_rect.size.x-48,8)
	settings_button.size=Vector2(48,48)
	statistics_button.position=combat_rect.position-safe_rect.position+Vector2(0,8);statistics_button.size=Vector2(48,48)
	journal_button.position=statistics_button.position+Vector2(48,0);journal_button.size=Vector2(48,48)
	if statistics_menu!=null:
		statistics_menu.position=Vector2(combat_rect.position.x,combat_rect.position.y+60)
		statistics_menu.size=Vector2(combat_rect.size.x,maxf(160,safe_rect.position.y+grid_top-12-statistics_menu.position.y))
	if settings_menu!=null:
		settings_menu.position=Vector2(combat_rect.end.x-minf(304,combat_rect.size.x-16)-8,combat_rect.position.y+60)
		settings_menu.size=Vector2(minf(304,combat_rect.size.x-16),minf(settings_menu.preferred_height(),combat_rect.size.y-68))
	for i in range(hero_panels.size()):
		hero_panels[i].position=Vector2(12+(i%2)*(width+8),grid_top+int(i/2.0)*(icon_style.panel_height+8))
		hero_panels[i].size=Vector2(width,icon_style.panel_height)
	if wave_counter!=null:
		wave_counter.position=Vector2(12,grid_top-36);wave_counter.size=Vector2(safe_rect.size.x-24,28)
	if pause_layer!=null:
		pause_layer.position=Vector2.ZERO;pause_layer.size=view.size
		var card_size:=Vector2(minf(292,safe_rect.size.x-32),250)
		pause_card.position=safe_rect.position+(safe_rect.size-card_size)*0.5;pause_card.size=card_size
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	if not is_inside_tree():return
	super._sync_projection()
	if not ready_ui or not is_instance_valid(floor_canvas.active_view): return
	var art = floor_canvas.active_view
	if not "image_rect" in art: return
	# Zoom the calibrated image AND camera together, around their common ground origin.
	# No independent stretch of the floor: feet and the illustrated floor stay aligned.
	var center: Vector2 = camera.unproject_position(Vector3.ZERO)
	var rect: Rect2 = art.image_rect
	var target: Vector2 = Vector2(viewport_3d.size)
	var zoom: float = maxf(1, maxf(center.x/maxf(1,center.x-rect.position.x),(target.x-center.x)/maxf(1,rect.end.x-center.x)))
	zoom = maxf(zoom,maxf(center.y/maxf(1,center.y-rect.position.y),(target.y-center.y)/maxf(1,rect.end.y-center.y)))
	camera.size = camera.size / (zoom * 1.002) * ARENA_ZOOM_OUT
	# Fit the complete logical ground and character height above the footer.
	var bounds:Rect2=_projected_combat_bounds()
	var fit:float=minf(1.0,minf(combat_rect.size.x/maxf(1,bounds.size.x),combat_rect.size.y/maxf(1,bounds.size.y)))
	camera.size/=maxf(0.1,fit)
	bounds=_projected_combat_bounds()
	var offset:Vector2=combat_rect.get_center()-bounds.get_center()
	# Horizontal origin remains centered; only vertical framing changes.
	offset.x=0
	render_box.position=offset;floor_canvas.position=offset;bars_layer.position=offset
	floor_canvas.sync_view()
	# Extend only the photograph's outer edge outside its calibrated rectangle.
	# Ground pixels and models continue using precisely the same projection.
	if "background" in art and art.background!=null:
		art.opaque_backdrop=false;art.queue_redraw()
		if arena_backdrop==null:
			arena_backdrop=ShaderMaterial.new();arena_backdrop.shader=preload("res://shaders/presentation/arena_edge_fill.gdshader")
			$Backdrop.material=arena_backdrop
		arena_backdrop.set_shader_parameter("image_texture",art.background)
		arena_backdrop.set_shader_parameter("image_origin",art.image_rect.position+offset)
		arena_backdrop.set_shader_parameter("image_size",art.image_rect.size)

func _mode_label(font_size: int) -> Label:
	var label:=Label.new();label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("ffd16a"))
	label.add_theme_color_override("font_outline_color",Color("173a70"))
	label.add_theme_constant_override("outline_size",3)
	return label

func _present_infinite() -> void:
	if not infinite_mode or wave_counter==null:return
	var epoch: int=floori((simulation.wave_number-1)/10.0)
	if epoch!=_arena_epoch:
		var id: StringName=rotation_chooser.call(chosen_arena) if rotation_chooser.is_valid() else fallback_choice.next_excluding(chosen_arena)
		if id==chosen_arena or id==&"reference" or not Catalog.ENTRIES.has(id):id=fallback_choice.next_excluding(chosen_arena)
		chosen_arena=id;arena_definition=Catalog.definition(id);floor_canvas.set_definition(arena_definition)
		_arena_epoch=epoch;_sync_projection()
	if _history_wave!=simulation.wave_number:
		var retained: Dictionary={}
		for unit in simulation.all_units():retained[unit.combat_id]=true
		action_presenter.prune_history(retained)
		_history_wave=simulation.wave_number
	wave_counter.text="Vague %d"%simulation.wave_number
	countdown.visible=simulation.infinite.waiting and simulation.result=="EN COURS"
	if countdown.visible:
		countdown.text=str(maxi(1,ceili(simulation.infinite.remaining-0.000001)))
		var center: Vector2=render_box.position+camera.unproject_position(Vector3.ZERO)*(render_box.size/Vector2(viewport_3d.size))
		center.y=clampf(center.y,combat_rect.position.y+54,combat_rect.end.y-54)
		countdown.position=center-Vector2(80,54);countdown.size=Vector2(160,108)

func _projected_combat_bounds() -> Rect2:
	var result:=Rect2(camera.unproject_position(Vector3(-3,0,-3)),Vector2.ZERO)
	for x in [-3.0,3.0]:
		for z in [-3.0,3.0]:
			for height in [0.0,1.6]:result=result.expand(camera.unproject_position(Vector3(x,height,z)))
	return result

func _open_settings() -> void:
	if not ready_ui or application_guard.blocked or action_pending or pause_layer.visible:return
	touch_router.cancel_gesture();_close_statistics()
	settings_menu.reflect(combat_settings.hero_bars,combat_settings.enemy_bars,combat_settings.damage_dealt_text,combat_settings.damage_received_text,combat_settings.healing_text)
	settings_menu.visible=not settings_menu.visible
	_update_layout();_update_buttons()
func _close_settings() -> void:
	if settings_menu!=null:settings_menu.hide()
func _change_settings(hero_bars: bool, enemy_bars: bool) -> void:
	if application_guard.blocked:return
	combat_settings.hero_bars=hero_bars;combat_settings.enemy_bars=enemy_bars
	var result: Error=combat_settings.save_preferences()
	settings_menu.status.text="Enregistrement indisponible" if result!=OK else ""
	settings_menu.status.visible=result!=OK
	_update_bars()
func _update_bars() -> void:
	super._update_bars()
	if combat_settings==null:return
	for unit in simulation.all_units():
		var show_bars:bool=combat_settings.hero_bars if unit.team==0 else combat_settings.enemy_bars
		if overhead.has(unit.combat_id) and not show_bars:overhead[unit.combat_id].hide()

func _open_statistics() -> void:_open_report(false)
func _open_journal() -> void:_open_report(true)
func _open_report(journal:bool) -> void:
	if not ready_ui or application_guard.blocked or action_pending or pause_layer.visible:return
	touch_router.cancel_gesture();_close_settings()
	if statistics_menu.visible and statistics_menu.journal_mode==journal:statistics_menu.hide()
	else:statistics_menu.open(simulation.report,journal)
	_update_layout();_update_buttons()
func _close_statistics() -> void:
	if statistics_menu!=null:statistics_menu.hide()
	if wave_counter!=null:wave_counter.show()
func _toggle_journal_pause() -> void:
	if application_guard.blocked or action_pending or simulation.result!="EN COURS" or not statistics_menu.visible or not statistics_menu.journal_mode:return
	_lock_actions();paused=not paused;simulation.clock.paused=paused
	if not paused:application_guard.acknowledge_resume()
	simulation.report.system(simulation.clock.elapsed,"Combat en pause." if paused else "Combat repris.")
	statistics_menu.sync_playback(paused,true);_update_buttons()

func _apply_text_preferences() -> void:
	action_presenter.set_text_preferences(combat_settings.damage_dealt_text,combat_settings.damage_received_text,combat_settings.healing_text)
func _change_text_settings(outgoing:bool,incoming:bool,healing:bool) -> void:
	if application_guard.blocked:return
	combat_settings.damage_dealt_text=outgoing;combat_settings.damage_received_text=incoming;combat_settings.healing_text=healing
	_apply_text_preferences()
	var result:Error=combat_settings.save_preferences()
	settings_menu.status.text="Enregistrement indisponible" if result!=OK else "";settings_menu.status.visible=result!=OK
