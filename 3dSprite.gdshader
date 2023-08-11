shader_type spatial;

uniform sampler2D BASE_TEX;
uniform sampler2D NORMAL_TEX;
uniform float normal_dep : hint_range(0.0, 4.0) = 1.0;

void fragment() {
	vec4 albedo_tex = texture(BASE_TEX,UV);
	vec4 normal_text = texture(NORMAL_TEX,UV);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
	NORMAL_MAP = normal_text.rgb;
	NORMAL_MAP_DEPTH = normal_dep;
}
