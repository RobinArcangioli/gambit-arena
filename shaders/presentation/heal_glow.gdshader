shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled;
uniform vec4 glow_color : source_color = vec4(0.04, 1.0, 0.16, 1.0);
uniform float visibility : hint_range(0.0, 1.0) = 0.0;
uniform bool tube = false;
void fragment() {
	float softness;
	if (tube) {
		softness = pow(abs(dot(normalize(NORMAL), normalize(VIEW))), 2.5) * 0.38;
	} else {
		float radius = length(UV - vec2(0.5)) * 2.0;
		softness = pow(max(0.0, 1.0 - radius), 1.8) * 0.62;
	}
	ALBEDO = glow_color.rgb;
	ALPHA = glow_color.a * visibility * softness;
}
