import MetalKit

class Scene {
    var projectionMatrix: float4x4!
    var viewMatrix: float4x4!
    var model: Model!
    
    var textureLoader: MTKTextureLoader!
    
    var clearColor: MTLClearColor
    var light: Light
    
    let uniformBufferSize = MemoryLayout<Float>.size * float4x4.numberOfElements() * 2 + Light.size()
    
    // TODO: multiply model and view matrices in shader?
    var modelViewMatrix: float4x4 {
        get {
            return model.modelMatrix().multiplyLeftCopy(matrix: viewMatrix)
        }
    }
    
    //var time:CFTimeInterval = 0.0
    
    init(_ metalDevice: MTLDevice, _ aspectRatio: Float) {
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        light = Light(color: (1.0, 1.0, 1.0), ambientIntensity: 0.1, direction: (0.0, 0.0, 1.0), diffuseIntensity: 0.8, shininess: 10, specularIntensity: 2)
                
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
                
        viewMatrix = float4x4()
        viewMatrix.translate(x: 0.0, y: 0.0, z: -4)
        viewMatrix.rotateAroundX(x: float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        model = Cube(metalDevice, textureLoader)
    }
    
    func updateProjectionMatrix(aspectRatio: Float) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
    }
    
    /*func updateWithDelta(delta: CFTimeInterval){
     time += delta
     }*/
    
    /*func updateWithDelta(delta: CFTimeInterval) {
     super.updateWithDelta(delta: delta)
     
     let secsPerMove: Float = 6.0
     rotationY = sinf( Float(time) * 2.0 * .pi / secsPerMove)
     rotationX = sinf( Float(time) * 2.0 * .pi / secsPerMove)
     }*/
}
