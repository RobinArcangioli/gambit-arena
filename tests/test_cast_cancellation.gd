extends Node
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Bars = preload("res://scripts/presentation/overhead_bars.gd")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error("Cast cancellation: " + message)
func fixture() -> Simulation:
	var world := Node3D.new(); add_child(world)
	var sim := Simulation.new(); world.add_child(sim); sim.configure(world)
	sim.orders_enabled = true; sim.rules = {"anne": [], "mako": []}; sim.reset()
	sim.wave.cap = 2
	sim.add_enemy(Vector2(1.5, 0)); sim.add_enemy(Vector2(2.5, 0))
	sim.wave.cap = 0
	for unit in sim.all_units(): unit.mover.speed = 0
	for unit in sim.heroes: unit.mana_regeneration = 0
	for enemy in sim.enemies: enemy.abilities.clear()
	sim.hero(&"mako").place(Vector2.ZERO); sim.hero(&"anne").place(Vector2(-2, -2))
	return sim
func dispose(sim: Simulation) -> void:
	sim.clear(); sim.world.queue_free()
func _ready() -> void:
	var sim := fixture()
	var mako = sim.hero(&"mako")
	var first = sim.enemies[0]
	var second = sim.enemies[1]
	sim.rules.mako = [{"enabled": true, "criterion": "enemy_near", "skill": "lightning"}, {"enabled": true, "criterion": "enemy_near", "skill": "basic"}]
	sim.advance(1.0 / 60)
	var old_id: int = mako.action.action_id
	check(mako.action.casting() and mako.action.last_skill == &"lightning", "real gambit starts lightning on nearest skeleton")
	for i in range(30): sim.advance(1.0 / 60)
	var spent: int = mako.action.spent
	var mana: float = mako.action.mana
	mako.action.cooldowns[&"heal"] = 3.0
	first.state.damage(10000)
	check(not mako.action.active and mako.action.phase == "ANNULEE", "target death immediately cancels preparation, without recovery")
	check(mako.action.remaining(&"lightning") == 0 and mako.action.available(&"lightning"), "unreleased lightning has no remaining cooldown")
	check(mako.action.mana == mana and mako.action.spent == spent, "cancelled spell does not spend mana")
	check(mako.action.remaining(&"heal") == 3.0, "unrelated cooldown is preserved")
	mako.action.cancel()
	check(mako.action.remaining(&"heal") == 3.0, "repeated cancellation remains harmless")
	sim.advance(1.0 / 60)
	check(mako.action.action_id > old_id and mako.action.last_skill == &"lightning" and mako.action.casting(), "next accepted tick recasts lightning instead of falling through to basic")
	var starts: Array = sim.events.filter(func(e): return e.kind == "start" and e.source_id == mako.combat_id)
	check(starts.size() == 1 and starts[0].target_id == second.combat_id, "new cast targets next living enemy")
	check(mako.action.elapsed == 0, "retarget has no leftover recovery or preparation")
	check(not mako.action.try_impact(old_id) and mako.action.spent == spent, "stale impact cannot affect replacement cast")
	# Lethal successful lightning must still retain its ordinary recovery and cooldown.
	second.state.damage(40)
	for i in range(121): sim.advance(1.0 / 60)
	check(not second.state.alive if is_instance_valid(second) else true, "replacement lightning resolves against the new target")
	check(mako.action.spent == spent + 30, "only released replacement spell costs mana")
	check(mako.action.active and mako.action.phase == "RECUPERATION" and mako.action.remaining(&"lightning") > 3.9, "own lethal impact retains successful cooldown and recovery")
	mako.action.cancel()
	check(mako.action.remaining(&"lightning") > 3.9, "cancelling after resolution cannot refund a successful cooldown")
	dispose(sim); await get_tree().process_frame
	# A dead ally releases heal too; the next injured ally is immediately eligible.
	sim = fixture()
	var anne = sim.hero(&"anne"); mako = sim.hero(&"mako")
	anne.state.damage(50); mako.state.damage(50)
	anne.place(Vector2.ZERO); mako.place(Vector2(1, 0))
	check(anne.action.request(&"heal", mako) > 0, "ally heal can start")
	anne.action.advance(0.5); mako.state.damage(10000)
	check(anne.action.remaining(&"heal") == 0 and anne.action.mana == 60, "dead ally refunds pending heal cooldown without mana debit")
	check(anne.action.request(&"heal", anne) > 0, "Anne can immediately heal another eligible target, including herself")
	dispose(sim); await get_tree().process_frame
	# Production skeleton profiles have no mana, including after time passes/reset.
	sim = fixture()
	for enemy in sim.enemies:
		check(enemy.mana_capacity == 0 and enemy.mana_regeneration == 0 and enemy.action.mana == 0, "skeleton has neither mana nor regeneration")
		enemy.action.advance(10)
		check(enemy.action.mana == 0, "time cannot grant skeleton mana")
	check(sim.hero(&"mako").mana_capacity == 60 and sim.hero(&"anne").mana_capacity == 60, "hero mana capacities remain unchanged")
	var bars := Bars.new(); add_child(bars)
	bars.set_values(40, 60, 0, 0, false, 0)
	await get_tree().process_frame; await get_tree().process_frame
	check(bars.get("mana_visible") == false and bars.material.get_shader_parameter("mana_visible") == false, "zero-capacity actor has no blue row in actual shader")
	bars.set_values(120, 180, 30, 60, true, 0.5)
	await get_tree().process_frame; await get_tree().process_frame
	check(bars.get("mana_visible") == true and bars.material.get_shader_parameter("mana_visible") == true and bars.casting, "same visual restores hero mana and casting rows")
	bars.queue_free(); dispose(sim); await get_tree().process_frame
	var summary := "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	var label := Label.new(); label.text = summary; add_child(label); print(summary)
