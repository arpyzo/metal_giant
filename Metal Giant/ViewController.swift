import UIKit
import MetalKit
import simd

class ViewController: UIViewController {
    var metalDevice: MTLDevice!
    var mtkView: MTKView!
    var modelLibrary: ModelLibrary!
    var scene: Scene!
    var renderer: Renderer!
    
    let panSensivity: Float = 5.0
    var lastPanLocation: CGPoint!
    
    override func loadView() {
        self.view = MTKView()
        mtkView = (self.view as! MTKView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        metalDevice = MTLCreateSystemDefaultDevice()
        mtkView.device = metalDevice
        
        renderer = Renderer(metalDevice)
        mtkView.delegate = renderer
        
        modelLibrary = ModelLibrary(metalDevice)
        scene = Scene(metalDevice, modelLibrary, Float(self.view.bounds.size.width / self.view.bounds.size.height))
        renderer.scene = scene
        
        setupGestures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupGestures() {
        let panHandler = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panHandler))
        self.view.addGestureRecognizer(panHandler)
    }
    
    @objc func panHandler(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == UIGestureRecognizer.State.changed {
            let pointInView = panGesture.location(in: self.view)
            
            let xDelta = Float((lastPanLocation.x - pointInView.x) / self.view.bounds.width) * panSensivity
            let yDelta = Float((lastPanLocation.y - pointInView.y) / self.view.bounds.height) * panSensivity
                        
            renderer.scene.viewProjectionMatrix.rotateAroundX(x: xDelta)
            renderer.scene.viewProjectionMatrix.rotateAroundY(y: yDelta)

            lastPanLocation = pointInView
        } else if panGesture.state == UIGestureRecognizer.State.began {
            lastPanLocation = panGesture.location(in: self.view)
        }
    }
    
    /*func updateWithDelta(delta: CFTimeInterval) {
     time += delta
     }
     
     func updateWithDelta(delta: CFTimeInterval) {
     super.updateWithDelta(delta: delta)
     
     let secsPerMove: Float = 6.0
     rotationY = sinf( Float(time) * 2.0 * .pi / secsPerMove)
     rotationX = sinf( Float(time) * 2.0 * .pi / secsPerMove)
     }*/
}
