extends "res://scripts/app/arena_page.gd"
## Functional AOE harness using the product's optional ground indicator, without final Meteor art.
var scenario:int=0
var laboratory_time:float=0
var changed:bool=false
var info:Label
func _ready() -> void:
	save_path="";settings_path="";infinite_mode=true;super._ready()
	get_window().title="Gambit Arena · AOE-001 · Météore / cible au sol"
	var row:=HBoxContainer.new();row.position=Vector2(16,16);row.z_index=40;add_child(row)
	for i in range(3):
		var button:=Button.new();button.text=["Groupe stable","Soin prioritaire","Zone vidée"][i]
		button.add_theme_font_size_override("font_size",12);button.custom_minimum_size=Vector2(119,44)
		row.add_child(button);button.pressed.connect(select_scenario.bind(i))
	info=Label.new();info.position=Vector2(124,76);info.size=Vector2(325,65)
	info.add_theme_font_size_override("font_size",12);info.add_theme_color_override("font_color",Color("ffd16a"))
	info.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(info)
	select_scenario(0)
func select_scenario(value:int) -> void:
	if application_guard.blocked:return
	scenario=value;laboratory_time=0;changed=false
	_reset();paused=false;simulation.clock.paused=false;application_guard.acknowledge_resume();pause_layer.hide()
	simulation.rules={"anne":[{"enabled":true,"criterion":"ally_hp_lt_50","skill":"heal"},{"enabled":true,"criterion":"enemy_group_3","skill":"meteor"},Orders.create()],"mako":[],"nassau":[]}
	simulation.hero(&"anne").place(Vector2(-3.4,0))
	simulation.hero(&"mako").place(Vector2(-2,-1));simulation.hero(&"nassau").place(Vector2(-2,1))
	var positions:Array=[Vector2(2.2,-.9),Vector2(2.2,0),Vector2(2.2,.9),Vector2(-3,-2),Vector2(-2,-3),Vector2(-3,2)]
	for i in range(simulation.enemies.size()):
		var enemy_unit=simulation.enemies[i];enemy_unit.place(positions[i]);enemy_unit.mover.speed=0
		enemy_unit.state.max_health=200;enemy_unit.state.health=200;enemy_unit.state.defense=9999
	_present();_show_target()
func _physics_process(delta:float) -> void:
	var before:float=simulation.clock.elapsed
	super._physics_process(delta)
	laboratory_time+=maxf(0,simulation.clock.elapsed-before)
	var anne=simulation.hero(&"anne")
	if not changed and scenario==1 and laboratory_time>=.6:
		simulation.hero(&"mako").state.damage(130);changed=true
	if not changed and scenario==2 and anne.action.casting() and anne.action.last_skill==&"meteor" and anne.action.elapsed>=1:
		for i in range(3):simulation.enemies[i].place(Vector2(-.8+i*.8,-3))
		changed=true
	_show_target()
func _show_target() -> void:
	if info==null:return
	var anne=simulation.hero(&"anne");var active:bool=anne.action.casting() and anne.action.last_skill==&"meteor"
	info.text="AOE-001 · Soin prioritaire → Groupe ≥ 3 / Météore\n%s · PM %d · recharge %.1f s"%["Centre verrouillé" if active else "Approche réévaluée" if anne.ground_intention else "Évaluation des gambits",floori(anne.action.mana),anne.action.remaining(&"meteor")]
