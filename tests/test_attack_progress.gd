extends Node
const App=preload("res://scenes/app/app_root.tscn")
const Buffs=preload("res://scripts/buffs/buff_catalog.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,message:String) -> void:
 checks+=1
 if not ok:failures+=1;push_error(message)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
 for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
  var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
  var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle();app.open_arena();await settle()
  var game=app.combat;game.set_process(false);game.set_physics_process(false)
  game.simulation.rules={"mako":[],"anne":[]}
  var actor=game.simulation.hero(&"mako");var target=game.simulation.enemies[0];var panel=game.hero_panels[0]
  actor.action.cancel();actor.buffs.clear();target.place(actor.mover.ground_position+Vector2(.8,0))
  check(actor.action.request(&"basic",target)>0,"real normal attack starts")
  game._present();await settle();var world=game.overhead[actor.combat_id]
  check(panel.bars.attacking and world.attacking and not panel.bars.casting,"both locations show normal attack in cast row")
  check(panel.bars.attack_marker.visible and world.attack_marker.visible and not panel.cast_icon.visible,"sword replaces spell icon for basic attack")
  check(is_equal_approx(panel.bars.attack_split,.6) and is_equal_approx(world.attack_split,.6),"sword marks real 0.6/1.0 impact boundary")
  var marker:Vector2=panel.bars.attack_marker.position
  actor.action.advance(.3,false,.3);game._present()
  check(is_equal_approx(panel.bars.attack_ratio,.3) and is_equal_approx(world.attack_ratio,.3) and not actor.action.resolved,"preparation advances from real personal action time")
  check(panel.bars.attack_marker.position==marker,"sword stays fixed while progress fills")
  var before:Array=[actor.action.elapsed,actor.action.spent,target.state.health,actor.buffs.snapshot()]
  for i in range(20):game._present()
  check(before==[actor.action.elapsed,actor.action.spent,target.state.health,actor.buffs.snapshot()],"refresh does not advance or resolve gameplay")
  actor.action.advance(.3,false,.3);game._present()
  check(actor.action.resolved and actor.action.phase=="RECUPERATION" and is_equal_approx(panel.bars.attack_ratio,.6),"exact impact occurs at sword boundary")
  actor.action.advance(.2,false,.2);game._present()
  check(panel.bars.attacking and is_equal_approx(panel.bars.attack_ratio,.8) and panel.cast_text.text.begins_with("Récup."),"recovery advances in silver portion")
  check(panel.get_global_rect().encloses(panel.bars.attack_marker.get_global_rect()),"panel sword stays inside at each resolution")
  game._change_settings(false,true);game._present()
  check(not world.is_visible_in_tree() and panel.bars.attack_marker.is_visible_in_tree(),"hero overhead preference hides sword but preserves panel")
  game._change_settings(true,true)
  actor.action.advance(.2,false,.2);game._present()
  check(not panel.bars.attacking and not world.attacking and not panel.bars.attack_marker.visible and not panel.cast_text.visible,"completed attack hides progress row and sword")
  target.state.heal(target.state.max_health);actor.action.request(&"basic",target);target.state.damage(10000);game._present()
  check(not panel.bars.attacking and not panel.bars.attack_marker.visible,"target death during preparation cancels row immediately")
  target=game.simulation.enemies[1];target.place(actor.mover.ground_position+Vector2(.8,0));target.state.damage(target.state.health-1)
  actor.action.request(&"basic",target);actor.action.advance(.6,false,.6);game._present()
  check(not target.state.alive and panel.bars.attacking and actor.action.resolved,"lethal impact retains recovery until action ends")
  actor.action.advance(.4,false,.4);actor.buffs.apply(Buffs.definition(&"booster"))
  target=game.simulation.enemies[2];target.place(actor.mover.ground_position+Vector2(.8,0));actor.action.request(&"basic",target)
  actor.action.advance(.1);game._present()
  check(is_equal_approx(panel.bars.attack_ratio,.13),"Booster accelerates preparation progress by 30 percent")
  var elapsed:float=actor.action.elapsed;actor.action.advance(4,true);game._present()
  check(actor.action.elapsed==elapsed and is_equal_approx(panel.bars.attack_ratio,.13),"pause freezes progress")
  actor.action.cancel();actor.buffs.clear();actor.action.request(&"lightning",target);game._present()
  check(panel.bars.casting and not panel.bars.attacking and not panel.bars.attack_marker.visible and panel.cast_icon.visible,"spell cast keeps original gold bar and skill icon")
  var enemy=game.simulation.enemies[3];enemy.place(actor.mover.ground_position+Vector2(.8,0));enemy.action.cancel();enemy.action.request(&"basic",actor);game._present()
  var enemy_bar=game.overhead[enemy.combat_id]
  check(enemy_bar.attacking and not enemy_bar.mana_visible and enemy_bar.attack_marker.visible,"mana-free enemy receives same attack bar")
  game._change_settings(true,false);game._present();check(not enemy_bar.is_visible_in_tree(),"enemy overhead preference also hides attack bar")
  actor.state.damage(10000);game._present();check(not panel.bars.attacking and not panel.bars.casting,"death removes action progress")
  viewport.queue_free();await settle()
 check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan sword widgets")
 var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
