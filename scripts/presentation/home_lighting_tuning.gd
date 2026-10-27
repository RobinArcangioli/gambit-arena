extends Control
## Temporary F6 art preview. No production save is opened or changed.
const App = preload("res://scenes/app/app_root.tscn")
const Lighting = preload("res://scripts/presentation/home_lighting.gd")
const OPTIONS = [
	{"id":"A","name":"Doux","candle":0.24,"brazier":0.38,"flicker":0.24},
	{"id":"B","name":"Équilibré","candle":0.27,"brazier":0.42,"flicker":0.30},
	{"id":"C","name":"Un peu plus présent","candle":0.30,"brazier":0.46,"flicker":0.34}]
const CHOICE_PATH = "user://home_lighting_choice.json"
var app
var selected: int = 1
var cycling: bool = true
var timer: float = 0.0
var title: Label
var detail: Label
var cycle_button: Button
var choice_buttons: Array[Button] = []
func _ready() -> void:
	DisplayServer.window_set_title("Gambit Arena — essais des lueurs A / B / C")
	theme = preload("res://resources/ui/night_gold.tres")
	app = App.instantiate();app.save_path="user://home001-tuning-unused.json";add_child(app)
	app.home_page.hide()
	var header:=PanelContainer.new();header.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	header.offset_left=12;header.offset_top=12;header.offset_right=-12;add_child(header)
	var head:=VBoxContainer.new();header.add_child(head)
	title=Label.new();title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size",24);head.add_child(title)
	detail=Label.new();detail.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	detail.add_theme_font_size_override("font_size",16);head.add_child(detail)
	var footer:=VBoxContainer.new();footer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	footer.offset_left=16;footer.offset_right=-16;footer.offset_top=-130;footer.offset_bottom=-16
	footer.add_theme_constant_override("separation",8);add_child(footer)
	var choices:=HBoxContainer.new();choices.add_theme_constant_override("separation",8);footer.add_child(choices)
	for i in range(OPTIONS.size()):
		var button:=Button.new();button.text=OPTIONS[i].id+" · "+OPTIONS[i].name
		button.add_theme_font_size_override("font_size",15);button.custom_minimum_size.y=48
		button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		button.pressed.connect(_select.bind(i));choices.add_child(button);choice_buttons.append(button)
	var actions:=HBoxContainer.new();actions.add_theme_constant_override("separation",8);footer.add_child(actions)
	cycle_button=Button.new();cycle_button.text="Pause du défilement";cycle_button.custom_minimum_size.y=48
	cycle_button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	cycle_button.pressed.connect(func():cycling=not cycling;timer=0;_caption());actions.add_child(cycle_button)
	var keep:=Button.new();keep.text="Retenir cet essai";keep.custom_minimum_size.y=48
	keep.size_flags_horizontal=Control.SIZE_EXPAND_FILL;keep.pressed.connect(_retain);actions.add_child(keep)
	if "--preset-c" in OS.get_cmdline_user_args():selected=2;cycling=false
	_apply()
func _select(index: int) -> void:
	selected=index;cycling=false;timer=0;_apply()
func _apply() -> void:
	var option: Dictionary=OPTIONS[selected]
	var layer=app.home_lighting
	layer.profile=layer.profile.duplicate(true)
	layer.profile.candle_strength=option.candle;layer.profile.brazier_strength=option.brazier
	layer.profile.flicker=option.flicker
	for i in range(layer.strengths.size()):layer.strengths[i]=option.candle if i<layer.profile.candles.size() else option.brazier
	layer._animate();_caption()
func _caption() -> void:
	var option: Dictionary=OPTIONS[selected]
	title.text="Essai "+option.id+" — "+option.name
	detail.text="Changement toutes les 8 s" if cycling else "Essai figé · scintillement toujours actif"
	cycle_button.text="Pause du défilement" if cycling else "Reprendre le défilement"
	for i in range(choice_buttons.size()):choice_buttons[i].modulate=Color("ffd68a") if selected==i else Color.WHITE
func _retain() -> void:
	cycling=false;_caption()
	var file:=FileAccess.open(CHOICE_PATH,FileAccess.WRITE)
	if file!=null:file.store_string(JSON.stringify(OPTIONS[selected]));file.close();detail.text="Essai "+OPTIONS[selected].id+" retenu"
func _process(delta: float) -> void:
	if not cycling or app==null or app.guard.blocked:return
	timer+=minf(delta,0.05)
	if timer>=8.0:selected=(selected+1)%OPTIONS.size();timer=0;_apply()
