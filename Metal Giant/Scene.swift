import MetalKit

class Scene {
    var clearColor: MTLClearColor
    
    var textureLoader: MTKTextureLoader!
    
    var projectionMatrix: float4x4!
    var worldModelMatrix: float4x4!
    //var modelViewMatrix:  float4x4!
    var objectToDraw: Node!
    
    let light = Light(color: (1.0,1.0,1.0), ambientIntensity: 0.1, direction: (0.0, 0.0, 1.0), diffuseIntensity: 0.8, shininess: 10, specularIntensity: 2)
    
    let sizeOfUniformsBuffer = MemoryLayout<Float>.size * float4x4.numberOfElements() * 2 + Light.size()
    
    /*var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0*/
    
    var modelViewMatrix: float4x4 {
        get {
            return objectToDraw.modelMatrix().multiplyLeftCopy(matrix: worldModelMatrix)
        }
    }
    
    init(_ metalDevice: MTLDevice, _ aspectRatio: Float) {
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        objectToDraw = Cube(metalDevice, textureLoader)
        
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
                
        worldModelMatrix = float4x4()
        worldModelMatrix.translate(x: 0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(x: float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        //modelViewMatrix = objectToDraw.modelMatrix()
        //modelViewMatrix.multiplyLeft(matrix: worldModelMatrix)
        
        //modelViewMatrix = objectToDraw.modelMatrix().multiplyLeftCopy(matrix: worldModelMatrix)
        
        //modelMatrix().multiplyLeftCopy(matrix: worldModelMatrix)        
    }
    
    func updateProjectionMatrix(_ aspectRatio: Float) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: aspectRatio,
            nearZ: 0.01, farZ: 100.0
        )
    }
    
    /*func modelViewMatrix() -> float4x4 {
        var modelViewMatrix = objectToDraw.modelMatrix()
        modelViewMatrix.multiplyLeft(matrix: worldModelMatrix)
        return modelViewMatrix
    }*/
    
    /*func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(x: positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }*/
}
