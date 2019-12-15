/*

wavy_screen.shader

ALPHA VERSION


animated sine based screen wobble, works as an overlay

add to a ColorRect

suggested uses:
    -add some blur for a water effect
    -seems good for 2D underwater seaweed


*/
shader_type canvas_item;

uniform float frequency = 16.0;
uniform float amplitude = 0.01;

uniform float speed = 1.0;

uniform float blur_amount : hint_range(0, 5); // amount of blur


void fragment() {
//    vec4 blur_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
//    vec4 orginal_color = textureLod(SCREEN_TEXTURE, SCREEN_UV,0.0);
//    COLOR = mix(blur_color,orginal_color, sharp_amount) * (hdr+1.0);

    vec2 suv = SCREEN_UV;
    
    suv.x += sin((UV.y+radians(TIME * speed))*frequency)*amplitude;
    vec4 orginal_color = textureLod(SCREEN_TEXTURE, suv,blur_amount);
    COLOR = orginal_color;
    }
