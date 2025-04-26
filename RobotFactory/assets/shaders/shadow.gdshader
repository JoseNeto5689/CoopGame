shader_type canvas_item;


void fragment() {
	vec4 pixelColor = texture(TEXTURE,UV);
	pixelColor = vec4(pixelColor.r *0.05 ,pixelColor.g *0.05,pixelColor.b*0.05, pixelColor.a);
	COLOR = pixelColor;
}
