extends Control
## Replaceable UI-only artwork and focal crops; never owns an actor or animation clock.
const TEXTURES = {
 &"anne":preload("res://assets/art/portraits/illustrations/anne.png"),
 &"mako":preload("res://assets/art/portraits/illustrations/mako.png")}
const FOCAL_POINTS = {&"anne":Vector2(.50,.18), &"mako":Vector2(.49,.50)}
const COMBAT_FOCAL_POINTS = {&"anne":Vector2(.50,.18), &"mako":Vector2(.49,.40)}
const COMBAT_ZOOM = {&"anne":2.5, &"mako":2.6}
var hero_id:StringName
var close_up:bool=false
var source_rect:=Rect2()
func _ready() -> void:
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
 resized.connect(queue_redraw)
func _draw() -> void:
 var texture:Texture2D=TEXTURES.get(hero_id)
 if texture==null or size.x<=2 or size.y<=2:return
 var destination:=Rect2(Vector2.ONE,size-Vector2.ONE*2)
 var zoom:float=COMBAT_ZOOM[hero_id] if close_up else 1.0
 var focus:Vector2=COMBAT_FOCAL_POINTS[hero_id] if close_up else FOCAL_POINTS[hero_id]
 source_rect=crop_rect(texture.get_size(),destination.size,focus,zoom)
 draw_texture_rect_region(texture,destination,source_rect)
 draw_rect(Rect2(Vector2.ZERO,size),Color("a68349"),false,1.0)
static func crop_rect(image_size:Vector2,area:Vector2,focus:Vector2,zoom:float=1.0) -> Rect2:
 var scale:float=maxf(area.x/image_size.x,area.y/image_size.y)*maxf(1.0,zoom)
 var extent:Vector2=area/scale
 var origin:Vector2=focus*image_size-extent*.5
 origin=origin.clamp(Vector2.ZERO,image_size-extent)
 return Rect2(origin,extent)
