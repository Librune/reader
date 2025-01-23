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

vec4 overlayEffect(vec2 uv) {
    vec2 adjustedUV = vec2(
        (uv.x - offsetX/iResolution.x) / scaleX,
        (uv.y - offsetY/iResolution.y) / scaleY
    );
    
    if (adjustedUV.x < 0.0 || adjustedUV.x > 1.0 || 
        adjustedUV.y < 0.0 || adjustedUV.y > 1.0) {
        return vec4(0.0);
    }

    // 获取原始颜色
    vec4 color = texture(iImage, adjustedUV);
    
    // 添加细微纹理
    float noise = noisePattern(uv * 2.0) * 0.02;
    
    // 增强下方暗色的渐变遮罩
    float gradientAlpha = mix(0.4, 1, uv.y); // 上方0.2透明度，下方增加到0.6透明度
    vec4 overlay = vec4(0.0, 0.0, 0.0, gradientAlpha);
    
    // 混合原始颜色和遮罩
    color = mix(color, overlay, overlay.a);
    
    // 添加细微纹理
    color.rgb += noise;
    
    return color;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / iResolution.xy;
    fragColor = overlayEffect(uv);
}