//
//  Vertex.swift
//  Metal Giant
//
//  Created by Robert Pyzalski on 8/27/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    var s,t: Float       // texture coordinates
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a,s,t]
    }
    
}
