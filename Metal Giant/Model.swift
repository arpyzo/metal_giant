import MetalKit
import simd

class Model {
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
    
    init(_ metalDevice: MTLDevice, _ textureLoader: MTKTextureLoader, _ vertices: Array<Vertex>) {        
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
