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

  fragColor = vec4(pixel * iTime ,0,   1);
}
