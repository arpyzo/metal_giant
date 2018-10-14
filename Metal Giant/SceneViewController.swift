//
//  SceneViewController.swift
//  Metal Giant
//
//  Created by Robert Pyzalski on 9/9/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import simd

class SceneViewController: MetalViewController, MetalViewControllerDelegate {
    let panSensivity:Float = 5.0
    var lastPanLocation: CGPoint!

    
    var worldModelMatrix: float4x4!
    var objectToDraw: Cube!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worldModelMatrix = float4x4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(float4x4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        objectToDraw = Cube(device: metalDevice, commandQ:commandQueue, textureLoader: textureLoader)
        self.metalViewControllerDelegate = self
        
        setupGestures()
    }
    
    //MetalViewControllerDelegate calls this:
    func renderObjects(drawable:CAMetalDrawable) {
        
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
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
