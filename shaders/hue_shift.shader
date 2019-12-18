/*

ported a simple hue shift using rotation (not as good as sextants)

try full RED, shifted 60 degrees, this should be full yellow but it's a bit dark
this is because of the sines used



*/

shader_type canvas_item;


uniform float hue_shift = 0.0;

vec3 applyHue(vec3 aColor, float aHue){
    
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
    
    
vec3 applyHue2(){
    // working on what i think is correct
    
    
    
    
    }
    
    





void fragment() {
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
    c = applyHue(c, hue_shift);
    COLOR.rgb = c;
}