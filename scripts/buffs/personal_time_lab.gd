extends "res://scripts/app/arena_page.gd"
## Isolated F6 recipe. Never loads or writes the player's gambits.
const Definition = preload("res://scripts/buffs/buff_definition.gd")
var readings: Label
var lab_panel: PanelContainer
var lab_buttons: Array[Button] = []

func _ready() -> void:
	save_path = "user://buffs001_isolated_lab.json"
	super._ready()
	simulation.rules = Orders.defaults()
	simulation.wave.cap = 0
	lab_panel = PanelContainer.new()
	add_child(lab_panel)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("10182ff0")
	style.border_color = Color("d9a64c")
	style.set_border_width_all(1)
	style.set_content_margin_all(12)
	lab_panel.add_theme_stylebox_override("panel", style)
	var column := VBoxContainer.new()
	lab_panel.add_child(column)
	var title := _label(column, 18)
	title.text = "BUFFS-001 · Horloges personnelles"
	readings = _label(column, 14)
	var line := HBoxContainer.new()
	column.add_child(line)
	lab_buttons.append(_button(line, "Mako ×1,30", apply_haste.bind(&"mako")))
	lab_buttons.append(_button(line, "Anne ×1,30", apply_haste.bind(&"anne")))
	lab_buttons.append(_button(line, "Retirer", remove_buffs))
	var controls := HBoxContainer.new()
	column.add_child(controls)
	lab_buttons.append(_button(controls, "Soin comparé", compare_casts))
	lab_buttons.append(_button(controls, "Squelette", add_dummy_enemy))
	lab_buttons.append(_button(controls, "Repartir", restart_lab))
	var note := _label(column, 12)
	note.text = "Buff 60 s · mana normale · Pause en haut
Buff d’essai isolé · sorts de comparaison."
	_refresh_lab()

func apply_haste(key: StringName) -> void:
	if paused or application_guard.blocked or simulation.result != "EN COURS": return
	var unit = simulation.hero(key)
	if Executor.living(unit): unit.buffs.apply(Definition.create(&"lab_haste", 60.0, 1.30))
	_refresh_lab()

func remove_buffs() -> void:
	if paused or application_guard.blocked: return
	for unit in simulation.all_units(): unit.buffs.clear()
	_refresh_lab()

func compare_casts() -> void:
	if paused or application_guard.blocked or simulation.result != "EN COURS": return
	for unit in simulation.heroes:
		unit.action.cancel()
		unit.abilities.assign([&"basic", &"heal", &"lightning"])
		unit.action.cooldowns.clear()
		unit.state.damage(maxi(0, unit.state.health - unit.state.max_health + 35))
		unit.action.mana = 30.0
		unit.action.request(&"heal", unit)
	_refresh_lab()

func add_dummy_enemy() -> void:
	if paused or application_guard.blocked: return
	simulation.wave.cap = 1
	simulation.add_enemy(Vector2(2, 2))
	simulation.wave.cap = 0

func restart_lab() -> void:
	if paused or application_guard.blocked: return
	_reset()
	simulation.rules = Orders.defaults()
	simulation.wave.cap = 0
	_refresh_lab()

func _process(delta: float) -> void:
	super._process(delta)
	_refresh_lab()

func _refresh_lab() -> void:
	if readings == null or not ready_ui: return
	var text: String = "Combat : %.2f s" % simulation.clock.elapsed
	for key in [&"mako", &"anne"]:
		var unit = simulation.hero(key)
		if not is_instance_valid(unit): continue
		text += "\n%s ×%.2f · perso %.2f s · buff %.1f s\nmana %.1f · cast %.0f %% · recharge soin %.2f s" % [unit.display_name, unit.buffs.multiplier(), unit.personal_elapsed, unit.buffs.remaining(&"lab_haste"), unit.action.mana, 100.0 * unit.action.cast_progress(), unit.action.remaining(&"heal")]
	readings.text = text
	var panel_height: float = maxf(280.0, lab_panel.get_combined_minimum_size().y)
	lab_panel.size = Vector2(safe_rect.size.x - 24, panel_height)
	lab_panel.position = safe_rect.position + Vector2(12, safe_rect.size.y - panel_height - 12)
	for button in lab_buttons: button.disabled = paused or application_guard.blocked or _modal_open()
