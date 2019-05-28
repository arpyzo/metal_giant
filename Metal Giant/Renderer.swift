import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    var samplerState: MTLSamplerState!
    
    var bufferProvider: BufferProvider
    
    var scene: Scene!
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0
    
    init(_ metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        
        let metalLibrary = metalDevice.makeDefaultLibrary()!

        let samplerDescriptor: MTLSamplerDescriptor! = MTLSamplerDescriptor()
        samplerState = metalDevice.makeSamplerState(descriptor: samplerDescriptor)

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        let sizeOfUniformsBuffer = MemoryLayout<Float>.size * float4x4.numberOfElements() * 2 + Light.size()
        self.bufferProvider = BufferProvider(metalDevice: metalDevice, inflightBuffersCount: 3, sizeOfUniformsBuffer: sizeOfUniformsBuffer)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.updateProjectionMatrix(Float(size.width / size.height))
    }
    
    func draw(in view: MTKView) {
        // UPDATE HERE
        //let systemTime = CACurrentMediaTime()
        //print("Time: \(systemTime)")
        //let timeDifference = (lastRenderTime == nil) ? 0 : (systemTime - lastRenderTime!)
        //lastRenderTime = systemTime
        //update(dt: timeDifference)
        
        guard let drawable = view.currentDrawable else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        // GREEN
        //renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        // BLACK
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        _ = bufferProvider.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.addCompletedHandler { (_) in
            self.bufferProvider.avaliableResourcesSemaphore.signal()
        }
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setCullMode(MTLCullMode.front)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(scene.objectToDraw.vertexBuffer, offset: 0, index: 0)
        
        renderEncoder?.setFragmentTexture(scene.objectToDraw.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        var nodeModelMatrix = self.modelMatrix()
        nodeModelMatrix.multiplyLeft(matrix: scene.worldModelMatrix)

        let uniformBuffer = bufferProvider.nextUniformsBuffer(projectionMatrix: scene.projectionMatrix, modelViewMatrix: nodeModelMatrix, light: scene.light)
        
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder?.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.objectToDraw.vertexCount,
                                      instanceCount: scene.objectToDraw.vertexCount/3)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(x: positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }
}
