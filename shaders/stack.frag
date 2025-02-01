#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform vec4 iMouse;
uniform sampler2D image;

#define shadowWidth 8
#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)
#define pi 3.14159265359

precision mediump float;
out vec4 fragColor;

vec3 blue = vec3(5, 83, 177) / 255;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec4 currentMouse = iMouse;

  vec2 uv = (fragCoord + vec2((currentMouse.z - currentMouse.x) , 0)) / resolution.xy;

 
  // 如果距离小于阈值，则将该像素设置为透明
  if (fragCoord.x > currentMouse.x) {
    fragColor = TRANSPARENT;
  }else {
    fragColor = texture(image, uv);
  }


  // 计算当前像素与鼠标位置的距离
  float distanceToMouse = distance(fragCoord.x, currentMouse.x);
  

  // 如果距离小于阴影宽度，则将该像素设置为阴影
   if(distanceToMouse < shadowWidth && fragCoord.x > currentMouse.x && fragCoord.x < currentMouse.z) {
      float shadowAlpha = 0.5 * (0.6 - smoothstep(0.0, shadowWidth * 1.7, distanceToMouse));
      fragColor = vec4(0.0, 0.0, 0.0, shadowAlpha);
  }
}

