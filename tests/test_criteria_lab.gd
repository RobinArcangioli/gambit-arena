extends Node
const Criteria = preload("res://scripts/gambits/target_criteria.gd")
const App = preload("res://scenes/app/app_root.tscn")
var checks: int = 0
var failures: int = 0
func check(ok: bool, message: String) -> void:
 checks+=1
 if not ok:failures+=1;push_error("CriteriaLabTouch: "+message)
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
 var path: String="user://gambits001-touch-lab.json"
 if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
 var viewport:=SubViewport.new();viewport.size=Vector2i(540,960);add_child(viewport)
 var lab=load("res://scenes/debug/gambits_criteria_lab.tscn").instantiate();lab.lab_path=path;viewport.add_child(lab);await settle();viewport.notify_mouse_entered()
 check(not FileAccess.file_exists(path),"opening lab never writes a configuration")
 tap(viewport,lab.criterion_picker.get_global_rect().get_center());await settle()
 check(lab.criterion_picker.get_popup().visible,"raw touch plus emulated mouse opens criteria popup")
 lab.criterion_picker.get_popup().hide();lab._criterion_changed(Criteria.IDS.find(&"ally_hp_lt_30"));await settle()
 check(lab.store.configuration.mako[0].criterion=="ally_hp_lt_30" and lab.result_label.text.contains("Anne"),"criteria callback chooses ally for lightning")
 check(FileAccess.file_exists(path),"choice immediately writes only isolated lab path")
 tap(viewport,lab.skill_picker.get_global_rect().get_center());await settle()
 check(lab.skill_picker.get_popup().visible,"capability popup opens through touch router")
 lab.skill_picker.get_popup().hide();lab._hero_changed(1);lab._criterion_changed(Criteria.IDS.find(&"enemy_far"));lab._skill_changed(1);await settle()
 check(lab.result_label.text.contains("Ennemi 120 PV") and lab.result_label.text.contains("Soin"),"enemy heal has independent criterion and capability")
 lab.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);check(not lab.active and lab.criterion_picker.disabled,"background blocks lab editing")
 var before: Dictionary=lab.store.configuration.duplicate(true);lab._criterion_changed(Criteria.IDS.find(&"self"))
 check(lab.store.configuration==before,"background callback cannot write")
 lab.notification(NOTIFICATION_APPLICATION_FOCUS_IN);check(lab.active and not lab.criterion_picker.disabled,"focus resumes laboratory")
 viewport.queue_free();await settle();DirAccess.remove_absolute(path)
 check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan laboratory popup or controls")
 var summary: String="%s : %d controles, %d echecs"%["OK" if failures==0 else "ECHEC",checks,failures]
 print(summary);var label:=Label.new();label.text=summary;add_child(label)
