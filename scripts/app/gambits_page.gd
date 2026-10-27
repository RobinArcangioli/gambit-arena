extends "res://scripts/app/hero_page.gd"
## Share the page shell and touch router; all rule semantics remain in PartyRules.
signal hero_requested
const Draft = preload("res://scripts/app/gambits_draft.gd")
var save_path: String = "user://party_rules_v2.json"
var draft := Draft.new()
var controls: Array[Dictionary] = []
var footer: HBoxContainer
var apply_button: Button
var cancel_button: Button
var message: Label

func _ready() -> void:
	draft.open(hero_id,save_path)
	super._ready()
	back_button.text = "‹ Fiche"
	title.text = "Gambits · "+reference.get("name","")
	title.add_theme_font_size_override("font_size",22)
	team_requested.connect(func():
		if active:hero_requested.emit())
	footer = HBoxContainer.new();footer.add_theme_constant_override("separation",12);content.add_child(footer)
	cancel_button = _button(footer,"Annuler",func():
		if active:hero_requested.emit())
	apply_button = _button(footer,"Appliquer",_apply)
	_layout();_refresh()

func _button(parent: Node, caption: String, callback: Callable) -> Button:
	var button := Button.new();button.text = caption
	button.custom_minimum_size = Vector2(44,46)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size",18)
	button.pressed.connect(callback);parent.add_child(button);return button

func _build_reference() -> void:
	_label(column,"Les règles sont évaluées de haut en bas. Allié inclut le héros lui-même.",17)
	message = _label(column,"",17)
	for i in range(3):
		var box := _panel()
		var head := HBoxContainer.new();head.add_theme_constant_override("separation",6);box.add_child(head)
		var priority := _label(head,str(i+1)+".",22);priority.autowrap_mode = TextServer.AUTOWRAP_OFF
		var row: Dictionary = {}
		row.enabled = _button(head,"",_toggle.bind(i))
		row.up = _button(head,"↑",_move.bind(i,-1));row.down = _button(head,"↓",_move.bind(i,1))
		row.skill = _button(box,"",_cycle_skill.bind(i))
		row.condition = _button(box,"",_cycle_condition.bind(i))
		row.threshold = _label(box,"",17)
		var adjust := HBoxContainer.new();adjust.add_theme_constant_override("separation",6);box.add_child(adjust)
		row.adjust = []
		for amount in [-10,-1,1,10]:row.adjust.append(_button(adjust,"%+d" % amount,_threshold.bind(i,amount)))
		controls.append(row)

func _refresh() -> void:
	for i in range(controls.size()):
		var fields: Dictionary = controls[i];var row: Dictionary = draft.rows[i]
		fields.enabled.text = "Actif" if row.enabled else "Inactif"
		fields.skill.text = ("Allié → Soin" if row.skill=="heal" else "Ennemi → Foudre" if row.skill=="lightning" else "Ennemi → Attaque")
		fields.condition.text = "Condition : Toujours" if row.condition=="always" else "Condition : PV < seuil"
		fields.threshold.text = "Seuil non utilisé" if row.condition=="always" else "Seuil : %d %% (strict)" % row.threshold
		for key in ["enabled","skill","condition"]:fields[key].disabled = not active
		fields.up.disabled = not active or i==0;fields.down.disabled = not active or i==2
		for j in range(4):
			var amount: int = [-10,-1,1,10][j]
			fields.adjust[j].disabled = not active or row.condition=="always" or (amount<0 and row.threshold==0) or (amount>0 and row.threshold==100)
	if message!=null:
		message.text = "Configuration illisible : enregistrement indisponible." if not draft.readable else ""
		message.visible = not draft.readable
	if apply_button!=null:apply_button.disabled = not active or not draft.readable
	if cancel_button!=null:cancel_button.disabled = not active

func _toggle(i: int) -> void:
	if not active:return
	draft.rows[i].enabled = not draft.rows[i].enabled;_refresh()
func _cycle_skill(i: int) -> void:
	if not active:return
	var row: Dictionary = draft.rows[i]
	row.skill = "basic" if row.skill!="basic" else "heal" if hero_id==&"anne" else "lightning"
	row.target = "ally" if row.skill=="heal" else "enemy";_refresh()
func _cycle_condition(i: int) -> void:
	if not active:return
	draft.rows[i].condition = "always" if draft.rows[i].condition!="always" else "hp_below";_refresh()
func _threshold(i: int, amount: int) -> void:
	if not active or draft.rows[i].condition!="hp_below":return
	draft.rows[i].threshold = clampi(draft.rows[i].threshold+amount,0,100);_refresh()
func _move(i: int, direction: int) -> void:
	if not active or i+direction<0 or i+direction>=3:return
	var other = draft.rows[i+direction];draft.rows[i+direction] = draft.rows[i];draft.rows[i] = other
	touch_router.cancel_gesture();_refresh()
func _apply() -> void:
	if not active:return
	var result: Error = draft.apply()
	if result==OK:hero_requested.emit()
	else:
		_refresh();message.text = "Enregistrement impossible. Vos changements restent ouverts.";message.show();scroll.scroll_vertical = 0

func _layout() -> void:
	super._layout()
	if content==null:return
	scroll.size.y = maxf(1,content.size.y-182)
	if footer!=null:
		footer.position = Vector2(24,content.size.y-80);footer.size = Vector2(content.size.x-48,56)

func set_active(enabled: bool) -> void:
	super.set_active(enabled)
	_refresh()
