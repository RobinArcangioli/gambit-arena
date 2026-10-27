shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_disabled, shadows_disabled;
uniform vec4 tint : source_color = vec4(0.035, 0.028, 0.02, 0.26);
uniform float feather : hint_range(0.001, 0.25) = 0.04;
void fragment() {
	float distance_from_center = length(UV - vec2(0.5));
	ALBEDO = tint.rgb;
	ALPHA = tint.a * (1.0 - smoothstep(0.5 - feather, 0.5, distance_from_center));
}
