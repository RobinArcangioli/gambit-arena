extends Control
## Passive borderless background, optionally dividing four equal hero slots.
var profile:Resource=preload("res://resources/ui/arena_hud.tres")
var separators:bool=false
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO,size),profile.backdrop)
	if not separators:return
	var middle:Vector2=size*.5
	var tint:Color=profile.gold;tint.a=.32
	var inset_x:float=16;var inset_y:float=12
	if profile.separator==2:
		tint=Color("45648d");tint.a=.55
		inset_x=size.x*.13;inset_y=size.y*.16
	_gradient(Vector2(inset_x,middle.y),Vector2(middle.x-8,middle.y),tint)
	_gradient(Vector2(middle.x+8,middle.y),Vector2(size.x-inset_x,middle.y),tint)
	_gradient(Vector2(middle.x,inset_y),Vector2(middle.x,middle.y-8),tint)
	_gradient(Vector2(middle.x,middle.y+8),Vector2(middle.x,size.y-inset_y),tint)
	if profile.separator==1:
		var gem:Color=profile.gold;gem.a=.65
		draw_polyline(PackedVector2Array([middle+Vector2(0,-3.5),middle+Vector2(3.5,0),middle+Vector2(0,3.5),middle+Vector2(-3.5,0),middle+Vector2(0,-3.5)]),gem,1,true)
	elif profile.separator==2:
		var tip:Color=profile.gold;tip.a=.48
		for direction in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:draw_line(middle+direction*11,middle+direction*16,tip,1,true)
func _gradient(start:Vector2,finish:Vector2,tint:Color) -> void:
	for i in range(24):
		var from:float=float(i)/24.0;var to:float=float(i+1)/24.0
		var paint:Color=tint;paint.a*=sin(PI*(from+to)*.5)
		draw_line(start.lerp(finish,from),start.lerp(finish,to),paint,1,true)
func apply_style(value:Resource) -> void:
	profile=value;queue_redraw()
