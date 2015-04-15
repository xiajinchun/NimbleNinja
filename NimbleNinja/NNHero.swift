//
//  NNHero.swift
//  NimbleNinja
//
//  Created by Jinchun Xia on 15/4/14.
//  Copyright (c) 2015 TEAM. All rights reserved.
//

import Foundation
import SpriteKit

class NNHero: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    
    var isUpsideDown = false
    
    init() {
        let size = CGSizeMake(32, 44)
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        
        loadAppearance()
        loadPhysicsBody(size)
    }
    
    func loadAppearance() {
        body = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, 40))
        body.position = CGPointMake(0, 2)
        body.zPosition = 10
        self.addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        let face  = SKSpriteNode(color: skinColor, size: CGSizeMake(self.frame.size.width, 12))
        face.position = CGPointMake(0, 7)
        body.addChild(face)
        
        let eyeColor = UIColor.whiteColor()
        let leftEye = SKSpriteNode(color: eyeColor, size: CGSizeMake(6, 6))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(3, 3))
        
        pupil.position = CGPointMake(2, 0)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPointMake(-4, 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPointMake(14, 0)
        face.addChild(rightEye)
        
        let eyebrow = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(11, 1))
        eyebrow.position = CGPointMake(-1, leftEye.size.height / 2)
        leftEye.addChild(eyebrow)
        rightEye.addChild(eyebrow.copy() as! SKSpriteNode)
        
        let armColor = UIColor(red: 46.0/255.0, green: 46.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        arm = SKSpriteNode(color: armColor, size: CGSizeMake(8, 14))
        arm.anchorPoint = CGPointMake(0.5, 0.9)
        arm.position = CGPointMake(-10, -7)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColor, size: CGSizeMake(arm.size.width, 5))
        hand.position = CGPointMake(0, -arm.size.height * 0.9 + hand.size.height / 2)
        arm.addChild(hand)
        
        leftFoot = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(9, 4))
        leftFoot.position = CGPointMake(-6, -size.height / 2 + leftFoot.size.height / 2)
        self.addChild(leftFoot)
        
        rightFoot = leftFoot.copy() as! SKSpriteNode
        rightFoot.position.x = 8
        self.addChild(rightFoot)
    }
    
    func loadPhysicsBody(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = wallCategory
        physicsBody?.affectedByGravity = false
    }
    
    func flip() {
        isUpsideDown = !isUpsideDown
        
        var scale: CGFloat!
        if isUpsideDown {
            scale = -1.0
        } else {
            scale = 1.0
        }
        
        let translate = SKAction.moveByX(0, y: scale*(size.height + kMLGroundHeight), duration: 0.1)
        let flip = SKAction.scaleYTo(scale, duration: 0.1)
        
        runAction(translate)
        runAction(flip)
    }
    
    func breath() {
        let breathOut = SKAction.moveByX(0, y: -2, duration: 1)
        let breathIn = SKAction.moveByX(0, y: 2, duration: 1)
        let breath = SKAction.sequence([breathOut, breathIn])
        body.runAction(SKAction.repeatActionForever(breath))
    }
    
    func startRuning() {
        let rotaeBack = SKAction.rotateByAngle(-CGFloat(M_PI)/2, duration: 0.1)
        arm.runAction(rotaeBack)
        performOneRunCycle()
    }
    
    func performOneRunCycle() {
        let up = SKAction.moveByX(0, y: 2, duration: 0.05)
        let down = SKAction.moveByX(0, y: -2, duration: 0.05)
        
        leftFoot.runAction(up, completion: { () -> Void in
            self.leftFoot.runAction(down)
            self.rightFoot.runAction(up, completion: { () -> Void in
                self.rightFoot.runAction(down, completion: { () -> Void in
                    self.performOneRunCycle()
                })
            })
        })
    }
    
    func stop() {
        body.removeAllActions()
        leftFoot.removeAllActions()
        rightFoot.removeAllActions()
    }
    
    func fail() {
        physicsBody?.affectedByGravity = true
        physicsBody?.applyImpulse(CGVectorMake(-5, 30))
        
        let rotateBack  = SKAction.rotateByAngle(CGFloat(M_PI) / 2, duration: 0.4)
        runAction(rotateBack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
