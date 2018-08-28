//
//  Shaders.metal
//  Metal Giant
//
//  Created by Robert Pyzalski on 8/22/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];  //1
    float4 color;
};

vertex VertexOut basic_vertex(                           // 1
                              const device VertexIn* vertex_array [[ buffer(0) ]],   // 2
                              unsigned int vid [[ vertex_id ]]) {
    
    VertexIn VertexIn = vertex_array[vid];                 // 3
    
    VertexOut VertexOut;
    VertexOut.position = float4(VertexIn.position,1);
    VertexOut.color = VertexIn.color;                       // 4
    
    return VertexOut;
}


fragment half4 basic_fragment() { // 1
    return half4(1.0);              // 2
}
