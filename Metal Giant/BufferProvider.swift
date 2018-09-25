//
//  BufferProvider.swift
//  Metal Giant
//
//  Created by Robert Pyzalski on 9/9/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import Foundation
import Metal
import simd

class BufferProvider: NSObject {
    let inflightBuffersCount: Int
    private var uniformsBuffers: [MTLBuffer]
    private var avaliableBufferIndex: Int = 0
    var avaliableResourcesSemaphore: DispatchSemaphore
    
    init(device:MTLDevice, inflightBuffersCount: Int, sizeOfUniformsBuffer: Int) {
        
        avaliableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)

        self.inflightBuffersCount = inflightBuffersCount
        uniformsBuffers = [MTLBuffer]()
        
        for _ in 0...inflightBuffersCount - 1 {
            let uniformsBuffer = device.makeBuffer(length: sizeOfUniformsBuffer, options: [])
            uniformsBuffers.append(uniformsBuffer!)
        }
    }
    
    deinit {
        for _ in 0...self.inflightBuffersCount {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    func nextUniformsBuffer(projectionMatrix: float4x4, modelViewMatrix: float4x4, light: Light) -> MTLBuffer {

        
        // 1
        let buffer = uniformsBuffers[avaliableBufferIndex]
        
        // 2
        let bufferPointer = buffer.contents()
        
        // 3
        var projectionMatrix = projectionMatrix
        var modelViewMatrix = modelViewMatrix
        
        //memcpy(bufferPointer, modelViewMatrix.raw(), MemoryLayout<Float>.size * float4x4.numberOfElements())
        //memcpy(bufferPointer + MemoryLayout<Float>.size * float4x4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * float4x4.numberOfElements())
        //memcpy(bufferPointer + 2 * MemoryLayout<Float>.size * float4x4.numberOfElements(), light.raw(), Light.size())

        memcpy(bufferPointer, &modelViewMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size*float4x4.numberOfElements(), &projectionMatrix, MemoryLayout<Float>.size*float4x4.numberOfElements())
        memcpy(bufferPointer + 2*MemoryLayout<Float>.size*float4x4.numberOfElements(), light.raw(), Light.size())
        
        // 4
        avaliableBufferIndex += 1
        if avaliableBufferIndex == inflightBuffersCount {
            avaliableBufferIndex = 0
        }
        
        return buffer
    }
}
