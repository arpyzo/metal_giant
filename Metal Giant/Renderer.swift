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
        scene.updateViewProjectionMatrix(aspectRatio: Float(size.width / size.height))
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
        
        // TODO: recursively traverse nodes here?
        
        // ONE

        let dataSize = scene.node.mesh.vertexData.count * MemoryLayout.size(ofValue: scene.node.mesh.vertexData[0])
        renderEncoder?.setVertexBytes(scene.node.mesh.vertexData, length: dataSize, index: 0)
        renderEncoder?.setFragmentTexture(scene.node.texture.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        let uniformBuffer = bufferProvider.nextUniformBuffer(scene.viewProjectionMatrix, scene.node.modelMatrix, scene.light)
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder?.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.node.mesh.vertexCount, instanceCount: scene.node.mesh.vertexCount/3)
        
        // TWO
        let dataSize2 = scene.node2.mesh.vertexData.count * MemoryLayout.size(ofValue: scene.node2.mesh.vertexData[0])
        //renderEncoder?.setVertexBuffer(scene.node2.mesh.vertexBuffer, offset: 0, index: 0)
        renderEncoder?.setVertexBytes(scene.node2.mesh.vertexData, length: dataSize2, index: 0)
        renderEncoder?.setFragmentTexture(scene.node2.texture.texture, index: 0)
        renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        let uniformBuffer2 = bufferProvider.nextUniformBuffer(scene.viewProjectionMatrix, scene.node2.modelMatrix, scene.light)
        renderEncoder?.setVertexBuffer(uniformBuffer2, offset: 0, index: 1)
        renderEncoder?.setFragmentBuffer(uniformBuffer2, offset: 0, index: 1)
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.node2.mesh.vertexCount, instanceCount: scene.node2.mesh.vertexCount/3)
        
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
