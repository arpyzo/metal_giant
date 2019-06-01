import simd
import GLKit

extension float4x4 {
    init() {
      self = unsafeBitCast(GLKMatrix4Identity, to: float4x4.self)
    }
    
    static func numberOfElements() -> Int {
        return 16
    }
    
    static func degrees(toRad angle: Float) -> Float {
        return Float(Double(angle) * .pi / 180)
    }
  
    static func makeScale(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeScale(x, y, z), to: float4x4.self)
    }
  
    static func makeRotate(_ radians: Float, _ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeRotation(radians, x, y, z), to: float4x4.self)
    }
  
    static func makeTranslation(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        return unsafeBitCast(GLKMatrix4MakeTranslation(x, y, z), to: float4x4.self)
    }
  
    static func makePerspectiveViewAngle(fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> float4x4 {
        var q = unsafeBitCast(GLKMatrix4MakePerspective(fovyRadians, aspectRatio, nearZ, farZ), to: float4x4.self)
        let zs = farZ / (nearZ - farZ)
        q[2][2] = zs
        q[3][2] = zs * nearZ
        return q
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
  
    mutating func scale(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeScale(x, y, z)
    }
  
    mutating func rotate(radians: Float, x: Float, y: Float, z: Float) {
        self = float4x4.makeRotate(radians, x, y, z) * self
    }
  
    mutating func rotateAroundX(x: Float, y: Float, z: Float) {
        var rotationM = float4x4.makeRotate(x, 1, 0, 0)
        rotationM = rotationM * float4x4.makeRotate(y, 0, 1, 0)
        rotationM = rotationM * float4x4.makeRotate(z, 0, 0, 1)
        self = self * rotationM
    }
  
    mutating func translate(x: Float, y: Float, z: Float) {
        self = self * float4x4.makeTranslation(x, y, z)
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

}
