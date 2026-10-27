extends RefCounted
const Orders = preload("res://scripts/gambits/orders.gd")
static func create(configuration: Dictionary) -> Dictionary:
	if not Orders.valid_configuration(configuration) or configuration.mako.size() >= Orders.MAX_ORDERS: return {}
	var result: Dictionary = configuration.duplicate(true)
	result.mako.push_front({"enabled": true, "criterion": "ally_roster", "skill": "booster"})
	return result
