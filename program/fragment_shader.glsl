#version 430
#define PI  3.1415926

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

vec2 rotate2D(vec2 uv, float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c) * uv;
}

vec2 hash12(float t) {
    float x = fract(sin(t * 3453.329));
    float y = fract(sin((t + x) * 8532.732));
    return vec2(x, y);
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    vec3 col = vec3(0.0);
    vec3 col1 = vec3(0.0);
    vec3 circle_col = vec3(0.0);
    vec3 circle_col1 = vec3(0.0);
    vec3 center_col = vec3(1.0);
    
    uv = rotate2D(uv, PI / 2.0);

    float r = 0.1;
    for (float i=0.0; i < 60.0; i++) {
        float factor = (sin(time) * 0.5 + 0.5) + 0.3;
        i += factor;

        float a = i/PI;
        float dx = 2*r*cos(a)-r*cos(2*a);
        float dy = 2*r*sin(a)+r*sin(2*a);
        float Circle_dx = r*cos(a);
        float Circle_dy= r*sin(a);

        col += 0.01 * factor / length(uv + vec2(dx - 0.1, dy) - 0.01 * hash12(i)); 
        col1 += 0.01 * factor / length(uv - vec2(dx + 0.1, dy) - 0.01 * hash12(i));
        circle_col += 0.01 * factor / length(uv - vec2(Circle_dx + 0.1, Circle_dy) - 0.02 * hash12(i));
        circle_col1 += 0.01 * factor / length(uv - vec2(Circle_dx*2 + 0.1, Circle_dy*2) - 0.02 * hash12(i));
        center_col+= 0.01 * factor / length(uv - vec2(Circle_dx/1024 + 0.1, Circle_dy/1024) - 0.02 * hash12(i));
    }
    col *= (sin(vec3(0.2, 0.8, 0.9) * time) * 0.1 + 0.1); 
    col += col1*(cos(vec3(0.2, 0.8, 0.9) * time) * 0.1 + 0.1);
    col += circle_col*(cos(vec3(1.0, 1.0, 1.0) * time) * 0.1+0.005);
    col += circle_col1*(sin(vec3(1.0, 1.0, 1.0) * time/2) * 0.1+0.005);
    col += center_col*(vec3(1.0,1.0,1.0) * 0.05);
    // col += *(sin(vec3(0.2, 0.8, 0.9) * time) * 0.15 + 0.25);

    fragColor = vec4(col, 1.0);
}