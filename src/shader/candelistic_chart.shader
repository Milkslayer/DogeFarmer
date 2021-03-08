shader_type canvas_item;

const float PI = 3.14159265359;
const vec4 data[] = {
	vec4(22., 10., 0.2, 0.6)
};

vec2 centerRadToPoints(vec2 inp){
	return vec2(inp.x - inp.y/2., inp.x + inp.y/2.);
}

float f(vec2 rs, vec2 x, vec2 y){
	return step(rs.x, x.x) + step(x.y, rs.x) 
	+ step(rs.y, y.x) + step(y.y, rs.y);
}

vec2 minXMaxY(vec2 inp){
	return vec2(min(inp.x, inp.y), max(inp.x, inp.y));
}

float candle(vec2 rs, vec2 x, vec2 openClose, vec2 minMax){
	float d = f(rs, centerRadToPoints(vec2(x.x, 0.004)), minMax);
	d *= f(rs, centerRadToPoints(x), centerRadToPoints(vec2(minMax.x, 0.005)));
	d *= f(rs, centerRadToPoints(x), centerRadToPoints(vec2(minMax.y, 0.005)));
	d *= f(rs, centerRadToPoints(x), minXMaxY(openClose));
	return  min(1., max(0., 1. - d));
}

void fragment(){
	vec2 rs = UV.xy;
	rs.y = rs.y * -1. + 1.;
	
	vec3 d = candle(rs, vec2(0.05, .03), vec2(0.22,0.1), vec2(0.09, 0.4)) * vec3(1., 0., 0.);
	d += candle(rs, vec2(0.1, .03), vec2(0.1,0.4), vec2(0.04, 0.6)) * vec3(0., 1., 0.);
	d += candle(rs, vec2(0.15, .03), vec2(0.4,0.2), vec2(0.1, 0.5)) * vec3(1., 0., 0.);
	
	COLOR = vec4(vec3(d), 1.);
}