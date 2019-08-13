import MetalKit
import simd

class Node {
    static var modelLibrary: ModelLibrary!
    
    var modelMesh: ModelMesh
    var modelTexture: ModelTexture

    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    
    var scale:     Float = 1.0
    
    var modelMatrix: float4x4 = float4x4()
    
    // TODO: make modelLibrary a static member?
    // TODO: remove metalDevice requirement
    //init(_ modelLibrary: ModelLibrary) {
    init(_ metalDevice: MTLDevice) {
        Node.modelLibrary = ModelLibrary(metalDevice)
        
        modelMesh = Node.modelLibrary.modelMeshes["cube"]!
        modelTexture = Node.modelLibrary.modelTextures["cube"]!

        self.updateModelMatrix()
    }
    
    func updateModelMatrix() {
        modelMatrix = float4x4()
        modelMatrix.translate(x: positionX, y: positionY, z: positionZ)
        modelMatrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundY(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.rotateAroundZ(x: rotationX, y: rotationY, z: rotationZ)
        modelMatrix.scale(x: scale, y: scale, z: scale)
    }
}
