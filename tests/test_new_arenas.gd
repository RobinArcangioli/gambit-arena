extends Node
const App=preload("res://scenes/app/app_root.tscn")
const Bounds=preload("res://scripts/arena/arena_bounds.gd")
const Catalog=preload("res://scripts/presentation/arena_catalog.gd")
var checks:int=0
var failures:int=0
func check(ok:bool,message:String) -> void:
	checks+=1
	if not ok:failures+=1;push_error("NewArenas: "+message)
func settle() -> void:await get_tree().process_frame;await get_tree().process_frame
func snapshot(game:Node) -> Array:
	var values:Array=[game.simulation.run_id,game.simulation.clock.elapsed,game.simulation.wave_number]
	for unit in game.simulation.all_units():values.append([unit.combat_id,unit.position,unit.state.health,unit.action.mana,unit.action.spent,unit.buffs.snapshot()])
	return values
func _ready() -> void:
	var supplied:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/art/arenas/supplied_additions.json"))
	check(Catalog.ids().size()==11,"ten playable arenas and one diagnostic reference")
	for record in supplied.assets:
		check(FileAccess.get_sha256("res://"+record.asset)==record.sha256,"provided PNG byte identity "+record.id)
		check(Catalog.preview(StringName(record.id)).get_size()==Vector2(108,192),"lightweight catalogue preview "+record.id)
	var calibration:Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://assets/art/arenas/calibration/arena_calibration.json"))
	for resolution in [Vector2i(540,960),Vector2i(540,1170),Vector2i(360,640)]:
		var viewport:=SubViewport.new();viewport.size=resolution;add_child(viewport)
		var app=App.instantiate();app.save_path="";app.combat_settings_path="";viewport.add_child(app);await settle();app.open_arena();await settle()
		var game=app.combat;game.set_physics_process(false);game.set_process(false)
		var state:Array=snapshot(game)
		var canonical:=PackedVector2Array()
		for record in calibration.assets:
			var id:StringName=StringName(record.id);game.chosen_arena=id;game._arena_epoch=0;game.floor_canvas.set_definition(Catalog.definition(id));game._sync_projection();await settle()
			var view=game.floor_canvas.active_view
			var center:=Vector2(record.image_center[0],record.image_center[1])
			check(view.ground_to_image(Vector2.ZERO).is_equal_approx(center),"logical origin on supplied floor center "+record.id)
			check(view.background.get_size()==Vector2(540,960) and is_equal_approx(view.image_rect.size.x/view.image_rect.size.y,540.0/960.0),"uniform image projection without deformation "+record.id)
			check(not view.show_calibration,"no grid visible in ordinary combat "+record.id)
			var polygon:=PackedVector2Array()
			for point in record.floor_polygon_px:polygon.append(Vector2(point[0],point[1]))
			var inside:bool=true
			for i in range(9):
				for j in range(9):
					var point:=Vector2(-Bounds.HALF_EXTENT+i*Bounds.HALF_EXTENT*.25,-Bounds.HALF_EXTENT+j*Bounds.HALF_EXTENT*.25)
					if not Bounds.contains_ground(point,0):continue
					inside=inside and view.inside_calibration(point) and Geometry2D.is_point_in_polygon(view.ground_to_image(point),polygon)
			check(inside,"all 81 logical grid vertices lie on clear floor "+record.id)
			var half_x:float=record.logical_grid_half_extents_px[0];var half_y:float=record.logical_grid_half_extents_px[1]
			check(view.ground_to_image(Vector2(3,-3)).distance_to(center+Vector2(half_x,0))<.01 and view.ground_to_image(Vector2(-3,-3)).distance_to(center-Vector2(0,half_y))<.01,"SVG calibration matches real projected grid "+record.id)
			var projected:=PackedVector2Array()
			for point in Bounds.polygon():projected.append(game.render_box.position+game.camera.unproject_position(Vector3(point.x,0,point.y)))
			if canonical.is_empty():canonical=projected
			var same:bool=true
			for index in range(8):same=same and projected[index].distance_to(canonical[index])<.01
			check(same,"identical octagon screen position size and shape on every background "+record.id)
			check(snapshot(game)==state,"visual selection cannot mutate combat state "+record.id)
		viewport.queue_free();await settle()
	check(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==0,"no retained arena views or actors")
	var label:=Label.new();label.text="%d controles, %d echecs"%[checks,failures];add_child(label);print(label.text)
