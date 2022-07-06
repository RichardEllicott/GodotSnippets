/*

wavy_sprite.shader

add to a Sprite, works on the sprite itself (not an overlay)

*/
shader_type canvas_item;

uniform float frequency = 16.0;
uniform float amplitude = 0.01;
uniform float speed = 1.0;

void fragment() {
    vec2 uv = UV;
    uv.x += sin((UV.y+radians(TIME * speed))*frequency)*amplitude;
    COLOR = texture(TEXTURE, uv);
    COLOR = COLOR;
    }
