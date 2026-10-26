extends Node
const Unit = preload("res://scripts/party/party_unit.gd")
const Executor = preload("res://scripts/party/party_executor.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Rules = preload("res://scripts/party/party_rules.gd")
const ANNE = preload("res://data/party/anne.tres")
const MAKO = preload("res://data/party/mako.tres")
const ENEMY = preload("res://data/party/skeleton.tres")
var checks: int = 0
var failures: int = 0
var world: Node3D
var clock := Clock.new()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("PartyGameplay: " + message)

func actor(profile, at: Vector2) -> Unit:
	var unit := Unit.new()
	unit.configure_party(profile)
	unit.presentation_enabled = false
	unit.action.clock = clock
	world.add_child(unit)
	unit.place(at)
	return unit

func _ready() -> void:
	world = Node3D.new()
	add_child(world)
	var anne := actor(ANNE, Vector2.ZERO)
	var mako := actor(MAKO, Vector2(3.9, 0))
	var enemy := actor(ENEMY, Vector2(0, 0.8))
	var anne_hp: int = anne.state.health
	mako.state.damage(100)
	var damaged: int = mako.state.health
	check(anne.action.request(&"lightning", enemy) == 0 and anne.action.mana == 60, "Anne cannot use Mako's lightning")
	check(mako.action.request(&"heal", anne) == 0 and mako.action.mana == 60, "Mako cannot heal")
	check(anne.action.request(&"special", enemy) == 0, "special identifier rejected in active party")
	check(anne.action.request(&"heal", anne) == 0, "full-health self is not a useful heal target")
	check(anne.action.request(&"heal", enemy) == 0, "heal rejects enemy")
	check(mako.action.request(&"lightning", anne) == 0, "damage rejects ally")
	check(anne.action.request(&"heal", mako) > 0, "ally heal accepted within 4 units")
	check(anne.action.mana == 60 and anne.action.spent == 0, "heal preparation does not spend mana")
	check(anne.action.request(&"heal", mako) == 0 and anne.action.spent == 0, "busy cannot debit early")
	anne.action.advance(1.49)
	check(mako.state.health == damaged and anne.action.casting(), "no heal before 1.5 seconds")
	check(is_equal_approx(anne.action.cast_progress(), 1.49 / 1.5), "cast fraction follows accepted time")
	var before: Array = [anne.action.elapsed, anne.action.mana, anne.action.remaining(&"heal")]
	clock.paused = true
	anne.action.advance(20.0)
	check(before == [anne.action.elapsed, anne.action.mana, anne.action.remaining(&"heal")], "pause freezes cast, mana and cooldown")
	check(not anne.action.try_impact(anne.action.action_id), "paused impact rejected")
	clock.paused = false
	anne.action.advance(0.01)
	check(mako.state.health == damaged + 30 and anne.state.health == anne_hp, "heal resolves on Mako at 1.5 seconds")
	check(anne.action.resolved and not anne.action.casting() and anne.action.cast_progress() == 0, "cast bar hides during recovery")
	check(not anne.action.try_impact(anne.action.action_id) and anne.action.applied_healing == 30, "duplicate impact cannot heal twice")
	anne.action.advance(3.0)
	check(anne.action.remaining(&"heal") == 0 and anne.action.mana == 55, "cooldown and regeneration are bounded")
	enemy.place(Vector2(3.9, 0.1))
	var enemy_hp: int = enemy.state.health
	check(mako.action.request(&"lightning", enemy) > 0 and mako.action.mana == 60 and mako.action.spent == 0, "Mako lightning preparation preserves mana")
	mako.action.advance(1.999)
	check(enemy.state.health == enemy_hp, "no lightning damage before 2 seconds")
	mako.action.advance(0.001)
	check(enemy.state.health == enemy_hp - (2 * mako.state.attack - enemy.state.defense), "lightning resolves once at 2 seconds")
	var after_lightning: int = enemy.state.health
	mako.action.advance(10.0)
	check(enemy.state.health == after_lightning and mako.action.mana == 60, "oversized tick cannot duplicate effect or overflow mana")
	check(anne.action.request(&"basic", mako) == 0, "basic cannot attack ally")
	enemy.place(Vector2(2, 0))
	check(anne.action.request(&"basic", enemy) == 0, "basic retains short reach")
	mako.place(Vector2(4.01, 0))
	check(anne.action.request(&"heal", mako) == 0, "heal rejects beyond spell reach")
	mako.place(Vector2(3, 0))
	check(anne.action.request(&"heal", mako) > 0, "fresh healing action")
	mako.state.damage(100000)
	check(not anne.action.active and anne.action.phase == "ANNULEE", "target death cancels casting immediately")
	anne.action.advance(3)
	check(not mako.state.alive, "healing never resurrects")
	for unit in [anne, mako, enemy]: unit.queue_free()
	await get_tree().process_frame
	# Target state replacement and source retirement cannot reuse an old cast.
	anne = actor(ANNE, Vector2.ZERO)
	mako = actor(MAKO, Vector2(1, 0))
	mako.state.damage(100)
	anne.action.request(&"heal", mako)
	mako.configure(MAKO)
	anne.action.advance(2)
	check(anne.action.phase == "ANNULEE" and mako.state.health == mako.state.max_health, "replacement target state is not healed by stale action")
	anne.action.advance(3)
	mako.state.damage(100)
	anne.action.request(&"heal", mako)
	anne.state.damage(100000)
	check(anne.action.retired and not anne.action.active, "source death retires executor")
	check(anne.action.request(&"heal", mako) == 0, "retired executor cannot restart")
	for unit in [anne, mako]: unit.queue_free()
	await get_tree().process_frame
	_test_rules()
	await _test_simulation()
	world.queue_free()
	await get_tree().process_frame
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)

