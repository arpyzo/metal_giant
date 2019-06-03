struct Vertex {
    var x, y, z: Float     // position
    var r, g, b, a: Float  // color
    var tx, ty: Float      // texture coordinates
    var nx, ny, nz: Float  // normal for lighting
    
    func floatBuffer() -> [Float] {
        //return [x, y, z, tx, ty, nx, ny, nz]
        return [x, y, z, r, g, b, a, tx, ty, nx, ny, nz]
    }
}
