shader_type canvas_item;
render_mode unshaded, blend_add;
uniform vec4 tint : source_color = vec4(1.0);
uniform float strength = 0.3;
void fragment() {
	vec2 p = (UV - vec2(0.5)) * 2.0;
	float r2 = dot(p,p);
	float edge = 1.0 - smoothstep(0.65,1.0,r2);
	// Only a soft light over the painted fire; no synthetic flame or expanding disc.
	float halo = exp(-r2 * 4.0) * edge;
	COLOR = vec4(tint.rgb,halo * strength * tint.a);
}
