extends "res://scripts/app/app_root.gd"
## Isolated preview: real combat, no player preferences or order files read/written.
func _ready() -> void:
	save_path="";combat_settings_path=""
	super._ready()
	call_deferred("_preview")
func _preview() -> void:
	open_arena()
	combat.simulation.hero(&"anne").state.damage(80)
	for tick in range(300):combat._physics_process(1.0/60.0)
	combat._open_statistics()
