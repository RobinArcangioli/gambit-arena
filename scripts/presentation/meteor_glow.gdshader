shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;
uniform vec4 tint : source_color = vec4(0.8,0.01,0.1,0.5);
uniform float opacity = 1.0;
uniform float phase = 0.0;
uniform bool trail = false;
void fragment() {
 vec2 p=UV*2.0-1.0;
 float mask;
 if (trail) {
  float taper=mix(0.10,0.75,UV.y);
  float wave=0.07*sin(UV.y*27.0+phase*20.0)+0.035*sin(UV.y*53.0-phase*31.0);
  float across=abs(p.x+wave)/taper;
  mask=pow(max(0.0,1.0-across),2.0)*smoothstep(0.0,0.18,UV.y)*smoothstep(1.0,0.86,UV.y);
 } else {
  float r=length(p);
  float edge=0.05*sin(atan(p.y,p.x)*13.0+phase*15.0)*sin(r*10.0);
  mask=pow(max(0.0,1.0-r+edge),0.7)*smoothstep(1.0,0.88,r);
 }
 ALBEDO=tint.rgb;
 ALPHA=mask*tint.a*opacity;
}
