shader_type canvas_item;

uniform float light_height : hint_range(-2500.0, 2500.0) = 0.0;
uniform bool light_fade = false;
uniform float light_fade_point : hint_range(-2500.0, 2500.0) = -200.0;
uniform float light_fade_rate : hint_range(0.1, 1000.0) = 0.0;

void fragment() {
	LIGHT_VERTEX.z = light_height;
}

void light() {
	float light_reduce = 0.0;
	if (light_height < light_fade_point && light_fade) {
		light_reduce = (light_fade_point - light_height) / light_fade_rate;
	}
	float cNdotL = max(0.0, dot(NORMAL, LIGHT_DIRECTION)) - light_reduce;
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
