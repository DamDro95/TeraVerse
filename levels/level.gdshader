shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 color_one : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Default White
uniform vec4 color_two : source_color = vec4(0.1, 0.1, 0.1, 1.0); // Default Dark Gray
uniform float size : hint_range(0.1, 50.0) = 2.0;               // Size of the tiles

void fragment() {
    // Generate a clean grid using UV coordinates multiplied by size
    vec2 pos = floor(UV * size);
    
    // Determine whether the grid coordinate sum is odd or even
    float pattern = mod(pos.x + pos.y, 2.0);
    
    // Smoothly interpolate between the two selected colors
    ALBEDO = mix(color_one, color_two, pattern).rgb;
}
