shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;
uniform float age=0.0;
uniform float opacity=1.0;
uniform bool fiery=false;
void fragment(){
 vec2 p=UV*2.0-1.0;
 float r=length(p);
 float a=atan(p.y,p.x);
 float t=clamp(age/.28,0.0,1.0);
 float front=mix(.16,.96,1.0-pow(1.0-t,2.0));
 float chaos=sin(a*17.0+age*31.0)*sin(a*11.0-age*23.0);
 float width=fiery ? .12 : .055;
 float edge=front+(fiery ? .023 : .008)*chaos;
 float band=1.0-smoothstep(width*.2,width,abs(r-edge));
 float outer=smoothstep(1.0,.98,r);
 float heat=fiery ? .45+.35*chaos : .1;
 vec3 red=mix(vec3(.72,.006,.001),vec3(1.0,.14,.002),heat);
 float fade=smoothstep(0.0,.035,age)*(1.0-smoothstep(.19,.47,age));
 ALBEDO=red;ALPHA=band*outer*fade*opacity*.96;
}
