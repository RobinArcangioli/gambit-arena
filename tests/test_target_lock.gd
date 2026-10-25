extends Node
const Unit = preload("res://scripts/combat/combat_unit.gd")
const Controller = preload("res://scripts/gambits/gambit_controller.gd")
const Manual = preload("res://scripts/manual/manual_commands.gd")
const Clock = preload("res://scripts/core/game_clock.gd")
const HERO = preload("res://data/actors/hero.tres")
const ENEMY = preload("res://data/actors/enemy.tres")
var checks: int = 0
var failures: int = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("TargetLock: " + message)

func actor(profile: Resource, at: Vector2, clock: Clock) -> Unit:
	var result := Unit.new()
	result.configure(profile)
	add_child(result)
	result.place(at)
	result.action.bind_clock(clock)
	return result

func _ready() -> void:
	var clock := Clock.new()
	var hero := actor(HERO, Vector2.ZERO, clock)
	var a := actor(ENEMY, Vector2(0.9, 0), clock)
	var b := actor(ENEMY, Vector2(-1.5, 0), clock)
	var enemies: Array[Unit] = [a, b]
	var pilot := Controller.new()
	var manual := Manual.new()
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == a.combat_id, "initial target A")
	check(pilot.execute(hero, enemies, clock) > 0, "first attack starts")
	b.place(Vector2(-0.7, 0))
	for tick in range(61):
		hero.action.advance(1.0 / 60.0)
	pilot.plan(0.1, hero, enemies, clock)
	check(a.state.alive and pilot.decision.target_id == a.combat_id, "closer B cannot replace living A after attack")
	a.place(Vector2(1.0, 0))
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == a.combat_id, "exact reach boundary retains A")
	# Self-heal and intention invalidation must not erase offensive focus.
	hero.state.damage(60)
	pilot.rules = Controller.standard_rules()
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == hero.combat_id and hero.focused_enemy(enemies) == a, "self heal preserves offensive target")
	check(pilot.execute(hero, enemies, clock) > 0, "heal starts")
	for tick in range(61):
		hero.action.advance(1.0 / 60.0)
	pilot.stop(hero, "rules_changed")
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == a.combat_id, "after heal and rule edit A remains selected")
	check(manual.submit(&"special", hero, enemies, clock) and manual.snapshot().target_id == a.combat_id, "manual special shares A despite closer B")
	manual.clear()
	check(manual.submit(&"heal", hero, enemies, clock) and hero.focused_enemy(enemies) == a, "manual self heal preserves A")
	manual.clear()
	# An unmatched condition cannot silently select another in-range enemy.
	pilot.rules = Controller.standard_rules()
	pilot.rules[0].enabled = false
	pilot.rules[1].enabled = false
	pilot.rules[2].condition = "hp_below"
	pilot.rules[2].threshold = 10
	b.state.damage(b.state.health - 1)
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.kind == "none" and hero.focused_enemy(enemies) == a, "condition miss does not switch to low-health B")
	pilot.rules[2].condition = "always"
	a.place(Vector2(1.01, 0))
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == b.combat_id, "out-of-range A releases focus")
	b.state.damage(10000)
	a.place(Vector2(0.9, 0))
	pilot.plan(0.1, hero, enemies, clock)
	check(pilot.decision.target_id == a.combat_id, "dead B releases focus immediately")
	clock.paused = true
	check(not manual.submit(&"basic", hero, enemies, clock) and hero.focused_enemy(enemies) == a, "rejected paused command preserves focus")
	clock.paused = false
	a.configure(ENEMY)
	check(hero.focused_enemy(enemies) == null, "replaced actor state cannot retain stale identity")
	hero.remember_enemy(a)
	enemies.erase(a)
	check(hero.focused_enemy(enemies) == null, "actor removed from combat releases focus")
	enemies.append(a)
	hero.remember_enemy(a)
	a.queue_free()
	check(hero.focused_enemy(enemies) == null, "queued deletion releases focus")
	await get_tree().process_frame
	check(hero.focused_enemy(enemies) == null, "freed reference is safe")
	manual.clear()
	hero.action.retire()
	hero.queue_free()
	b.queue_free()
	var summary_text: String = "STEP-025-fix1 / cible persistante\n%s : %d controles, %d echecs\nF8 pour arreter." % ["OK" if failures == 0 else "ECHEC", checks, failures]
	print(summary_text)
	var label := Label.new()
	label.text = summary_text
	label.position = Vector2(20, 30)
	add_child(label)
