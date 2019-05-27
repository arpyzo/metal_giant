import MetalKit
import QuartzCore
import simd

class Object {
    let metalDevice: MTLDevice
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var bufferProvider: BufferProvider
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0
    
    var time:CFTimeInterval = 0.0
    
    let light = Light(color: (1.0,1.0,1.0), ambientIntensity: 0.1, direction: (0.0, 0.0, 1.0), diffuseIntensity: 0.8, shininess: 10, specularIntensity: 2)
    
    var texture: MTLTexture
    lazy var samplerState: MTLSamplerState? = Object.defaultSampler(device: self.metalDevice)
    
    init(_ metalDevice: MTLDevice, _ textureLoader: MTKTextureLoader) {
        // Front
        let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.25, t: 0.25, nX: 0.0, nY: 0.0, nZ: 1.0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.25, t: 0.50, nX: 0.0, nY: 0.0, nZ: 1.0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 0.50, t: 0.50, nX: 0.0, nY: 0.0, nZ: 1.0)
        let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 0.50, t: 0.25, nX: 0.0, nY: 0.0, nZ: 1.0)
        
        // Left
        let E = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.00, t: 0.25, nX: -1.0, nY: 0.0, nZ: 0.0)
        let F = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.00, t: 0.50, nX: -1.0, nY: 0.0, nZ: 0.0)
        let G = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 0.25, t: 0.50, nX: -1.0, nY: 0.0, nZ: 0.0)
        let H = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 0.25, t: 0.25, nX: -1.0, nY: 0.0, nZ: 0.0)
        
        // Right
        let I = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.50, t: 0.25, nX: 1.0, nY: 0.0, nZ: 0.0)
        let J = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.50, t: 0.50, nX: 1.0, nY: 0.0, nZ: 0.0)
        let K = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 0.75, t: 0.50, nX: 1.0, nY: 0.0, nZ: 0.0)
        let L = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 0.75, t: 0.25, nX: 1.0, nY: 0.0, nZ: 0.0)
        
        // Top
        let M = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.25, t: 0.00, nX: 0.0, nY: 1.0, nZ: 0.0)
        let N = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.25, t: 0.25, nX: 0.0, nY: 1.0, nZ: 0.0)
        let O = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 0.50, t: 0.25, nX: 0.0, nY: 1.0, nZ: 0.0)
        let P = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 0.50, t: 0.00, nX: 0.0, nY: 1.0, nZ: 0.0)
        
        // Bottom
        let Q = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.25, t: 0.50, nX: 0.0, nY: -1.0, nZ: 0.0)
        let R = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.25, t: 0.75, nX: 0.0, nY: -1.0, nZ: 0.0)
        let S = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 0.50, t: 0.75, nX: 0.0, nY: -1.0, nZ: 0.0)
        let T = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 0.50, t: 0.50, nX: 0.0, nY: -1.0, nZ: 0.0)
        
        // Back
        let U = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s: 0.75, t: 0.25, nX: 0.0, nY: 0.0, nZ: -1.0)
        let V = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s: 0.75, t: 0.50, nX: 0.0, nY: 0.0, nZ: -1.0)
        let W = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s: 1.00, t: 0.50, nX: 0.0, nY: 0.0, nZ: -1.0)
        let X = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s: 1.00, t: 0.25, nX: 0.0, nY: 0.0, nZ: -1.0)
        
        let vertices:Array<Vertex> = [
            A,B,C, A,C,D,   //Front
            E,F,G, E,G,H,   //Left
            I,J,K, I,K,L,   //Right
            M,N,O, M,O,P,   //Top
            Q,R,S, Q,S,T,   //Bot
            U,V,W, U,W,X    //Back
        ]
        
        let path = Bundle.main.path(forResource: "cube", ofType: "png")!
        let texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)

        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = metalDevice.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        self.metalDevice = metalDevice
        vertexCount = vertices.count
        
        self.texture = texture
        
        //self.bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2)
        let sizeOfUniformsBuffer = MemoryLayout<Float>.size * float4x4.numberOfElements() * 2 + Light.size()
        self.bufferProvider = BufferProvider(metalDevice: metalDevice, inflightBuffersCount: 3, sizeOfUniformsBuffer: sizeOfUniformsBuffer)

    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: float4x4, projectionMatrix: float4x4, clearColor: MTLClearColor?) {
        
        _ = bufferProvider.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        // GREEN
        //renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        // BLACK
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.addCompletedHandler { (_) in
            self.bufferProvider.avaliableResourcesSemaphore.signal()
        }
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setCullMode(MTLCullMode.front)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        
        renderEncoder?.setFragmentTexture(texture, index: 0)
        if let samplerState = samplerState{
            renderEncoder?.setFragmentSamplerState(samplerState, index: 0)
        }

        var nodeModelMatrix = self.modelMatrix()
        nodeModelMatrix.multiplyLeft(matrix: parentModelViewMatrix)

        //let uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * Matrix4.numberOfElements() * 2, options: [])

        //let bufferPointer = uniformBuffer?.contents()

        //memcpy(bufferPointer, nodeModelMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        //memcpy(bufferPointer?.advanced(by: MemoryLayout<Float>.size * Matrix4.numberOfElements()), projectionMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        
        let uniformBuffer = bufferProvider.nextUniformsBuffer(projectionMatrix: projectionMatrix, modelViewMatrix: nodeModelMatrix, light: light)

        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder?.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)

        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount,
                                     instanceCount: vertexCount/3)
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
    
    func updateWithDelta(delta: CFTimeInterval){
        time += delta
    }
    
    class func defaultSampler(device: MTLDevice) -> MTLSamplerState {
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter             = MTLSamplerMinMagFilter.nearest
        sampler.magFilter             = MTLSamplerMinMagFilter.nearest
        sampler.mipFilter             = MTLSamplerMipFilter.nearest
        sampler.maxAnisotropy         = 1
        sampler.sAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.tAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.rAddressMode          = MTLSamplerAddressMode.clampToEdge
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp           = 0
        sampler.lodMaxClamp           = .greatestFiniteMagnitude
        return device.makeSamplerState(descriptor: sampler)!
    }
    
    /*func updateWithDelta(delta: CFTimeInterval) {
        super.updateWithDelta(delta: delta)
        
        let secsPerMove: Float = 6.0
        rotationY = sinf( Float(time) * 2.0 * .pi / secsPerMove)
        rotationX = sinf( Float(time) * 2.0 * .pi / secsPerMove)
    }*/
}
