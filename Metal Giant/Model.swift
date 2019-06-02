import MetalKit
import simd

class Model {
    var vertexBuffer: MTLBuffer
    var vertexCount: Int
    
    var texture: MTLTexture
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    
    var scale:     Float = 1.0
    
    // TODO: make modelLibrary a static member?
    init(_ modelLibrary: ModelLibrary) {
        vertexBuffer = modelLibrary.models["cube"]!.vertexBuffer
        vertexCount = modelLibrary.models["cube"]!.vertexCount
        
        texture = modelLibrary.models["cube"]!.texture
    }
    
    func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(x: positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }
    
    /*func updateWithDelta(delta: CFTimeInterval) {
        time += delta
     }*/
    
    /*func updateWithDelta(delta: CFTimeInterval) {
        super.updateWithDelta(delta: delta)
     
        let secsPerMove: Float = 6.0
        rotationY = sinf(Float(time) * 2.0 * .pi / secsPerMove)
        rotationX = sinf(Float(time) * 2.0 * .pi / secsPerMove)
     }*/
}
