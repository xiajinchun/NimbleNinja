//
//  NNWallGenerator.swift
//  NimbleNinja
//
//  Created by Jinchun Xia on 15/4/14.
//  Copyright (c) 2015 TEAM. All rights reserved.
//

import Foundation
import SpriteKit

class NNWallGenerator: SKSpriteNode {
    
    var generationTiemr: NSTimer?
    var walls = [NNWall]()
    
    func startGeneratingWallsEvery(seconds: NSTimeInterval) {
        generationTiemr = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generateWall", userInfo: nil, repeats: true)
    }
    
    func generateWall() {
        var scale: CGFloat
        var rand = arc4random_uniform(2)
        if rand == 0 {
            scale = -1.0
        } else {
            scale = 1.0
        }
        
        let wall = NNWall()
        wall.position.x = size.width / 2 + wall.size.width / 2
        wall.position.y = scale * (kMLGroundHeight / 2 + wall.size.height / 2)
        walls.append(wall)
        addChild(wall)
    }
    
    func stopGenerating() {
        generationTiemr?.invalidate()
    }
    
    func stopWalls() {
        stopGenerating()
        for wall in walls {
            wall.stopMoving()
        }
    }
}