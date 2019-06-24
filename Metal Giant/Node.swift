import MetalKit
import simd

class Node {
    var modelMesh: ModelMesh
    var modelTexture: ModelTexture

    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    
    var scale:     Float = 1.0
    
    var modelMatrix: float4x4
    
    // TODO: make modelLibrary a static member?
    init(_ modelLibrary: ModelLibrary) {
        modelMesh = modelLibrary.modelMeshes["cube"]!
        modelTexture = modelLibrary.modelTextures["cube"]!

        // TODO: replace with updateModelMatrix
        modelMatrix = float4x4()
        modelMatrix.translate(x: positionX, y: positionY, z: positionZ)
        modelMatrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundY(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundZ(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.scale(x: scale, y: scale, z: scale)
    }
    
    func updateModelMatrix() {
        modelMatrix = float4x4()
        modelMatrix.translate(x: positionX, y: positionY, z: positionZ)
        modelMatrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundY(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundZ(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.scale(x: scale, y: scale, z: scale)
    }
    
    /*func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(x: positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }*/
    
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
