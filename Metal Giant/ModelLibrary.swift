import MetalKit

struct ModelMesh {
    var vertices: Array<Vertex>!
    var vertexData: Array<Float>!
    var vertexCount: Int!
}

struct ModelTexture {
    var texture: MTLTexture!
}

class ModelLibrary {
    var metalDevice: MTLDevice
    
    var meshes: [String: ModelMesh] = [:]
    var textures: [String: ModelTexture] = [:]
    
    // TODO: preload models?
    // TODO: performance - minimize copying
    init(_ metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        
        // Front
        /*let A = Vertex(x: -1.0, y:  1.0, z:  1.0, tx: 0.25, ty: 0.25, nx:  0.0, ny:  0.0, nz:  1.0)
        let B = Vertex(x: -1.0, y: -1.0, z:  1.0, tx: 0.25, ty: 0.50, nx:  0.0, ny:  0.0, nz:  1.0)
        let C = Vertex(x:  1.0, y: -1.0, z:  1.0, tx: 0.50, ty: 0.50, nx:  0.0, ny:  0.0, nz:  1.0)
        let D = Vertex(x:  1.0, y:  1.0, z:  1.0, tx: 0.50, ty: 0.25, nx:  0.0, ny:  0.0, nz:  1.0)
        
        // Left
        let E = Vertex(x: -1.0, y:  1.0, z: -1.0, tx: 0.00, ty: 0.25, nx: -1.0, ny:  0.0, nz:  0.0)
        let F = Vertex(x: -1.0, y: -1.0, z: -1.0, tx: 0.00, ty: 0.50, nx: -1.0, ny:  0.0, nz:  0.0)
        let G = Vertex(x: -1.0, y: -1.0, z:  1.0, tx: 0.25, ty: 0.50, nx: -1.0, ny:  0.0, nz:  0.0)
        let H = Vertex(x: -1.0, y:  1.0, z:  1.0, tx: 0.25, ty: 0.25, nx: -1.0, ny:  0.0, nz:  0.0)
        
        // Right
        let I = Vertex(x:  1.0, y:  1.0, z:  1.0, tx: 0.50, ty: 0.25, nx:  1.0, ny:  0.0, nz:  0.0)
        let J = Vertex(x:  1.0, y: -1.0, z:  1.0, tx: 0.50, ty: 0.50, nx:  1.0, ny:  0.0, nz:  0.0)
        let K = Vertex(x:  1.0, y: -1.0, z: -1.0, tx: 0.75, ty: 0.50, nx:  1.0, ny:  0.0, nz:  0.0)
        let L = Vertex(x:  1.0, y:  1.0, z: -1.0, tx: 0.75, ty: 0.25, nx:  1.0, ny:  0.0, nz:  0.0)
        
        // Top
        let M = Vertex(x: -1.0, y:  1.0, z: -1.0, tx: 0.25, ty: 0.00, nx:  0.0, ny:  1.0, nz:  0.0)
        let N = Vertex(x: -1.0, y:  1.0, z:  1.0, tx: 0.25, ty: 0.25, nx:  0.0, ny:  1.0, nz:  0.0)
        let O = Vertex(x:  1.0, y:  1.0, z:  1.0, tx: 0.50, ty: 0.25, nx:  0.0, ny:  1.0, nz:  0.0)
        let P = Vertex(x:  1.0, y:  1.0, z: -1.0, tx: 0.50, ty: 0.00, nx:  0.0, ny:  1.0, nz:  0.0)
        
        // Bottom
        let Q = Vertex(x: -1.0, y: -1.0, z:  1.0, tx: 0.25, ty: 0.50, nx:  0.0, ny: -1.0, nz:  0.0)
        let R = Vertex(x: -1.0, y: -1.0, z: -1.0, tx: 0.25, ty: 0.75, nx:  0.0, ny: -1.0, nz:  0.0)
        let S = Vertex(x:  1.0, y: -1.0, z: -1.0, tx: 0.50, ty: 0.75, nx:  0.0, ny: -1.0, nz:  0.0)
        let T = Vertex(x:  1.0, y: -1.0, z:  1.0, tx: 0.50, ty: 0.50, nx:  0.0, ny: -1.0, nz:  0.0)
        
        // Back
        let U = Vertex(x:  1.0, y:  1.0, z: -1.0, tx: 0.75, ty: 0.25, nx:  0.0, ny:  0.0, nz: -1.0)
        let V = Vertex(x:  1.0, y: -1.0, z: -1.0, tx: 0.75, ty: 0.50, nx:  0.0, ny:  0.0, nz: -1.0)
        let W = Vertex(x: -1.0, y: -1.0, z: -1.0, tx: 1.00, ty: 0.50, nx:  0.0, ny:  0.0, nz: -1.0)
        let X = Vertex(x: -1.0, y:  1.0, z: -1.0, tx: 1.00, ty: 0.25, nx:  0.0, ny:  0.0, nz: -1.0)*/
        
        // Front
        let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.25, nx: 0.0, ny: 0.0, nz: 1.0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.50, nx: 0.0, ny: 0.0, nz: 1.0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.50, ty: 0.50, nx: 0.0, ny: 0.0, nz: 1.0)
        let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 0.50, ty: 0.25, nx: 0.0, ny: 0.0, nz: 1.0)
        
        // Left
        let E = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.00, ty: 0.25, nx: -1.0, ny: 0.0, nz: 0.0)
        let F = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.00, ty: 0.50, nx: -1.0, ny: 0.0, nz: 0.0)
        let G = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.25, ty: 0.50, nx: -1.0, ny: 0.0, nz: 0.0)
        let H = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 0.25, ty: 0.25, nx: -1.0, ny: 0.0, nz: 0.0)
        
        // Right
        let I = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.50, ty: 0.25, nx: 1.0, ny: 0.0, nz: 0.0)
        let J = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.50, ty: 0.50, nx: 1.0, ny: 0.0, nz: 0.0)
        let K = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.75, ty: 0.50, nx: 1.0, ny: 0.0, nz: 0.0)
        let L = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 0.75, ty: 0.25, nx: 1.0, ny: 0.0, nz: 0.0)
        
        // Top
        let M = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.00, nx: 0.0, ny: 1.0, nz: 0.0)
        let N = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.25, nx: 0.0, ny: 1.0, nz: 0.0)
        let O = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.50, ty: 0.25, nx: 0.0, ny: 1.0, nz: 0.0)
        let P = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 0.50, ty: 0.00, nx: 0.0, ny: 1.0, nz: 0.0)
        
        // Bottom
        let Q = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.50, nx: 0.0, ny: -1.0, nz: 0.0)
        let R = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.25, ty: 0.75, nx: 0.0, ny: -1.0, nz: 0.0)
        let S = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.50, ty: 0.75, nx: 0.0, ny: -1.0, nz: 0.0)
        let T = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 0.50, ty: 0.50, nx: 0.0, ny: -1.0, nz: 0.0)
        
        // Back
        let U = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.75, ty: 0.25, nx: 0.0, ny: 0.0, nz: -1.0)
        let V = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 0.75, ty: 0.50, nx: 0.0, ny: 0.0, nz: -1.0)
        let W = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 1.00, ty: 0.50, nx: 0.0, ny: 0.0, nz: -1.0)
        let X = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, tx: 1.00, ty: 0.25, nx: 0.0, ny: 0.0, nz: -1.0)
        
        meshes["cube"] = ModelMesh()
        meshes["cube"]!.vertices = [
            A,B,C, A,C,D,   // Front
            E,F,G, E,G,H,   // Left
            I,J,K, I,K,L,   // Right
            M,N,O, M,O,P,   // Top
            Q,R,S, Q,S,T,   // Bottom
            U,V,W, U,W,X    // Back
        ]
        
        // TODO: replace with model I/O
        meshes["cube"]!.vertexData = Array<Float>()
        for vertex in meshes["cube"]!.vertices {
            meshes["cube"]!.vertexData += vertex.floatBuffer()
        }
        meshes["cube"]!.vertexCount = meshes["cube"]!.vertices.count

        let textureLoader = MTKTextureLoader(device: metalDevice)
        let path = Bundle.main.path(forResource: "cube", ofType: "png")!
        
        // TODO: move texture loading into ModelTexture init
        textures["cube"] = ModelTexture()
        textures["cube"]!.texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
    }
    
    func makeNode(_ nameName: String) -> Node {
        return Node(meshes["cube"]!, textures["cube"]!)
    }
}
