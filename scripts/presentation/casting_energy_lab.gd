extends "res://scripts/app/arena_page.gd"
## Isolated loop: real requests and accepted clock, no player configuration written.
var lab_panel: PanelContainer
var selected: int = 1
var elapsed: float = 0.0
func _ready() -> void:
	save_path = "user://casting014-lab.json"
	theme = preload("res://resources/ui/night_gold.tres")
	super._ready()
	simulation.rules = {"mako":[],"anne":[]};simulation.wave.cap = 0
	simulation.hero(&"anne").state.damage(10)
	simulation.hero(&"mako").place(Vector2(-0.65,0))
	simulation.hero(&"anne").place(Vector2(0.65,0))
	lab_panel = PanelContainer.new();add_child(lab_panel)
	var column := VBoxContainer.new();lab_panel.add_child(column)
	var note := _label(column,14);note.text = "Incantation · énergie ambiante
Soin Anne / Foudre Mako · boucle visuelle isolée"
	var row := HBoxContainer.new();column.add_child(row)
	for index in range(3):_button(row,["A · Discret","B · Équilibré","C · Présent"][index],choose.bind(index))
	choose(1)
func choose(index: int) -> void:
	if paused or application_guard.blocked:return
	selected = index;action_presenter.casting_strength = [0.42,0.65,0.88][index]
func _physics_process(delta: float) -> void:
	if not ready_ui:return
	# Freeze enemies and authoritative combat; loop actual casting states on the two heroes.
	if paused or application_guard.blocked:return
	var dt: float = minf(delta,1.0/30.0)
	elapsed += dt
	for unit in simulation.heroes:
		unit.action.cancel()
		var skill: StringName = &"lightning" if unit.actor_key == &"mako" else &"heal"
		unit.action.cooldowns.clear();unit.action.mana = 60
		unit.action.request(skill, simulation.hero(&"anne") if skill == &"lightning" else unit)
		unit.action.elapsed = fposmod(elapsed,3.2)
		if unit.action.elapsed >= unit.action._windup():unit.action.cancel()
	action_presenter.present(simulation.all_units(),[],dt,simulation.run_id)
	_present()
func _process(delta: float) -> void:
	super._process(delta)
	if lab_panel != null:
		lab_panel.position = safe_rect.position + Vector2(12,72)
		lab_panel.size = Vector2(safe_rect.size.x-24,110)
