extends SceneTree
## Deterministic export sizing only: source illustrations are preserved byte-for-byte.
const DIR="res://assets/art/branding/"
func _initialize() -> void:
	var square:=Image.load_from_file(DIR+"beherit_square_source.png")
	var round_logo:=Image.load_from_file(DIR+"beherit_round_source.png")
	if square==null or round_logo==null:push_error("Branding sources unavailable");quit(1);return
	var main:Image=square.duplicate();main.resize(192,192,Image.INTERPOLATE_LANCZOS)
	if main.save_png(DIR+"launcher_192.png")!=OK:quit(1);return
	var foreground:=Image.create(432,432,false,Image.FORMAT_RGBA8);foreground.fill(Color.TRANSPARENT)
	var mark:Image=round_logo.duplicate();mark.resize(288,288,Image.INTERPOLATE_LANCZOS)
	foreground.blit_rect(mark,Rect2i(0,0,288,288),Vector2i(72,72))
	if foreground.save_png(DIR+"adaptive_foreground_432.png")!=OK:quit(1);return
	var background:=Image.create(432,432,false,Image.FORMAT_RGBA8);background.fill(Color("000000"))
	if background.save_png(DIR+"adaptive_background_432.png")!=OK:quit(1);return
	var splash:Image=round_logo.duplicate();splash.resize(320,320,Image.INTERPOLATE_LANCZOS)
	if splash.save_png(DIR+"boot_logo_320.png")!=OK:quit(1);return
	print("LOGO001_BRANDING_PREPARED");quit()
