extends Node3D
## Passive animation sampler. Every input is a value or accepted visual time; no gameplay calls.
const CLIP_END_MARGIN: float = 0.0001
const Definition = preload("res://scripts/presentation/character_definition.gd")
const FootprintShadow = preload("res://scripts/presentation/footprint_shadow.gd")
var ground_radius: float = 0.0
var ground_shadow: FootprintShadow
var definition: Definition
var model: Node3D
var player: AnimationPlayer
var valid: bool = false
var walking: bool = false
var sample_time: float = 0.0
var active_clip: StringName
var clip_time: float = 0.0
var action_active: bool = false
var action_skill: StringName
var action_elapsed: float = 0.0
var cast_active: bool = false
var attack_active: bool = false
var attack_id: int = 0
var attack_tail: bool = false
var _finished_tail_id: int = 0
var attack_elapsed: float = 0.0
var attack_windup: float = 0.6
var attack_recovery: float = 0.4
var hit_elapsed: float = 0.0
var hit_remaining: float = 0.0
var flash_remaining: float = 0.0
var dying: bool = false
var death_elapsed: float = 0.0
var _meshes: Array[MeshInstance3D] = []
var _skeletons: Array[Skeleton3D] = []
var _flash: StandardMaterial3D

func _ready() -> void:
	if definition == null or definition.model == null: return
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
	if players.is_empty(): return
	player = players[0] as AnimationPlayer
	player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	player.stop()
	if not player.has_animation(definition.idle_clip) or not player.has_animation(definition.move_clip): return
	# Private copies contain only skeletal transforms. No methods, game properties or root motion.
	var selected: Array[StringName] = [definition.idle_clip, definition.move_clip, definition.attack_clip, definition.hit_clip, definition.death_clip, definition.cast_clip]
	for library_name in player.get_animation_library_list():
		var source := player.get_animation_library(library_name)
		var library := AnimationLibrary.new()
		for clip_name in source.get_animation_list():
			var full_name: StringName = StringName(str(library_name) + "/" + str(clip_name)) if not str(library_name).is_empty() else clip_name
			if full_name not in selected: continue
			var animation := source.get_animation(clip_name).duplicate() as Animation
			for track in range(animation.get_track_count() - 1, -1, -1):
				var path := animation.track_get_path(track)
				var type := animation.track_get_type(track)
				if path.get_subname_count() != 1 or str(path.get_subname(0)).to_lower() == "root" or type not in [Animation.TYPE_POSITION_3D, Animation.TYPE_ROTATION_3D, Animation.TYPE_SCALE_3D]: animation.remove_track(track)
			library.add_animation(clip_name, animation)
		player.remove_animation_library(library_name)
		player.add_animation_library(library_name, library)
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_meshes.append(mesh)
	for skeleton in model.find_children("*", "Skeleton3D", true, false): _skeletons.append(skeleton)
	_flash = StandardMaterial3D.new()
	_flash.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_flash.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_flash.albedo_color = Color(1.0, 0.88, 0.60, 0.40)
	if definition.ground_shadow_enabled and ground_radius > 0.0:
		ground_shadow = FootprintShadow.new()
		ground_shadow.name = "GroundFootprint"
		ground_shadow.configure(ground_radius, definition.ground_shadow_color, definition.ground_shadow_feather)
		add_child(ground_shadow)
	valid = true
	pose(0.0, false, Vector2.ZERO)

func pose(_gait: float, moving: bool, facing: Vector2) -> void:
	if dying: return
	if facing.length_squared() > 0.0001: rotation.y = atan2(facing.x, facing.y)
	if walking != moving: sample_time = 0.0
	walking = moving
	if moving: hit_remaining = 0.0
	_sample()

func sync_action(active: bool, skill: StringName, id: int, elapsed: float, windup: float, recovery: float, terminal_tail: bool = false) -> void:
	if dying: return
	action_skill = skill
	action_elapsed = maxf(0.0, elapsed)
	if terminal_tail and not active and skill == &"basic" and elapsed >= windup and elapsed < windup + recovery and _finished_tail_id != id:
		if not attack_tail:
			action_active = true
			cast_active = false
			attack_active = true
			attack_tail = true
			attack_id = id
			attack_elapsed = elapsed
			attack_windup = maxf(0.001, windup)
			attack_recovery = maxf(0.001, recovery)
		_sample()
		return
	attack_tail = false
	action_active = active
	cast_active = active and skill != &"basic"
	attack_active = active and skill == &"basic"
	attack_id = id if attack_active else 0
	attack_elapsed = maxf(0.0, elapsed)
	attack_windup = maxf(0.001, windup)
	attack_recovery = maxf(0.001, recovery)
	if action_active: hit_remaining = 0.0
	_sample()

