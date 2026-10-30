shader_type spatial;
render_mode unshaded, blend_add, cull_disabled, depth_draw_never;
uniform vec4 tint : source_color = vec4(1.0,0.05,0.0,0.5);
uniform float opacity=1.0;
uniform float phase=0.0;
uniform bool trail=false;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1)),f.x),f.y);}
float fbm(vec2 p){return noise(p)*.57+noise(p*2.03)*.29+noise(p*4.11)*.14;}
void fragment(){
 vec2 p=UV*2.0-1.0;
 float mask;
 if(trail){
  float n=fbm(vec2(UV.x*7.0,UV.y*11.0-phase*15.0));
  float width=mix(.12,.86,pow(UV.y,.45));
  float ragged=abs(p.x+(n-.5)*.35)/width;
  mask=smoothstep(1.0,.05,ragged)*smoothstep(.04,.25,UV.y)*smoothstep(1.0,.88,UV.y);
  mask*=smoothstep(.21,.7,n);
 }else{
  float n=fbm(p*4.0+phase*2.5);
  mask=smoothstep(1.0,.3,length(p)+(n-.5)*.25);
 }
 ALBEDO=tint.rgb;ALPHA=mask*tint.a*opacity;
}
