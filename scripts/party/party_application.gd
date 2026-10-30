extends "res://scripts/arena/arena.gd"
## Composition of independent party logic, models, bars, Android guard and touch-safe UI.
const Presenter = preload("res://scripts/presentation/combat_presenter.gd")
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
const Store = preload("res://scripts/gambits/configuration_store.gd")
const OrdersEditor = preload("res://scripts/gambits/orders_editor.gd")
@export var orders_enabled: bool = false
var orders_editor: OrdersEditor
const Rules = preload("res://scripts/party/party_rules.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const PartyUnit = preload("res://scripts/party/party_unit.gd")
const Bars = preload("res://scripts/presentation/overhead_bars.gd")
const Layout = preload("res://scripts/ui/hud_layout.gd")
const Router = preload("res://scripts/ui/touch_scroll_router.gd")
const Guard = preload("res://scripts/platform/application_guard.gd")
const Picker = preload("res://scripts/presentation/arena_picker.gd")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
const APPEARANCES = {&"anne": preload("res://resources/presentation/characters/anne.tres"), &"mako": preload("res://resources/presentation/characters/mako.tres"), &"nassau":preload("res://resources/presentation/characters/nassau.tres"), &"skeleton": preload("res://resources/presentation/characters/skeleton_variant.tres")}
var team_slots:Array[StringName]=preload("res://scripts/party/party_roster.gd").SLOTS.duplicate()
@export var characters_enabled: bool = true
@export var action_animations_enabled: bool = true
@export var save_path: String = "user://party_rules_v2.json"
var simulation := Simulation.new()
var action_presenter := Presenter.new()
var application_guard := Guard.new()
var touch_router := Router.new()
var arena_picker: Picker
var selected_hero: StringName = &"anne"
var ready_ui: bool = false
var selected_tab: String = "skills"
var status: Label
var hero_buttons: Array[Button] = []
var skill_buttons: Array[Button] = []
var rules_buttons: Array[Button] = []
var toolbar: Array[Button] = []
var footer_scroll: ScrollContainer
var footer_content: VBoxContainer
var overlay: ColorRect
var modal_scroll: ScrollContainer
var modal_content: VBoxContainer
var modal_title: Label
var editing_index: int = -1
var draft: Dictionary = {}
var modal_buttons: Array[Button] = []
var threshold_label: Label
var apply_button: Button
var feedback_label: Label
var bars_layer: Control
var overhead: Dictionary = {}
var migration: Dictionary = {}
var layout_probe: float = 0.0
var safe_area_override := Rect2()

func _ready() -> void:
	super._ready()
	hero.hide()
	enemy.hide()
	hero.queue_free()
	enemy.queue_free()
	for slot in slots: slot.hide()
	position_button.hide()
	marks_button.hide()
	$HUD/SlotsTitle.hide()
	$HUD/Title.text = "GAMBIT ARENA"
	$HUD/Title.add_theme_font_size_override("font_size", 20)
	$HUD/Description.add_theme_font_size_override("font_size", 15)
	world.child_entered_tree.connect(_compose_actor)
	action_presenter.name = "CombatPresentation"
	world.add_child(action_presenter)
	add_child(simulation)
	simulation.configure(world)
	simulation.orders_enabled = orders_enabled
	simulation.team_slots=team_slots.duplicate()
	if orders_enabled:
		simulation.rules = Orders.defaults()
		var store := Store.new(save_path)
		if store.load_configuration()==OK:simulation.rules = store.configuration
	elif not save_path.is_empty():
		var stored: Dictionary = Rules.load_configuration(save_path)
		if not stored.is_empty(): simulation.rules = stored
	_build_party_controls()
	bars_layer = Control.new()
	bars_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bars_layer)
	move_child(bars_layer, hud.get_index())
	_build_party_overlays()
	touch_router.active_scrollers = _touch_scrollers
	add_child(touch_router)
	# Raw input guard must remain last for reverse depth-first dispatch.
	add_child(application_guard)
	ready_ui = true
	_update_layout()
	_reset()

