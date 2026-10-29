shader_type canvas_item;
render_mode unshaded;
uniform sampler2D image_texture : source_color, filter_linear;
uniform vec2 image_origin;
uniform vec2 image_size = vec2(1.0);
varying vec2 pixel;
void vertex(){pixel=VERTEX;}
void fragment(){
 vec2 uv=(pixel-image_origin)/max(image_size,vec2(1.0));
 vec2 edge_uv=vec2(1.0)-abs(mod(uv,vec2(2.0))-vec2(1.0));
 COLOR=texture(image_texture,clamp(edge_uv,vec2(0.001),vec2(0.999)));
}
