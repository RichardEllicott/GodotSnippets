/*

my current main combi shader


combines blur, and a mix of the blur to look like bloom

to give a soft crt look
use blur, a mix, and also some brightness

source for brightness/contrast/saturation:
https://docs.godotengine.org/en/3.1/tutorials/shading/screen-reading_shaders.html


added a hue shift



*/

shader_type canvas_item;

uniform float brightness : hint_range(0, 16);
uniform float contrast : hint_range(0, 16);
uniform float saturation : hint_range(0, 16);

uniform float blur_amount : hint_range(0, 5);
uniform float blur_mix : hint_range(0, 1);

uniform bool enable_hue_shift = false;
uniform float hue_shift = 0.0;

vec3 apply_hue(vec3 aColor, float aHue){
    
    // very simply hue shift using "Rodrigues' rotation formula"
    
    // https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
    
    //formulae is fast but not 100% accurate
    //for example, shifting RED one sextant does not result in pure yellow
    
    float angle = radians(aHue);
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    //Rodrigues' rotation formula
    return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1.0 - cosAngle);
    }

void fragment() {

    vec4 blur_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    vec4 orginal_color = textureLod(SCREEN_TEXTURE, SCREEN_UV,0.0);
    
    vec4 c = mix(blur_color,orginal_color, blur_mix);
    
    if (enable_hue_shift){
        c.rgb = apply_hue(c.rgb, hue_shift);
        }

    
    c.rgb = mix(vec3(0.0), c.rgb, brightness);
    c.rgb = mix(vec3(0.5), c.rgb, contrast);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);
    
    COLOR = c;
}


