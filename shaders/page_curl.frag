#version 460 core

precision highp float;

// Canvas size
uniform vec2 uResolution;

// Page texture
uniform sampler2D uCurrentPage;
uniform sampler2D uNextPage;
uniform sampler2D uPreviousPage;

// Curl parameters
uniform float uCurlAmount;      // 0.0 to 1.0
uniform float uCurlDirection;   // 1.0 for forward, -1.0 for backward
uniform vec2 uCurlPosition;     // Touch position normalized
uniform float uShadowIntensity; // 0.0 to 0.5
uniform float uPageBorderRadius; // Corner radius

out vec4 fragColor;

// Helper function for page curl calculation
vec2 curlMapping(vec2 uv, float amount, float direction, vec2 curlPos) {
    // Distance from curl position
    vec2 dist = uv - curlPos;
    
    // Calculate curl angle based on distance and amount
    float angle = amount * length(dist) * direction;
    
    // Create rotation matrix
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);
    
    // Apply rotation to the UV
    dist = rotation * dist;
    vec2 curled_uv = curlPos + dist;
    
    return curled_uv;
}

// Function to apply rounded corners to page
float roundedRectangle(vec2 uv, vec2 size, float radius) {
    vec2 q = abs(uv - 0.5) - size * 0.5 + radius;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - radius;
}

void main() {
    // Normalize coordinates
    vec2 uv = gl_FragCoord.xy / uResolution;
    
    // Apply page border radius
    float roundedCorner = roundedRectangle(uv, vec2(1.0), uPageBorderRadius);
    if (roundedCorner > 0.0) {
        fragColor = vec4(1.0, 1.0, 1.0, 0.0); // Transparent for rounded corners
        return;
    }
    
    // Calculate curl effect
    vec2 curledUV = curlMapping(uv, abs(uCurlAmount), sign(uCurlDirection), uCurlPosition);
    
    // Check if the curled UV is within bounds
    bool inBounds = curledUV.x >= 0.0 && curledUV.x <= 1.0 && 
                    curledUV.y >= 0.0 && curledUV.y <= 1.0;
    
    // Calculate shadow based on curl amount and position
    float shadowFactor = 0.0;
    if (uCurlDirection > 0.0) { // Forward curl
        shadowFactor = smoothstep(0.0, 0.8, uCurlAmount) * 
                        (1.0 - smoothstep(0.7, 1.0, curledUV.x)) * 
                        uShadowIntensity;
    } else { // Backward curl
        shadowFactor = smoothstep(0.0, 0.8, uCurlAmount) * 
                        smoothstep(0.0, 0.3, curledUV.x) * 
                        uShadowIntensity;
    }
    
    // Determine which page texture to sample from
    if (inBounds) {
        if (uCurlAmount == 0.0) {
            // No curl, just show current page
            fragColor = texture(uCurrentPage, uv);
        } 
        else if (uCurlDirection > 0.0) {
            // Forward curl - show next page beneath the curl
            if (curledUV.x > uv.x) {
                fragColor = texture(uCurrentPage, curledUV);
                // Apply shadow to the curled part
                fragColor.rgb *= (1.0 - shadowFactor);
            } else {
                fragColor = texture(uNextPage, uv);
            }
        } 
        else {
            // Backward curl - show previous page beneath the curl
            if (curledUV.x < uv.x) {
                fragColor = texture(uCurrentPage, curledUV);
                // Apply shadow to the curled part
                fragColor.rgb *= (1.0 - shadowFactor);
            } else {
                fragColor = texture(uPreviousPage, uv);
            }
        }
    } else {
        // Outside bounds - determine what to show
        if (uCurlDirection > 0.0) {
            fragColor = texture(uNextPage, uv);
        } else {
            fragColor = texture(uPreviousPage, uv);
        }
    }
    
    // Add page edge highlight
    float edgeHighlight = 0.0;
    if (uCurlDirection > 0.0) {
        float edgeDistance = abs(curledUV.x - uv.x);
        edgeHighlight = smoothstep(0.01, 0.0, edgeDistance) * uCurlAmount * 0.5;
    } else {
        float edgeDistance = abs(curledUV.x - uv.x);
        edgeHighlight = smoothstep(0.01, 0.0, edgeDistance) * uCurlAmount * 0.5;
    }
    
    fragColor.rgb += vec3(edgeHighlight);
}