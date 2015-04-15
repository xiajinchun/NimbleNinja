//
//  GameScene.swift
//  NimbleNinja
//
//  Created by Jinchun Xia on 15/4/14.
//  Copyright (c) 2015 TEAM. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingGround: NNMovingGround!
    var hero: NNHero!
    var cloudGenerator: NNCloudGenerator!
    var wallGenerator: NNWallGenerator!
    
    var isStarted = false
    var isGameOver = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        /* add ground */
        addMovingGround()
        
        /* add hero */
        addHero()

        /* add cloud generator */
        addCloudGenerator()
        
        /* add wall generator */
        addWallGenerator()
        
        /* add start label */
        addTapToStartLabel()
        
        /* add physics world */
        addPhysicsWorld()
    }
    
    func addMovingGround() {
        movingGround = NNMovingGround(size: CGSizeMake(view!.frame.width, kMLGroundHeight))
        movingGround.position = CGPointMake(0, view!.frame.size.height / 2)
        self.addChild(movingGround)
    }
    
    func addHero() {
        hero = NNHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height / 2 + hero.frame.size.height / 2)
        self.addChild(hero)
        hero.breath()
    }
    
    func addCloudGenerator() {
        cloudGenerator = NNCloudGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        cloudGenerator.position = view!.center
        cloudGenerator.zPosition = -10
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(5)
    }
    
    func addWallGenerator() {
        wallGenerator = NNWallGenerator(color: UIColor.clearColor(), size: view!.frame.size)
        wallGenerator.position = view!.center
        addChild(wallGenerator)
    }
    
    func addTapToStartLabel() {
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 40
        tapToStartLabel.fontName = "Helvetice"
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = 22.0
        addChild(tapToStartLabel)
        tapToStartLabel.runAction(blinkAnimation())
    }
    
    func addPhysicsWorld() {
        physicsWorld.contactDelegate = self
    }
    
    // MARK: - Game Lifecycle
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
    
    func gameOver() {
        isGameOver = true
        
        // stop everthing
        hero.fail()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        
        // create game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = "Helvetice"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
        gameOverLabel.runAction(blinkAnimation())
    }
    
    func restart() {
        cloudGenerator.stopGenerating()
        
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        
        view!.presentScene(newScene)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if isGameOver {
            restart()
        } else if !isStarted {
            start()
        } else {
            hero.flip()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: - SKPhysiscContactDeleagte
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGameOver{
            gameOver()
        }
    }
    
    // MARK: - Animation
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: duration)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        
        return SKAction.repeatActionForever(blink)
    }
}
