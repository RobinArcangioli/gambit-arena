extends "res://scripts/presentation/character_lab.gd"
## Reuses arena, model and orientation controls, without combat or saved rules.
func _ready() -> void:
	super._ready()
	$HUD/Title.text = "GRAPHICS-008 / OMBRES AU SOL"
	$HUD/SlotsTitle.text = "Empreinte logique : diametre 0.70 / rayon 0.35"
