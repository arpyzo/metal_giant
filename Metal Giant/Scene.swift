import MetalKit

class Scene {
    var clearColor: MTLClearColor
    
    var textureLoader: MTKTextureLoader!
    
    var projectionMatrix: float4x4!
    var worldModelMatrix: float4x4!
    var objectToDraw: Object!
    
    init(_ metalDevice: MTLDevice, _ aspectRatio: Float) {
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
        
        worldModelMatrix = float4x4()
        worldModelMatrix.translate(x: 0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(x: float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        objectToDraw = Cube(metalDevice, textureLoader)
    }
    
    func updateProjectionMatrix(_ aspectRatio: Float) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
    }
}
