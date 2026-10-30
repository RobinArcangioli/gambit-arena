extends Node
const App=preload("res://scenes/app/app_root.tscn")
const Illustration=preload("res://scripts/presentation/hero_illustration.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,message:String) -> void:
 checks+=1
 if not ok:failures+=1;push_error(message)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
 var metadata:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/art/portraits/illustrations/provenance.json"))
 for record in metadata.assets:check(FileAccess.get_sha256("res://"+record.asset)==record.sha256,"supplied artwork is byte-identical")
 for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
  var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
  var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle()
  app.open_team();await settle();var page=app.team_page
  check(page.illustrations.size()==3 and page.portraits.size()==3,"two artworks and exactly two idle models")
  for i in range(2):
   var artwork:Rect2=page.illustrations[i].get_global_rect();var idle:Rect2=page.idle_frames[i].get_global_rect()
   check(artwork.intersects(idle) and idle.end.x>artwork.end.x and idle.end.y>artwork.end.y,"idle frame overlaps and extends beyond both image edges")
   check(page.cards[i].get_global_rect().encloses(idle),"displaced frame stays within reserved team slot")
   var slot:Vector2=page.cards[i].size
   var initial:Vector2=Vector2(clampf(slot.x*.4,64,96),clampf(slot.y*.36,88,132))-Vector2.ONE*6
   check(page.portraits[i].size.is_equal_approx(initial) and idle.size.x<initial.x and idle.size.y<initial.y,"smaller frame crops the original viewport without scaling the model")
   check(page.illustrations[i].mouse_filter==Control.MOUSE_FILTER_IGNORE and page.portraits[i].mouse_filter==Control.MOUSE_FILTER_IGNORE,"art and model leave the card clickable")
   var id:StringName=page.illustrations[i].hero_id
   for area in [page.illustrations[i].size,Vector2(42,76)]:
    var focus:Vector2=Illustration.COMBAT_FOCAL_POINTS[id] if area==Vector2(42,76) else Illustration.FOCAL_POINTS[id]
    var zoom:float=Illustration.COMBAT_ZOOM[id] if area==Vector2(42,76) else 1.0
    var crop:Rect2=Illustration.crop_rect(Vector2(941,1672),area,focus,zoom)
    check(Rect2(Vector2.ZERO,Vector2(941,1672)).encloses(crop) and crop.has_point(focus*Vector2(941,1672)),"crop preserves focus and stays within original image")
    check(is_equal_approx(crop.size.x/crop.size.y,area.x/area.y),"art fills area without distortion")
  app.return_home();await settle();app.open_arena();await settle();var game=app.combat
  game.set_process(false);game.set_physics_process(false)
  var height:float=game.hero_panels[0].size.y
  check(game.hero_panels.all(func(p):return is_equal_approx(p.size.y,height)),"all four combat panels retain identical height")
  for i in range(2):
   var panel=game.hero_panels[i]
   check(panel.portrait.close_up and panel.portrait.size==Vector2(42,76),"battle portrait uses a fixed close-up gutter")
   check(panel.get_global_rect().encloses(panel.portrait.get_global_rect()),"portrait fits combat panel")
   check(panel.buff_tray.position.y>panel.bars.position.y+2*(panel.bars.bar_height+panel.bars.bar_gap)+panel.bars.bar_height,"buff row is below all three bars")
  check(game.hero_panels[3].portrait==null,"empty slots have no artwork or 3D viewport")
  viewport.queue_free();await settle()
 check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan portrait worlds")
 var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
