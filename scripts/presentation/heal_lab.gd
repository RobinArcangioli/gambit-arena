extends "res://scripts/presentation/action_lab.gd"
## Isolated art preview: the +30 shown here is a sample, not a gameplay resolution.
const HealProfile = preload("res://resources/presentation/effects/heal.tres")
var effect: Node3D
var heal_preview: bool = false
var preview_resolved: bool = false

func _ready() -> void:
	super._ready()
	for connection in slots[1].pressed.get_connections(): slots[1].pressed.disconnect(connection.callable)
	slots[1].text = "Soin (demo)"
	slots[1].pressed.connect(_heal_preview)
	$HUD/Title.text = "GRAPHICS-009 / SOIN"
	$HUD/Description.text = "Soin (demo) : Duck puis anneaux +30 / 1 s\nAucune modification des PV / mana"

func _heal_preview() -> void:
	if gallery_guard.blocked: return
	hero_index = 0
	_preview("cast")
	heal_preview = true
	preview_resolved = false

func _refresh_characters() -> void:
	heal_preview = false
	if is_instance_valid(effect):
		effect.hide()
		effect.queue_free()
	effect = null
	super._refresh_characters()

func _process(delta: float) -> void:
	var before: float = visual_time
	super._process(delta)
	var dt: float = visual_time - before
	if dt <= 0: return
	if is_instance_valid(effect):
		effect.advance_visual(dt)
		if effect.age >= effect.duration:
			effect.queue_free()
			effect = null
	if heal_preview and not preview_resolved and preview_elapsed >= 1.5:
		preview_resolved = true
		effect = HealProfile.scene.instantiate()
		world.add_child(effect)
		effect.position = gallery_actors[0].position + HEROES[0].heal_effect_origin
		effect.setup(HealProfile, 30)
