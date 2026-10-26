shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, fog_disabled;

uniform vec4 glow_color : source_color = vec4(0.16, 0.48, 1.0, 1.0);
uniform vec4 core_color : source_color = vec4(0.88, 0.98, 1.0, 1.0);
uniform float visibility : hint_range(0.0, 2.0) = 1.0;
uniform float reveal : hint_range(0.0, 1.0) = 1.0;
uniform int shape = 0; // ribbon / round flare / ring

void fragment() {
	float distance_to_core = abs(UV.x * 2.0 - 1.0);
	float core = exp(-distance_to_core * distance_to_core * 95.0);
	float aura = exp(-distance_to_core * distance_to_core * 3.0) * 0.72;
	float gate = 1.0 - smoothstep(reveal, reveal + 0.035, UV.y);
	if (shape > 0) {
		float radius = length(UV * 2.0 - 1.0);
		if (shape == 1) {
			core = exp(-radius * radius * 55.0);
			aura = exp(-radius * radius * 5.0) * 0.48;
		} else {
			float ring = (radius - 0.72) * 13.0;
			core = exp(-ring * ring) * 0.6;
			aura = exp(-ring * ring * 0.12) * 0.28;
		}
		gate = 1.0 - smoothstep(0.85, 1.0, radius);
	}
	ALBEDO = mix(glow_color.rgb, core_color.rgb, core);
	ALPHA = clamp((core + aura) * visibility * gate * COLOR.a, 0.0, 1.0);
}
