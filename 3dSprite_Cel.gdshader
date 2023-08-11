shader_type spatial;

uniform sampler2D BASE_TEX;
uniform sampler2D NORMAL_TEX;
uniform float normal_dep : hint_range(0.0, 4.0) = 1.0;

uniform float first_stage : hint_range(0.0, 1.0) = 0.5; 
uniform float first_smooth : hint_range(0.0, 1.0) = 0.0; // Lengthens the color transition
uniform float second_stage : hint_range(0.0, 1.0) = 0.0;   // If left at 0, only level 1 is used.
uniform float second_smooth : hint_range(0.0, 1.0) = 0.0;
uniform float light_strength : hint_range(0.0, 100.0) = 12.0;
uniform float max_light : hint_range(0.0, 1.0) = 1.0;
uniform float mid_light : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 albedo_tex = texture(BASE_TEX,UV);
	vec4 normal_text = texture(NORMAL_TEX,UV);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
	NORMAL_MAP = normal_text.rgb;
	NORMAL_MAP_DEPTH = normal_dep;
}

void light() {
	float level_1 = first_stage;
	float level_1_smooth = first_smooth;
	float level_2 = second_stage;
	float level_2_smooth = second_smooth;
	float mid_range_light = mid_light;
	
	vec3 light_normal = normalize(LIGHT);
	float would_be_strength = max(0.0, dot(NORMAL, LIGHT));
	if (would_be_strength > level_1 && level_2 == 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength);
		DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * diff * (ALBEDO + light_strength) * max_light;
	} 
	else if (would_be_strength > level_1 && would_be_strength < level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength);
		DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * diff * (ALBEDO + light_strength) * mid_light;
	} 
	else if (would_be_strength >= level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_2, (level_2 + level_2_smooth), would_be_strength);
		if (diff < mid_range_light ) {diff = mid_range_light;}
		DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * diff * (ALBEDO + light_strength) * max_light;
	}
}
