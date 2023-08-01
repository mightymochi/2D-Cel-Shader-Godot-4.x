shader_type canvas_item;

uniform float first_stage : hint_range(0.0, 1.0) = 0.5; 
uniform float first_smooth : hint_range(0.0, 1.0) = 0.0; // Lengthens the color transition
uniform float second_stage : hint_range(0.0, 1.0) = 0.0;   // If left at 0, only level 1 is used.
uniform float second_smooth : hint_range(0.0, 1.0) = 0.0;
uniform float light_strength : hint_range(0.0, 1.0) = 1.0;
uniform float max_light : hint_range(0.0, 1.0) = 1.0;
uniform float mid_light : hint_range(0.0, 1.0) = 0.5;
uniform float light_height : hint_range(-2500.0, 2500.0) = 0.0;
uniform float normal_dep : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	LIGHT_VERTEX.z = light_height;
	NORMAL_MAP = texture(NORMAL_TEXTURE, UV).rgb;
	NORMAL_MAP_DEPTH = normal_dep;
}

void light() {
	float level_1 = first_stage;
	float level_1_smooth = first_smooth;
	float level_2 = second_stage;
	float level_2_smooth = second_smooth;
	float mid_range_light = mid_light;
	
	vec3 light_normal = normalize(LIGHT_DIRECTION);
	float would_be_strength = max(0.0, dot(NORMAL, LIGHT_DIRECTION));
	if (would_be_strength > level_1 && level_2 == 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength);
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * max_light * diff * light_strength, LIGHT_COLOR.a);
	} 
	else if (would_be_strength > level_1 && would_be_strength < level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength);
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * mid_light * diff * light_strength, LIGHT_COLOR.a);
	} 
	else if (would_be_strength >= level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_2, (level_2 + level_2_smooth), would_be_strength);
		if (diff < mid_range_light ) {diff = mid_range_light;}
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * max_light * diff * light_strength, LIGHT_COLOR.a);
	}
}
