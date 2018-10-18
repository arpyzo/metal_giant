import UIKit
import simd

class SceneViewController: MetalViewController, MetalViewControllerDelegate {
    let panSensivity: Float = 5.0
    var lastPanLocation: CGPoint!
    
    var projectionMatrix: float4x4!
    var worldModelMatrix: float4x4!
    var objectToDraw: Object!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metalViewControllerDelegate = self
        
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height),
            nearZ: 0.01, farZ: 100.0
        )

        worldModelMatrix = float4x4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        objectToDraw = Cube(metalDevice, commandQueue, textureLoader)
        
        setupGestures()
    }
    
    //MetalViewControllerDelegate calls this:
    func updateProjectionMatrix(newSize: CGSize) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            fovyRadians: float4x4.degrees(toRad: 85.0),
            aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height),
            nearZ: 0.01, farZ: 100.0
        )
    }
    
    //MetalViewControllerDelegate calls this:
    func renderObjects(drawable:CAMetalDrawable) {
        
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
    //MetalViewControllerDelegate calls this:
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
    }
    
    //MARK: - Gesture related
    // 1
    func setupGestures(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(SceneViewController.pan))
        self.view.addGestureRecognizer(pan)
    }
    
    // 2
    @objc func pan(panGesture: UIPanGestureRecognizer){
        if panGesture.state == UIGestureRecognizerState.changed {
            let pointInView = panGesture.location(in: self.view)
            // 3
            let xDelta = Float((lastPanLocation.x - pointInView.x)/self.view.bounds.width) * panSensivity
            let yDelta = Float((lastPanLocation.y - pointInView.y)/self.view.bounds.height) * panSensivity
            // 4
            objectToDraw.rotationY -= xDelta
            objectToDraw.rotationX -= yDelta
            lastPanLocation = pointInView
        } else if panGesture.state == UIGestureRecognizerState.began {
            lastPanLocation = panGesture.location(in: self.view)
        }
    }
}
