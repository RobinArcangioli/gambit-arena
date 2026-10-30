shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;
uniform float phase=0.0;
uniform float opacity=1.0;
uniform float seed=0.0;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1)),f.x),f.y);}
void fragment(){
 vec2 p=UV*2.0-1.0;
 float n=noise(p*4.0+vec2(seed,-phase*1.2))*.65+noise(p*9.1+seed)*.35;
 float density=smoothstep(1.02,.4,length(p)+(n-.5)*.38);
 ALBEDO=mix(vec3(.025,.017,.014),vec3(.17,.085,.04),n);
 ALPHA=density*opacity*.55;
}
