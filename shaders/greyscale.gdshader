shader_type canvas_item;

//void vertex() {
	// Called for every vertex the material is visible on.
//}

void fragment() {
	vec4 tmp = texture(TEXTURE, UV);
	float brightness = (tmp.r + tmp.g + tmp.b)/3.0;
	COLOR = vec4(vec3(brightness), tmp.a);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
