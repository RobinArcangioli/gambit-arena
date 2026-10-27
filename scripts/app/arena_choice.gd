extends RefCounted
## A private visual RNG. Never consumes the gameplay/global random stream.
const Catalog = preload("res://scripts/presentation/arena_catalog.gd")
var rng := RandomNumberGenerator.new()
var draws: int = 0
var choices: Array[StringName] = []
func _init() -> void:
	for id in Catalog.ids():
		if id != &"reference": choices.append(id)
	rng.randomize()
func next() -> StringName:
	return next_excluding(&"")

func next_excluding(excluded: StringName) -> StringName:
	draws += 1
	var pool: Array[StringName] = []
	for id in choices:
		if id != excluded: pool.append(id)
	return pool[rng.randi_range(0, pool.size() - 1)]
