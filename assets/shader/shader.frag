#version 460 core

#include <Flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;

out vec4 fragColor;

vec3 palette(in float t)
{
  vec3 a = vec3(0.892, 0.725, 0.000);
  vec3 b = vec3(0.878, 0.278, 0.725);
  vec3 c = vec3(0.332, 0.518, 0.545);
  vec3 d = vec3(2.440, 5.043, 0.732);
  return a + b*cos(6.28318*(c*t+d));
}

void main() {
  // Foundation
  vec2 pixel = FlutterFragCoord() / uSize;
  pixel = pixel - 0.5;
  pixel.y = pixel.y * -1;
  pixel = pixel * 2;
  pixel.x *= uSize.x / uSize.y;
  // Foundation

  vec2 pixP = pixel;
  vec3 finalColor = vec3(0);

  for(float i =0;i<3; i++) {  
    pixel = fract(pixel * 2) - 0.5;

    float d = length(pixel ) * exp(-length(pixP));
    vec3 color =palette(length(pixP) + i* 0.4 + iTime); // vec3(1,0,0);

    d = sin((d * 8) + iTime) / 8;
    d = abs(d);
    // d = smoothstep(0.0, 0.1, d);
    d = pow(0.01 / d, 1.2);
    finalColor +=  d * color;
  }

  fragColor = vec4(finalColor , 1);
}
