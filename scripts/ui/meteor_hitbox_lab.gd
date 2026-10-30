extends "res://scripts/app/arena_page.gd"
## Isolated boundary regression: identical product logic and art, visible physical disks.
const Zone=preload("res://scripts/presentation/area_zone.gd")
const GroundBody=preload("res://scripts/crowd/ground_crowd.gd")
var scenario:int=0
var changed:bool=false
var info:Label
var disks:Array[Node3D]=[]
func _ready() -> void:
	save_path="";settings_path="";infinite_mode=true
	chooser=func():return &"colisee_solaire"
	super._ready()
	get_window().title="Gambit Arena · Météore · Chevauchement des disques"
	var row:=HBoxContainer.new();row.position=Vector2(16,16);row.z_index=40;add_child(row)
	for i in range(3):
		var button:=Button.new();button.text=["Bords fixes","Entre / sort","Contact exact"][i]
		button.add_theme_font_size_override("font_size",12);button.custom_minimum_size=Vector2(119,44)
		row.add_child(button);button.pressed.connect(select_scenario.bind(i))
	info=Label.new();info.position=Vector2(124,76);info.size=Vector2(325,72)
	info.add_theme_font_size_override("font_size",12);info.add_theme_color_override("font_color",Color("ffd16a"))
	info.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(info)
	select_scenario(0)
func select_scenario(value:int) -> void:
	if application_guard.blocked:return
	for disk in disks:
		if is_instance_valid(disk):disk.queue_free()
	disks.clear();scenario=value;changed=false
	_reset();paused=false;simulation.clock.paused=false;application_guard.acknowledge_resume();pause_layer.hide()
	simulation.rules={"anne":[],"mako":[],"nassau":[]}
	simulation.hero(&"anne").place(Vector2(-2.7,-.8))
	simulation.hero(&"mako").place(Vector2(-3.2,1));simulation.hero(&"nassau").place(Vector2(-3.1,2))
	var positions:Array=[Vector2(1.6,0),Vector2(-1.6,0),Vector2(0,-1.75),Vector2(0,1.9),Vector2(2.8,-1.5),Vector2(2.6,1.9)]
	if scenario==2:positions=[Vector2(1.75,0),Vector2(2.8,-1.7),Vector2(2.8,-.5),Vector2(2.8,.7),Vector2(1.8,2.6),Vector2(-.5,2.7)]
	for i in range(simulation.enemies.size()):
		var unit=simulation.enemies[i];unit.place(positions[i]);unit.mover.speed=0
		var disk:=Zone.new();unit.add_child(disk);disk.set_radius(GroundBody.RADIUS);disk.position.y=.045;disks.append(disk)
	simulation.hero(&"anne").action.request_ground(&"meteor",Vector2.ZERO)
	_present();_show_result()
func _physics_process(delta:float) -> void:
	super._physics_process(delta)
	var anne=simulation.hero(&"anne")
	if scenario==1 and not changed and anne.action.last_skill==&"meteor" and anne.action.casting() and anne.action.elapsed>=1:
		simulation.enemies[0].place(Vector2(2.1,0));simulation.enemies[3].place(Vector2(0,1.6));changed=true
	_show_result()
func _show_result() -> void:
	if info==null:return
	var count:int=0
	for unit in simulation.enemies:
		if unit.state.health<unit.state.max_health:count+=1
	info.text="AOE 1,4 · disques ennemis 0,35\n%s\n%d ennemi(s) touché(s)"%[["Attendu : 3 touchés, les autres hors zone","Un ennemi sort, un autre entre","Attendu : contact à 1,75 touché"][scenario],count]
