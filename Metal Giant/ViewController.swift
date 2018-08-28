//
//  ViewController.swift
//  Metal Giant
//
//  Created by Robert Pyzalski on 8/19/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {
    var metalDevice: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!

    var objectToDraw: Triangle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        metalDevice = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = metalDevice           // 2
        //metalLayer.pixelFormat = .bgra8Unorm // 3
        //metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        
        objectToDraw = Triangle(device: metalDevice)
        
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
        
        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
    }
    
    @objc func gameloop() {
        autoreleasepool {
            //self.render()
            render()
        }
    }

}

