extends "res://scripts/app/app_root.gd"
## Real local preview, no player order/settings files.
func _ready() -> void:
	save_path="";combat_settings_path="";super._ready();call_deferred("_preview")
func _preview() -> void:
	open_arena();combat.simulation.hero(&"anne").state.damage(45)
