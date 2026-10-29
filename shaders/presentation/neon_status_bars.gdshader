shader_type canvas_item;
render_mode unshaded;
uniform int segments = 0;
uniform float segment_gap = 1.2;
uniform float empty_brightness = 0.22;
uniform float bar_width = 29.4;
uniform float bar_height = 1.25;
uniform float bar_gap = 2.25;
uniform float glow_radius = 1.0;
uniform float glow_strength = 0.22;
uniform vec3 ratios = vec3(1.0,1.0,0.0);
uniform bool casting = false;
uniform bool attacking = false;
uniform float attack_split = 0.6;
uniform vec4 recovery_color : source_color = vec4(0.80,0.85,0.91,1.0);
uniform bool mana_visible = true;
uniform bool selected = false;
uniform vec4 health_color : source_color = vec4(1.0,0.27,0.27,1.0);
uniform vec4 mana_color : source_color = vec4(0.22,0.62,1.0,1.0);
uniform vec4 cast_color : source_color = vec4(1.0,0.82,0.29,1.0);
uniform vec4 track_color : source_color = vec4(0.025,0.05,0.09,0.38);
varying vec2 local_position;
void vertex() { local_position = VERTEX; }
float rounded_box(vec2 p, vec2 half_size) {
	float radius = min(half_size.x,half_size.y);
	vec2 q = abs(p) - half_size + vec2(radius);
	return length(max(q,vec2(0.0))) + min(max(q.x,q.y),0.0) - radius;
}
void over(inout vec4 target, vec3 tint, float alpha) {
	float a = clamp(alpha,0.0,1.0);
	target.rgb = tint*a + target.rgb*(1.0-a);
	target.a = a + target.a*(1.0-a);
}
void fragment() {
	vec4 modulation = COLOR;
	vec4 result = vec4(0.0);
	for (int i=0; i<3; i++) {
		if ((i==1 && !mana_visible) || (i==2 && !casting && !attacking)) { continue; }
		vec4 row = vec4(0.0);
		vec4 tint = i==0 ? health_color : (i==1 ? mana_color : cast_color);
		if (i==2 && attacking && local_position.x>(attack_split-.5)*bar_width) { tint=recovery_color; }
		int visible_row = i - ((i==2 && !mana_visible) ? 1 : 0);
		vec2 center = vec2(0.0,float(visible_row)*(bar_height+bar_gap)+bar_height*0.5);
		float d = rounded_box(local_position-center,vec2(bar_width,bar_height)*0.5);
		float aa = max(fwidth(d)*0.5,0.15);
		vec4 empty = (segments>0 || (i==2 && attacking)) ? vec4(tint.rgb*empty_brightness,0.92) : track_color;
		over(row,empty.rgb,empty.a*(1.0-smoothstep(-aa,aa,d)));
		float filled = bar_width*clamp(ratios[i],0.0,1.0);
		if (filled>0.0001) {
			center.x = (filled-bar_width)*0.5;
			d = rounded_box(local_position-center,vec2(filled,bar_height)*0.5);
			float outside = max(d,0.0)/max(glow_radius,0.1);
			float halo = exp(-outside*outside*1.5)*glow_strength;
			over(row,tint.rgb,halo*tint.a);
			float core = 1.0-smoothstep(-aa,aa,d);
			over(row,mix(tint.rgb,vec3(1.0),0.12),core*0.94*tint.a);
		}
		if (segments>1 && i<2) {
			float x=local_position.x+bar_width*0.5;
			float spacing=bar_width/float(segments);
			float distance_to_gap=bar_width;
			for (int boundary=1; boundary<10; boundary++) {
				if (boundary<segments) { distance_to_gap=min(distance_to_gap,abs(x-float(boundary)*spacing)); }
			}
			float aa=max(fwidth(x)*0.5,0.15);
			row*=smoothstep(segment_gap*0.5-aa,segment_gap*0.5+aa,distance_to_gap);
		}
		over(result,row.rgb/max(row.a,0.00001),row.a);
	}
	// Historical diagnostics only; the product leaves selection disabled.
	if (selected) {
		float d = length(local_position-vec2(0.0,-5.0))-2.0;
		over(result,cast_color.rgb,1.0-smoothstep(-0.4,0.4,d));
	}
	COLOR = vec4(result.rgb/max(result.a,0.00001),result.a)*modulation;
}
