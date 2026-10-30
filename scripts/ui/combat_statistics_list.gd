extends Control
## Virtual drawing: one Control for all participants, only visible rows are painted.
var palette:Resource=preload("res://resources/ui/arena_hud.tres")
const COLORS:Array[Color]=[Color("ffd16a"),Color("e44949"),Color(0.72,1,0.8)]
var entries:Array[Dictionary]=[]
var offsets:Array[float]=[]
var peaks:Array[int]=[1,1,1]
var mvp:int=0
var show_headings:bool=true
var scroller:ScrollContainer
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal=Control.SIZE_EXPAND_FILL
	resized.connect(queue_redraw)
func set_rows(rows:Array[Dictionary], maxima:Array[int]) -> void:
	entries.clear();offsets.clear();peaks.assign(maxima)
	var team:int=-1;var top:float=0
	for row in rows:
		if show_headings and int(row.team)!=team:
			team=int(row.team);entries.append({"heading":"Héros" if team==0 else "Ennemis"});offsets.append(top);top+=26
		entries.append(row);offsets.append(top);top+=70
	custom_minimum_size=Vector2(0,maxf(1,top));queue_redraw()
func _draw() -> void:
	if scroller==null:return
	var font:Font=get_theme_default_font()
	var top:float=scroller.scroll_vertical
	var last:float=top+scroller.size.y
	var index:int=maxi(0,offsets.bsearch(top)-1)
	while index<entries.size() and offsets[index]<last:
		var row:Dictionary=entries[index];var y:float=offsets[index]
		if row.has("heading"):
			draw_string(font,Vector2(0,y+18),row.heading,HORIZONTAL_ALIGNMENT_LEFT,size.x,14,palette.title)
		else:
			var is_mvp:bool=int(row.id)==mvp
			var text:String=str(row.name)+(" †" if not row.alive else "")
			var font_size:int=12 if size.x<160 else 14
			while text.length()>4 and font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x>size.x-(35 if is_mvp else 0):text=text.left(-2)+"…"
			draw_string(font,Vector2(0,y+15),text,HORIZONTAL_ALIGNMENT_LEFT,size.x,font_size,palette.stat_text if row.alive else palette.muted)
			if is_mvp:draw_string(font,Vector2(font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x+6,y+15),"MVP",HORIZONTAL_ALIGNMENT_LEFT,31,11,Color("ff00ff"))
			for metric in range(3):
				var value:int=int(row[["dealt","received","healed"][metric]])
				var at:=Vector2(0,y+22+metric*15)
				var color:Color=COLORS[metric]
				draw_style_box(_track(color),Rect2(at,Vector2(size.x,13)))
				if value>0:draw_style_box(_fill(color),Rect2(at,Vector2(size.x*clampf(float(value)/peaks[metric],0,1),13)))
				var caption:String=["Infligés","Reçus","Soins"][metric]
				draw_string_outline(font,at+Vector2(3,10),caption,HORIZONTAL_ALIGNMENT_LEFT,-1,10,2,palette.icon_fill)
				draw_string(font,at+Vector2(3,10),caption,HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color.WHITE)
				var number:String=str(value);var width:float=font.get_string_size(number,HORIZONTAL_ALIGNMENT_LEFT,-1,10).x
				draw_string_outline(font,at+Vector2(size.x-width-3,10),number,HORIZONTAL_ALIGNMENT_LEFT,-1,10,2,palette.icon_fill)
				draw_string(font,at+Vector2(size.x-width-3,10),number,HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color.WHITE)
		index+=1
func _track(color:Color) -> StyleBoxFlat:
	var paint:=StyleBoxFlat.new();paint.bg_color=Color(color.r*.2,color.g*.2,color.b*.2,.85);paint.set_corner_radius_all(2);return paint
func _fill(color:Color) -> StyleBoxFlat:
	var paint:=StyleBoxFlat.new();paint.bg_color=Color(color.r,color.g,color.b,.8);paint.set_corner_radius_all(2);return paint
