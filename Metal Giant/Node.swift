import MetalKit
import simd

class Node {
    let metalDevice: MTLDevice

    var vertexData: Array<Float>
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
    
    /*var modelMatrix: float4x4 {
        get {
            return modelMatrix().multiplyLeftCopy(matrix: worldModelMatrix)
        }
    }*/
    
    init(_ metalDevice: MTLDevice, _ textureLoader: MTKTextureLoader, _ vertices: Array<Vertex>) {
        self.metalDevice = metalDevice
        
        let path = Bundle.main.path(forResource: "cube", ofType: "png")!
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        
        vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = metalDevice.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        vertexCount = vertices.count
    }
    
    func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(x: positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(x: rotationX, y: rotationY, z: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }
}
