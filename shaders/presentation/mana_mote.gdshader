shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled;
uniform float opacity = 0.6;
void fragment() {
 float radius = length(UV - vec2(0.5)) * 2.0;
 float halo = pow(max(0.0, 1.0 - radius), 2.2);
 float core = smoothstep(0.23, 0.0, radius);
 ALBEDO = mix(vec3(0.08, 0.42, 1.0), vec3(0.55, 0.86, 1.0), core);
 ALPHA = (halo * 0.42 + core * 0.7) * opacity;
}
