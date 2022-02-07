//
//  MenuScene.swift
//  Dodgy Ball
//
//  Created by Seth Rodgers on 5/27/15.
//  Copyright (c) 2015 Seth Rodgers. All rights reserved.
//

import UIKit
import GameKit
import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate
{
    let screenSize = UIScreen.main.bounds
    
    var dbLabel: SKLabelNode!
    
    var playButton: SKShapeNode!
    var playText: SKLabelNode!
    let playCategoryName = "play"
    var fingerIsOnPlay = false
    
    var audioButton: SKShapeNode!
    var audioText: SKLabelNode!
    let audioCategoryName = "audio"
    var fingerIsOnAudio = false
    var audioOn = true
    
    var scoresButton: SKShapeNode!
    var scoresText: SKLabelNode!
    let scoresCategoryName = "scores"
    
    var playCount = 0
    let defaults = UserDefaults.standard
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        defaults.setValue(playCount, forKey: "playCount")
        audioOn = defaults.bool(forKey: "audio")
        
        //Background color
        self.backgroundColor = UIColor(red: 130.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //DB label
        dbLabel = SKLabelNode(fontNamed: "Blockt")
        dbLabel.text = "Dodgy Ball"
        dbLabel.fontSize = screenHeight / 12
        dbLabel.fontColor = UIColor.white
        dbLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.3)
        addChild(dbLabel)
        
        //Play button
        let pbWidth = screenWidth/2.65
        let pbHeight = screenHeight/8
        playButton = SKShapeNode(rect: CGRect(x: -pbWidth/2, y: -pbHeight*0.35, width: pbWidth, height: pbHeight), cornerRadius: pbHeight/6)
        playButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        playButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        playButton.name = playCategoryName
        addChild(playButton)
        
        //Play text
        playText = SKLabelNode(fontNamed: "Blockt")
        playText.text = "Play"
        playText.fontSize = screenHeight / 13
        playText.fontColor = UIColor.white
        playText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        addChild(playText)
        
        //Scores button
        let sbWidth = screenWidth/2.25
        let sbHeight = screenHeight/8
        scoresButton = SKShapeNode(rect: CGRect(x: -sbWidth/2, y: -pbHeight*1.5, width: sbWidth, height: pbHeight), cornerRadius: pbHeight/6)
        scoresButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        scoresButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        scoresButton.name = "scores"
        addChild(scoresButton)
        
        //Scores text
        scoresText = SKLabelNode(fontNamed: "Blockt")
        scoresText.text = "Scores"
        scoresText.fontSize = screenHeight / 15
        scoresText.fontColor = UIColor.white
        scoresText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2.8)
        addChild(scoresText)
        
        //Audio button
        let abWidth = screenWidth/1.5
        let abHeight = screenHeight/9
        audioButton = SKShapeNode(rect: CGRect(x: -abWidth/2, y: -abHeight*2.85, width: abWidth, height: abHeight), cornerRadius: abHeight/6)
        audioButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        audioButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        audioButton.name = "audio"
        addChild(audioButton)
        
        //Audio text
        audioText = SKLabelNode(fontNamed: "Blockt")
        if(defaults.bool(forKey: "audio") == true)
        {
            audioText.text = "Sounds: On"
        }
        else
        {
            audioText.text = "Sounds: Off"
        }
        audioText.fontSize = screenHeight / 16
        audioText.fontColor = UIColor.white
        audioText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/4.45)
        addChild(audioText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //Track touch
        let touch = touches.first as UITouch!
        let touchLocation = touch!.location(in: self)
        
        playCount = defaults.integer(forKey: "playCount")
        playCount += 1
        defaults.setValue(playCount, forKey: "playCount")
        
        //Change scene when play button touched
        if playButton.contains(touchLocation)
        {
            print("Play button touched")
            fingerIsOnPlay = true
            playButton.fillColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        }
        //Show game center leaderboard
        if scoresButton.contains(touchLocation)
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showLeaderboard"), object: nil)
            
        }
        //Turn audio on and off
        if audioButton.contains(touchLocation)
        {
            audioButton.fillColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            fingerIsOnAudio = true
            
            if audioOn == false
            {
                audioOn = true
                audioText.text = "Sounds: On"
                print("Audio button pressed")
                defaults.set(audioOn, forKey: "audio")
            }
            else
            {
                audioOn = false
                audioText.text = "Sounds: Off"
                print("Audio button pressed")
                defaults.set(audioOn, forKey: "audio")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if fingerIsOnPlay
        {
            playButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            let scene = GameScene(size: self.view!.bounds.size)
            self.view?.presentScene(scene)
            fingerIsOnPlay = false
        }
        if fingerIsOnAudio
        {
            audioButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            fingerIsOnAudio = false
        }
        print("Play count: \(playCount)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





