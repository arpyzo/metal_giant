import simd

extension float4x4 {
    init() {
        self = matrix_identity_float4x4
    }
    
    static func numberOfElements() -> Int {
        return 16
    }
    
    static func degrees(toRad angle: Float) -> Float {
        return Float(Double(angle) * .pi / 180)
    }
  
    static func makeScale(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let rows = [
            simd_float4( x,       0, 0, 0),
            simd_float4( 0, y, 0, 0),
            simd_float4( 0, 0,  z, 0),
            simd_float4( 0, 0,  0, 1.0)
        ]
        
        let scaleMatrix = float4x4(rows: rows)

        return scaleMatrix
    }
    
    mutating func makeRotationMatrixX(x: Float, y: Float, z: Float) {
        let rows = [
            simd_float4( 1.0,       0, 0, 0),
            simd_float4( 0, cos(x), -sin(x), 0),
            simd_float4( 0, sin(x),  cos(x), 0),
            simd_float4( 0, 0,  0, 1.0)
        ]
        
        let rotationMatrix = float4x4(rows: rows)
        
        self = self * rotationMatrix
    }
    
    mutating func makeRotationMatrixY(x: Float, y: Float, z: Float) {
        let rows = [
            simd_float4( cos(y),       0, sin(y), 0),
            simd_float4( 0, 1, 0, 0),
            simd_float4( -sin(y),  0, cos(y), 0),
            simd_float4( 0, 0,  0, 1.0)
        ]
        
        let rotationMatrix = float4x4(rows: rows)
        
        self = self * rotationMatrix
    }
    
    mutating func makeRotationMatrixZ(x: Float, y: Float, z: Float) {
        let rows = [
            simd_float4( cos(z),       -sin(z), Float(0), Float(0)),
            simd_float4( sin(z),  cos(z), Float(0), Float(0)),
            simd_float4(0.0, 0, 1.0, 0),
            simd_float4( 0, 0,  0, 1.0)
        ]
        
        let rotationMatrix = float4x4(rows: rows)
        
        self = self * rotationMatrix
    }


    
    mutating func translate(x: Float, y: Float, z: Float) {
        self = self * makeTranslationMatrix(x, y, z)
    }
    
    func makeTranslationMatrix(_ tx: Float, _ ty: Float, _ tz: Float) -> simd_float4x4 {
        var matrix = matrix_identity_float4x4
                
        matrix[3, 0] = tx
        matrix[3, 1] = ty
        matrix[3, 2] = tz

        return matrix
    }
    
    static func makePerspectiveViewAngle(fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> float4x4 {
        
        let cotan = 1.0 / tanf(fovyRadians / 2.0);
        
        let rows = [
            simd_float4( cotan / aspectRatio, 0.0, 0.0, 0.0),
            simd_float4( 0.0, cotan, 0.0, 0.0),
            simd_float4(0.0, 0.0, (farZ + nearZ) / (nearZ - farZ), (2.0 * farZ * nearZ) / (nearZ - farZ)),
            simd_float4( 0.0, 0.0, -1.0, 0.0)
        ]
        
        var q = float4x4(rows: rows)
        
        let zs = farZ / (nearZ - farZ)
        q[2][2] = zs
        q[3][2] = zs * nearZ
        return q
    }
    
    mutating func scale(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeScale(x, y, z)
    }
}

// GL functions
/*
func getGLRot(_ matrix: GLKMatrix4) -> float4x4 {
    return float4x4(columns: (float4(x: matrix.m00, y: matrix.m01, z: matrix.m02, w: matrix.m03),
                              float4(x: matrix.m10, y: matrix.m11, z: matrix.m12, w: matrix.m13),
                              float4(x: matrix.m20, y: matrix.m21, z: matrix.m22, w: matrix.m23),
                              float4(x: matrix.m30, y: matrix.m31, z: matrix.m32, w: matrix.m33)))
}
 
static func makeFrustum(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeFrustum(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
}
 
static func makeOrtho(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeOrtho(left, right, bottom, top, nearZ, farZ), to: float4x4.self)
}
 
static func makeLookAt(eyeX: Float, eyeY: Float, eyeZ: Float, centerX: Float, centerY: Float, centerZ: Float, upX: Float, upY: Float, upZ: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ), to: float4x4.self)
}
 
static func makeTranslation(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return unsafeBitCast(GLKMatrix4MakeTranslation(x, y, z), to: float4x4.self)
}
 
mutating func multiplyLeft(matrix: float4x4) {
    let glMatrix1 = unsafeBitCast(matrix, to: GLKMatrix4.self)
    let glMatrix2 = unsafeBitCast(self, to: GLKMatrix4.self)
    let result = GLKMatrix4Multiply(glMatrix1, glMatrix2)
    self = unsafeBitCast(result, to: float4x4.self)
}
 
func multiplyLeftCopy(matrix: float4x4) -> float4x4 {
    var copy = self
    let glMatrix1 = unsafeBitCast(matrix, to: GLKMatrix4.self)
    let glMatrix2 = unsafeBitCast(self, to: GLKMatrix4.self)
    let result = GLKMatrix4Multiply(glMatrix1, glMatrix2)
    copy = unsafeBitCast(result, to: float4x4.self)
    return copy
}
*/
