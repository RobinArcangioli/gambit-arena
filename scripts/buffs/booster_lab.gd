extends "res://scripts/app/arena_page.gd"
## Real Booster orders and events, isolated from the player's saved configuration.
const BuffCatalog = preload("res://scripts/buffs/buff_catalog.gd")
const Preset = preload("res://scripts/buffs/booster_preset.gd")
var lab_panel: PanelContainer
var readings: Label
var journal: Array[String] = []
var lab_buttons: Array[Button] = []

func _ready() -> void:
	# Two-actor timing fixture; the product roster is tested separately with all three.
	team_slots=[&"nassau",&"anne",&"",&""]
	save_path = "user://buffs002_isolated_lab.json"
	super._ready()
	lab_panel = PanelContainer.new();add_child(lab_panel)
	var style := StyleBoxFlat.new();style.bg_color = Color("10182ff0")
	style.border_color = Color("d9a64c");style.set_border_width_all(1);style.set_content_margin_all(12)
	lab_panel.add_theme_stylebox_override("panel",style)
	var column := VBoxContainer.new();lab_panel.add_child(column)
	var title := _label(column,18);title.text = "BUFFS-002 · Allié → Booster"
	readings = _label(column,14)
	var row := HBoxContainer.new();column.add_child(row)
	lab_buttons.append(_button(row,"Repartir",restart_lab))
	lab_buttons.append(_button(row,"Mana 0",empty_mana))
	lab_buttons.append(_button(row,"Squelette",add_dummy_enemy))
	var note := _label(column,12)
	note.text = "20 mana · cast 1,5 s · ×1,30 pendant 60 s\nMontre dorée 2 s · durée du buff indépendante."
	_refresh_lab()

func _reset() -> void:
	super._reset()
	if not ready_ui:return
	simulation.rules = Preset.create(Orders.defaults())
	simulation.wave.cap = 0
	journal.clear()

func restart_lab() -> void:
	if paused or application_guard.blocked:return
	_reset();_refresh_lab()

func empty_mana() -> void:
	if paused or application_guard.blocked:return
	simulation.hero(&"nassau").action.mana = 0

func add_dummy_enemy() -> void:
	if paused or application_guard.blocked:return
	simulation.wave.cap = 1;simulation.add_enemy(Vector2(2,2));simulation.wave.cap = 0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	for event in simulation.events:
		if event.kind == "buff_applied":
			var target_name: String = "Nassau" if event.target_id == simulation.hero(&"nassau").combat_id else "Anne"
			journal.append("%.2f s · Nassau → %s" % [event.game_time,target_name])
			if journal.size() > 4:journal.pop_front()

func _process(delta: float) -> void:
	super._process(delta);_refresh_lab()

func _refresh_lab() -> void:
	if readings == null or not ready_ui:return
	var text: String = "Combat %.2f s" % simulation.clock.elapsed
	for key in [&"nassau",&"anne"]:
		var unit = simulation.hero(key)
		text += "\n%s ×%.2f · Booster %.1f s · mana %.1f" % [unit.display_name,unit.buffs.multiplier(),unit.buffs.remaining(BuffCatalog.BOOSTER),unit.action.mana]
	text += "\nApplications :\n" + ("En attente…" if journal.is_empty() else "\n".join(journal))
	readings.text = text
	var height: float = maxf(264,lab_panel.get_combined_minimum_size().y)
	lab_panel.size = Vector2(safe_rect.size.x-24,height)
	lab_panel.position = safe_rect.position+Vector2(12,safe_rect.size.y-height-12)
	for button in lab_buttons:button.disabled = paused or application_guard.blocked or _modal_open()
