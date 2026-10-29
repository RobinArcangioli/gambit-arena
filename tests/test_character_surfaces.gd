extends Node
const View=preload("res://scripts/presentation/character_view.gd")
const Profile=preload("res://scripts/presentation/character_surface_profile.gd")
const App=preload("res://scenes/app/app_root.tscn")
const DEFINITIONS=[
	preload("res://resources/presentation/characters/mako.tres"),
	preload("res://resources/presentation/characters/anne.tres"),
	preload("res://resources/presentation/characters/skeleton.tres"),
	preload("res://resources/presentation/characters/skeleton_variant.tres")
]
var checks:int=0
var failures:int=0
func check(ok:bool,message:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error(message)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func _ready() -> void:
	for definition in DEFINITIONS:
		var first:=View.new();first.definition=definition;add_child(first)
		var second:=View.new();second.definition=definition;add_child(second)
		check(first.valid and second.valid,"both real imported character instances animate")
		check(first.surface_profile==View.SurfaceProfile,"selected contrast preset is shared")
		var original_profile:=Profile.new();original_profile.use_imported_materials=true
		for mesh_index in range(first._meshes.size()):
			var mesh=first._meshes[mesh_index]
			for surface in range(mesh.mesh.get_surface_count()):
				var source:BaseMaterial3D=mesh.mesh.surface_get_material(surface)
				var paint:BaseMaterial3D=mesh.get_active_material(surface)
				check(paint!=source and paint!=second._meshes[mesh_index].get_active_material(surface),"private appearance cannot alter other instances")
				check(paint.albedo_texture==source.albedo_texture and paint.albedo_color==source.albedo_color,"source art and base colors preserved")
				check(is_equal_approx(source.metallic,.4) and is_equal_approx(source.roughness,.2721655),"imported material remains untouched")
				check(is_equal_approx(paint.roughness,.95) and is_equal_approx(paint.metallic,0) and is_equal_approx(paint.metallic_specular,.05),"selected matte properties apply on every surface")
		var elapsed:float=first.sample_time
		first.apply_surface_profile(original_profile)
		check(first.sample_time==elapsed,"switching appearance does not advance animation")
		for mesh in first._meshes:
			for surface in range(mesh.mesh.get_surface_count()):check(mesh.get_active_material(surface)==mesh.mesh.surface_get_material(surface),"original is exactly recoverable")
		first.apply_surface_profile(View.SurfaceProfile)
		first.sync_action(true,&"basic",1,.3,.6,.4)
		first.apply_surface_profile(View.SurfaceProfile)
		check(first.attack_active and first.action_active and is_equal_approx(first.attack_elapsed,.3),"appearance does not change active attack timing")
		remove_child(first);add_child(first)
		check(first._meshes.all(func(mesh):return is_equal_approx(mesh.get_active_material(0).roughness,.95)),"death reparenting keeps selected material")
		first.queue_free();second.queue_free();await settle()
	var app=App.instantiate();app.save_path="";app.combat_settings_path="";add_child(app);await settle()
	app.open_team();await settle()
	for portrait in app.team_page.portraits:
		check(portrait.character.surface_profile==View.SurfaceProfile,"team idle shares selected profile")
		check_lights(portrait.character.get_parent())
	app.return_home();await settle();app.open_arena();await settle()
	app.combat.set_process(false);app.combat.set_physics_process(false)
	check_lights(app.combat.world)
	app.combat.simulation.add_enemy(Vector2.ZERO)
	for view in app.combat.world.find_children("*","Node3D",true,false):
		if view is View:check(view.surface_profile==View.SurfaceProfile,"every combat actor including new spawns inherits contrast profile")
	app.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no orphan material preview actors")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
func check_lights(world:Node) -> void:
	var found:int=0
	for child in world.get_children():
		if child is WorldEnvironment:
			check(child.environment.ambient_light_color==View.SurfaceProfile.ambient_color and is_equal_approx(child.environment.ambient_light_energy,.32),"selected cool ambient light in each context");found+=1
		elif child is DirectionalLight3D:
			check(child.light_color==View.SurfaceProfile.light_color and is_equal_approx(child.light_energy,1.05),"selected warm key light in each context");found+=1
	check(found==2,"ambient and key light both present")
