import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    var samplerState: MTLSamplerState!
    
    var bufferProvider: BufferProvider!
    
    var scene: Scene! {
        didSet {
            bufferProvider = BufferProvider(metalDevice, bufferCount: 3, bufferSize: scene.uniformBufferSize)
        }
    }
    
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
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.updateProjectionMatrix(aspectRatio: Float(size.width / size.height))
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
        renderPassDescriptor.colorAttachments[0].clearColor = scene.clearColor
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        _ = bufferProvider.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.addCompletedHandler { (_) in
            self.bufferProvider.avaliableResourcesSemaphore.signal()
        }
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setCullMode(MTLCullMode.front)
        renderEncoder?.setRenderPipelineState(pipelineState)
        
        renderEncoder?.setVertexBuffer(scene.node.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.setFragmentTexture(scene.node.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        let uniformBuffer = bufferProvider.nextUniformBuffer(scene.projectionMatrix, scene.modelViewMatrix, scene.light)
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder?.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.node.vertexCount,
                                      instanceCount: scene.node.vertexCount/3)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
