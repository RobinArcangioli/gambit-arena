extends Control
## Routes own scene lifetime. No combat exists on Home; configuration remains in its file.
const GambitsPage = preload("res://scenes/app/gambits_page.tscn")
const HeroPage = preload("res://scenes/app/hero_page.tscn")
const TeamPage = preload("res://scenes/app/team_page.tscn")
const ArenaPage = preload("res://scenes/app/arena_page.tscn")
const Choice = preload("res://scripts/app/arena_choice.gd")
const Guard = preload("res://scripts/platform/application_guard.gd")
const Layout = preload("res://scripts/ui/hud_layout.gd")
const Home = preload("res://assets/art/ui/home.png")
const AppTheme = preload("res://resources/ui/night_gold.tres")
const ROUTES = [&"home", &"arena", &"team", &"hero", &"gambits"]
@export var save_path: String = "user://party_rules_v2.json"
var arena_choice := Choice.new()
var guard := Guard.new()
var background: TextureRect
var home_page: Control
var arena_button: Button
var team_button: Button
var combat
var team_page
var hero_page
var gambits_page
var selected_hero_id: StringName
signal hero_selected(hero_id: StringName)
var route: StringName = &"home"
var transitioning: bool = false
var _last_back_msec: int = -10000
var safe_area_override := Rect2()

func _ready() -> void:
	theme = AppTheme
	if get_tree().has_method("set_quit_on_go_back"):get_tree().set_quit_on_go_back(false)
	background = TextureRect.new();background.texture = Home
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	home_page = Control.new();home_page.mouse_filter = Control.MOUSE_FILTER_IGNORE;add_child(home_page)
	team_button = _button("Équipe");team_button.pressed.connect(open_team)
	arena_button = _button("Arène");arena_button.pressed.connect(open_arena)
	add_child(guard)
	get_viewport().size_changed.connect(_layout)
	_layout()

func _button(caption: String) -> Button:
	var button := Button.new();button.text = caption
	button.add_theme_font_size_override("font_size",23)
	button.focus_mode = Control.FOCUS_ALL
	home_page.add_child(button)
	return button

func _layout() -> void:
	if background == null:return
	var view: Rect2 = get_viewport_rect()
	background.position = Vector2.ZERO;background.size = view.size
	var candidate: Rect2 = safe_area_override
	if not candidate.has_area() and OS.get_name() == "Android":candidate = get_viewport().get_screen_transform().affine_inverse()*Rect2(DisplayServer.get_display_safe_area())
	var safe: Rect2 = Layout.usable_rect(view,candidate)
	home_page.position = safe.position;home_page.size = safe.size
	var width: float = minf(360,safe.size.x*0.68)
	var top: float = minf(safe.size.y*0.76,safe.size.y-156)
	team_button.position = Vector2((safe.size.x-width)*0.5,top);team_button.size = Vector2(width,60)
	arena_button.position = team_button.position+Vector2(0,76);arena_button.size = Vector2(width,60)

func open_arena() -> void:
	if guard.blocked or transitioning or route!=&"home":return
	transitioning = true
	arena_button.disabled = true
	guard.acknowledge_resume()
	combat = ArenaPage.instantiate()
	combat.save_path = save_path
	combat.chooser = arena_choice.next
	combat.home_requested.connect(return_home)
	add_child(combat)
	home_page.hide();background.hide();route = &"arena"
	call_deferred("_finish_transition")

func return_home() -> void:
	if guard.blocked or transitioning or route==&"home":return
	transitioning = true
	if combat != null:
		combat.touch_router.cancel_gesture()
		combat.process_mode = Node.PROCESS_MODE_DISABLED
		remove_child(combat);combat.queue_free();combat = null
	if gambits_page != null:
		gambits_page.set_active(false);remove_child(gambits_page);gambits_page.queue_free();gambits_page = null
	if hero_page != null:
		hero_page.set_active(false)
		remove_child(hero_page);hero_page.queue_free();hero_page = null
	if team_page != null:
		team_page.set_active(false)
		remove_child(team_page);team_page.queue_free();team_page = null
	route = &"home";home_page.show();background.show()
	call_deferred("_finish_transition")

func _finish_transition() -> void:
	transitioning = false
	arena_button.disabled = guard.blocked
	team_button.disabled = guard.blocked

func go_back() -> void:
	if guard.blocked or transitioning:return
	# Android can deliver both an Escape key and the native Back notification.
	# Treat that closely spaced pair as one navigation intent, including modals.
	var now: int = Time.get_ticks_msec()
	if now - _last_back_msec < 180: return
	_last_back_msec = now
	if gambits_page != null:
		if gambits_page.editor.close_popup():return
		return_hero()
	elif hero_page != null:
		return_team()
	elif team_page != null:
		return_home()
	elif combat != null:
		if is_instance_valid(combat.orders_editor) and combat.orders_editor.close_popup():return
		if combat._modal_open():
			if combat.arena_picker.visible:combat._close_arena_picker()
			else:combat._close_modal()
		else:return_home()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE and route!=&"home":
		go_back();get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if guard == null:return
	if guard.observe(what) and is_instance_valid(arena_button):
		arena_button.disabled = guard.blocked
		team_button.disabled = guard.blocked
		if team_page != null:team_page.set_active(not guard.blocked and route==&"team")
		if hero_page != null:hero_page.set_active(not guard.blocked and route==&"hero")
		if gambits_page != null:gambits_page.set_active(not guard.blocked)
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if route!=&"home":go_back()
		# Home is the root route: a repeated Android Back must not close the app.
		# The OS Home gesture remains available for putting it in the background.

func open_team() -> void:
	if guard.blocked or transitioning or route!=&"home":return
	transitioning = true
	team_button.disabled = true
	guard.acknowledge_resume()
	team_page = TeamPage.instantiate()
	team_page.home_requested.connect(return_home)
	team_page.hero_selected.connect(_select_team_hero)
	add_child(team_page)
	home_page.hide();background.hide();route = &"team"
	call_deferred("_finish_transition")

func _select_team_hero(id: StringName) -> void:
	if guard.blocked or transitioning or route!=&"team" or not team_page.Roster.PROFILES.has(id):return
	selected_hero_id = id
	transitioning = true
	team_page.set_active(false);team_page.hide()
	hero_page = HeroPage.instantiate();hero_page.hero_id = id
	hero_page.team_requested.connect(return_team);hero_page.gambits_requested.connect(open_gambits);add_child(hero_page)
	route = &"hero"
	hero_selected.emit(id)
	call_deferred("_finish_transition")

func return_team() -> void:
	if guard.blocked or transitioning or route!=&"hero":return
	transitioning = true
	hero_page.set_active(false);remove_child(hero_page);hero_page.queue_free();hero_page = null
	team_page.show();team_page.set_active(true);route = &"team"
	call_deferred("_finish_transition")

func open_gambits() -> void:
	if guard.blocked or transitioning or route!=&"hero":return
	transitioning = true
	hero_page.set_active(false);hero_page.hide()
	gambits_page = GambitsPage.instantiate();gambits_page.hero_id = selected_hero_id;gambits_page.save_path = save_path
	gambits_page.hero_requested.connect(return_hero);add_child(gambits_page);route = &"gambits"
	call_deferred("_finish_transition")

func return_hero() -> void:
	if guard.blocked or transitioning or route!=&"gambits":return
	transitioning = true
	gambits_page.set_active(false);remove_child(gambits_page);gambits_page.queue_free();gambits_page = null
	hero_page.show();hero_page.set_active(true);route = &"hero"
	call_deferred("_finish_transition")
