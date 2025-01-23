#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iBlur;
uniform sampler2D iImage;

out vec4 fragColor;

// 添加玻璃质感效果
vec4 glassEffect(vec2 uv, float blur) {
    vec2 pixelSize = 1.0 / iResolution;
    vec4 color = vec4(0.0);
    float total = 0.0;
    
    // 改进的高斯模糊
    for(float x = -3.0; x <= 3.0; x++) {
        for(float y = -3.0; y <= 3.0; y++) {
            vec2 offset = vec2(x, y) * pixelSize * blur;
            float weight = exp(-(x*x + y*y) / (2.0 * 3.0 * 3.0));
            color += texture(iImage, uv + offset) * weight;
            total += weight;
        }
    }
    
    vec4 blurred = color / total;
    
    // 添加轻微的色彩调整
    float luminance = dot(blurred.rgb, vec3(0.299, 0.587, 0.114));
    vec3 tinted = mix(blurred.rgb, vec3(luminance), 0.2);
    
    // 添加细微渐变
    float vignette = smoothstep(1.5, 0.5, length(uv * 2.0 - 1.0));
    tinted = mix(tinted, tinted * 0.9, vignette);
    
    // 调整透明度
    float alpha = mix(0.65, 0.85, vignette);
    
    return vec4(tinted, alpha);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / iResolution.xy;
    
    // 基础玻璃效果
    vec4 glass = glassEffect(uv, iBlur);
    
    // 添加轻微的菱形纹理
    float pattern = sin(uv.x * 50.0 + uv.y * 50.0) * 0.02;
    
    // 最终颜色
    fragColor = glass + vec4(pattern);
    
    // 确保透明度在合理范围内
    fragColor.a = clamp(fragColor.a, 0.65, 0.85);
}