func _build_party_controls() -> void:
	status = _label(hud, 15)
	for key in [&"anne", &"mako"]:
		var button := _button(hud, String(key).capitalize(), _select_hero.bind(key))
		button.toggle_mode = true
		hero_buttons.append(button)
	footer_scroll = _scroll(hud)
	footer_content = _column(footer_scroll)
	var replay_button := _button(hud, "Rejouer", _reset)
	var arena_button := _button(hud, "Arenes", _open_arena_picker)
	var skills_button := _button(hud, "Competences", _show_tab.bind("skills"))
	var rules_button := _button(hud, "Gambits", _show_tab.bind("rules"))
	toolbar = [replay_button, arena_button, skills_button, rules_button]

func _build_party_overlays() -> void:
	overlay = ColorRect.new()
	overlay.color = Color(0.035, 0.055, 0.09, 0.98)
	overlay.hide()
	add_child(overlay)
	modal_scroll = _scroll(overlay)
	modal_content = _column(modal_scroll)
	arena_picker = Picker.new()
	arena_picker.hide()
	add_child(arena_picker)
	arena_picker.arena_selected.connect(_choose_arena)
	arena_picker.close_requested.connect(_close_arena_picker)

func _compose_actor(node: Node) -> void:
	if node is PartyUnit:
		node.appearance = APPEARANCES.get(node.actor_key)
		node.presentation_enabled = characters_enabled

func _label(parent: Node, font_size: int = 16) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", font_size)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _button(parent: Node, caption: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = caption
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.custom_minimum_size.y = 48
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(callback)
	parent.add_child(button)
	return button

func _scroll(parent: Node) -> ScrollContainer:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.scroll_deadzone = 12
	parent.add_child(scroll)
	return scroll

func _column(parent: Node) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.mouse_filter = Control.MOUSE_FILTER_PASS
	column.add_theme_constant_override("separation", 8)
	parent.add_child(column)
	return column

func _select_hero(key: StringName) -> void:
	if application_guard.blocked or _modal_open(): return
	selected_hero = key
	touch_router.cancel_gesture()
	_rebuild_footer()
	_present()

func _show_tab(tab: String) -> void:
	if application_guard.blocked or _modal_open(): return
	selected_tab = tab
	touch_router.cancel_gesture()
	_rebuild_footer()

func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func _rebuild_footer() -> void:
	if not ready_ui: return
	orders_editor = null
	_clear_children(footer_content)
	skill_buttons.clear()
	rules_buttons.clear()
	if selected_tab == "skills":
		var actor = simulation.hero(selected_hero)
		for skill in actor.abilities:
			var button := _button(footer_content, "", _command.bind(skill))
			button.custom_minimum_size.y = 60
			skill_buttons.append(button)
	elif orders_enabled:
		orders_editor = OrdersEditor.new();orders_editor.hero_id = selected_hero;orders_editor.save_path = save_path
		orders_editor.configuration_changed.connect(func(config: Dictionary):simulation.rules = config)
		footer_content.add_child(orders_editor)
		footer_scroll.theme = orders_editor.theme
	else:
		var explanation := _label(footer_content, 15)
		explanation.text = "Priorite de haut en bas / appui pour modifier"
		for i in range(3):
			var row := HBoxContainer.new()
			footer_content.add_child(row)
			var edit := _button(row, "", _open_rule.bind(i))
			edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			edit.clip_text = true
			edit.custom_minimum_size.y = 76
			rules_buttons.append(edit)
			_button(row, "ON" if simulation.rules[String(selected_hero)][i].enabled else "OFF", _toggle_rule.bind(i)).custom_minimum_size.x = 48
			var up := _button(row, "↑", _move_rule.bind(i, -1))
			up.disabled = i == 0
			up.custom_minimum_size.x = 44
			var down := _button(row, "↓", _move_rule.bind(i, 1))
			down.disabled = i == 2
			down.custom_minimum_size.x = 44
		_button(footer_content, "Importer le preset historique…", _preview_migration)
	feedback_label = _label(footer_content, 15)
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_present()

