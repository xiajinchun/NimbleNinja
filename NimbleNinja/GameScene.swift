//
//  GameScene.swift
//  NimbleNinja
//
//  Created by Jinchun Xia on 15/4/14.
//  Copyright (c) 2015 TEAM. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var movingGround: NNMovingGround!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        /* add ground */
        movingGround = NNMovingGround(size: CGSizeMake(view.frame.width, kMLGroundHeight))
        movingGround.position = CGPointMake(0, view.frame.size.height / 2)
        self.addChild(movingGround)

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
