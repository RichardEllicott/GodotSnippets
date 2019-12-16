/*

ported from here:
    
    https://thebookofshaders.com/11/


smooths out the simple random noise


*/
shader_type canvas_item;

uniform float frequency = 8.0; //amount of pixels width and height

uniform vec2 offset = vec2(0.0,0.0);


float random(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float smooth_noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



void fragment() {
    vec2 uv = UV;
    uv += offset;
    uv = uv*frequency;
    
    float random_float = smooth_noise(uv);
    
    COLOR = vec4(random_float,random_float,random_float,1.0);
    }