static func skill_name(skill: StringName) -> String:
	return "Météore" if skill==&"meteor" else "Booster" if skill == &"booster" else "Soin" if skill == &"heal" else "Foudre" if skill == &"lightning" else "Attaque"

func _command(skill: StringName) -> void:
	if application_guard.blocked or _modal_open(): return
	simulation.request_manual(selected_hero, skill)
	_present()

func _present() -> void:
	if not ready_ui or simulation.heroes.is_empty(): return
	var actor = simulation.hero(selected_hero)
	for i in range(hero_buttons.size()):
		var member = simulation.heroes[i]
		hero_buttons[i].text = "%s%s" % [member.display_name, " / KO" if not member.state.alive else ""]
		hero_buttons[i].set_pressed_no_signal(member.actor_key == selected_hero)
	$HUD/Description.text = "%s / vague %d/%d" % ["PAUSE" if paused and simulation.result == "EN COURS" else simulation.result, simulation.wave_number, simulation.wave_count]
	var action = actor.action
	var action_text: String = "Repos"
	if action.active:
		action_text = "%s / %.1f s" % [skill_name(action.last_skill), maxf(0, Executor.cast_duration(action.last_skill) - action.elapsed)] if action.casting() else "Recuperation" if action.resolved else "Attaque"
	elif not actor.pending.is_empty(): action_text = "Commande en attente / %.1f s" % maxf(0.0, actor.pending.deadline - simulation.clock.elapsed)
	status.text = "%s  |  PV %d/%d  |  Mana %d/%d\n%s\nSoin %.1f s  /  Foudre %.1f s  |  Ennemis %d" % [actor.display_name, actor.state.health, actor.state.max_health, floori(action.mana), actor.mana_capacity, action_text, action.remaining(&"heal"), action.remaining(&"lightning"), simulation.enemies.size()]
	for i in range(skill_buttons.size()):
		var skill: StringName = actor.abilities[i]
		skill_buttons[i].text = "%s  /  %d mana\n%s" % [skill_name(skill), Executor.cost(skill), "Incantation %.1f s  ·  Delai %.1f s" % [Executor.cast_duration(skill), action.remaining(skill)] if skill != &"basic" else "Attaque de base"]
		# Busy/resource/cooldown commands may queue; terminal, pause and dead heroes cannot.
		skill_buttons[i].disabled = paused or simulation.result != "EN COURS" or not actor.state.alive
	for i in range(rules_buttons.size()):
		var rule: Dictionary = simulation.rules[String(selected_hero)][i]
		rules_buttons[i].text = "%d. %s\n%s\n%s" % [i + 1, skill_name(rule.skill), "Allie (soi inclus)" if rule.target == "ally" else "Ennemi", "Toujours" if rule.condition == "always" else "PV < %d %%" % rule.threshold]
	if is_instance_valid(feedback_label): feedback_label.text = simulation.feedback
	floor_canvas.feet.clear()
	for unit in simulation.all_units():
		if unit.state.alive: floor_canvas.feet.append(unit.position)
	floor_canvas.queue_redraw()
	_update_bars()

func _update_bars() -> void:
	var current: Dictionary = {}
	for unit in simulation.all_units():
		if not unit.state.alive: continue
		current[unit.combat_id] = true
		if not overhead.has(unit.combat_id):
			var bar := Bars.new()
			bars_layer.add_child(bar)
			overhead[unit.combat_id] = bar
		var bar: Bars = overhead[unit.combat_id]
		bar.selected = unit.actor_key == selected_hero
		bar.set_values(unit.state.health, unit.state.max_health, unit.action.mana, unit.mana_capacity, unit.action.casting(), unit.action.cast_progress())
		bar.set_attack(unit.action.active and unit.action.last_skill==&"basic",unit.action.elapsed,unit.action._windup(),unit.action._recovery())
		var height: float = unit.appearance.overhead_height if unit.appearance != null else 1.3
		var projected: Vector2 = camera.unproject_position(unit.position + Vector3(0, height, 0))
		var ratio: Vector2 = render_box.size / Vector2(viewport_3d.size)
		bar.position = projected * ratio
		bar.visible = not camera.is_position_behind(unit.position)
	for id in overhead.keys():
		if not current.has(id):
			overhead[id].queue_free()
			overhead.erase(id)

