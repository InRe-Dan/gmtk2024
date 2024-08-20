shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float avg = (COLOR.x + COLOR.y + COLOR.z) / 3.;
	COLOR = vec4(vec3(1.0), avg * 0.2);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
