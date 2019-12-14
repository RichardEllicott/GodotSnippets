/*

luminescent_screen_blur.shader

combines a blur with the original image giving a "neon" look

*/
shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5); // amount of blur

uniform float sharp_amount : hint_range(0, 1); // mix back in orginal signal 0 to 1

uniform float hdr : hint_range(0, 5); // brighten the image to compensate for washed colors

void fragment() {
    vec4 blur_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    vec4 orginal_color = textureLod(SCREEN_TEXTURE, SCREEN_UV,0.0);
    COLOR = mix(blur_color,orginal_color, sharp_amount) * (hdr+1.0);
    }