func _process(delta: float) -> void:
	if not ready_ui: return
	layout_probe += delta
	if layout_probe >= 0.25:
		layout_probe = 0.0
		_update_layout()
	_update_bars()

func _physics_process(delta: float) -> void:
	if not ready_ui: return
	if application_guard.blocked or application_guard.resume_required: paused = true
	simulation.clock.paused = paused
	if not paused and application_guard.consume_return_step():
		_present()
		return
	action_presenter.capture(simulation.all_units(), simulation.run_id)
	var before: float = simulation.clock.elapsed
	simulation.advance(delta, paused)
	var dt: float = maxf(0, simulation.clock.elapsed - before)
	var visual_dt: float = dt
	# A bounded visual tail completes death after terminal gameplay has stopped.
	# It obeys the same pause/focus gate and never advances the game clock.
	if simulation.result != "EN COURS" and not paused and not application_guard.blocked and not application_guard.resume_required and is_finite(delta) and delta > 0.0:
		visual_dt = minf(delta, simulation.clock.MAX_STEP)
	action_presenter.enabled = action_animations_enabled
	action_presenter.present(simulation.all_units(), simulation.events, visual_dt, simulation.run_id, simulation.result != "EN COURS")
	_present()

func _reset() -> void:
	if not ready_ui or application_guard.blocked: return
	touch_router.cancel_gesture()
	simulation.reset()
	action_presenter.reset_run(simulation.run_id)
	simulation.clock.paused = paused
	_rebuild_footer()
	_update_buttons()

func _update_buttons() -> void:
	if not ready_ui:
		super._update_buttons()
		return
	pause_button.text = "Reprendre" if paused else "Pause"
	pause_button.disabled = application_guard.blocked or _modal_open()
	for button in toolbar: button.disabled = application_guard.blocked or _modal_open()
	simulation.clock.paused = paused
	_present()

func _toggle_pause() -> void:
	if not ready_ui or application_guard.blocked or _modal_open(): return
	paused = not paused
	if not paused: application_guard.acknowledge_resume()
	_update_buttons()

func _modal_open() -> bool:
	return ready_ui and (overlay.visible or arena_picker.visible)

func _open_arena_picker() -> void:
	if application_guard.blocked or _modal_open(): return
	paused = true
	touch_router.cancel_gesture()
	arena_picker.mark_selected(floor_canvas.definition.arena_id)
	arena_picker.show()
	_update_buttons()

func _choose_arena(id: StringName) -> void:
	if application_guard.blocked or not arena_picker.visible: return
	arena_definition = Catalog.definition(id)
	floor_canvas.set_definition(arena_definition)
	_sync_projection()
	_close_arena_picker()

func _close_arena_picker() -> void:
	if application_guard.blocked: return
	arena_picker.hide()
	touch_router.cancel_gesture()
	_update_buttons()

func _open_rule(index: int) -> void:
	if application_guard.blocked or _modal_open(): return
	paused = true
	editing_index = index
	draft = simulation.rules[String(selected_hero)][index].duplicate(true)
	_clear_children(modal_content)
	modal_title = _label(modal_content, 21)
	modal_title.text = "%s / gambit %d" % [String(selected_hero).capitalize(), index + 1]
	modal_buttons.clear()
	modal_buttons.append(_button(modal_content, "", _cycle_rule_skill))
	modal_buttons.append(_button(modal_content, "", _cycle_condition))
	threshold_label = _label(modal_content)
	var row := HBoxContainer.new()
	modal_content.add_child(row)
	for amount in [-10, -1, 1, 10]:
		var b := _button(row, "%+d" % amount, _change_threshold.bind(amount))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var explanation := _label(modal_content)
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	explanation.text = "Le Soin cible un membre vivant de l'equipe, Anne comprise. Priorite au pourcentage de PV le plus bas. Le seuil est strict."
	apply_button = _button(modal_content, "Appliquer", _apply_rule)
	_button(modal_content, "Annuler", _close_modal)
	_refresh_rule()
	overlay.show()
	modal_scroll.scroll_vertical = 0
	touch_router.cancel_gesture()
	_update_buttons()

