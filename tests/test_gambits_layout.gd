extends Node
const App = preload("res://scenes/app/app_root.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
 checks+=1
 if not ok:failures+=1;push_error("GambitsLayout: "+message)
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
  var path: String="user://gambits002-layout-%d.json" % resolution.y
  var config: Dictionary=preload("res://scripts/gambits/orders.gd").defaults()
  config.anne=[];config.mako=[]
  for i in range(100):
   config.anne.append(preload("res://scripts/gambits/orders.gd").create())
   config.mako.append(preload("res://scripts/gambits/orders.gd").create())
  preload("res://scripts/gambits/configuration_codec.gd").save(path,config)
  var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
  var app=App.instantiate();app.save_path=path;viewport.add_child(app);await settle();viewport.notify_mouse_entered()
  tap(viewport,app.team_button.get_global_rect().get_center());await settle()
  for index in range(2):
   tap(viewport,app.team_page.portraits[index].get_global_rect().get_center());await settle()
   var sheet=app.hero_page;sheet.scroll.scroll_vertical=10000;await settle()
   tap(viewport,sheet.gambits_button.get_global_rect().get_center());await settle()
   var page=app.gambits_page;var editor=page.editor
   check(app.route==&"gambits" and page.hero_id==sheet.hero_id,"real touch opens correct editor once")
   page.safe_area_override=Rect2(8,24,resolution.x-16,resolution.y-44);page._layout();await settle()
   var view:=Rect2(Vector2.ZERO,Vector2(resolution));var safe: Rect2=page.safe_area_override
   check(page.background.get_rect()==view and safe.encloses(page.back_button.get_global_rect()),"background and back fit safe portrait")
   check(not page.back_button.get_global_rect().intersects(page.scroll.get_global_rect()),"scroll cannot cover Back")
   check(page.column.size.x<=page.scroll.size.x and page.scroll.get_h_scroll_bar().max_value<=page.scroll.size.x+1,"no horizontal overflow on narrow screen")
   tap(viewport,editor.controls[0].enabled.get_global_rect().get_center());await settle()
   check(not editor.rows[0].enabled,"finger toggles once without emulated duplicate")
   tap(viewport,editor.controls[0].criterion.get_global_rect().get_center());await settle()
   check(editor.popup_open(),"real touch opens styled dropdown")
   editor.close_popup()
   var start: Vector2=page.scroll.get_global_rect().get_center()+Vector2(0,80)
   var snapshot: Array=editor.rows.duplicate(true)
   touch(viewport,start,true);drag(viewport,start-Vector2(0,180));touch(viewport,start-Vector2(0,180),false);await settle()
   check(page.scroll.scroll_vertical>0 and editor.rows==snapshot,"swipe scrolls without editing crossed rows")
   var bar: VScrollBar=page.scroll.get_v_scroll_bar();page.scroll.scroll_vertical=roundi(bar.max_value-bar.page);await settle()
   check(page.scroll.get_global_rect().encloses(editor.add_button.get_global_rect()),"bottom add control reachable at 100 rows")
   check(page.scroll.get_global_rect().encloses(editor.controls[99].delete.get_global_rect()),"last order reachable")
   var stored_before: String=FileAccess.get_file_as_string(path)
   touch(viewport,editor.controls[99].delete.get_global_rect().get_center(),true)
   app.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);app.notification(NOTIFICATION_APPLICATION_PAUSED)
   app.notification(NOTIFICATION_APPLICATION_RESUMED);app.notification(NOTIFICATION_APPLICATION_FOCUS_IN)
   touch(viewport,editor.controls[99].delete.get_global_rect().get_center(),false);await settle()
   check(app.route==&"gambits" and FileAccess.get_file_as_string(path)==stored_before,"stale release cannot delete after resume")
   tap(viewport,editor.controls[99].delete.get_global_rect().get_center());await settle()
   check(editor.rows.size()==99 and not editor.add_button.disabled,"fresh tap deletes once and reenables Add")
   tap(viewport,page.back_button.get_global_rect().get_center());await settle()
   check(app.route==&"hero" and app.hero_page==sheet,"Back returns same sheet")
   tap(viewport,sheet.back_button.get_global_rect().get_center());await settle()
   check(app.route==&"team" and app.team_page.cards.all(func(c):return not c.button_pressed and not c.has_focus()),"team has no selected card")
  viewport.queue_free();await settle();DirAccess.remove_absolute(path)
 check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"all editor pages released")
 var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
 print(summary);var label:=Label.new();label.text=summary;add_child(label)
