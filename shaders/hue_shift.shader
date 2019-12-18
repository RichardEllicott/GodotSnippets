/*

ported a simple hue shift using rotation (not as good as sextants)

try full RED, shifted 60 degrees, this should be full yellow but it's a bit dark
this is because of the sines used

ADDED CORRECT HSB from book of shaders:
    From https://thebookofshaders.com/06/
    




*/

shader_type canvas_item;


uniform float hue_shift = 0.0;

vec3 applyHue(vec3 aColor, float aHue){
    
    // very simply hue shift using "Rodrigues' rotation formula"
    
    // https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
    
    //formulae is fast but not 100% accurate
    //for example, shifting RED one sextant does not result in pure yellow
    // actually results are (170,170,0) (darker yellow)
    
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
    


// From https://thebookofshaders.com/06/
// requested on help: https://github.com/godotengine/godot/issues/18920
vec3 rgb2hsb(vec3 c){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                vec4(c.gb, K.xy),
                step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                vec4(c.r, p.yzx),
                step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

vec3 hsb2rgb(vec3 c){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                    6.0)-3.0)-1.0,
                    0.0,
                    1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}



void fragment() {
//    //ROTATION METHOD
//    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
//    c = applyHue(c, hue_shift);
//    COLOR.rgb = c;
    
    //CHANGE TO HSB, SHIFT, CHANGE BACK METHOD
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb; //read
    c = rgb2hsb(c); // rgb to hsb
    c.x += hue_shift/360.0; // shift the hude
    c = hsb2rgb(c);
    COLOR.rgb = c;
    
    
    
    
}