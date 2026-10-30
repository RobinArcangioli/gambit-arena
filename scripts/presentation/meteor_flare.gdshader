shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;
uniform float age=0.0;
uniform float opacity=1.0;
void fragment(){
 float a=UV.x*6.283185;
 float fingers=.30+.42*abs(sin(a*13.0+age*23.0)*sin(a*7.0-age*19.0))+.20*sin(a*29.0-age*35.0);
 float fire=1.0-smoothstep(fingers-.16,fingers,UV.y);
 fire*=smoothstep(0.0,.08,UV.y);
 float hot=pow(1.0-UV.y,3.0)*.65;
 ALBEDO=mix(vec3(.80,.008,.001),vec3(1.0,.24,.008),hot);
 ALPHA=fire*opacity*.94;
}
