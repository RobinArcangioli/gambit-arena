extends RefCounted
const Orders = preload("res://scripts/gambits/orders.gd")
static func create(configuration: Dictionary) -> Dictionary:
	if not Orders.valid_configuration(configuration) or configuration.nassau.size() >= Orders.MAX_ORDERS: return {}
	var result: Dictionary = configuration.duplicate(true)
	result.nassau.push_front({"enabled": true, "criterion": "ally_roster", "skill": "booster"})
	return result
