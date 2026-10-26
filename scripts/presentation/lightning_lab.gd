extends "res://scripts/presentation/action_lab.gd"
## Art preview only: no skill request, damage, mana or cooldown mutation.
const LightningProfile = preload("res://resources/presentation/effects/lightning.tres")
var preparation: Node3D
var strike: Node3D
var lightning_preview: bool = false
var preview_resolved: bool = false

func _ready() -> void:
	super._ready()
	for index in [1, 2]:
		for connection in slots[index].pressed.get_connections(): slots[index].pressed.disconnect(connection.callable)
	slots[1].text = "Foudre (demo)"
	slots[1].pressed.connect(_lightning_preview)
	slots[2].text = "Annuler"
	slots[2].pressed.connect(_refresh_characters)
	$HUD/Title.text = "GRAPHICS-006 / FOUDRE"
	$HUD/Description.text = "Foudre (demo) : Duck 2 s puis eclair\nHalo, ramifications et impact lumineux"

func _lightning_preview() -> void:
	if gallery_guard.blocked: return
	hero_index = 1
	_preview("cast")
	lightning_preview = true
	preview_resolved = false
	preparation = LightningProfile.cast_scene.instantiate()
	world.add_child(preparation)
	preparation.setup(LightningProfile)
	_update_anchors()

func _refresh_characters() -> void:
	lightning_preview = false
	for node in [preparation, strike]:
		if is_instance_valid(node):
			node.hide()
			node.queue_free()
	preparation = null
	strike = null
	super._refresh_characters()

func _update_anchors() -> void:
	preparation.set_anchors(gallery_actors[0].position + HEROES[1].lightning_cast_origin,
		gallery_actors[1].position, preview_elapsed / 2.0)

func _process(delta: float) -> void:
	var before: float = visual_time
	super._process(delta)
	var dt: float = visual_time - before
	if dt <= 0: return
	if lightning_preview:
		gallery_actors[1].visual.sync_action(false, &"lightning", 1, preview_elapsed, 2.0, 0.4)
	if is_instance_valid(strike):
		strike.advance_visual(dt)
		if strike.age >= strike.duration:
			strike.queue_free()
			strike = null
	if is_instance_valid(preparation):
		_update_anchors()
		preparation.advance_visual(dt)
	if lightning_preview and not preview_resolved and preview_elapsed >= 2.0:
		preview_resolved = true
		if is_instance_valid(preparation): preparation.queue_free()
		preparation = null
		strike = LightningProfile.strike_scene.instantiate()
		world.add_child(strike)
		strike.position = gallery_actors[1].position
		strike.setup(LightningProfile, 1447)
		gallery_actors[1].visual.react_hit()
