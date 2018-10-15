import UIKit
import MetalKit
import simd

protocol MetalViewControllerDelegate: class {
    func updateProjectionMatrix(newSize: CGSize)
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(drawable: CAMetalDrawable)
}

class MetalViewController: UIViewController {
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?
    
    @IBOutlet weak var mtkView: MTKView! {
        didSet {
            mtkView.delegate = self
            mtkView.preferredFramesPerSecond = 60
            mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }

    var metalDevice: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    
    //var lastFrameTimestamp: CFTimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalDevice = MTLCreateSystemDefaultDevice()
        mtkView.device = metalDevice

        let defaultLibrary = metalDevice.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        textureLoader = MTKTextureLoader(device: metalDevice)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func render(_ drawable: CAMetalDrawable?) {
        guard let drawable = drawable else { return }
        self.metalViewControllerDelegate?.renderObjects(drawable: drawable)
    }
    
    /*@objc func newFrame(displayLink: CADisplayLink) {
        if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        gameloop(timeSinceLastUpdate: elapsed)
    }
    
    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
        //self.metalViewControllerDelegate?.updateLogic(timeSinceLastUpdate: timeSinceLastUpdate)
        //objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
        
        autoreleasepool {
            self.render()
        }
    }*/
}

// MARK: - MTKViewDelegate
extension MetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.metalViewControllerDelegate?.updateProjectionMatrix(newSize: size)
    }
    
    func draw(in view: MTKView) {
        render(view.currentDrawable)
    }
}

