extends Node
const App = preload("res://scenes/app/app_root.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
 checks+=1
 if not ok:failures+=1;push_error("HeroLayout: "+message)
func settle() -> void:
 await get_tree().process_frame;await get_tree().process_frame
func touch(viewport: Viewport, at: Vector2, pressed: bool) -> void:
 var finger:=InputEventScreenTouch.new();finger.position=at;finger.index=0;finger.pressed=pressed;viewport.push_input(finger,true)
 var mouse:=InputEventMouseButton.new();mouse.device=-1;mouse.position=at;mouse.global_position=at;mouse.button_index=MOUSE_BUTTON_LEFT;mouse.pressed=pressed;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT if pressed else 0;viewport.push_input(mouse,true)
func tap(viewport: Viewport, at: Vector2) -> void:
 touch(viewport,at,true);touch(viewport,at,false)
func drag(viewport: Viewport, at: Vector2) -> void:
 var finger:=InputEventScreenDrag.new();finger.position=at;finger.index=0;viewport.push_input(finger,true)
 var mouse:=InputEventMouseMotion.new();mouse.device=-1;mouse.position=at;mouse.global_position=at;mouse.button_mask=MOUSE_BUTTON_MASK_LEFT;viewport.push_input(mouse,true)
func _ready() -> void:
 for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
  var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
  var app=App.instantiate();app.save_path="";viewport.add_child(app);await settle();viewport.notify_mouse_entered()
  tap(viewport,app.team_button.get_global_rect().get_center());await settle()
  for index in range(2):
   tap(viewport,app.team_page.portraits[index].get_global_rect().get_center());await settle()
   var page=app.hero_page
   check(page!=null and app.route==&"hero" and page.hero_id==(&"mako" if index==0 else &"anne"),"actual portrait tap opens correct sheet once")
   page.safe_area_override=Rect2(8,24,resolution.x-16,resolution.y-44);page._layout();await settle()
   var view:=Rect2(Vector2.ZERO,Vector2(resolution));var safe: Rect2=page.safe_area_override
   check(page.background.get_rect()==view and safe.encloses(page.back_button.get_global_rect()),"full provided background and safe return")
   check(safe.encloses(page.scroll.get_global_rect()) and not page.scroll.get_global_rect().intersects(page.back_button.get_global_rect()),"scroll never covers return or safe edges")
   check(page.column.size.x<=page.scroll.size.x and page.scroll.get_h_scroll_bar().max_value<=page.scroll.size.x+1,"no horizontal content overflow")
   var start: Vector2=page.scroll.get_global_rect().get_center()+Vector2(0,100)
   touch(viewport,start,true);drag(viewport,start-Vector2(0,160));touch(viewport,start-Vector2(0,160),false);await settle()
   check(page.column.size.y<=page.scroll.size.y or page.scroll.scroll_vertical>0,"raw finger scrolls overflow, tall screen may fit full sheet")
   var bar: VScrollBar=page.scroll.get_v_scroll_bar();page.scroll.scroll_vertical=roundi(bar.max_value-bar.page);await settle()
   check(page.scroll.get_global_rect().encloses(page.gambits_button.get_global_rect()),"Gambits stays reachable at bottom even on small screen")
   tap(viewport,page.gambits_button.get_global_rect().get_center());await settle()
   check(app.route==&"hero" and page.gambits_button.disabled,"future Gambits cannot open wrong route")
   page.scroll.scroll_vertical=0;await settle()
   touch(viewport,start,true)
   app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);app.notification(NOTIFICATION_APPLICATION_PAUSED)
   app.notification(NOTIFICATION_APPLICATION_RESUMED);app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
   touch(viewport,page.back_button.get_global_rect().get_center(),false);await settle()
   check(app.route==&"hero","stale touch after resume cannot leave sheet")
   tap(viewport,page.back_button.get_global_rect().get_center());await settle()
   check(app.route==&"team" and app.hero_page==null and app.team_page.active,"fresh finger returns to selected team")
  viewport.queue_free();await settle()
 check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"all routes release their nodes")
 var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
 print(summary);var label:=Label.new();label.text=summary;add_child(label)
