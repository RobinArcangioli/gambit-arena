extends VBoxContainer
## One immediate editor for menu and combat. Row tokens invalidate stale callbacks.
signal configuration_changed(configuration: Dictionary)
const Store = preload("res://scripts/gambits/configuration_store.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const SkillIcons = preload("res://scripts/presentation/skill_icons.gd")
var icon_style: Resource = SkillIcons.DEFAULT_STYLE
const Icon = preload("res://scripts/gambits/order_icon.gd")
const Palette = preload("res://scripts/app/app_theme.gd")
var hero_id: StringName = &"anne"
var save_path: String = "user://party_rules_v2.json"
var store: Store
var rows: Array = []
var tokens: Array[int] = []
var sequence: int = 0
var controls: Array[Dictionary] = []
var active: bool = true
var readable: bool = true
var list: VBoxContainer
var message: Label
var counter: Label
var add_button: Button
var empty_label: Label

func _ready() -> void:
	theme = Palette.editor_theme()
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation",10)
	store = Store.new(save_path)
	readable = store.load_configuration()==OK
	rows = store.configuration.get(String(hero_id),[]).duplicate(true)
	message = Label.new();message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size",15);add_child(message)
	message.text = "Configuration illisible : modification indisponible." if not readable else _migration_text()
	message.visible = not message.text.is_empty()
	list = VBoxContainer.new();list.add_theme_constant_override("separation",8);add_child(list)
	empty_label = Label.new();empty_label.text = "Aucun ordre. Ajoutez votre premier gambit."
	empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART;add_child(empty_label)
	var bottom := HBoxContainer.new();bottom.add_theme_constant_override("separation",12);add_child(bottom)
	add_button = Button.new();add_button.text = "+ Ajouter un ordre";add_button.custom_minimum_size.y = 48
	add_button.add_theme_font_size_override("font_size",16)
	add_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL;add_button.pressed.connect(add_order);bottom.add_child(add_button)
	counter = Label.new();bottom.add_child(counter)
	for row in rows:tokens.append(_token())
	_rebuild()

func _migration_text() -> String:
	var notes: PackedStringArray = []
	for note in store.migration_notes:
		if note.hero!=String(hero_id):continue
		if note.kind=="threshold_lowered":notes.append("Ordre %d : ancien seuil %d %% → %d %%." % [note.index+1,note.from.threshold,Criteria.threshold(note.criterion)])
		else:notes.append("Ordre %d désactivé : choisissez un critère de ciblage." % (note.index+1))
	return "\n".join(notes)
func _token() -> int:
	sequence+=1;return sequence
func _icon(parent: Node, symbol: String, hint: String, callback: Callable) -> Button:
	var button := Icon.new();button.symbol = symbol;button.tooltip_text = hint
	button.custom_minimum_size = Vector2(32 if get_viewport_rect().size.x<450 else 40,48);button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(callback);parent.add_child(button);return button
func _picker(parent: Node, hint: String) -> OptionButton:
	var picker := OptionButton.new();picker.tooltip_text = hint;picker.fit_to_longest_item = false
	picker.custom_minimum_size = Vector2(65,48);picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	picker.clip_text = true;picker.alignment = HORIZONTAL_ALIGNMENT_LEFT
	picker.add_theme_font_size_override("font_size",15)
	picker.get_popup().prefer_native_menu = false
	picker.pressed.connect(func():
		if active and readable:picker.show_popup())
	parent.add_child(picker);return picker
func _rebuild() -> void:
	close_popup()
	for child in list.get_children():list.remove_child(child);child.queue_free()
	controls.clear()
	for i in range(rows.size()):
		var row := HBoxContainer.new();row.add_theme_constant_override("separation",4);list.add_child(row)
		var token: int = tokens[i]
		var fields: Dictionary = {}
		fields.enabled = _icon(row,"enabled","Activer / désactiver l’ordre %d" % (i+1),toggle.bind(token))
		fields.enabled.enabled_order = rows[i].enabled
		fields.up = _icon(row,"up","Monter l’ordre",move_order.bind(token,-1))
		fields.down = _icon(row,"down","Descendre l’ordre",move_order.bind(token,1))
		fields.criterion = _picker(row,"Critère de ciblage")
		fields.criterion.size_flags_stretch_ratio = 1.7
		for id in Criteria.IDS:fields.criterion.add_item(Criteria.label(id))
		fields.criterion.select(Criteria.IDS.find(StringName(rows[i].criterion)))
		fields.criterion.item_selected.connect(func(index: int):change(token,"criterion",String(Criteria.IDS[index])))
		fields.skill = _picker(row,"Capacité")
		fields.skill.custom_minimum_size.x=132 if get_viewport_rect().size.x>=450 else 65
		var abilities: Array = Array(Orders.PROFILES[hero_id].abilities)
		fields.skill.add_theme_constant_override("icon_max_width",icon_style.picker_size)
		for id in abilities:
			var caption:String="Booster" if id==&"booster" else "Soin" if id==&"heal" else "Foudre" if id==&"lightning" else "Attaque"
			var texture:Texture2D=SkillIcons.texture(id)
			if texture!=null:fields.skill.add_icon_item(texture,caption)
			else:fields.skill.add_item(caption)
			fields.skill.get_popup().set_item_icon_max_width(fields.skill.item_count-1,icon_style.picker_size)
		fields.skill.select(abilities.find(StringName(rows[i].skill)))
		fields.skill.item_selected.connect(func(index: int):change(token,"skill",String(abilities[index])))
		fields.delete = _icon(row,"delete","Supprimer l’ordre",remove_order.bind(token))
		controls.append(fields)
	counter.text = "%d / 100" % rows.size();empty_label.visible = rows.is_empty()
	set_active(active)
func _commit(next: Array, next_tokens: Array[int]) -> void:
	if not active or not readable:return
	var result: Error = store.save_hero(hero_id,next)
	if result==OK:
		rows = next.duplicate(true);tokens = next_tokens.duplicate()
		configuration_changed.emit(store.configuration.duplicate(true))
	else:
		message.text = "Enregistrement impossible. Dernier état enregistré conservé.";message.show()
	_rebuild()
func toggle(token: int) -> void:
	var i: int = tokens.find(token)
	if i<0:return
	var next: Array = rows.duplicate(true);next[i].enabled = not next[i].enabled;_commit(next,tokens)
func change(token: int, field: String, value: String) -> void:
	var i: int = tokens.find(token)
	if i<0 or field not in ["criterion","skill"]:return
	var next: Array = rows.duplicate(true);next[i][field] = value;_commit(next,tokens)
func move_order(token: int, direction: int) -> void:
	var i: int = tokens.find(token);var destination: int = i+direction
	if i<0 or destination<0 or destination>=rows.size():return
	var next: Array = rows.duplicate(true);var ids: Array[int] = tokens.duplicate()
	var row = next.pop_at(i);next.insert(destination,row);ids.remove_at(i);ids.insert(destination,token);_commit(next,ids)
func remove_order(token: int) -> void:
	var i: int = tokens.find(token)
	if i<0:return
	var next: Array = rows.duplicate(true);var ids: Array[int] = tokens.duplicate()
	next.remove_at(i);ids.remove_at(i);_commit(next,ids)
func add_order() -> void:
	if rows.size()>=Orders.MAX_ORDERS:return
	var next: Array = rows.duplicate(true);var ids: Array[int] = tokens.duplicate()
	next.append(Orders.create());ids.append(_token());_commit(next,ids)
func popup_open() -> bool:
	for fields in controls:
		for key in ["criterion","skill"]:
			if fields[key].get_popup().visible:return true
	return false
func close_popup() -> bool:
	var found: bool = popup_open()
	for fields in controls:
		for key in ["criterion","skill"]:fields[key].get_popup().hide()
	return found
func set_active(value: bool) -> void:
	active = value
	if not value:close_popup()
	for i in range(controls.size()):
		for key in controls[i]:controls[i][key].disabled = not active or not readable
		controls[i].up.disabled = not active or not readable or i==0
		controls[i].down.disabled = not active or not readable or i==rows.size()-1
	if add_button!=null:add_button.disabled = not active or not readable or rows.size()>=Orders.MAX_ORDERS
