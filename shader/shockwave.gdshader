shader_type canvas_item;

uniform float strength: hint_range(0.0, 0.1, 0.001) = 0.08;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius: hint_range(0.0, 1.0, 0.001) = 0.25;


uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform float width: hint_range(0.0, 0.1, 0.0001) = 0.04;
uniform float feather: hint_range(0.0, 1.0, 0.001) = 0.135;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 st = SCREEN_UV;
	float aspect_ratio = SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x;
	vec2 scaled_st = (st -vec2(0.0, 0.5)) / vec2(1.0, aspect_ratio) + vec2(0,0.5); 
	vec2 dist_center = scaled_st - center;
	float mask =  (1.0 - smoothstep(radius-feather, radius, length(dist_center))) * smoothstep(radius - width - feather, radius-width , length(dist_center));
	vec2 offset = normalize(dist_center)*strength*mask;
	vec2 biased_st = scaled_st - offset;
	
	vec2 abber_vec = offset*aberration*mask;
	
	vec2 final_st = st*(1.0-mask) + biased_st*mask;

	vec4 red = texture(SCREEN_TEXTURE, final_st + abber_vec);
	vec4 blue = texture(SCREEN_TEXTURE, final_st - abber_vec);
	vec4 ori = texture(SCREEN_TEXTURE, final_st);
	COLOR = vec4(red.r, ori.g, blue.b, 1.0);
}
// -------------------------------------------------------------------------------------------------
//shader_type canvas_item;
//
//uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;
//uniform vec2 center;
//uniform float force;
//uniform float size;
//uniform float thickness;
//uniform float offset;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
	//
	//// distortion
	//float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	//vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	//float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) *
		//smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
		 //
	//vec2 disp = normalize(scaledUV - center) * force * mask;
	//COLOR = texture(existing_screen_texture, UV - disp);
	//
	//COLOR.r = texture(existing_screen_texture, vec2(SCREEN_UV.x + offset, SCREEN_UV.y) - disp).r;
	//COLOR.g = texture(existing_screen_texture, SCREEN_UV - disp).g;
	//COLOR.b = texture(existing_screen_texture, vec2(SCREEN_UV.x - offset, SCREEN_UV.y) - disp).b;
	//
	
	// COLOR.rgb = vec3(mask);
	// -------------------------------------------------------------------------
	//// invert color
	//vec3 new_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	//new_color = vec3(1.0) - new_color;
	//COLOR.rgb = new_color;
//}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