func react_hit() -> void:
	if dying or not valid: return
	flash_remaining = maxf(0.0, definition.flash_duration)
	# Strict mutex: an active attack cannot have its animation or skeleton touched by a hit.
	if action_active or attack_active or cast_active or walking:
		hit_remaining = 0.0
		_apply_flash()
		return
	hit_elapsed = 0.0
	hit_remaining = maxf(0.001, definition.hit_duration)
	_sample()

func start_death() -> void:
	dying = true
	death_elapsed = 0.0
	action_active = false
	cast_active = false
	attack_active = false
	attack_tail = false
	walking = false
	hit_remaining = 0.0
	flash_remaining = 0.0
	_sample()

func advance_visual(dt: float) -> void:
	if not valid or not is_finite(dt) or dt <= 0.0: return
	if dying:
		death_elapsed += dt
	else:
		if attack_tail:
			attack_elapsed = minf(attack_windup + attack_recovery, attack_elapsed + dt)
			if attack_elapsed >= attack_windup + attack_recovery:
				action_active = false
				attack_active = false
				attack_tail = false
				_finished_tail_id = attack_id
		sample_time += dt * (definition.move_playback if walking else 1.0)
		if hit_remaining > 0.0:
			hit_elapsed += dt
			hit_remaining = maxf(0.0, hit_remaining - dt)
		flash_remaining = maxf(0.0, flash_remaining - dt)
	_sample()

func _has(clip: StringName) -> bool:
	return valid and clip != &"" and player.has_animation(clip)

func _sample() -> void:
	if not valid: return
	var clip: StringName = definition.move_clip if walking else definition.idle_clip
	var looping: bool = true
	var position_in_clip: float = sample_time
	if dying and _has(definition.death_clip):
		clip = definition.death_clip
		position_in_clip = death_elapsed / maxf(0.001, definition.death_duration) * player.get_animation(clip).length
		looping = false
	elif attack_active and _has(definition.attack_clip):
		clip = definition.attack_clip
		var contact: float = clampf(definition.attack_contact, 0.0, player.get_animation(clip).length)
		if attack_elapsed <= attack_windup:
			position_in_clip = contact * attack_elapsed / attack_windup
		else:
			position_in_clip = contact + (player.get_animation(clip).length - contact) * (attack_elapsed - attack_windup) / attack_recovery
		looping = false
	elif cast_active and _has(definition.cast_clip):
		clip = definition.cast_clip
		var release: float = clampf(definition.cast_release, 0.0, player.get_animation(clip).length)
		if action_elapsed <= attack_windup:
			position_in_clip = release * action_elapsed / attack_windup
		else:
			position_in_clip = release + (player.get_animation(clip).length - release) * (action_elapsed - attack_windup) / attack_recovery
		looping = false
	elif not walking and not action_active and hit_remaining > 0.0 and _has(definition.hit_clip):
		clip = definition.hit_clip
		position_in_clip = hit_elapsed / maxf(0.001, definition.hit_duration) * player.get_animation(clip).length
		looping = false
	if active_clip != clip or player.current_animation != clip or not player.is_playing():
		active_clip = clip
		player.play(clip)
	var duration: float = maxf(0.001, player.get_animation(clip).length)
	# Sampling exactly at a non-looping end can stop AnimationPlayer while the
	# logical action is still active (float boundary). Keep the final pose alive.
	clip_time = fposmod(position_in_clip, duration) if looping else clampf(position_in_clip, 0.0, maxf(0.0, duration - CLIP_END_MARGIN))
	for skeleton in _skeletons: skeleton.reset_bone_poses()
	player.seek(clip_time, true)
	_apply_flash()

func _apply_flash() -> void:
	for mesh in _meshes: mesh.material_overlay = _flash if flash_remaining > 0.0 else null