func _test_rules() -> void:
	var source: Dictionary = {"id": 1, "health": 140, "max_health": 140, "position": Vector2.ZERO}
	var ally: Dictionary = {"id": 2, "health": 90, "max_health": 180, "position": Vector2(2, 0)}
	var foe: Dictionary = {"id": 3, "health": 60, "max_health": 60, "position": Vector2(0.5, 0)}
	var view: Dictionary = {"key": &"anne", "source": source, "allies": [ally], "enemies": [foe], "mana": 60.0, "cooldowns": {}, "abilities": [&"basic", &"heal"]}
	var rows: Array = Rules.defaults(&"anne")
	check(Rules.evaluate(rows, view).skill == "basic", "exactly 50 percent does not trigger allied healing")
	ally.health = 89
	var choice: Dictionary = Rules.evaluate(rows, view)
	check(choice.skill == "heal" and choice.target_id == 2, "ally below 50 percent selects Mako")
	ally.health = 0
	check(Rules.evaluate(rows, view).skill == "basic", "dead ally skipped")
	ally.health = 89
	view.mana = 19
	check(Rules.evaluate(rows, view).skill == "basic", "insufficient mana falls back to attack")
	view.mana = 60
	view.cooldowns = {"heal": 0.1}
	check(Rules.evaluate(rows, view).skill == "basic", "heal cooldown falls back to attack")
	view.cooldowns = {}
	var snapshot_before: Dictionary = view.duplicate(true)
	Rules.evaluate(rows, view)
	check(view == snapshot_before, "pure evaluator does not mutate snapshot")
	var wrong: Dictionary = rows[0].duplicate(true)
	wrong.target = "enemy"
	check(not Rules.valid_rule(wrong, &"anne"), "invalid heal target rejected by authoring validator")
	check(not Rules.valid_rule(rows[0], &"mako"), "Mako cannot configure Anne's heal")
	var all_rules: Dictionary = {"anne": rows, "mako": Rules.defaults(&"mako")}
	var path: String = "/tmp/gambit-party-rules-tests.json"
	check(Rules.save_configuration(path, all_rules) == OK, "versioned rule save")
	check(Rules.load_configuration(path) == all_rules, "save round trip preserves per-hero rules")
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string('{"version":1,"heroes":{}}')
	file.close()
	check(Rules.load_configuration(path).is_empty(), "old schema never silently reinterpreted")
	file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string('{"version":2,"heroes":{"anne":[{"threshold":50.5}]}}')
	file.close()
	check(Rules.load_configuration(path).is_empty(), "malformed and fractional thresholds rejected")
	DirAccess.remove_absolute(path)
	var old: Array = [
		{"enabled": true, "target": "self", "condition": "hp_below", "threshold": 50, "skill": "heal"},
		{"enabled": true, "target": "enemy", "condition": "always", "threshold": 50, "skill": "special"},
		{"enabled": true, "target": "enemy", "condition": "always", "threshold": 50, "skill": "basic"}]
	var migrated_anne: Dictionary = Rules.migrate_legacy(old, &"anne")
	var migrated_mako: Dictionary = Rules.migrate_legacy(old, &"mako")
	check(migrated_anne.rules[0].target == "ally" and not migrated_anne.rules[1].enabled, "explicit Anne migration maps heal and disables incompatible lightning")
	check(migrated_mako.rules[1].skill == "lightning" and not migrated_mako.rules[0].enabled, "explicit Mako migration maps lightning and disables heal")
	check(not migrated_anne.notes.is_empty() and old[0].target == "self", "migration explains changes without mutating legacy data")