func _refresh_rule() -> void:
	modal_buttons[0].text = "%s → %s" % ["Allie (soi inclus)" if draft.target == "ally" else "Ennemi", skill_name(draft.skill)]
	modal_buttons[1].text = "Condition : " + ("Toujours" if draft.condition == "always" else "PV < seuil")
	threshold_label.text = "Seuil : %d %%" % draft.threshold

func _cycle_rule_skill() -> void:
	if application_guard.blocked: return
	draft.skill = "basic" if draft.skill != "basic" else "heal" if selected_hero == &"anne" else "lightning"
	draft.target = "ally" if draft.skill == "heal" else "enemy"
	_refresh_rule()

func _cycle_condition() -> void:
	if application_guard.blocked: return
	draft.condition = "always" if draft.condition != "always" else "hp_below"
	_refresh_rule()

func _change_threshold(amount: int) -> void:
	if application_guard.blocked: return
	draft.threshold = clampi(draft.threshold + amount, 0, 100)
	_refresh_rule()

func _apply_rule() -> void:
	if application_guard.blocked or editing_index < 0 or not Rules.valid_rule(draft, selected_hero): return
	simulation.rules[String(selected_hero)][editing_index] = draft.duplicate(true)
	_persist()
	_close_modal()

func _toggle_rule(index: int) -> void:
	if application_guard.blocked or _modal_open(): return
	var rule: Dictionary = simulation.rules[String(selected_hero)][index]
	rule.enabled = not rule.enabled
	_persist()
	touch_router.cancel_gesture()
	_rebuild_footer()

func _move_rule(index: int, direction: int) -> void:
	if application_guard.blocked or _modal_open(): return
	var destination: int = index + direction
	if destination < 0 or destination >= 3: return
	var rows: Array = simulation.rules[String(selected_hero)]
	var row = rows[index]
	rows[index] = rows[destination]
	rows[destination] = row
	_persist()
	touch_router.cancel_gesture()
	_rebuild_footer()

func _persist() -> void:
	if not save_path.is_empty() and Rules.save_configuration(save_path, simulation.rules) != OK:
		simulation.feedback = "Sauvegarde impossible ; regles conservees pour cette session."

func _preview_migration() -> void:
	if application_guard.blocked or _modal_open(): return
	var legacy: Array = [
		{"enabled": true, "target": "self", "condition": "hp_below", "threshold": 50, "skill": "heal"},
		{"enabled": true, "target": "enemy", "condition": "always", "threshold": 50, "skill": "special"},
		{"enabled": true, "target": "enemy", "condition": "always", "threshold": 50, "skill": "basic"}]
	migration = Rules.migrate_legacy(legacy, selected_hero)
	paused = true
	_clear_children(modal_content)
	var title := _label(modal_content, 20)
	title.text = "Importer le preset historique"
	var text := _label(modal_content)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.text = "Remplace les trois regles de %s.\n\n%s\n\nLes autres regles incompatibles seront desactivees." % [String(selected_hero).capitalize(), "\n".join(migration.notes)]
	_button(modal_content, "Confirmer l'import", _apply_migration)
	_button(modal_content, "Annuler", _close_modal)
	overlay.show()
	touch_router.cancel_gesture()
	_update_buttons()

func _apply_migration() -> void:
	if application_guard.blocked or migration.is_empty(): return
	simulation.rules[String(selected_hero)] = migration.rules.duplicate(true)
	_persist()
	_close_modal()

func _close_modal() -> void:
	if application_guard.blocked: return
	overlay.hide()
	editing_index = -1
	draft.clear()
	migration.clear()
	touch_router.cancel_gesture()
	_rebuild_footer()
	_update_buttons()

