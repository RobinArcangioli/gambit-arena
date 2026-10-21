extends RefCounted
## Coordinates on the ground are independent from their screen representation.


static func ground_to_screen(ground: Vector2, origin: Vector2 = Vector2.ZERO) -> Vector2:
	return origin + Vector2(ground.x - ground.y, (ground.x + ground.y) * 0.5)


static func screen_to_ground(screen: Vector2, origin: Vector2 = Vector2.ZERO) -> Vector2:
	var relative: Vector2 = screen - origin
	return Vector2(relative.x * 0.5 + relative.y, relative.y - relative.x * 0.5)
