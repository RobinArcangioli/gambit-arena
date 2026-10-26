extends "res://scripts/combat/actor_profile.gd"
## Gameplay identity and abilities. No artistic resources.
@export var actor_key: StringName
@export var display_name: String
@export var team: int = 0
@export var abilities: Array[StringName] = [&"basic"]
@export var mana_capacity: int = 60
@export var mana_regeneration: float = 5.0
