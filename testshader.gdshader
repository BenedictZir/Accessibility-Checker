shader_type canvas_item;

uniform float time;
uniform vec2 resolution = vec2(1024.0, 600.0);
uniform float dot_radius = 10.0;
uniform float spacing = 40.0;

void fragment() {
	vec2 uv = FRAGCOORD.xy / resolution;
	vec2 pos = mod(FRAGCOORD.xy + vec2(sin(time) * 100.0, cos(time) * 100.0), spacing);
	float dist = length(pos - spacing * 0.5);

	float dot = smoothstep(dot_radius, dot_radius - 2.0, dist);
	vec3 color = mix(vec3(0.0, 0.5, 1.0), vec3(1.0), dot);

	COLOR = vec4(color, 1.0);
}
	