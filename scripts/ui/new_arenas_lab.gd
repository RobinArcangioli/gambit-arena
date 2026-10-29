extends "res://scripts/app/app_root.gd"
## Local calibration fixture, no player order/settings files .
const Overlay=preload("res://scripts/ui/arena_calibration_overlay.gd")
const Arenas=preload("res://scripts/presentation/arena_catalog.gd")
var caption:Label
var grid:Node2D
var selected_id:StringName=&"ville_alexandrie"
func _ready() -> void:
	save_path="";combat_settings_path="";super._ready();call_deferred("_preview")
func _preview() -> void:
	open_arena();combat.set_physics_process(false);combat.set_process(false)
	grid=Overlay.new();grid.game=combat;grid.z_index=20;add_child(grid)
	caption=Label.new();caption.position=Vector2(120,86);caption.size=Vector2(combat.safe_rect.size.x-240,24);caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;caption.clip_text=true;caption.add_theme_color_override("font_color",Color("ffd16a"));caption.z_index=30;combat.hud.add_child(caption)
	var width:float=(combat.safe_rect.size.x-152)/3
	for index in range(3):
		var button:=Button.new();button.text=["Précédente","Suivante","Grille"][index];button.position=Vector2(12+index*(width+8),12);button.size=Vector2(width,44);button.clip_text=true;button.z_index=30;combat.hud.add_child(button)
		if index<2:button.pressed.connect(cycle_arena.bind(-1 if index==0 else 1))
		else:button.pressed.connect(toggle_grid)
	select_arena(&"ville_alexandrie")
func select_arena(id:StringName) -> void:
	if not is_instance_valid(combat):return
	caption.text=Arenas.title(id)
	selected_id=id;combat.chosen_arena=id;combat._arena_epoch=0;combat.floor_canvas.set_definition(Arenas.definition(id));combat._sync_projection();combat._physics_process(0)
	print_state()

func cycle_arena(direction:int) -> void:
	var ids:Array[StringName]=Arenas.ids();ids.erase(&"reference")
	select_arena(ids[posmod(ids.find(selected_id)+direction,ids.size())])

func toggle_grid() -> void:
	grid.visible=not grid.visible;print_state()
func print_state() -> void:print("ARENA_CALIBRATION_STATE ",String(selected_id)," ",int(grid.visible))
