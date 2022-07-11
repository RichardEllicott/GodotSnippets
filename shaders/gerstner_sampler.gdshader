/*

this allows a solution to figuring out a gernster height by iterating the problem

(similar to how a computer can solve sine to make a table of values)


it's best to use this function to generare a canvas sample, to read back to another shader:



EXAMPLE FRAG SHADER FOR USAGE ON A TEXTURERECT:

float freq = 1.0; // how many repeats to show
float x = (uv.x - 0.25) * radians(360.0 * freq); // our x offset with a correction
float y = gerstner_sampler(x,50); // sampling 50 times for an accurate image
y = y * 0.5 + 0.5; // ensuring the image goes from black to white
color_out = vec3(y,y,y);




*/




float gerstner_sampler(float x,int steps){
	// approximate gerstner function
	
	// y = sin(x-cos(x-cos(x-cos(x))
	// where the amount of x-cos(...) steps is set by "steps"
	
	// steps = 0 would be a plain sine wave
	// each extra step will be more gerstner
	
	// i wrote this function with the intention of generating a gerstner texture
	
	// make sure to generate a sample of this data instead of doing it real-time if implementing a professional shader

	float y = x; // we load y up with x, i recurse over y for the total steps
	for (int i = 0; i < steps; i++){
		y = x-cos(y);
	}
	y = sin(y);

	return y;
}
