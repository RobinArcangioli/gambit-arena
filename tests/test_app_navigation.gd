extends Node
const App = preload("res://scenes/app/app_root.tscn")
const Choice = preload("res://scripts/app/arena_choice.gd")
const Rules = preload("res://scripts/party/party_rules.gd")
const Unit = preload("res://scripts/party/party_unit.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:failures += 1;push_error("AppNavigation: "+message)
func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
func _ready() -> void:
	seed(771);var expected: int = randi();seed(771)
	var choices := Choice.new()
	for i in range(20):choices.next()
	check(randi()==expected,"visual RNG never consumes global gameplay RNG")
	choices.rng.seed=441
	var other := Choice.new();other.rng.seed=441
	var observed: Dictionary = {}
	var deterministic: bool = true
	for i in range(256):
		var id: StringName = choices.next();observed[id]=true
		deterministic = deterministic and id==other.next() and id!=&"reference"
	check(deterministic and observed.size()==8,"eight eligible visual arenas, independent seeded selection and reference excluded")
	var path: String = "user://ui001-rules-test.json"
	var configuration: Dictionary = {"anne":Rules.defaults(&"anne"),"mako":Rules.defaults(&"mako")}
	configuration.anne[0].threshold = 37
	check(Rules.save_configuration(path,configuration)==OK,"existing version-two save available")
	var app = App.instantiate();app.save_path=path;add_child(app)
	await settle()
	check(app.route==&"home" and app.combat==null and app.arena_choice.draws==0,"Home has no combat or arena draw")
	check(app.background.get_rect().size==get_viewport().get_visible_rect().size and not app.team_button.disabled,"full-page provided background and enabled team entry")
	app.open_arena();app.open_arena()
	await settle()
	var game = app.combat
	game.set_process(false);game.set_physics_process(false)
	check(app.route==&"arena" and app.arena_choice.draws==1,"double entry creates one combat and exactly one draw")
	check(game.simulation.rules==preload("res://scripts/gambits/configuration_codec.gd").migrate(configuration).configuration,"new arena loads preserved hero rules")
	check(game.render_box.position==game.floor_canvas.position and game.render_box.size==get_viewport().get_visible_rect().size,"arena extends underneath every command")
	check(game.get_node_or_null('HUD/HeaderPanel')==null and game.get_node_or_null('HUD/FooterPanel')==null,"no separate opaque button bands")
	var initial_id: StringName=game.chosen_arena
	for tick in range(120):game._physics_process(1.0/60.0)
	check(game.chosen_arena==initial_id and app.arena_choice.draws==1,"waves and ordinary ticks do not redraw the arena")
	game._toggle_pause();game._resume_combat();await settle()
	check(app.arena_choice.draws==1,"pause and resume never redraw")
	game._reset()
	check(app.arena_choice.draws==2,"Replay makes exactly one new visual draw")
	game._toggle_pause()
	var back_key:=InputEventKey.new();back_key.keycode=KEY_ESCAPE;back_key.pressed=true
	get_viewport().push_input(back_key,true)
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	check(app.combat==game and not game.pause_layer.visible,"key and native back pair closes only the top modal")
	check(app.combat==game and not game.pause_layer.visible and not game.paused,"Back closes pause menu and resumes before any abandonment")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	game.notification(NOTIFICATION_APPLICATION_FOCUS_OUT)
	app.return_home()
	check(app.combat==game and game.paused,"background blocks route changes and freezes combat")
	app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	game.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
	app.return_home();await settle()
	check(app.combat==null and not is_instance_valid(game),"abandon detaches and frees arena")
	check(Rules.load_configuration(path)==configuration,"abandon preserves saved rules")
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST)
	await settle()
	check(app.route==&"home" and app.is_inside_tree(),"repeated Android back at Home keeps root route alive")
	app.open_arena();await settle()
	await get_tree().create_timer(0.2).timeout
	app.notification(NOTIFICATION_WM_GO_BACK_REQUEST);await settle()
	check(app.route==&"arena" and app.combat.pause_layer.visible,"Android back opens pause instead of abandoning")
	app.combat._ask_abandon();app.combat._confirm_abandon();await settle()
	check(app.route==&"home" and app.combat==null,"confirmed abandon returns Home")
	for run in range(20):
		app.open_arena();await settle()
		game=app.combat;game.set_process(false);game.set_physics_process(false)
		check(game.simulation.rules==preload("res://scripts/gambits/configuration_codec.gd").migrate(configuration).configuration and game.simulation.hero(&"anne").state.health==140 and game.simulation.hero(&"mako").state.health==180,"fresh party and preserved configuration on entry")
		if run%2==0:
			game.simulation.hero(&"mako").state.damage(150)
			for tick in range(30):game._physics_process(1.0/60.0)
			check(game.simulation.hero(&"anne").action.casting(),"abandon is exercised during an actual heal cast")
		else:
			game.simulation.add_enemy(Vector2(2,0))
			for tick in range(30):game._physics_process(1.0/60.0)
			check(game.simulation.hero(&"mako").action.casting(),"abandon is exercised during an actual lightning cast")
		app.return_home();await settle()
		check(app.combat==null and app.get_children().filter(func(node):return node is Unit).is_empty(),"twenty abandon cycles retain no active combat")
	app.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"routes release actors, presentation effects and viewports")
	print("%s : %d controles, %d echecs" % ["OK" if failures==0 else "ECHEC",checks,failures])
	var label:=Label.new();label.text="%s : %d controles, %d echecs" % ["OK" if failures==0 else "ECHEC",checks,failures];add_child(label)
