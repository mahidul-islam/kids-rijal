#version 460 core

#include <Flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;

out vec4 fragColor;

float plot(vec2 pixel) {    
    return smoothstep(0.02, 0.0, abs(pixel.y - pixel.x));
}

float plot2(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main() {
  vec2 pixel = FlutterFragCoord() / uSize;
  pixel.y = 1 - pixel.y;

  vec3 green = vec3(0, 1, 0);

  float y = pow(pixel.x, 5.0);    
  vec3 color = vec3(y);

    float pct = plot2(pixel, y);

    
    color = (1-pct)*color + pct*green;

  fragColor = vec4(color,   1);
}
