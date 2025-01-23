#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iBlur;
uniform sampler2D iImage;  // 添加图像采样器

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / iResolution.xy;
    vec2 pixelSize = 1.0 / iResolution;
    vec4 color = vec4(0.0);
    
    // 高斯模糊
    float total = 0.0;
    for(float x = -4.0; x <= 4.0; x++) {
        for(float y = -4.0; y <= 4.0; y++) {
            vec2 offset = vec2(x, y) * pixelSize * iBlur;
            float weight = exp(-(x*x + y*y) / (2.0 * 4.0 * 4.0));
            color += texture(iImage, uv + offset) * weight;
            total += weight;
        }
    }
    
    fragColor = color / total;
}