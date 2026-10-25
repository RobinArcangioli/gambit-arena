extends RefCounted
## Viewport-coordinate layout. No gameplay state; invalid safe areas fall back.
const MARGIN: float = 12.0
const GAP: float = 8.0

static func usable_rect(view: Rect2, candidate: Rect2) -> Rect2:
	if not candidate.position.is_finite() or not candidate.size.is_finite() or not candidate.has_area():
		return view
	var clipped: Rect2 = view.intersection(candidate)
	return clipped if clipped.has_area() else view

static func regions(size_value: Vector2) -> Dictionary:
	var width: float = maxf(1.0, size_value.x - MARGIN * 2.0)
	var footer_height: float = clampf(size_value.y - 480.0, 232.0, 340.0)
	var footer_y: float = size_value.y - MARGIN - footer_height
	return {
		"header": Rect2(MARGIN, MARGIN, width, 64),
		"status": Rect2(MARGIN, 84, width, 128),
		"arena": Rect2(MARGIN, 220, width, maxf(1.0, footer_y - GAP - 220)),
		"footer": Rect2(MARGIN, footer_y, width, footer_height),
		"modal": Rect2(MARGIN, (size_value.y - minf(616, size_value.y - 24)) * 0.5, width, minf(616, size_value.y - 24)),
	}

static func camera_width(view_size: Vector2) -> float:
	# Keep the entire floor and standing actors visible, at most 48 px/world unit.
	return maxf(10.2, maxf(view_size.x / 48.0, view_size.x * 6.8 / maxf(1, view_size.y)))
