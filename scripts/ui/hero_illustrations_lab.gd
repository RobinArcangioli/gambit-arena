extends "res://scripts/app/app_root.gd"
## Presentation fixture: no player saves, independently frozen cast/buff snapshots.
var toolbar:HBoxContainer
func _ready() -> void:
 save_path="";combat_settings_path="";super._ready()
 toolbar=HBoxContainer.new();toolbar.z_index=50;toolbar.position=Vector2(160,16);add_child(toolbar)
 for tab in ["Équipe","Combat"]:
  var button:=Button.new();button.text=tab;button.custom_minimum_size=Vector2(110,44);toolbar.add_child(button)
  button.pressed.connect(show_preview.bind(tab))
 call_deferred("show_preview","Équipe")
func show_preview(tab:String) -> void:
 if guard.blocked or transitioning:return
 if route!=&"home":return_home();await get_tree().process_frame;await get_tree().process_frame
 if guard.blocked:return
 if tab=="Équipe":
  open_team();await get_tree().process_frame;await get_tree().process_frame
  if is_instance_valid(team_page):team_page.title.hide()
 else:
  open_arena();await get_tree().process_frame;await get_tree().process_frame
  if not is_instance_valid(combat):return
  combat.set_process(false);combat.set_physics_process(false)
  var mako=combat.simulation.hero(&"mako");var anne=combat.simulation.hero(&"anne")
  combat.simulation.rules={"mako":[],"anne":[]}
  for unit in combat.simulation.heroes:unit.buffs.apply(preload("res://scripts/buffs/buff_catalog.gd").definition(&"booster"))
  mako.state.damage(55);anne.state.damage(38);mako.action.mana=42;anne.action.mana=38
  mako.action.request(&"lightning",anne);mako.action.elapsed=.5
  anne.action.request(&"heal",anne);anne.action.elapsed=.4
  combat._physics_process(0);combat._present()
 print("HERO_ILLUSTRATIONS_PREVIEW "+tab)
