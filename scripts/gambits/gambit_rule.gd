extends Resource
## Data only. Validation belongs to the evaluator; editor hints are not guards.
@export var enabled: bool = true
@export_enum("self", "enemy") var target: String = "enemy"
@export_enum("always", "hp_below") var condition: String = "always"
@export_range(0, 100, 1) var threshold: int = 50
@export_enum("basic", "heal", "special") var skill: String = "basic"

func valid() -> bool:
	return target in ["self", "enemy"] and condition in ["always", "hp_below"] and threshold >= 0 and threshold <= 100 and skill in ["basic", "heal", "special"] and ((skill == "heal" and target == "self") or (skill != "heal" and target == "enemy"))
