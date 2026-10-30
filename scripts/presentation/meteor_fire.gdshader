shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;
uniform float age = 0.0;
uniform float seed = 0.0;
uniform float opacity = 1.0;
uniform bool stone = false;
varying vec3 local_point;
float hash(vec3 p) { return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453); }
float noise(vec3 p) {
 vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);
 return mix(mix(mix(hash(i),hash(i+vec3(1,0,0)),f.x),mix(hash(i+vec3(0,1,0)),hash(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash(i+vec3(0,0,1)),hash(i+vec3(1,0,1)),f.x),mix(hash(i+vec3(0,1,1)),hash(i+vec3(1,1,1)),f.x),f.y),f.z);
}
float fbm(vec3 p) {return noise(p)*.58+noise(p*2.07)*.28+noise(p*4.13)*.14;}
void vertex() {
 local_point=VERTEX;
 float n=noise(NORMAL*5.0+seed);
 VERTEX*=stone ? .85+n*.3 : .83+n*.35;
}
void fragment() {
 vec3 p=local_point*4.0+vec3(seed,age*-4.5,0.0);
 float n=fbm(p);
 vec3 col;
 if (stone) {
  float cracks=pow(1.0-abs(noise(local_point*13.0+seed)*2.0-1.0),25.0);
  col=mix(vec3(.055,.029,.018)*(0.6+n*.8),vec3(1.0,.12,.008),cracks*.9);
 } else {
  float heat=n*.72+.40-age*.48;
  col=mix(vec3(.045,.028,.021),vec3(.44,.021,.002),smoothstep(.08,.48,heat));
  col=mix(col,vec3(1.0,.14,.006),smoothstep(.4,.66,heat));
  col=mix(col,vec3(1.0,.61,.08),smoothstep(.68,.88,heat));
  col=mix(col,vec3(1.0,.9,.55),smoothstep(.88,1.0,heat));
 }
 float rim=smoothstep(0.0,.42,abs(dot(NORMAL,VIEW)));
 ALBEDO=col;ALPHA=opacity*(stone ? 1.0 : rim*smoothstep(.10,.30,n));
}
