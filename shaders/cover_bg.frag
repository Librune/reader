#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D uTexture;
uniform float uBlurAmount;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 pixelSize = 1.0 / uResolution;
    vec4 color = vec4(0.0);
    
    // 9x9 高斯模糊
    float total = 0.0;
    for(float x = -4.0; x <= 4.0; x++) {
        for(float y = -4.0; y <= 4.0; y++) {
            vec2 offset = vec2(x, y) * pixelSize * uBlurAmount;
            float weight = exp(-(x*x + y*y) / (2.0 * 4.0 * 4.0));
            color += texture(uTexture, uv + offset) * weight;
            total += weight;
        }
    }
    
    fragColor = color / total;
    // 添加轻微的亮度提升和饱和度调整
    fragColor.rgb = mix(fragColor.rgb, vec3(1.0), 0.2);
}