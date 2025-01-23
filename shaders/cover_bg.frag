#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iBlur;
uniform float scaleX;
uniform float scaleY;
uniform float offsetX;
uniform float offsetY;
uniform vec4 overlayColor;
uniform sampler2D iImage;

out vec4 fragColor;

float noisePattern(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec4 gaussianBlur(vec2 uv, float blur) {
    if (blur <= 0.0) return texture(iImage, uv);
    
    vec4 color = vec4(0.0);
    float total = 0.0;
    float sigma = blur * 0.5;
    
    // 保持原始 5x5 采样模式以保证性能
    for(float x = -2.0; x <= 2.0; x++) {
        for(float y = -2.0; y <= 2.0; y++) {
            vec2 offset = vec2(x, y) * 0.01 * blur;
            float weight = exp(-(x*x + y*y)/(2.0*sigma*sigma));
            color += texture(iImage, uv + offset) * weight;
            total += weight;
        }
    }
    
    return color / total;
}

vec4 applyOriginalOverlay(vec4 baseColor, vec2 uv) {
    // 完全保留原始遮罩逻辑
    float noise = noisePattern(uv * 2.0) * 0.02;
    float gradientAlpha = mix(0.56, 1.12, uv.y);
    vec4 overlay = vec4(overlayColor.rgb, gradientAlpha);
    vec4 result = mix(baseColor, overlay, overlay.a);
    result.rgb += noise;
    return result;
}

vec4 overlayEffect(vec2 uv) {
    vec2 adjustedUV = vec2(
        (uv.x - offsetX/iResolution.x) / scaleX,
        (uv.y - offsetY/iResolution.y) / scaleY
    );
    
    if (adjustedUV.x < 0.0 || adjustedUV.x > 1.0 || 
        adjustedUV.y < 0.0 || adjustedUV.y > 1.0) {
        return vec4(0.0);
    }

    // 优化后的模糊强度计算
    const float blurStart = 0.666;
    float blurStrength = 0.0;
    
    if (uv.y > blurStart) {
        float t = smoothstep(blurStart, 1.0, uv.y);
        blurStrength = pow(t, 1.5) * iBlur;
    }
    
    // 分离处理通道
    vec4 blurredColor = gaussianBlur(adjustedUV, blurStrength);
    vec4 originalColor = texture(iImage, adjustedUV);
    
    // 混合原始和模糊颜色
    vec4 finalColor = mix(originalColor, blurredColor, smoothstep(blurStart, 1.0, uv.y));
    
    // 应用原始遮罩效果
    return applyOriginalOverlay(finalColor, uv);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / iResolution.xy;
    fragColor = overlayEffect(uv);
}