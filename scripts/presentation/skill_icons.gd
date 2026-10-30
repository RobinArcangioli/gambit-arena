extends RefCounted
## One replaceable art catalogue shared by skills, orders, casts and active buffs.
const DEFAULT_STYLE = preload("res://resources/presentation/skill_icons/standard.tres")
const TEXTURES = {
	&"meteor": preload("res://assets/ui/meteor.svg"),
	&"heal": preload("res://assets/art/skills/heal.png"),
	&"lightning": preload("res://assets/art/skills/lightning.png"),
	&"booster": preload("res://assets/art/skills/booster.png")}
static func texture(id: StringName) -> Texture2D: return TEXTURES.get(id)
static func rect(id: StringName, extent: float) -> TextureRect:
	var icon := TextureRect.new(); icon.texture = texture(id)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.custom_minimum_size = Vector2.ONE * extent; icon.size = icon.custom_minimum_size
	return icon