func _test_simulation() -> void:
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.reset()
	var anne = sim.hero(&"anne")
	var mako = sim.hero(&"mako")
	check(sim.heroes.size() == 2 and anne.state != mako.state and anne.action != mako.action, "independent two-hero runtime state")
	mako.state.damage(100)
	sim.advance(1.0 / 60.0)
	check(anne.action.casting() and anne.action._target == mako, "automatic allied gambit uses shared executor")
	var before: float = sim.clock.elapsed
	var spell_time: float = anne.action.elapsed
	for i in range(50): sim.advance(1.0, true)
	check(sim.clock.elapsed == before and anne.action.elapsed == spell_time, "coordinator pause freezes both heroes")
	var before_mana: float = anne.action.mana
	check(sim.request_manual(&"anne", &"heal"), "manual allied command can queue while occupied")
	check(anne.action.mana == before_mana and not anne.pending.is_empty(), "manual queue does not debit early")
	sim.reset()
	anne = sim.hero(&"anne")
	mako = sim.hero(&"mako")
	sim.rules.anne[0].enabled = false
	check(sim.add_enemy(Vector2(0, 1.8)), "enemy spawn accepted")
	var enemy = sim.enemies[0]
	anne.place(Vector2(0, 1))
	mako.place(Vector2(2, 0))
	sim.advance(1.0/60.0)
	check(enemy.desired_target == anne, "enemy picks nearest live hero")
	var focus = enemy
	anne.offensive_focus = focus
	anne.focus_state = focus.state
	mako.state.damage(100)
	sim.rules.anne[0].enabled = true
	if anne.action.active: anne.action.cancel()
	sim.advance(1.0/60.0)
	check(anne.offensive_focus == focus and anne.desired_skill == &"heal", "healing preserves offensive focus")
	var held: Vector3 = anne.position
	for i in range(60): sim.advance(1.0/60.0)
	check(anne.position == held, "casting at range never creeps")
	anne.state.damage(100000)
	sim.advance(1.0/60.0)
	check(sim.result == "EN COURS" and sim.living_heroes().size() == 1, "one hero death is not defeat")
	check(enemy.desired_target == mako or enemy.action.active, "enemy reselects surviving hero when free")
	mako.state.damage(100000)
	sim.advance(1.0/60.0, true)
	check(sim.result == "DEFAITE" and sim.terminal_count == 1, "both heroes dead causes one defeat even in pause")
	sim.advance(1)
	check(sim.terminal_count == 1, "terminal outcome is latched")
	var previous_run: int = sim.run_id
	sim.reset()
	check(sim.run_id == previous_run + 1 and sim.heroes[0].pending.is_empty() and sim.events.is_empty(), "replay clears commands and events")
	sim.wave_count = 3
	sim.total_per_wave = 1
	sim.reset()
	for unit in sim.heroes: unit.state.set_attack(10000)
	for tick in range(2400):
		sim.advance(1.0/60.0)
		if sim.result != "EN COURS": break
	check(sim.result == "VICTOIRE" and sim.spawned == 3 and sim.defeated == 3 and sim.wave_number == 3, "three waves finish with correct totals")
	sim.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	check(world.get_child_count() == 0, "simulation destruction removes all party actors")
