/*
italic.shader

note this is a vertex shader (works well with text)
*/
shader_type canvas_item;

uniform float italic = 0.3;

void vertex() {
    VERTEX.x -= VERTEX.y * italic;
    }
