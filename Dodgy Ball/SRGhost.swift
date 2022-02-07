//
//  SRGhost.swift
//  Dodgy Ball
//
//  Created by Seth Rodgers on 5/25/15.
//  Copyright (c) 2015 Seth Rodgers. All rights reserved.
//

import Foundation
import SpriteKit

class SRGhost: SKShapeNode
{
    let screenSize = UIScreen.main.bounds
    
    var body: SKShapeNode!
    var leftEye: SKShapeNode!
    var rightEye: SKShapeNode!
    var leftPupil: SKShapeNode!
    var rightPupil: SKShapeNode!
    
    override init()
    {
        super.init()
        
        let screenWidth = screenSize.width
        
        //Body
        body = SKShapeNode(circleOfRadius: screenWidth / 10)
        body.position = CGPoint(x: self.frame.width, y: self.frame.height)
        body.fillColor = UIColor.red
        addChild(body)
        
        leftEye = SKShapeNode(circleOfRadius: screenWidth / 35)
        leftEye.position = CGPoint(x: -15, y: 0)
        leftEye.fillColor = UIColor.white
        body.addChild(leftEye)
        
        rightEye = leftEye.copy() as! SKShapeNode
        rightEye.position = CGPoint(x: 15, y: 0)
        body.addChild(rightEye)
        
        leftPupil = SKShapeNode(circleOfRadius: screenWidth / 60)
        leftPupil.position = CGPoint(x: self.frame.width, y: self.frame.height)
        leftPupil.fillColor = UIColor.black
        leftEye.addChild(leftPupil)
        
        rightPupil = leftPupil.copy() as! SKShapeNode
        rightEye.addChild(rightPupil)
        
    }
    
    func blink()
    {
        let blinkOneLeft = SKAction.run{self.leftPupil.isHidden = true}
        let blinkLeftTwo = SKAction.run{self.leftPupil.isHidden = false}
        let blinkRightOne = SKAction.run{self.rightPupil.isHidden = true}
        let blinkRightTwo = SKAction.run{self.rightPupil.isHidden = false}
        let blinkOne = SKAction.sequence([blinkOneLeft, blinkRightOne])
        let blinkTwo = SKAction.sequence([blinkLeftTwo, blinkRightTwo])
        let waitOne = SKAction.wait(forDuration: 0.05)
        let waitTwo = SKAction.wait(forDuration: 2)
        let sequence = SKAction.sequence([blinkOne, waitOne, blinkTwo, waitTwo])
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