func _touch_scrollers() -> Array[ScrollContainer]:
	if not ready_ui: return []
	if is_instance_valid(orders_editor) and orders_editor.popup_open():return []
	if arena_picker.visible: return [arena_picker.scroll]
	if overlay.visible: return [modal_scroll]
	return [footer_scroll]

func _notification(what: int) -> void:
	if not is_instance_valid(application_guard): return
	if application_guard.observe(what) and application_guard.resume_required:
		paused = true
		if ready_ui:
			if is_instance_valid(orders_editor):orders_editor.set_active(false)
			touch_router.notification(what)
			_update_buttons()
	if ready_ui and what in [NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_IN]:
		if is_instance_valid(orders_editor):orders_editor.set_active(not application_guard.blocked)
		call_deferred("_update_layout")

func _unhandled_key_input(event: InputEvent) -> void:
	if not ready_ui or not event is InputEventKey or not event.pressed or event.echo or application_guard.blocked: return
	if event.keycode == KEY_ESCAPE and _modal_open():
		if arena_picker.visible: _close_arena_picker()
		else: _close_modal()
	elif event.keycode == KEY_SPACE: _toggle_pause()
	elif event.keycode == KEY_R and not _modal_open(): _reset()
	else: return
	get_viewport().set_input_as_handled()

func _update_layout() -> void:
	if not ready_ui:
		super._update_layout()
		return
	var view: Rect2 = get_viewport_rect()
	safe_rect = view
	if safe_area_override.has_area():
		safe_rect = Layout.usable_rect(view, safe_area_override)
	elif OS.get_name() == "Android":
		safe_rect = Layout.usable_rect(view, get_viewport().get_screen_transform().affine_inverse() * Rect2(DisplayServer.get_display_safe_area()))
	$Backdrop.size = view.size
	hud.position = safe_rect.position
	hud.size = safe_rect.size
	var areas: Dictionary = Layout.regions(safe_rect.size)
	$HUD/HeaderPanel.position = areas.header.position
	$HUD/HeaderPanel.size = areas.header.size
	$HUD/Title.position = Vector2(24, 18)
	$HUD/Description.position = Vector2(24, 47)
	pause_button.position = Vector2(safe_rect.size.x - 128, 18)
	pause_button.size = Vector2(104, 48)
	var half: float = (safe_rect.size.x - 56) * 0.5
	for i in range(2):
		hero_buttons[i].position = Vector2(24 + i * (half + 8), 84)
		hero_buttons[i].size = Vector2(half, 44)
	status.position = Vector2(24, 138)
	status.size = Vector2(safe_rect.size.x - 48, 76)
	status.add_theme_font_size_override("font_size", 14 if safe_rect.size.x < 400 else 15)
	render_box.position = safe_rect.position + areas.arena.position
	render_box.size = areas.arena.size
	floor_canvas.position = render_box.position
	bars_layer.position = render_box.position
	bars_layer.size = render_box.size
	bars_layer.clip_contents = true
	$HUD/FooterPanel.position = areas.footer.position
	$HUD/FooterPanel.size = areas.footer.size
	for i in range(4):
		toolbar[i].position = areas.footer.position + Vector2(12 + (i % 2) * (half + 8), 8 + int(i / 2.0) * 56)
		toolbar[i].size = Vector2(half, 48)
	footer_scroll.position = areas.footer.position + Vector2(12, 120)
	footer_scroll.size = Vector2(areas.footer.size.x - 24, areas.footer.size.y - 132)
	overlay.position = safe_rect.position + areas.modal.position
	overlay.size = areas.modal.size
	modal_scroll.position = Vector2(16, 16)
	modal_scroll.size = overlay.size - Vector2(32, 32)
	arena_picker.position = safe_rect.position
	arena_picker.size = safe_rect.size
	call_deferred("_sync_projection")

func _sync_projection() -> void:
	if not is_node_ready(): return
	camera.size = Layout.camera_width(Vector2(viewport_3d.size))
	floor_canvas.view_size = Vector2(viewport_3d.size)
	floor_canvas.sync_view()
