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
    
    static func makeTranslationMatrix(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let translationMatrix = float4x4([
            float4(1, 0, 0, 0),
            float4(0, 1, 0, 0),
            float4(0, 0, 1, 0),
            float4(x, y, z, 1)
        ]);
        
        return translationMatrix
    }
    
    mutating func translate(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeTranslationMatrix(x, y, z)
    }

    static func makeXRotationMatrix(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let rotationMatrix = float4x4([
            float4(1,       0,      0, 0),
            float4(0,  cos(x), sin(x), 0),
            float4(0, -sin(x), cos(x), 0),
            float4(0,       0,      0, 1)
        ]);
        
        return rotationMatrix
    }
    
    mutating func rotateAroundX(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeXRotationMatrix(x, y, z)
    }

    static func makeYRotationMatrix(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let rotationMatrix = float4x4([
            float4(cos(y), 0, -sin(y), 0),
            float4(     0, 1,       0, 0),
            float4(sin(y), 0,  cos(y), 0),
            float4(     0, 0,       0, 1)
        ]);
        
        return rotationMatrix
    }

    mutating func rotateAroundY(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeYRotationMatrix(x, y, z)
    }

    static func makeZRotationMatrix(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let rotationMatrix = float4x4([
            float4( cos(z), sin(z), 0, 0),
            float4(-sin(z), cos(z), 0, 0),
            float4(      0,      0, 1, 0),
            float4(      0,      0, 0, 1)
        ]);
        
        return rotationMatrix
    }

    mutating func rotateAroundZ(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeZRotationMatrix(x, y, z)
    }

    static func makeScalingMatrix(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        let scalingMatrix = float4x4([
            float4(x, 0, 0, 0),
            float4(0, y, 0, 0),
            float4(0, 0, z, 0),
            float4(0, 0, 0, 1)
        ]);
        
        return scalingMatrix
    }
    
    mutating func scale(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeScalingMatrix(x, y, z)
    }
    
    static func makeProjectionMatrix(fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> float4x4 {
        
        let scale = 1.0 / tanf(fovyRadians / 2.0);
        
        let projectionMatrix = float4x4([
            float4(scale / aspectRatio,     0,                               0,  0),
            float4(                  0, scale,                               0,  0),
            float4(                  0,     0,           farZ / (nearZ - farZ), -1),
            float4(                  0,     0, (farZ * nearZ) / (nearZ - farZ),  0)
        ]);
        
        return projectionMatrix
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
