#version 460 core

#include <Flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;

out vec4 fragColor;

void main() {
  // Foundation
  vec2 pixel = FlutterFragCoord() / uSize;
  pixel = pixel - 0.5;
  pixel.y = pixel.y * -1;
  pixel = pixel * 2;
  pixel.x *= uSize.x / uSize.y;
  // Foundation

  float d = length(pixel);

  d = sin((d * 8)- iTime) / 8;
  d = abs(d);
  d = smoothstep(0.0, 0.1, d);

  fragColor = vec4(d, d, d, 1);
}
