extends Node3D
## Passive view. Samples animation only when the caller supplies accepted game time.
const Definition = preload("res://scripts/presentation/character_definition.gd")
var definition: Definition
var model: Node3D
var player: AnimationPlayer
var valid: bool = false
var walking: bool = false
var sample_time: float = 0.0
var active_clip: StringName

func _ready() -> void:
	if definition == null or definition.model == null:
		return
	var instance := definition.model.instantiate()
	if not instance is Node3D:
		instance.free()
		return
	model = instance as Node3D
	add_child(model)
	model.scale = Vector3.ONE * definition.model_scale
	model.position = definition.model_offset
	model.rotation.y = definition.forward_rotation
	var players := model.find_children("*", "AnimationPlayer", true, false)
	if players.is_empty():
		return
	player = players[0] as AnimationPlayer
	player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	player.stop()
	if not player.has_animation(definition.idle_clip) or not player.has_animation(definition.move_clip):
		return
	# Local libraries: never mutate shared imported resources. Keep only skeletal transforms.
	for library_name in player.get_animation_library_list():
		var source := player.get_animation_library(library_name)
		var library := AnimationLibrary.new()
		for clip_name in source.get_animation_list():
			var full_name: StringName = StringName(str(library_name) + "/" + str(clip_name)) if not str(library_name).is_empty() else clip_name
			if full_name not in [definition.idle_clip, definition.move_clip]:
				continue
			var animation := source.get_animation(clip_name).duplicate() as Animation
			for track in range(animation.get_track_count() - 1, -1, -1):
				var path := animation.track_get_path(track)
				var type := animation.track_get_type(track)
				if path.get_subname_count() != 1 or str(path.get_subname(0)).to_lower() == "root" or type not in [Animation.TYPE_POSITION_3D, Animation.TYPE_ROTATION_3D, Animation.TYPE_SCALE_3D]:
					animation.remove_track(track)
			library.add_animation(clip_name, animation)
		player.remove_animation_library(library_name)
		player.add_animation_library(library_name, library)
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	valid = true
	pose(0.0, false, Vector2.ZERO)

func pose(_gait: float, moving: bool, facing: Vector2) -> void:
	if facing.length_squared() > 0.0001:
		rotation.y = atan2(facing.x, facing.y)
	if not valid:
		return
	var clip: StringName = definition.move_clip if moving else definition.idle_clip
	walking = moving
	if clip != active_clip:
		active_clip = clip
		sample_time = 0.0
		player.play(active_clip)
	_sample()

func advance_visual(dt: float) -> void:
	if not valid or not is_finite(dt) or dt <= 0.0:
		return
	sample_time += dt * (definition.move_playback if walking else 1.0)
	_sample()

func _sample() -> void:
	var duration: float = player.get_animation(active_clip).length
	player.seek(fposmod(sample_time, maxf(duration, 0.001)), true)
