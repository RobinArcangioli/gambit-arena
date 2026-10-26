extends Node
const Main = preload("res://scenes/main.tscn")
const PartyActor = preload("res://scripts/party/party_unit.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("PartyViews: " + message)

func _ready() -> void:
	var runs: Array = []
	for mode in range(3):
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		app.characters_enabled = mode != 2
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		if mode == 1:
			for unit in app.simulation.all_units(): unit.set_appearance(null)
			# Future enemies use the same art-independent diagnostic composition.
			app.world.child_entered_tree.connect(func(node):
				if node is PartyActor: node.appearance = null)
		var mako = app.simulation.hero(&"mako")
		mako.state.damage(110)
		var frames: Array = []
		var healed: bool = false
		var struck: bool = false
		for tick in range(900):
			app._physics_process(1.0 / 60.0)
			var units: Array = []
			for unit in app.simulation.all_units():
				units.append([unit.actor_key, unit.position, unit.state.health, unit.action.mana, unit.action.phase, unit.action.elapsed, unit.action.spent, unit.action.applied_damage, unit.action.applied_healing, unit.mover.facing, unit.action.last_skill])
			frames.append([app.simulation.clock.elapsed, app.simulation.result, app.simulation.spawned, app.simulation.defeated, app.simulation.hits, units])
			for event in app.simulation.events:
				if event.skill == "heal" and event.healing > 0: healed = true
				if event.skill == "lightning" and event.damage > 0: struck = true
		check(healed and struck, "sequence covers real healing and lightning resolutions")
		runs.append(frames)
		main.queue_free()
		await get_tree().process_frame
		await get_tree().process_frame
	check(runs[0] == runs[1] and runs[1] == runs[2], "900 ticks identical with models, mannequin and absent view in actual Main")
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "all visual compositions release construction objects")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
