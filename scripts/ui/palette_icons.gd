extends RefCounted
## Recolor imported small glyphs once per palette, also works inside an exported PCK.
static var cache:Dictionary={}
static func icon(source:Texture2D,profile:Resource) -> Texture2D:
	if profile.gold==Color("eac174") and profile.icon_fill==Color("10182f"):return source
	var key:String="%d:%s:%s"%[source.get_instance_id(),profile.gold.to_html(),profile.icon_fill.to_html()]
	if cache.has(key):return cache[key]
	var image:Image=source.get_image().duplicate() as Image
	if image.is_compressed():image.decompress()
	image.convert(Image.FORMAT_RGBA8)
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var old:Color=image.get_pixel(x,y)
			var mix_value:float=clampf((old.r-16.0/255.0)/(234.0/255.0-16.0/255.0),0,1)
			var tint:Color=profile.icon_fill.lerp(profile.gold,mix_value);tint.a=old.a;image.set_pixel(x,y,tint)
	var result:=ImageTexture.create_from_image(image);cache[key]=result;return result
static func checkbox(checked:bool,profile:Resource) -> Texture2D:
	if profile.gold==Color("eac174"):return preload("res://assets/ui/settings_checked.svg") if checked else preload("res://assets/ui/settings_unchecked.svg")
	var key:String="box:%s:%s:%s"%[checked,profile.gold.to_html(),profile.icon_fill.to_html()]
	if cache.has(key):return cache[key]
	var svg:String='<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22"><rect x="2" y="2" width="18" height="18" rx="4" fill="#%s" stroke="#%s" stroke-width="1.5"/>%s</svg>'%[profile.icon_fill.to_html(false),profile.gold.to_html(false),'<path d="m6 11 3.5 4L16 7" fill="none" stroke="#fff0e8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>' if checked else ""]
	var image:=Image.new();image.load_svg_from_string(svg);var result:=ImageTexture.create_from_image(image);cache[key]=result;return result
