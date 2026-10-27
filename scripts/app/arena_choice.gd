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
	draws += 1
	return choices[rng.randi_range(0, choices.size() - 1)]
