shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx, blend_add;

uniform float shininess = 100;

void light() {
	vec3 half_vec = normalize(VIEW + LIGHT);
	float n_dot_half = max(0.0, dot(NORMAL, half_vec));
	float pf = pow(n_dot_half, shininess * SPECULAR_AMOUNT);

	SPECULAR_LIGHT += pf * ATTENUATION;
	ALPHA += pf * ATTENUATION;
}

void fragment() {
	ALPHA = 1.0;
}