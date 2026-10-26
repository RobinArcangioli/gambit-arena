extends "res://scripts/presentation/graphics_lab.gd"
## Gallery only: no combat, no skills. All four profiles can be inspected independently.
const ViewActor = preload("res://scripts/combat/stats_actor.gd")
const HEROES = [preload("res://resources/presentation/characters/anne.tres"), preload("res://resources/presentation/characters/mako.tres")]
const ENEMIES = [preload("res://resources/presentation/characters/skeleton.tres"), preload("res://resources/presentation/characters/skeleton_variant.tres")]
var gallery_actors: Array[ViewActor] = []
var hero_index: int = 0
var enemy_index: int = 0
var moving: bool = false
var visual_time: float = 0.0
var direction_index: int = 0

func _ready() -> void:
	super._ready()
	hero.hide()
	enemy.hide()
	for index in range(2):
		var actor := ViewActor.new()
		actor.enemy = index == 1
		actor.appearance = HEROES[0] if index == 0 else ENEMIES[0]
		world.add_child(actor)
		gallery_actors.append(actor)
	for index in range(3, 6):
		slots[index].show()
		slots[index].disabled = false
	slots[3].pressed.connect(_cycle_hero)
	slots[4].pressed.connect(_cycle_enemy)
	slots[5].pressed.connect(_cycle_motion)
	$HUD/Title.text = "GRAPHICS-003 / PERSONNAGES"
	$HUD/SlotsTitle.text = "Modeles / repos, marche et orientations"
	_refresh_characters()

func _refresh_characters() -> void:
	if gallery_actors.is_empty():
		return
	gallery_actors[0].set_appearance(HEROES[hero_index])
	gallery_actors[1].set_appearance(ENEMIES[enemy_index])
	slots[3].text = HEROES[hero_index].display_name
	slots[4].text = ENEMIES[enemy_index].display_name
	slots[5].text = "Marche" if moving else "Repos"
	_place_actors()

func _cycle_hero() -> void:
	if gallery_guard.blocked: return
	hero_index = (hero_index + 1) % HEROES.size()
	_refresh_characters()

func _cycle_enemy() -> void:
	if gallery_guard.blocked: return
	enemy_index = (enemy_index + 1) % ENEMIES.size()
	_refresh_characters()

func _cycle_motion() -> void:
	if gallery_guard.blocked: return
	moving = not moving
	direction_index = (direction_index + 1) % 8
	slots[5].text = "Marche" if moving else "Repos"
	_pose_characters()

func _place_actors() -> void:
	super._place_actors()
	if gallery_actors.is_empty(): return
	gallery_actors[0].position = hero.position
	gallery_actors[1].position = enemy.position
	_pose_characters()

func _pose_characters() -> void:
	var facing := Vector2.DOWN.rotated(direction_index * PI / 4.0)
	for actor in gallery_actors:
		actor.pose(visual_time, moving, facing)

func _process(delta: float) -> void:
	if paused or gallery_guard.blocked or gallery_guard.resume_required:
		return
	if gallery_guard.consume_return_step():
		return
	var dt: float = minf(delta, 0.1)
	visual_time += dt
	_pose_characters()
	for actor in gallery_actors:
		actor.advance_visual(dt)
