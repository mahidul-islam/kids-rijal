#version 460 core

#include <Flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform int intervalCount;
uniform vec3 uInterval[3];
uniform float totalDuration;
uniform float maxHeight;

out vec4 fragColor;

void main() {
    vec2 pixel = FlutterFragCoord() / uSize;
    pixel.y = 1 - pixel.y ;

    vec3 white = vec3(1.0,1.0,1.0);
    vec3 recovery = vec3(1.0,0.0,0.0);
    vec3 z1 = vec3(1.0,0.0,0.0);
    vec3 z2 = vec3(0.0,1.0,0.0);
    vec3 z3 = vec3(0.0,0.0,1.0);
    vec3 z4 = vec3(1.0,1.0,0.0);
    vec3 z5 = vec3(1.0,1.0,0.0);
    vec3 z6 = vec3(1.0,1.0,0.0);
    vec3 z7 = vec3(1.0,1.0,0.0);
    vec3 de = vec3(1.0,1.0,0.0);

    vec3 color = white;
    float prevDuration = 0;
    for(int i =0;i<=uInterval.length(); i++) {
        if(i <= intervalCount) {
            float height = uInterval[i].y / maxHeight;
            float duration = uInterval[i].x / totalDuration;
            int colorIndex = int(uInterval[i].z);
            if(i != 0 ){
                prevDuration += (uInterval[i -1].x / totalDuration);
            }
            if(pixel.y <=height && (pixel.x > prevDuration && pixel.x <= (prevDuration + duration))) {
                if(colorIndex == 0){
                    color = recovery;
                } else if(colorIndex == 1) {
                    color = z1;
                } else if(colorIndex == 2) {
                    color = z2;
                } else if(colorIndex == 3) {
                    color = z3;
                } else if(colorIndex == 4) {
                    color = z4;
                } else if(colorIndex == 5) {
                    color = z5;
                } else if(colorIndex == 6) {
                    color = z6;
                } else if(colorIndex == 7) {
                    color = z7;
                } else {
                    color = de;
                }
            }
        }
    }
    fragColor = vec4(color, 1);
}
