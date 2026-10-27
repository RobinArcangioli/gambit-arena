extends "res://scripts/app/hero_page.gd"
## F6 laboratory only: detached snapshots, no PartySimulation or damage execution.
const Catalogue = preload("res://scripts/gambits/target_criteria.gd")
const Orders = preload("res://scripts/gambits/orders.gd")
const Codec = preload("res://scripts/gambits/configuration_codec.gd")
const Store = preload("res://scripts/gambits/configuration_store.gd")
const Legacy = preload("res://scripts/party/party_rules.gd")
const Guard = preload("res://scripts/platform/application_guard.gd")
@export var lab_path: String = "user://gambits_v3_lab.json"
var store: Store
var guard := Guard.new()
var hero_picker: OptionButton
var criterion_picker: OptionButton
var skill_picker: OptionButton
var result_label: Label
var storage_label: Label
var load_error: Error
func _ready() -> void:
	hero_id = &"mako";store = Store.new(lab_path);load_error = store.load_configuration()
	super._ready()
	title.text = "Banc Gambits v3";title.add_theme_font_size_override("font_size",23)
	back_button.text = "F6";back_button.disabled = true
	add_child(guard);_refresh()
func _picker(parent: Node, labels: Array, callback: Callable) -> OptionButton:
	var picker := OptionButton.new();picker.custom_minimum_size.y = 48
	picker.add_theme_font_size_override("font_size",18)
	for value in labels:picker.add_item(String(value))
	parent.add_child(picker);picker.item_selected.connect(callback)
	# TouchScrollRouter emits BaseButton.pressed; open the native picker explicitly.
	picker.pressed.connect(picker.show_popup)
	return picker
func _build_reference() -> void:
	_label(column,"F6 · Banc isolé, sans combat. Le jeu et party_rules_v2.json restent inchangés.",17)
	var box := _panel()
	hero_picker = _picker(box,["Mako","Anne"],_hero_changed)
	var labels: Array = []
	for id in Catalogue.IDS:labels.append(Catalogue.label(id))
	criterion_picker = _picker(box,labels,_criterion_changed)
	skill_picker = _picker(box,[],_skill_changed)
	var output := _panel();result_label = _label(output,"",20)
	_label(column,"Instantané : Mako 100/180 PV ; Anne 40/140 PV ; ennemis 80/100 PV (près) et 120/300 PV (loin). Aucun effet n'est exécuté.",17)
	var migration := _panel()
	var old: Dictionary = {"anne":Legacy.defaults(&"anne"),"mako":Legacy.defaults(&"mako")};old.anne[0].threshold = 80
	var converted: Dictionary = Codec.migrate(old)
	_label(migration,"Migration isolée : Anne 80 % → "+Catalogue.label(converted.configuration.anne[0].criterion),18)
	storage_label = _label(column,"",16)
func _row() -> Dictionary:
	if not store.configuration.has(String(hero_id)):return Orders.create()
	var rows: Array = store.configuration[String(hero_id)]
	return rows[0] if not rows.is_empty() else Orders.create()
func _refresh() -> void:
	if hero_picker==null:return
	var order: Dictionary = _row()
	criterion_picker.select(Catalogue.IDS.find(StringName(order.criterion)))
	skill_picker.clear()
	for skill in Orders.PROFILES[hero_id].abilities:skill_picker.add_item(Reference.TITLES[skill])
	skill_picker.select(Orders.PROFILES[hero_id].abilities.find(StringName(order.skill)))
	var mako: Dictionary = {"id":1,"health":100,"max_health":180,"position":Vector2.ZERO}
	var anne: Dictionary = {"id":2,"health":40,"max_health":140,"position":Vector2(2,0)}
	var view: Dictionary = {"key":hero_id,"source":mako if hero_id==&"mako" else anne,"allies":[anne if hero_id==&"mako" else mako],"enemies":[{"id":3,"health":80,"max_health":100,"position":Vector2(1,0)},{"id":4,"health":120,"max_health":300,"position":Vector2(5,0)}],"mana":60.0,"abilities":Orders.PROFILES[hero_id].abilities,"cooldowns":{}}
	var choice: Dictionary = Orders.evaluate([order],view)
	var names: Dictionary = {1:"Mako",2:"Anne",3:"Ennemi 80 PV",4:"Ennemi 120 PV"}
	result_label.text = "Cible résolue : "+names.get(choice.get("target_id",-1),"Aucune")+"\nCapacité : "+Reference.TITLES[StringName(order.skill)]
	storage_label.text = "Écriture immédiate isolée : gambits_v3_lab.json" if load_error==OK else "Écriture du laboratoire impossible (%d)." % load_error
	for picker in [hero_picker,criterion_picker,skill_picker]:picker.disabled = not active or load_error!=OK
func _hero_changed(index: int) -> void:
	if not active:return
	hero_id = &"mako" if index==0 else &"anne";_refresh()
func _criterion_changed(index: int) -> void:
	if not active:return
	var changed: Dictionary = _row().duplicate(true);changed.criterion = String(Catalogue.IDS[index]);_save(changed)
func _skill_changed(index: int) -> void:
	if not active:return
	var changed: Dictionary = _row().duplicate(true);changed.skill = String(Orders.PROFILES[hero_id].abilities[index]);_save(changed)
func _save(order: Dictionary) -> void:
	var rows: Array = store.configuration[String(hero_id)].duplicate(true)
	if rows.is_empty():rows.append(order)
	else:rows[0] = order
	load_error = store.save_hero(hero_id,rows);_refresh()
func set_active(enabled: bool) -> void:
	super.set_active(enabled)
	if back_button!=null:back_button.disabled = true
	_refresh()
func _notification(what: int) -> void:
	if guard!=null and guard.observe(what):set_active(not guard.blocked)
