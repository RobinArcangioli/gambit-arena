extends "res://scripts/skills/skills_lab.gd"
const Rule = preload("res://scripts/gambits/gambit_rule.gd")
const Snapshot = preload("res://scripts/gambits/gambit_snapshot.gd")
const Evaluator = preload("res://scripts/gambits/gambit_evaluator.gd")
const GameClock = preload("res://scripts/core/game_clock.gd")
const SCENARIOS: Array[String] = ["Priorites", "Hors portee", "Egalite", "Sans cible"]
var rules: Array[Rule] = []
var clock := GameClock.new()
var sample_energy: int = 60
var sample_cooldown: float = 0.0
var cadence: float = 0.0
var evaluations: int = 0
var decision: Dictionary = {}

func _ready() -> void:
	super._ready()
	$HUD/Title.text = "STEP-016 / GAMBITS"
	$HUD/Description.text = "Decision seule : aucun effet execute\nTrois regles, lecture a 10 Hz"
	_update_buttons()

func _reset() -> void:
	clock.reset()
	cadence = 0.0
	evaluations = 0
	sample_energy = 60
	sample_cooldown = 0.0
	rules.clear()
	for skill in ["heal", "special", "basic"]:
		var rule := Rule.new()
		rule.skill = skill
		if skill == "heal":
			rule.target = "self"
			rule.condition = "hp_below"
		rules.append(rule)
	super._reset()
	# Inherited executor exists only for the historical scene's setup; never ticks.
	executor.retire()
	if mode_index == 1:
		actors[1].position = Vector3(2, 0, -2)
	elif mode_index == 2:
		actors[1].position = Vector3(1.2, 0, 0)
		var other := StatsActor.new()
		other.enemy = true
		other.configure(ENEMY)
		world.add_child(other)
		other.position = Vector3(-1.2, 0, 0)
		other.pose(0.0, false, Vector2(1, 1))
		actors.append(other)
	elif mode_index == 3:
		actors[1].state.damage(1000000)
	decision = Evaluator.evaluate(rules, _snapshot())
	_present()
	_update_buttons()

func _snapshot() -> Snapshot:
	var view := Snapshot.new()
	for index in range(actors.size()):
		var actor: StatsActor = actors[index]
		var row: Dictionary = {"id": index + 1, "health": actor.state.health, "max_health": actor.state.max_health, "position": Vector2(actor.position.x, actor.position.z)}
		if index == 0:
			view.source = row
		else:
			view.enemies.append(row)
	view.energy = sample_energy
	view.special_cooldown = sample_cooldown
	view.paused = paused
	return view

func _evaluate() -> void:
	decision = Evaluator.evaluate(rules, _snapshot())
	evaluations += 1
	_present()

func _physics_process(delta: float) -> void:
	if not setup_complete:
		return
	clock.paused = paused
	var dt: float = clock.step(delta)
	if dt <= 0.0:
		return
	cadence += dt
	if cadence + 0.000001 >= 0.1:
		cadence = maxf(0.0, cadence - 0.1)
		_evaluate()

func _command(index: int) -> void:
	if index == 5:
		_reset()
		return
	if paused or not setup_complete:
		return
	match index:
		0: actors[0].state.damage(30)
		1: actors[0].state.heal(100)
		2: sample_energy = 0 if sample_energy > 0 else 60
		3: sample_cooldown = 6.0 if sample_cooldown == 0.0 else 0.0
	_evaluate()
	_update_buttons()

func _present() -> void:
	# During the inherited reset actors exist, but the next snapshot is not ready yet.
	if decision.is_empty():
		return
	var result: String = "Aucune : %s" % decision["reason"]
	if decision["kind"] == "intent":
		result = "R%d %s -> #%d / %s" % [decision["rule_index"] + 1, decision["skill"], decision["target_id"], "approche" if decision["approach"] else "a portee"]
	readout.text = "Heros %d/100 | energie %d | CD spec %.0f\n1. Soi PV < 50%% : soin\n2. Ennemi vivant : speciale\n3. Ennemi vivant : attaque\n%s\nLectures %d | aucun effet execute" % [actors[0].state.health, sample_energy, sample_cooldown, result, evaluations]
	floor_canvas.feet.clear()
	for actor in actors:
		actor.visible = actor.state.alive
		if actor.visible:
			floor_canvas.feet.append(actor.position)
	floor_canvas.queue_redraw()

func _next_placement() -> void:
	if paused or not setup_complete:
		return
	mode_index = (mode_index + 1) % SCENARIOS.size()
	_reset()

func _update_buttons() -> void:
	clock.paused = paused
	pause_button.text = "Reprendre" if paused else "Pause"
	position_button.disabled = paused
	marks_button.text = "Reperes : oui" if floor_canvas.show_marks else "Reperes : non"
	if not setup_complete:
		return
	position_button.text = "%d/4 %s" % [mode_index + 1, SCENARIOS[mode_index]]
	var captions: Array[String] = ["Blesser 30", "Retablir", "Energie 0/60", "CD spec 0/6", "Evaluer", "Rejouer"]
	for index in range(6):
		controls[index].text = captions[index]
		controls[index].disabled = paused and index != 5

func _unhandled_key_input(event: InputEvent) -> void:
	# Existing A/H/S/D/E/R bindings address the six diagnostic buttons.
	super._unhandled_key_input(event)
