shader_type canvas_item;
uniform float blackness;

void fragment() {
	vec4 pixelColor = texture(TEXTURE,UV);
	pixelColor = vec4(pixelColor.r * blackness ,pixelColor.g *blackness,pixelColor.b*blackness, pixelColor.a);
	COLOR = pixelColor;
}
