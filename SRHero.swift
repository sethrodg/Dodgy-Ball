//
//  SRHero.swift
//  Dodgy Ball
//
//  Created by Seth Rodgers on 5/25/15.
//  Copyright (c) 2015 Seth Rodgers. All rights reserved.
//

import Foundation
import SpriteKit

class SRHero: SKShapeNode
{
    let screenSize = UIScreen.main.bounds
    
    var body: SKShapeNode!
    var leftEye: SKShapeNode!
    var rightEye: SKShapeNode!
    var leftPupil: SKShapeNode!
    var rightPupil: SKShapeNode!
    var bodyRad: CGFloat!

    override init()
    {
        super.init()
        
        let screenWidth = screenSize.width
        bodyRad = screenWidth / 10
        
        //Body
        body = SKShapeNode(circleOfRadius: bodyRad)
        body.position = CGPoint(x: self.frame.width, y: self.frame.height)
        body.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        addChild(body)
        
        //Eyes
        leftEye = SKShapeNode(circleOfRadius: screenWidth / 35)
        leftEye.position = CGPoint(x: 0, y: 0)
        leftEye.fillColor = UIColor.white
        body.addChild(leftEye)
        
//        rightEye = leftEye.copy() as! SKShapeNode
//        rightEye.position = CGPointMake(15, 10)
//        body.addChild(rightEye)
        
        //Pupils
        leftPupil = SKShapeNode(circleOfRadius: screenWidth / 60)
        leftPupil.position = CGPoint(x: 0, y: 0)
        leftPupil.fillColor = UIColor.black
        leftEye.addChild(leftPupil)
        
//        rightPupil = leftPupil.copy() as! SKShapeNode
//        rightEye.addChild(rightPupil)
    }
    
    func blink()
    {
        let blinkOne = SKAction.run{self.leftPupil.isHidden = true}
        let blinkTwo = SKAction.run{self.leftPupil.isHidden = false}
        let waitOne = SKAction.wait(forDuration: 0.05)
        let waitTwo = SKAction.wait(forDuration: 2.5)
        let sequence = SKAction.sequence([waitTwo, blinkOne, waitOne, blinkTwo])
        let runBlink = SKAction.repeatForever(sequence)
        run(runBlink, withKey: "runBlink")
    }
    
    func stopBlink()
    {
        removeAction(forKey: "runBlink")
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
