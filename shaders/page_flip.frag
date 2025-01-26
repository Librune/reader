// page_flip.frag
#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform vec4 iMouse;
uniform sampler2D image;

#define shadowWidth 8.0    // 缩小阴影宽度
#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)

precision mediump float;
out vec4 fragColor;

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 uv = fragCoord / resolution.xy;
  
  float pageEdge = iMouse.x;
  float distanceToEdge = fragCoord.x - pageEdge;
  
  if (iMouse.x > 0.0) {
    if (fragCoord.x > pageEdge) {
      fragColor = TRANSPARENT;
    } else {
      vec2 adjustedUV = uv;
      adjustedUV.x += (iMouse.z - iMouse.x) / resolution.x;
      fragColor = texture(image, adjustedUV);
    }
    
    // 优化后的阴影效果
    if (abs(distanceToEdge) < shadowWidth) {
      float shadowStrength = 1.0 - pow(abs(distanceToEdge)/shadowWidth, 2.0); // 平方衰减
      float shadowAlpha = 0.15 * shadowStrength; // 降低基础透明度
      
      // 带渐变的阴影颜色
      vec4 shadowColor = vec4(0.0, 0.0, 0.0, shadowAlpha);
      
      // 更精细的混合
      if(fragCoord.x <= pageEdge) {
        fragColor = mix(fragColor, shadowColor, shadowAlpha * 0.5); // 优化混合比例
      } else {
        fragColor = shadowColor;
      }
    }
  } else {
    fragColor = texture(image, uv);
  }
}