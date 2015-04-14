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
    var hero: NNHero!
    var cloudGenerator: NNCloudGenerator!
    var wallGenerator: NNWallGenerator!
    
    var isStarted = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        /* add ground */
        movingGround = NNMovingGround(size: CGSizeMake(view.frame.width, kMLGroundHeight))
        movingGround.position = CGPointMake(0, view.frame.size.height / 2)
        self.addChild(movingGround)
        
        /* add hero */
        hero = NNHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height / 2 + hero.frame.size.height / 2)
        self.addChild(hero)
        hero.breath()

        /* add cloud generator */
        cloudGenerator = NNCloudGenerator(color: UIColor.clearColor(), size: view.frame.size)
        cloudGenerator.position = view.center
        cloudGenerator.zPosition = -10
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
        
        /* add wall generator */
        wallGenerator = NNWallGenerator(color: UIColor.clearColor(), size: view.frame.size)
        wallGenerator.position = view.center
        addChild(wallGenerator)
    }
    
    func start() {
        isStarted = true
        
        /* find the ndoe by named "tapToStartLabel" and then remove it from parent node */
        let tapToStartLabel = childNodeWithName("tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        hero.stop()
        hero.startRuning()
        movingGround.start()
        
        wallGenerator.startGeneratingWallsEvery(1)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if !isStarted {
            start()
        } else {
            hero.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
