shader_type canvas_item;

uniform vec3 smoke_color : source_color = vec3(1.0);
uniform float move_range : hint_range(0.0, 1.0);

void fragment(){
	vec2 our_pixel = vec2(UV.x - TEXTURE_PIXEL_SIZE.x*((cos(TIME)*1.+0.1)/(UV.y+1.)), UV.y);
	vec4 source_texture = texture(TEXTURE, our_pixel);
	//if(SCREEN_UV.x > 0.5 && SCREEN_UV.x < 1.)
	//	pixel_left = SCREEN_UV.x-0.0;
	//COLOR = texture(TEXTURE, vec2(float(pixel_left), SCREEN_UV.y));
	COLOR = source_texture;
	//vec4 out_color = source_texture;
	/*if (source_texture.rbg == smoke_color.rbg && source_texture.a != 0.0) {
		out_color.a = 1.0; 
	} else {
		out_color.a = 1.0;
	}*/
	//COLOR = source_texture;
		
		
	//COLOR = vec4(mix(source_texture, flash_color, pct).rgb, source_texture.a);
}