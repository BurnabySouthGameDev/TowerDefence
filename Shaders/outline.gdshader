shader_type spatial;
render_mode blend_mix, cull_front, unshaded;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float size : hint_range(1.0, 1.5, 0.01) = 1.1;

void vertex() {
    VERTEX *= size;
}

void fragment() {
    ALBEDO = color.rgb;
    ALPHA  = color.a;
}
