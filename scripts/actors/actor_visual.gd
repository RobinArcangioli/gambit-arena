extends Node2D
## Presentation only: animation playback never moves the root or applies damage.

const STATES: Array[String] = ["idle", "move", "attack", "hit", "death"]
const DIRECTIONS: Array[String] = ["se", "sw", "ne", "nw"]
const SPEEDS: Array[float] = [4.0, 8.0, 8.0, 10.0, 6.0]
@export var atlas: Texture2D
var visual: AnimatedSprite2D

func _ready() -> void:
	visual = AnimatedSprite2D.new()
	visual.name = "Visual"
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	visual.centered = false
	visual.offset = Vector2(-40, -68)
	var frames := SpriteFrames.new()
	frames.remove_animation(&"default")
	for state_index in range(STATES.size()):
		for direction_index in range(DIRECTIONS.size()):
			var animation_name := StringName(STATES[state_index] + "_" + DIRECTIONS[direction_index])
			frames.add_animation(animation_name)
			frames.set_animation_speed(animation_name, SPEEDS[state_index])
			frames.set_animation_loop_mode(animation_name,
				SpriteFrames.LOOP_LINEAR if state_index < 2 else SpriteFrames.LOOP_NONE)
			for frame_index in range(4):
				var frame_texture := AtlasTexture.new()
				frame_texture.atlas = atlas
				frame_texture.region = Rect2(frame_index * 80, (state_index * 4 + direction_index) * 80, 80, 80)
				frame_texture.filter_clip = true
				frames.add_frame(animation_name, frame_texture)
	visual.sprite_frames = frames
	add_child(visual)
	play_pose("idle", "se")

func play_pose(state: String, direction: String, restart: bool = false) -> void:
	var animation_name := StringName(state + "_" + direction)
	if not visual.sprite_frames.has_animation(animation_name):
		push_error("Unknown actor animation: " + String(animation_name))
		return
	# Repeated gameplay requests must not reset playback each frame.
	if visual.animation == animation_name and not restart:
		return
	visual.stop()
	visual.play(animation_name)

func set_visual_paused(paused: bool) -> void:
	# Zero speed preserves phase and also preserves a finished one-shot pose.
	visual.speed_scale = 0.0 if paused else 1.0
