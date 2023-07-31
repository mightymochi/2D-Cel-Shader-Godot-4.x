shader_type canvas_item;

uniform float light_height : hint_range(-2500.0, 2500.0) = 0.0;

void fragment() {
	LIGHT_VERTEX.z = light_height;
}
