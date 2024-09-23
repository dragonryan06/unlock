shader_type canvas_item;

uniform bool blink = false;

void fragment() {
	if (blink) {
		COLOR.rgb*=0.2*sin(TIME*6.0)+1.0;
	}
}