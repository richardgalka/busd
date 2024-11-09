shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float pct : hint_range(0.0, 1.0);

void fragment(){
	vec4 source_texture = texture(TEXTURE, UV);
	COLOR = vec4(mix(source_texture, flash_color, pct).rgb, source_texture.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
