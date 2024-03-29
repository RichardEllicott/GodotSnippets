
//const float PI = 3.14159265358979323846;
const float PI =   3.14159265358979323846264338327950288419716939937510;


// https://godotforums.org/d/19408-random-number-generation/3
float rand2f(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


vec3 gerstner_wave(vec3 _vert_in, float _time, float _angle, float _frequency, float _amplitude){

	// an angle 3D Vector based gerstner wave

	//https://docs.godotengine.org/en/3.5/tutorials/shaders/shader_reference/shading_language.html?highlight=shading%20language

	// roughly following this Unity example:
	// https://catlikecoding.com/unity/tutorials/flow/waves/
	
	// requires PI
	
	vec3 dir_x = vec3(cos(_angle),0,sin(_angle));
	vec3 dir_y = vec3(0,1,0);
	
	vec3 return_vert = vec3(0,0,0);
	
	float x_val = dot(_vert_in,dir_x);
	x_val += _time;
		
	float k = 2.0 * PI / _frequency;  /// NOTE MUST BE IMPORTAT
	
	float f = k * (x_val);

	
	return_vert += dir_x * cos(f) * _amplitude; // turn off for pure sine
	return_vert += dir_y * sin(f) * _amplitude;
	
	// RANDOM
	float rand_amp = 1.0;
	vec3 ran_vert = _vert_in;
	//ran_vert += dir_x * _time / 64.0;
	return_vert.y += rand2f(ran_vert.xz) * rand_amp;
	

	return return_vert;
}





