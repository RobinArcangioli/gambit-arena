extends Control
## Read-only artwork preview: no gameplay, player files, or artificial boot delay.
const SQUARE=preload("res://assets/art/branding/beherit_square_source.png")
const ROUND=preload("res://assets/art/branding/beherit_round_source.png")
func _ready() -> void:
	texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	get_window().content_scale_size=Vector2i(900,800);get_window().size=Vector2i(900,800)
	get_window().title="Gambit Arena · Beherit · Icône et démarrage"
	theme=preload("res://resources/ui/styles/palette_blood.tres")
	var bg:=ColorRect.new();bg.color=Color("000000");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);bg.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(bg)
	_label("Gambit Arena · Logo Beherit",Vector2(26,16),24)
	_label("Illustrations retenues · versions carrée et ronde",Vector2(26,53),15)
	var square:=TextureRect.new();square.texture=SQUARE;square.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;square.size=Vector2(260,260);square.position=Vector2(32,97);add_child(square)
	var circle:=TextureRect.new();circle.texture=ROUND;circle.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;circle.size=Vector2(260,260);circle.position=Vector2(325,97);add_child(circle)
	_label("Icône classique",Vector2(32,367),18);_label("Version circulaire",Vector2(325,367),18)
	_label("Lisibilité en petit format",Vector2(32,414),18)
	for i in range(4):
		var edge:int=[96,64,48,32][i]
		var texture:=TextureRect.new();texture.texture=ROUND;texture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		texture.size=Vector2.ONE*edge;texture.position=Vector2(32+i*142,452+(96-edge)*.5);add_child(texture)
		_label(str(edge)+" px",Vector2(32+i*142,559),14)
	_label("Démarrage",Vector2(630,94),18)
	var panel:=Panel.new();var paint:=StyleBoxFlat.new();paint.bg_color=Color("000000");paint.border_color=Color("b41c29");paint.set_border_width_all(1);paint.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel",paint);panel.position=Vector2(630,132);panel.size=Vector2(232,414);add_child(panel)
	var splash:=TextureRect.new();splash.texture=ROUND;splash.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;splash.size=Vector2.ONE*130;splash.position=Vector2(51,142);panel.add_child(splash)
	_label("Fond noir · logo centré",Vector2(630,559),14)
	_label("Le cercle de feu et le pendentif sont conservés.\nL’icône Android est adaptée à ses masques ; aucune retouche du dessin.",Vector2(32,624),16)
	var open:=Button.new();open.text="Voir l’accueil actuel";open.position=Vector2(32,704);open.size=Vector2(280,48);add_child(open)
	open.pressed.connect(func():get_tree().change_scene_to_file("res://scenes/app/app_root.tscn"))
func _label(text:String,at:Vector2,font_size:int) -> void:
	var label:=Label.new();label.text=text;label.position=at;label.add_theme_font_size_override("font_size",font_size);add_child(label)
