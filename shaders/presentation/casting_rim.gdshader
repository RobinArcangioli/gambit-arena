shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_front, shadows_disabled;
uniform float strength = 0.65;
uniform float width = 0.028;
uniform float layer_opacity = 0.65;
void vertex() { VERTEX += normalize(NORMAL) * width; }
void fragment() {
 ALBEDO = vec3(0.10, 0.48, 1.0);
 ALPHA = strength * layer_opacity;
}
