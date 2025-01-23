#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iBlur;
uniform float scaleX;
uniform float scaleY;
uniform float offsetX;
uniform float offsetY;
uniform sampler2D iImage;

out vec4 fragColor;

vec4 glassEffect(vec2 uv, float blur) {
    // 应用缩放和偏移
    vec2 adjustedUV = vec2(
        (uv.x - offsetX/iResolution.x) / scaleX,
        (uv.y - offsetY/iResolution.y) / scaleY
    );
    
    // 检查UV是否在有效范围内
    if (adjustedUV.x < 0.0 || adjustedUV.x > 1.0 || 
        adjustedUV.y < 0.0 || adjustedUV.y > 1.0) {
        return vec4(0.0);
    }

    vec2 pixelSize = 1.0 / iResolution;
    vec4 color = vec4(0.0);
    float total = 0.0;
    
    // 高斯模糊
    for(float x = -3.0; x <= 3.0; x++) {
        for(float y = -3.0; y <= 3.0; y++) {
            vec2 offset = vec2(x, y) * pixelSize * blur;
            float weight = exp(-(x*x + y*y) / (2.0 * 3.0 * 3.0));
            color += texture(iImage, adjustedUV + offset) * weight;
            total += weight;
        }
    }
    
    return color / total;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / iResolution.xy;
    fragColor = glassEffect(uv, iBlur);
}