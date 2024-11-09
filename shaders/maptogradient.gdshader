shader_type canvas_item;

uniform sampler2D gradient_texture;

//void vertex() {
	// Called for every vertex the material is visible on.
//}


void fragment() {
	lowp vec4 tmp = texture(TEXTURE, UV);
	lowp float brightness = (tmp.r + tmp.g + tmp.b)/3.0;
	lowp vec4 gradient_color = texture(gradient_texture, UV);
	COLOR.rbg = vec3(brightness);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
