shader_type canvas_item;

uniform float fade_start = 100.0;
uniform float fade_end   = 0.0;

void fragment() {
    // posisi layar
    vec2 screen_pos = SCREEN_UV * vec2(1920.0, 1080.0);

    float alpha = 1.0;
    if (screen_pos.y < fade_start) {
        alpha = smoothstep(fade_end, fade_start, screen_pos.y);
    }

    // ambil warna asli fragment (teks) dari pipeline
    vec4 col = COLOR;

    COLOR = col * vec4(1.0, 1.0, 1.0, alpha);
}
