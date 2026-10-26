extends Node
## GAMEPLAY-001-fix1: heal team includes caster; mana commits only with a valid effect.
const Unit = preload("res://scripts/party/party_unit.gd")
const Simulation = preload("res://scripts/party/party_simulation.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
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
		push_error("PartyFix1: " + message)

func make_actor(profile, at: Vector2) -> Unit:
	var unit := Unit.new()
	unit.configure_party(profile)
	unit.presentation_enabled = false
	unit.mana_regeneration = 0.0
	unit.action.clock = clock
	world.add_child(unit)
	unit.place(at)
	return unit

func clear_world() -> void:
	for child in world.get_children(): child.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame

func _ready() -> void:
	world = Node3D.new()
	add_child(world)
	# Pure decisions: include Anne, compare ratios, keep exact threshold and stable ties.
	var source: Dictionary = {"id": 1, "health": 69, "max_health": 140, "position": Vector2.ZERO}
	var ally: Dictionary = {"id": 2, "health": 180, "max_health": 180, "position": Vector2(1, 0)}
	var view: Dictionary = {"key": &"anne", "source": source, "allies": [ally], "enemies": [], "mana": 60.0, "cooldowns": {}, "abilities": [&"basic", &"heal"]}
	var rules: Array = Rules.defaults(&"anne")
	check(Rules.evaluate(rules, view).target_id == 1, "Anne below 50 percent heals herself even with healthy Mako")
	source.health = 70
	check(Rules.evaluate(rules, view).is_empty(), "Anne at exactly 50 percent does not trigger strict threshold")
	source.health = 56 # 40 percent
	ally.health = 36 # 20 percent
	check(Rules.evaluate(rules, view).target_id == 2, "more wounded Mako takes priority over Anne")
	source.health = 28 # 20 percent
	ally.health = 72 # 40 percent
	check(Rules.evaluate(rules, view).target_id == 1, "more wounded Anne takes priority over Mako")
	source.health = 56
	ally.health = 72 # equal 40 percent
	check(Rules.evaluate(rules, view).target_id == 1, "equal ratios use distance deterministically")
	source.health = 140
	ally.health = 89
	check(Rules.evaluate(rules, view).target_id == 2, "wounded ally still selected when caster is healthy")
	ally.health = 0
	check(Rules.evaluate(rules, view).is_empty(), "dead ally never selected")
	# The current Main's evaluator and manual path must agree on self-healing.
	var sim := Simulation.new()
	add_child(sim)
	sim.configure(world)
	sim.reset()
	var anne = sim.hero(&"anne")
	anne.state.damage(100)
	sim.advance(1.0/60.0)
	check(anne.action.casting() and anne.action._target == anne, "live automatic gambit starts a self heal")
	check(anne.action.mana == 60 and anne.action.spent == 0, "automatic self heal leaves mana intact during cast")
	for tick in range(91): sim.advance(1.0/60.0)
	check(anne.state.health == 70 and anne.action.spent == 20, "automatic self heal resolves once and pays at resolution")
	sim.reset()
	anne = sim.hero(&"anne")
	var mako = sim.hero(&"mako")
	anne.state.damage(100)
	check(sim.request_manual(&"anne", &"heal") and anne.pending.target_id == anne.combat_id, "manual heal includes self")
	mako.state.damage(150)
	check(sim.request_manual(&"anne", &"heal") and anne.pending.target_id == mako.combat_id, "manual heal also prioritizes lowest HP ratio")
	sim.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	for skill in [&"heal", &"lightning"]:
		var caster := make_actor(ANNE if skill == &"heal" else MAKO, Vector2.ZERO)
		var target := make_actor(MAKO if skill == &"heal" else ENEMY, Vector2(1, 0))
		if skill == &"heal": target.state.damage(100)
		var duration: float = caster.action.cast_duration(skill)
		var original_hp: int = target.state.health
		var cost: int = caster.action.cost(skill)
		check(caster.action.request(skill, target) > 0, "cast accepted: " + String(skill))
		check(caster.action.mana == 60 and caster.action.spent == 0, "no charge at cast start: " + String(skill))
		caster.action.advance(duration - 0.01)
		check(caster.action.mana == 60 and caster.action.spent == 0 and target.state.health == original_hp, "no charge or effect during preparation: " + String(skill))
		var paid_at_signal: Array = []
		target.state.health_changed.connect(func(_health, _maximum):
			paid_at_signal.append(caster.action.spent == cost and not caster.action.try_impact(caster.action.action_id)))
		caster.action.advance(0.01)
		check(caster.action.mana == 60 - cost and caster.action.spent == cost and target.state.health != original_hp, "single mana debit accompanies real effect: " + String(skill))
		check(paid_at_signal == [true], "cost and resolution latched before health callbacks: " + String(skill))
		caster.action.advance(10)
		check(caster.action.spent == cost and not caster.action.try_impact(caster.action.action_id), "no second debit after recovery or duplicate impact")
		await clear_world()
		# Cancellation matrix: death, removal, state replacement, range loss, manual cancel.
		for reason in ["death", "remove", "state", "range", "cancel", "source_death"]:
			caster = make_actor(ANNE if skill == &"heal" else MAKO, Vector2.ZERO)
			target = make_actor(MAKO if skill == &"heal" else ENEMY, Vector2(1, 0))
			if skill == &"heal": target.state.damage(100)
			caster.action.request(skill, target)
			caster.action.advance(0.5)
			match reason:
				"death": target.state.damage(100000)
				"remove": target.queue_free()
				"state": target.configure(MAKO if skill == &"heal" else ENEMY)
				"range": target.place(Vector2(5, 0))
				"cancel": caster.action.cancel()
				"source_death": caster.state.damage(100000)
			await get_tree().process_frame
			caster.action.advance(duration)
			check(caster.action.mana == 60 and caster.action.spent == 0 and not caster.action.casting(), "cancel has no mana debit: %s / %s" % [skill, reason])
			await clear_world()
	# Full target at resolution and depleted mana cannot produce a paid/invalid effect.
	var healer := make_actor(ANNE, Vector2.ZERO)
	var patient := make_actor(MAKO, Vector2(1, 0))
	patient.state.damage(100)
	healer.action.request(&"heal", patient)
	patient.state.heal(100)
	healer.action.advance(1.5)
	check(healer.action.mana == 60 and healer.action.spent == 0 and healer.action.applied_healing == 0, "no mana spent for a now-full healing target")
	await clear_world()
	var mage := make_actor(MAKO, Vector2.ZERO)
	var foe := make_actor(ENEMY, Vector2(1, 0))
	mage.action.request(&"lightning", foe)
	mage.action.mana = 5
	mage.action.advance(2)
	check(mage.action.mana == 5 and mage.action.spent == 0 and foe.state.health == foe.state.max_health, "mana revalidated at resolution without overdraft")
	await clear_world()
	world.queue_free()
	await get_tree().process_frame
	var summary: String = "%s : %d controles, %d echecs" % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary)
	var label := Label.new()
	label.text = summary
	add_child(label)
