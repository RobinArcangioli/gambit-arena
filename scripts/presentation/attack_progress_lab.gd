extends "res://scripts/app/arena_page.gd"
## Frozen examples of the real action timeline; no player saves or independent UI clock.
var controls:HBoxContainer
func _ready() -> void:
 infinite_mode=true;save_path="";settings_path="";theme=preload("res://resources/ui/night_gold.tres");super._ready()
 set_process(false);set_physics_process(false)
 controls=HBoxContainer.new();controls.position=Vector2(12,12);add_child(controls)
 for item in ["Préparation","Coup","Récupération","Sort"]:
  var button:=Button.new();button.text={"Préparation":"Prépa.","Coup":"Coup","Récupération":"Récup.","Sort":"Sort"}[item];button.tooltip_text=item;button.add_theme_font_size_override("font_size",14);button.custom_minimum_size=Vector2(94,44);controls.add_child(button);button.pressed.connect(snapshot.bind(item))
 snapshot("Préparation")
func snapshot(stage:String) -> void:
 if application_guard.blocked:return
 # A preview is a frozen combat sample, never a pause-menu sample.  Some desktop
 # window managers emit a focus notification while the off-screen snapshot starts.
 paused=false;simulation.clock.paused=false;pause_layer.hide()
 simulation.reset();simulation.rules={"mako":[],"anne":[]};action_presenter.reset_run(simulation.run_id)
 for key in [&"mako",&"anne"]:
  var unit=simulation.hero(key);unit.state.damage(30);unit.action.mana=40
  var foe=simulation.enemies[0 if key==&"mako" else 1]
  foe.place(unit.mover.ground_position+Vector2(.8,0))
  if stage=="Sort":unit.action.request(&"heal" if key==&"anne" else &"lightning",unit if key==&"anne" else foe);unit.action.elapsed=.7
  else:
   unit.action.request(&"basic",foe)
   if stage=="Coup":unit.action.advance(.6,false,.6)
   elif stage=="Récupération":unit.action.advance(.8,false,.8)
   else:unit.action.advance(.3,false,.3)
  foe.action.request(&"basic",unit);foe.action.advance(.8 if key==&"mako" else .3,false,.8 if key==&"mako" else .3)
 paused=false;simulation.clock.paused=false;pause_layer.hide()
 super._physics_process(0);_present()
 print("ATTACK_PROGRESS_PREVIEW "+stage)
