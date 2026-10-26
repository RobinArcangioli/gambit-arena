extends Node
## Whole-game state equality across artistic replacements and absent/invalid art.
const PartyActor = preload("res://scripts/party/party_unit.gd")
const Mannequin = preload("res://scripts/hybrid/proxy_actor.gd")
const Main = preload("res://scenes/main.tscn")
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
const Definition = preload("res://scripts/presentation/character_definition.gd")
const ArenaDefinition = preload("res://scripts/presentation/arena_definition.gd")
const Gallery = preload("res://scenes/debug/graphics_qualification_lab.tscn")
const Skeleton = preload("res://resources/presentation/characters/skeleton.tres")
const Violet = preload("res://resources/presentation/examples/lightning_violet.tres")
const MakoAsAnne = preload("res://resources/presentation/examples/mako_as_anne.tres")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("GraphicsContracts: " + message)

func trace(app) -> Array:
	var units: Array = []
	for unit in app.simulation.all_units():
		units.append([unit.actor_key, unit.position, unit.mover.facing, unit.state.health, unit.action.mana,
			unit.action.spent, unit.action.phase, unit.action.elapsed, unit.action.last_skill,
			unit.action.active, unit.action.applied_damage, unit.action.applied_healing, unit.action.cooldowns.duplicate()])
	return [app.simulation.clock.elapsed, app.simulation.result, app.simulation.spawned,
		app.simulation.defeated, app.simulation.hits, units]

func _ready() -> void:
	var baseline: Array = []
	var modes: Array = ["baseline", "no_view", "missing_model", "bad_model", "bad_arena", "bad_effect", "violet", "model_swap", "skeleton_swap"]
	for id in Catalog.ids(): modes.append(String(id))
	for mode in modes:
		var main = Main.instantiate()
		var app = main.get_node("ApplicationLab")
		app.save_path = ""
		app.characters_enabled = mode != "no_view"
		add_child(main)
		app.set_process(false)
		app.set_physics_process(false)
		var anne = app.simulation.hero(&"anne")
		var mako = app.simulation.hero(&"mako")
		mako.state.damage(110)
		if Catalog.ENTRIES.has(StringName(mode)): app.floor_canvas.set_definition(Catalog.definition(StringName(mode)))
		if mode == "model_swap":
			mako.set_appearance(MakoAsAnne)
			check(mako.actor_key == &"mako" and &"lightning" in mako.abilities and &"heal" not in mako.abilities, "model swap preserves Mako identity and abilities")
		if mode == "skeleton_swap":
			app.world.child_entered_tree.connect(func(node):
				if node is PartyActor and node.team != anne.team: node.appearance = Skeleton)
		if mode == "missing_model":
			anne.set_appearance(Definition.new())
			check(anne.visual is Mannequin, "missing art resource falls back to mannequin")
		if mode in ["bad_model", "bad_arena", "bad_effect"]:
			var packed := PackedScene.new()
			var empty := Node3D.new()
			packed.pack(empty)
			empty.free()
			if mode == "bad_model":
				var definition := Definition.new()
				definition.model = packed
				anne.set_appearance(definition)
				check(anne.visual is Mannequin, "model without rig or clips is safely replaced")
			elif mode == "bad_arena":
				var definition := ArenaDefinition.new()
				definition.view_scene = packed
				app.floor_canvas.set_definition(definition)
				check(app.floor_canvas.definition.arena_id == &"reference", "invalid arena view falls back to calibrated reference")
			else:
				app.action_presenter.heal_definition = app.action_presenter.heal_definition.duplicate()
				app.action_presenter.heal_definition.scene = packed
				app.action_presenter.lightning.definition = app.action_presenter.lightning.definition.duplicate()
				app.action_presenter.lightning.definition.cast_scene = packed
				app.action_presenter.lightning.definition.strike_scene = packed
		if mode == "violet": app.action_presenter.lightning.definition = Violet
		var frames: Array = []
		var healed: bool = false
		var struck: bool = false
		for tick in range(600):
			app._physics_process(1.0/60.0)
			frames.append(trace(app))
			for event in app.simulation.events:
				if event.get("skill", "") == "heal" and event.get("healing", 0) > 0: healed = true
				if event.get("skill", "") == "lightning" and event.get("damage", 0) > 0: struck = true
		check(healed and struck, "real heal and lightning exercised with " + mode)
		if mode == "baseline": baseline = frames
		else: check(frames == baseline, "600 gameplay ticks exactly identical with " + mode)
		if mode == "bad_effect":
			check(app.action_presenter.heals_played == 0 and app.action_presenter.lightning.strikes_played == 0, "malformed scenes are ignored without altering real resolutions")
		main.queue_free()
		await settle()
	# Real start/resolve/end can all be drained between presentation snapshots.
	var main = Main.instantiate()
	var app = main.get_node("ApplicationLab")
	app.save_path = ""
	add_child(main)
	app.set_process(false)
	app.set_physics_process(false)
	app.simulation.add_enemy(Vector2(2, 0))
	var mako = app.simulation.hero(&"mako")
	check(mako.action.request(&"lightning", app.simulation.enemies[0]) > 0, "real queued action starts")
	mako.action.advance(2.4)
	app._physics_process(1.0/60.0)
	check(app.action_presenter.lightning.strikes_played == 1 and app.action_presenter.lightning.preparations.is_empty(), "real complete action between snapshots still presents one impact")
	check(mako.action.spent == 30, "one actual debit despite three visual transition events")
	main.queue_free()
	await settle()
	var gallery = Gallery.instantiate()
	add_child(gallery)
	gallery.set_process(false)
	for mode in ["logic", "decor", "models", "full"]:
		gallery._fixture(2, mode)
		for tick in range(180): gallery._step(1.0/60.0)
		check(gallery.app.simulation.enemies.size() <= 2, "qualification fixture keeps configured enemy cap in " + mode)
		check(gallery.app.simulation.all_units().all(func(unit): return is_instance_valid(unit.visual) == (mode in ["models", "full"])), "new waves preserve requested graphical variant in " + mode)
	gallery._demo()
	check(gallery.app.floor_canvas.definition.arena_id == &"sanctuaire_polaire" and gallery.app.simulation.hero(&"mako").appearance == MakoAsAnne and gallery.app.action_presenter.lightning.definition == Violet, "three replacements demonstrated in the same isolated composition")
	check(gallery.app.simulation.hero(&"mako").state.attack == 18, "demo changes no Mako attack statistic")
	gallery.queue_free()
	await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == 0, "all missing/replaced views and effects are freed")
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)

func settle() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
