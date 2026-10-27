extends Resource
## Shared passive opacity envelope. Defaults reproduce GRAPHICS-009's heal exactly.
@export_range(0.001, 1.0) var fade_in_end: float = 0.06
@export_range(0.0, 0.999) var fade_out_start: float = 0.36
func sample(progress: float) -> float:
	if not is_finite(progress): return 0.0
	var p: float = clampf(progress, 0.0, 1.0)
	return smoothstep(0.0, fade_in_end, p) * (1.0 - smoothstep(fade_out_start, 1.0, p))
