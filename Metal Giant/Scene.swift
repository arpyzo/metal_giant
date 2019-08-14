import MetalKit

class Scene {
    var viewMatrix: float4x4!
    var projectionMatrix: float4x4!
    var viewProjectionMatrix: float4x4!
    
    var modelLibrary: ModelLibrary!
    var node: Node!
    var node2: Node!
    
    var clearColor: MTLClearColor
    var light: Light
    
    let uniformBufferSize = MemoryLayout<Float>.size * float4x4.numberOfElements() * 2 + Light.size()

    init(_ metalDevice: MTLDevice, _ modelLibrary: ModelLibrary, _ aspectRatio: Float) {
        // TODO: get light from lightLibrary
        // TODO: get clearColor from elsewhere
        
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        light = Light(color: (1.0, 1.0, 1.0), ambientIntensity: 0.1, direction: (0.0, 0.0, 1.0),
                      diffuseIntensity: 0.8, shininess: 10, specularIntensity: 2)
        
        viewMatrix = float4x4()
        viewMatrix.translate(x: 0.0, y: 0.0, z: -4)
        viewMatrix.rotateAroundX(x: float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        updateViewProjectionMatrix(aspectRatio: aspectRatio)
        
        // TODO: create node hierarchy
        node = modelLibrary.makeNode("cube")
        node2 = modelLibrary.makeNode("cube")
        node2.positionY = 1.0
        node2.updateModelMatrix()
    }
    
    func updateViewProjectionMatrix(aspectRatio: Float) {
        projectionMatrix = float4x4.makeProjectionMatrix(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
        
        viewProjectionMatrix = projectionMatrix * viewMatrix
    }
}
