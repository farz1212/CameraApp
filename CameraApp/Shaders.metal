//
//  Water.metal
//  SwiftUI17
//
//  Created by Paul Hudson on 09/06/2023.
//
// This is used in a handful of pieces of sample code.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Structure to represent the input texture coordinates
struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinate;
};

// Fragment shader function that applies a color tint effect
fragment float4 colorTintShader(VertexOut in [[stage_in]],
                                texture2d<float> inputTexture [[texture(0)]],
                                sampler inputSampler [[sampler(0)]],
                                constant float4 &tintColor [[buffer(0)]]) {
    // Sample the original color from the input texture
    float4 originalColor = inputTexture.sample(inputSampler, in.textureCoordinate);
    
    // Apply the tint color effect by multiplying the original color with the tint color
    float4 tintedColor = originalColor * tintColor;

    // Output the tinted color
    return tintedColor;
}

// Vertex shader function (pass-through)
vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                              constant float2 *vertexArray [[buffer(0)]]) {
    VertexOut out;
    // Set the position of the vertex
    out.position = float4(vertexArray[vertexID], 0.0, 1.0);
    
    // Set the texture coordinate to the same value as the position
    out.textureCoordinate = vertexArray[vertexID];
    
    return out;
}



[[ stitchable ]] half4 checkerboard(float2 position, half4 currentColor, float size, half4 newColor) {
    uint2 posInChecks = uint2(position.x / size, position.y / size);
    bool isColor = (posInChecks.x ^ posInChecks.y) & 1;
    return isColor ? newColor * currentColor.a : half4(0.0, 0.0, 0.0, 0.0);
}

[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time) {
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * currentColor.a;
}

[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float strength) {
    float min_strength = max(strength, 0.0001);
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return layer.sample(float2(coord_x, coord_y));
}

[[ stitchable ]] float2 simpleWave(float2 position, float time) {
//    return position + float2 (0, sin(time + position.x / 20)) * 10;
    return position + float2 (sin(time + position.y / 20), sin(time + position.x / 20)) * 5;
}

[[ stitchable ]] float2 complexWave(float2 position, float time, float2 size, float speed, float strength, float frequency) {
    float2 normalizedPosition = position / size;
    float moveAmount = time * speed;

    position.x += sin((normalizedPosition.x + moveAmount) * frequency) * strength;
    position.y += cos((normalizedPosition.y + moveAmount) * frequency) * strength;

    return position;
}

[[ stitchable ]] half4 emboss(float2 position, SwiftUI::Layer layer, float strength) {
    half4 current_color = layer.sample(position);
    half4 new_color = current_color;

    new_color += layer.sample(position + 1) * strength;
    new_color -= layer.sample(position - 1) * strength;

    return half4(new_color);
}
