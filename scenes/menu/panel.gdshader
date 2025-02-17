shader_type canvas_item;

uniform float zoom: hint_range(1.0, 200.0, 0.1) = 20.0;
uniform float wave_crop: hint_range(0.0, 1.0, 0.01) = 0.8;
uniform float brightness: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 1.0;
uniform float iterations: hint_range(0.0, 100.0, 1.0) = 5.0;
uniform float freq_start: hint_range(0.1, 50.0, 0.01) = 20.0;
uniform float freq_coeff: hint_range(0.1, 2.0, 0.01) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV - 0.5;
	float time = TIME * speed;
	float freq = freq_start;
	for (float i = 0.0;i < iterations;i++) {
		uv.y += sin(uv.x * 4.0 + time) / freq;
		uv.x += cos(uv.y * 8.0 + time) / freq;
		freq += freq_coeff;
	}
	float wave = sin(uv.y * zoom) * 0.5 + 0.5;
	wave = 1.0 - smoothstep(0.0, 0.5, wave);
	float hard_limit = step(wave_crop, 1.0 - abs(uv.y));
	float soft_limit = smoothstep(wave_crop, wave_crop + 0.1, 1.0 - abs(uv.y));
	wave *= hard_limit;
	vec3 color = vec3(0.1) * wave;
	color.rb += brightness * vec2(uv.x + 0.5, uv.y + 0.5) * soft_limit;
	COLOR = vec4(color, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
