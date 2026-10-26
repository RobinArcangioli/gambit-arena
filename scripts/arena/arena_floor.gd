extends Node2D
## Presentation host and diagnostic overlay; no collision geometry or simulation access.
const ArenaBounds = preload("res://scripts/arena/arena_bounds.gd")
const Definition = preload("res://scripts/presentation/arena_definition.gd")
const View = preload("res://scripts/presentation/arena_view.gd")
const REFERENCE = preload("res://resources/presentation/arenas/reference.tres")
var camera: Camera3D
var view_size := Vector2(508, 572)
var show_marks: bool = false
var feet: Array[Vector3] = []
var definition: Definition
var active_view: View
var presentation_enabled: bool = true

func _ready() -> void:
	if active_view == null:
		set_definition(definition)

func set_definition(choice: Definition) -> void:
	var selected: Definition = choice if choice != null and choice.view_scene != null else REFERENCE
	var candidate: Node = selected.view_scene.instantiate()
	if not candidate is View:
		candidate.free()
		selected = REFERENCE
		candidate = REFERENCE.view_scene.instantiate()
	if is_instance_valid(active_view):
		remove_child(active_view)
		active_view.queue_free()
	definition = selected
	active_view = candidate as View
	add_child(active_view)
	# Draw child background before this host's overlay.
	active_view.show_behind_parent = true
	sync_view()

func sync_view() -> void:
	if is_instance_valid(active_view):
		active_view.visible = presentation_enabled
		active_view.sync_projection(camera, view_size)
	queue_redraw()

func set_presentation_enabled(enabled: bool) -> void:
	presentation_enabled = enabled
	sync_view()

func _project(point: Vector2) -> Vector2:
	return camera.unproject_position(Vector3(point.x, 0, point.y))

func _square(half_extent: float) -> PackedVector2Array:
	return PackedVector2Array([_project(Vector2(-half_extent, -half_extent)),
		_project(Vector2(half_extent, -half_extent)), _project(Vector2(half_extent, half_extent)),
		_project(Vector2(-half_extent, half_extent))])

func _outline(points: PackedVector2Array, color: Color, width: float) -> void:
	var loop: PackedVector2Array = points.duplicate()
	loop.append(points[0])
	draw_polyline(loop, color, width, true)

func _draw() -> void:
	if not is_instance_valid(camera):
		return
	if show_marks and presentation_enabled:
		_outline(_square(ArenaBounds.HALF_EXTENT - ArenaBounds.ACTOR_MARGIN), Color("78d0d2"), 1.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(1, 0)), Color("f3bd67"), 2.0)
		draw_line(_project(Vector2.ZERO), _project(Vector2(0, 1)), Color("77c9ef"), 2.0)
		for foot in feet:
			var point: Vector2 = camera.unproject_position(foot)
			draw_line(point - Vector2(5, 0), point + Vector2(5, 0), Color("fff2bb"), 1.5)
			draw_line(point - Vector2(0, 4), point + Vector2(0, 4), Color("fff2bb"), 1.5)
