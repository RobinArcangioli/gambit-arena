extends Label3D
## Shared former heal-number animation: one second, upward drift, common fade.
const DefaultFade=preload("res://resources/presentation/effects/common_fade.tres")
var age:float=0
var duration:float=1
var height:float=1.55
var origin:Vector3=Vector3.ZERO
var tint:Color=Color.WHITE
var outline:Color=Color("10182f")
var fade:Resource=DefaultFade
func setup(caption:String,color:Color,edge:Color,seconds:float=1,at_height:float=1.55,envelope:Resource=DefaultFade) -> void:
	text=caption;tint=color;outline=edge;duration=maxf(.1,seconds);height=at_height
	fade=envelope if envelope!=null else DefaultFade
	font_size=48;pixel_size=.006;billboard=BaseMaterial3D.BILLBOARD_ENABLED;outline_size=5
	advance_visual(0)
func advance_visual(dt:float) -> void:
	if not is_finite(dt) or dt<0:return
	age=minf(duration,age+dt)
	var progress:float=clampf(age/duration,0,1);var alpha:float=fade.sample(progress)
	position=origin+Vector3(0,height+progress*.24,0)
	modulate=Color(tint.r,tint.g,tint.b,tint.a*alpha)
	outline_modulate=Color(outline.r,outline.g,outline.b,outline.a*alpha)
