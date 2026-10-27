extends "res://scripts/app/arena_page.gd"
## Art-only trials. Synthetic success facts are confined to this explicitly labelled lab.
const WatchProfile = preload("res://resources/presentation/effects/booster.tres")
var selected: int = 1
var comparison: bool = false
var replay_at: float = 0.0
var cycle_at: float = 0.0
var sequence: int = 0
var lab_panel: PanelContainer
var caption: Label
var trial_buttons: Array[Button] = []

func _ready() -> void:
	save_path = "user://graphics010_art_lab.json"
	super._ready()
	lab_panel = PanelContainer.new();add_child(lab_panel)
	var style := StyleBoxFlat.new();style.bg_color = Color("10182ff0")
	style.border_color = Color("d9a64c");style.set_border_width_all(1);style.set_content_margin_all(12)
	lab_panel.add_theme_stylebox_override("panel",style)
	var column := VBoxContainer.new();lab_panel.add_child(column)
	caption = _label(column,16)
	var row := HBoxContainer.new();column.add_child(row)
	for i in range(3):trial_buttons.append(_button(row,["A · Discret","B · Équilibré","C · Présent"][i],choose_trial.bind(i)))
	var controls := HBoxContainer.new();column.add_child(controls)
	trial_buttons.append(_button(controls,"Revoir",preview))
	trial_buttons.append(_button(controls,"Comparer A/B/C",toggle_comparison))
	var note := _label(column,12)
	note.text = "Montre sur Mako : 2 s · soin sur Anne : 1 s\nAperçus visuels seuls · aucun buff, PV ou mana modifié."
	choose_trial(1);_refresh_lab()

func _reset() -> void:
	super._reset()
	if not ready_ui:return
	simulation.rules = {"mako":[],"anne":[]};simulation.wave.cap = 0
	replay_at = 0;cycle_at = 0

func choose_trial(index: int) -> void:
	if paused or application_guard.blocked:return
	selected = clampi(index,0,2)
	var profile: Resource = WatchProfile.duplicate()
	profile.radius = [0.42,0.47,0.52][selected]
	profile.opacity = [0.65,0.85,1.0][selected]
	action_presenter.booster.definition = profile
	preview();cycle_at = simulation.clock.elapsed + 6.0

func preview() -> void:
	if paused or application_guard.blocked:return
	action_presenter.booster.clear_visuals();action_presenter._clear_heals()
	action_presenter.capture(simulation.all_units(),simulation.run_id)
	action_presenter.booster.advance_visual(action_presenter.bindings,0)
	sequence += 1
	var target = simulation.hero(&"mako")
	action_presenter.booster.consume({"run_id":simulation.run_id,"kind":"buff_applied","buff_id":"booster","outcome":"booster","source_id":target.combat_id,"target_id":target.combat_id,"sequence":sequence})
	var healed = simulation.hero(&"anne")
	action_presenter._heal({"target_id":healed.combat_id,"target_position":healed.position,"healing":30})
	replay_at = simulation.clock.elapsed + 2.8

func toggle_comparison() -> void:
	if paused or application_guard.blocked:return
	comparison = not comparison;cycle_at = simulation.clock.elapsed + 6.0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if paused or application_guard.blocked or not ready_ui:return
	if comparison and simulation.clock.elapsed >= cycle_at:choose_trial((selected+1)%3)
	elif simulation.clock.elapsed >= replay_at:preview()

func _process(delta: float) -> void:
	super._process(delta);_refresh_lab()

func _refresh_lab() -> void:
	if caption == null:return
	caption.text = "GRAPHICS-010 · Montre %s\n%s" % [["A · Discret","B · Équilibré","C · Présent"][selected],"Comparaison automatique / 6 s" if comparison else "Choisir un essai ou revoir le même effet"]
	var height: float = maxf(194,lab_panel.get_combined_minimum_size().y)
	lab_panel.size = Vector2(safe_rect.size.x-24,height)
	lab_panel.position = safe_rect.position+Vector2(12,safe_rect.size.y-height-12)
	for button in trial_buttons:button.disabled = paused or application_guard.blocked or _modal_open()
