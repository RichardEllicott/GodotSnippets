/*

random_noise.shader

procedural noise texture

can put on sprite (but add texture to get size)


note the limitations if you use say a frequency of 256, the repetition of noise
this is because the pseudo-random generator is pretty shoddy!

the offset also doesn't work too well, creating even more repetative noise

try some weird settings like:
    frequency = 32
    offset = 5363, 356

the random breaks down and eventually dies with larger numbers


*/
shader_type canvas_item;

uniform float frequency = 8.0; //amount of pixels width and height

uniform vec2 offset = vec2(0.0,0.0);

float random_noise(vec2 co){
    // very low quality random noise
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    uv += offset;
    uv = floor(uv*frequency);
    float random_float = random_noise(uv);
    COLOR = vec4(random_float,random_float,random_float,1.0);
    }
