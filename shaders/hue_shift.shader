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
    
    


vec3 hsv_to_rgb(vec3 HSV){
    /*
    soruce:
        https://gamedev.stackexchange.com/questions/28782/hue-saturation-brightness-contrast-effect-in-hlsl
    
    SEEMS WRONG!!!
    
    looking for a sextant capable shifting code
    
    
    
    */

    
    vec3 RGB = vec3(HSV.z,HSV.z,HSV.z);
    
    float h = (HSV.x+180.0)/60.0; //get a hue in the 0..5 interval from the -180 180 intv
    float s = HSV.y;
    float v = HSV.z;
    
    float i = floor(h);
    float f = h - i;
    
    float p = (1.0 - s);
    float q = (1.0 - s * f);
    float t = (1.0 - s * (1.0 - f));
    
    if (i == 0.0) { RGB = vec3(1, t, p); }
    else if (i == 1.0) { RGB = vec3(q, 1, p); }
    else if (i == 2.0) { RGB = vec3(p, 1, t); }
    else if (i == 3.0) { RGB = vec3(p, q, 1); }
    else if (i == 4.0) { RGB = vec3(t, p, 1); }
    else /* i == -1 */ { RGB = vec3(1, p, q); }
    
    RGB *= v;
    
    return RGB;
    }
    





void fragment() {
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
    c = applyHue(c, hue_shift);
    COLOR.rgb = c;
}