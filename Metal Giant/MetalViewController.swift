//
//  ViewController.swift
//  Metal Giant
//
//  Created by Robert Pyzalski on 8/19/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import MetalKit
import simd

protocol MetalViewControllerDelegate : class {
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(drawable: CAMetalDrawable)
}

class MetalViewController: UIViewController {
    var metalDevice: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    var textureLoader: MTKTextureLoader! = nil

    //var objectToDraw: Triangle!
    //var objectToDraw: Cube!
    //var objectToDraw: Node!
    
    var projectionMatrix: float4x4!
    
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        metalDevice = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = metalDevice           // 2
        textureLoader = MTKTextureLoader(device: metalDevice)

        //metalLayer.pixelFormat = .bgra8Unorm // 3
        //metalLayer.framebufferOnly = true    // 4
        //metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        
        projectionMatrix = float4x4.makePerspectiveViewAngle(
            float4x4.degrees(toRad: 85.0),
            aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height),
            nearZ: 0.01,
            farZ: 100.0
        )
        
        //objectToDraw = Triangle(device: metalDevice)
        //objectToDraw = Cube(device: metalDevice)
        
        //objectToDraw.positionX = 0.0
        //objectToDraw.positionY =  0.0
        //objectToDraw.positionZ = -2.0
        //objectToDraw.rotationZ = Matrix4.degrees(toRad: 45);
        //objectToDraw.scale = 0.5
        
        /*objectToDraw.positionX = -0.25
        objectToDraw.positionY =  0.25
        objectToDraw.positionZ = -0.25
        objectToDraw.rotationZ = Matrix4.degrees(toRad: 45)
        objectToDraw.scale = 0.5*/


        // Try bytesNoCopy
        // Investigate buffer persistence
        
        // 1
        let defaultLibrary = metalDevice.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        timer = CADisplayLink(target: self, selector: #selector(MetalViewController.newFrame(displayLink:)))
        
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let window = view.window {
            let scale = window.screen.nativeScale
            let layerSize = view.bounds.size
            //2
            view.contentScaleFactor = scale
            metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
            metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
            
            projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        
        /*let worldModelMatrix = Matrix4() // now float4x4
        worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix ,clearColor: nil)
        */
        
        self.metalViewControllerDelegate?.renderObjects(drawable: drawable)
    }
    
    // 1
    @objc func newFrame(displayLink: CADisplayLink) {
        
        if lastFrameTimestamp == 0.0
        {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        // 2
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        // 3
        gameloop(timeSinceLastUpdate: elapsed)
    }
    
    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
        //self.metalViewControllerDelegate?.updateLogic(timeSinceLastUpdate: timeSinceLastUpdate)
        // 4
        //objectToDraw.updateWithDelta(delta: timeSinceLastUpdate)
        
        // 5
        autoreleasepool {
            self.render()
        }
    }
}

