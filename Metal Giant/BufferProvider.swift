import Metal
import simd

// Try bytesNoCopy
// Investigate buffer persistence

class BufferProvider: NSObject {
    let bufferCount: Int
    private var uniformBuffers: [MTLBuffer]
    private var avaliableBufferIndex: Int = 0
    var avaliableResourcesSemaphore: DispatchSemaphore
    
    init(_ metalDevice: MTLDevice, bufferCount: Int, bufferSize: Int) {
        
        avaliableResourcesSemaphore = DispatchSemaphore(value: bufferCount)

        self.bufferCount = bufferCount
        uniformBuffers = [MTLBuffer]()
        
        for _ in 0...bufferCount - 1 {
            let uniformBuffer = metalDevice.makeBuffer(length: bufferSize, options: [])
            uniformBuffers.append(uniformBuffer!)
        }
    }
    
    deinit {
        for _ in 0...self.bufferCount {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    // TODO: Should buffer provider be filling buffers with data?
    func nextUniformBuffer(_ projectionMatrix: float4x4, _ modelViewMatrix: float4x4, _ light: Light) -> MTLBuffer {
        let buffer = uniformBuffers[avaliableBufferIndex]
        
        let bufferPointer = buffer.contents()
        
        var projectionMatrix = projectionMatrix
        var modelViewMatrix = modelViewMatrix
        
        //memcpy(bufferPointer, modelViewMatrix.raw(), MemoryLayout<Float>.size * float4x4.numberOfElements())
        //memcpy(bufferPointer + MemoryLayout<Float>.size * float4x4.numberOfElements(), projectionMatrix.raw(), MemoryLayout<Float>.size * float4x4.numberOfElements())
        //memcpy(bufferPointer + 2 * MemoryLayout<Float>.size * float4x4.numberOfElements(), light.raw(), Light.size())

        memcpy(bufferPointer, &modelViewMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size * float4x4.numberOfElements(), &projectionMatrix, MemoryLayout<Float>.size*float4x4.numberOfElements())
        memcpy(bufferPointer + 2*MemoryLayout<Float>.size * float4x4.numberOfElements(), light.raw(), Light.size())
        
        avaliableBufferIndex += 1
        if avaliableBufferIndex == bufferCount {
            avaliableBufferIndex = 0
        }
        
        return buffer
    }
}
