extends "res://scripts/app/arena_page.gd"
## Isolated demonstration snapshots; never reads or writes the player's orders.
const BarStyle = preload("res://resources/presentation/status_bars/neon.tres")
var trials: Array[Resource] = []
var selected: int = 1
var running: bool = false
var lab_panel: PanelContainer
var caption: Label
var controls: Array[Button] = []
var dark_arena: bool = false

func _ready() -> void:
	save_path="user://graphics011_bars_lab.json"
	super._ready()
	for i in range(3):
		var profile: Resource = BarStyle.duplicate()
		profile.world_height=[1.0,1.25,1.5][i];profile.panel_height=2.2
		profile.glow_strength=[0.14,0.22,0.30][i];profile.glow_radius=[0.85,1.0,1.15][i]
		trials.append(profile)
	lab_panel=PanelContainer.new();add_child(lab_panel)
	var paint:=StyleBoxFlat.new();paint.bg_color=Color("10182ff0");paint.border_color=Color("d9a64c")
	paint.set_border_width_all(1);paint.set_content_margin_all(12);lab_panel.add_theme_stylebox_override("panel",paint)
	var column:=VBoxContainer.new();lab_panel.add_child(column);caption=_label(column,16)
	var actions:=HBoxContainer.new();column.add_child(actions)
	controls.append(_button(actions,"Clair / sombre",switch_arena))
	controls.append(_button(actions,"Animer / figer",toggle_motion))
	var note:=_label(column,12);note.text="Modèles : B · panneaux : Lumineux\nPV / mana segmentés · sort continu · textes blancs"
	_snapshot();switch_arena();choose_trial(1)

func _snapshot() -> void:
	simulation.reset();simulation.rules={"mako":[],"anne":[]};simulation.wave.cap=2
	action_presenter.reset_run(simulation.run_id)
	var mako=simulation.hero(&"mako");var anne=simulation.hero(&"anne")
	mako.state.damage(50);anne.state.damage(70);mako.action.mana=36;anne.action.mana=27
	mako.action.request(&"booster",anne);mako.action.elapsed=0.75
	anne.action.request(&"heal",anne);anne.action.elapsed=0.45
	for at in [Vector2(1.8,1.4),Vector2(-1.8,-1.4)]:simulation.add_enemy(at)
	for enemy_unit in simulation.enemies:
		enemy_unit.state.damage(16);enemy_unit.action.mana=42
		enemy_unit.abilities.append(&"booster");enemy_unit.action.request(&"booster",anne);enemy_unit.action.elapsed=0.95
	simulation.wave.cap=0
	super._physics_process(0)
	_apply_trial()

func choose_trial(index: int) -> void:
	if paused or application_guard.blocked:return
	selected=clampi(index,0,2);_apply_trial();_refresh_lab()

func _apply_trial() -> void:
	if trials.is_empty():return
	for bar in overhead.values():
		if bar.style_resource!=trials[selected]:bar.apply_style(trials[selected])
	for panel in hero_panels:
		if panel.bars!=null and panel.bars.style_resource!=trials[selected]:panel.bars.apply_style(trials[selected],true)

func toggle_motion() -> void:
	if paused or application_guard.blocked:return
	running=not running
	if running:
		simulation.rules=Orders.defaults();_reset()
	else:_snapshot()
	_apply_trial()

func switch_arena() -> void:
	if paused or application_guard.blocked:return
	dark_arena=not dark_arena
	arena_definition=Catalog.definition(&"arcane_bleu_sombre" if dark_arena else &"lumiere_angelique")
	floor_canvas.set_definition(arena_definition);_sync_projection()

func _physics_process(delta: float) -> void:
	if running:super._physics_process(delta)
	_apply_trial()

func _process(delta: float) -> void:
	super._process(delta);_apply_trial();_refresh_lab()

func _refresh_lab() -> void:
	if caption==null:return
	caption.text="GRAPHICS-012 · Panneaux héros\nModèles B · panneaux Lumineux\n"+("Combat automatique" if running else "Vue figée · textes et segments")
	var height:float=maxf(194,lab_panel.get_combined_minimum_size().y)
	lab_panel.size=Vector2(safe_rect.size.x-24,height);lab_panel.position=safe_rect.position+Vector2(12,safe_rect.size.y-height-12)
	for button in controls:button.disabled=paused or application_guard.blocked or _modal_open()
