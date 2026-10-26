extends "res://scripts/presentation/character_lab.gd"
## Visual previews only. These buttons never request a gameplay action or mutate health.
const ActionView = preload("res://scripts/presentation/character_view.gd")
var preview: String = ""
var preview_elapsed: float = 0.0

func _ready() -> void:
	super._ready()
	for index in range(3):
		for connection in slots[index].pressed.get_connections(): slots[index].pressed.disconnect(connection.callable)
	for index in range(3):
		slots[index].text = ["Attaque", "Coup recu", "Mort"][index]
		slots[index].disabled = false
		slots[index].pressed.connect(_preview.bind(["attack", "hit", "death"][index]))
	direction_index = 7
	_place_actors()
	$HUD/Title.text = "GRAPHICS-004 / ACTIONS"
	$HUD/Description.text = "Sword / HitReact / Death\nC : Sort (Duck) / hors combat"

func _refresh_characters() -> void:
	preview = ""
	preview_elapsed = 0.0
	super._refresh_characters()

func _preview(kind: String) -> void:
	if gallery_guard.blocked: return
	_refresh_characters()
	moving = false
	preview = kind
	_pose_characters()
	for actor in gallery_actors:
		if not actor.visual is ActionView: continue
		if kind == "death": actor.visual.start_death()
		elif kind == "hit": actor.visual.react_hit()
	if kind == "cast":
		for actor in gallery_actors: actor.visual.sync_action(true, &"heal" if hero_index == 0 else &"lightning", 1, 0.0, _cast_windup(), 0.4)
	else:
		gallery_actors[0].visual.sync_action(kind == "attack", &"basic", 1, 0.0, 0.6, 0.4)

func _cycle_motion() -> void:
	_refresh_characters()
	super._cycle_motion()

func _process(delta: float) -> void:
	if paused or gallery_guard.blocked or gallery_guard.resume_required or gallery_guard.consume_return_step(): return
	var dt: float = minf(delta, 1.0/30.0)
	visual_time += dt
	var previous: float = preview_elapsed
	preview_elapsed += dt
	_pose_characters()
	for actor in gallery_actors: actor.advance_visual(dt)
	if preview == "cast":
		for actor in gallery_actors: actor.visual.sync_action(preview_elapsed < _cast_windup() + 0.4, &"heal" if hero_index == 0 else &"lightning", 1, preview_elapsed, _cast_windup(), 0.4)
		if preview_elapsed >= _cast_windup() + 0.4: preview = ""
	if preview == "attack":
		gallery_actors[0].visual.sync_action(preview_elapsed < 1.0, &"basic", 1, preview_elapsed, 0.6, 0.4)
		if previous < 0.6 and preview_elapsed >= 0.6: gallery_actors[1].visual.react_hit()
		if preview_elapsed >= 1.0: preview = ""

func _place_actors() -> void:
	super._place_actors()
	if gallery_actors.is_empty(): return
	var anchor: Vector2 = PLACEMENTS[placement_index].clamp(Vector2(-2, -2), Vector2(2, 2))
	gallery_actors[0].position = Vector3(anchor.x - 0.35, 0, anchor.y + 0.35)
	gallery_actors[1].position = Vector3(anchor.x + 0.35, 0, anchor.y - 0.35)
	floor_canvas.feet = [gallery_actors[0].position, gallery_actors[1].position]
	floor_canvas.queue_redraw()
	_pose_characters()

func _pose_characters() -> void:
	if preview != "attack" or gallery_actors.size() < 2:
		super._pose_characters()
		return
	var offset: Vector3 = gallery_actors[1].position - gallery_actors[0].position
	var facing := Vector2(offset.x, offset.z).normalized()
	gallery_actors[0].pose(visual_time, false, facing)
	gallery_actors[1].pose(visual_time, false, -facing)

func _cast_windup() -> float:
	return 1.5 if hero_index == 0 else 2.0

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_C and not gallery_guard.blocked:
		_preview("cast")
		get_viewport().set_input_as_handled()
		return
	super._unhandled_key_input(event)
