//
//  GameOverScene.swift
//  Dodgy Ball
//
//  Created by Seth Rodgers on 5/25/15.
//  Copyright (c) 2015 Seth Rodgers. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Social

class GameOverScene: SKScene
{
    let screenSize = UIScreen.main.bounds
    
    var gameOverText: SKLabelNode!
    
    var scoreBlock: SKShapeNode!
    var score: Int!
    var i = 0
    var scoreText: SKLabelNode!
    var bestScoreText: SKLabelNode!
    
    var replayButton: SKShapeNode!
    var replayText: SKLabelNode!
    var fingerIsOnReplay = false
    
    var menuButton: SKShapeNode!
    var menuText: SKLabelNode!
    var fingerIsOnMenu = false

    
    var tweetButton: SKShapeNode!
    var tweetText: SKLabelNode!
    
    let defaults = UserDefaults.standard
    
    var audioPlayer = AVAudioPlayer()
    
    
    override init(size: CGSize)
    {
        super.init(size: size)
    }
    
    override func didMove(to view: SKView)
    {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //Background Color
        self.backgroundColor = UIColor(red: 130.0/255.0, green: 205.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //Game over text
        gameOverText = SKLabelNode(fontNamed: "Blockt")
        gameOverText.text = "Game Over"
        gameOverText.fontSize = screenHeight / 12
        gameOverText.fontColor = UIColor.white
        gameOverText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.3)
        addChild(gameOverText)
        
        //Score block
        let sbWidth = screenWidth/1.6
        let sbHeight = screenHeight/5.5
        scoreBlock = SKShapeNode(rect: CGRect(x: -sbWidth/2, y: sbHeight/8, width: sbWidth, height: sbHeight), cornerRadius: sbHeight/6)
        scoreBlock.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        scoreBlock.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        addChild(scoreBlock)
        
        //Score text
        scoreText = SKLabelNode(fontNamed: "Blockt")
        scoreText.text = "Score: 0"
        scoreText.fontSize = screenHeight / 16
        scoreText.fontColor = UIColor.white
        scoreText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.57)
        addChild(scoreText)
        
        //Best score text
        let defaults = UserDefaults.standard
        let bestScore = defaults.integer(forKey: "bestScore")
        bestScoreText = SKLabelNode(fontNamed: "Blockt")
        bestScoreText.text = "Best: \(bestScore)"
        bestScoreText.fontSize = screenHeight / 16
        bestScoreText.fontColor = UIColor.white
        bestScoreText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.8)
        addChild(bestScoreText)
        
        //Replay button
        let rpbWidth = screenWidth/2.2
        let rpbHeight = screenHeight/9.5
        replayButton = SKShapeNode(rect: CGRect(x: -rpbWidth/2, y: -rpbHeight*1.1, width: rpbWidth, height: rpbHeight), cornerRadius: rpbHeight/6)
        replayButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        replayButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        replayButton.name = "replay"
        addChild(replayButton)
        
        //Replay text
        replayText = SKLabelNode(fontNamed: "Blockt")
        replayText.text = "Replay"
        replayText.fontSize = screenHeight / 15
        replayText.fontColor = UIColor.white
        replayText.name = "replay"
        replayText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2.375)
        addChild(replayText)
        
        //Menu button
        let mbWidth = screenWidth/2.2
        let mbHeight = screenHeight/9.5
        menuButton = SKShapeNode(rect: CGRect(x: -mbWidth/2, y: -mbHeight*2.3, width: mbWidth, height: mbHeight), cornerRadius: mbHeight/6)
        menuButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        menuButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        menuButton.name = "menu"
        addChild(menuButton)
        
        //Menu text
        menuText = SKLabelNode(fontNamed: "Blockt")
        menuText.text = "Menu"
        menuText.fontSize = screenHeight / 15
        menuText.fontColor = UIColor.white
        menuText.name = "menu"
        menuText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3.4)
        addChild(menuText)
        
        //Tweet button
        let tbWidth = screenWidth/2.2
        let tbHeight = screenHeight/9.5
        tweetButton = SKShapeNode(rect: CGRect(x: -tbWidth/2, y: -tbHeight*3.5, width: tbWidth, height: tbHeight), cornerRadius: tbHeight/6)
        tweetButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        tweetButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        tweetButton.name = "tweet"
        addChild(tweetButton)
        
        //Tweet text
        tweetText = SKLabelNode(fontNamed: "Blockt")
        tweetText.text = "Tweet"
        tweetText.fontSize = screenHeight/15
        tweetText.fontColor = UIColor.white
        tweetText.name = "tweet"
        tweetText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        addChild(tweetText)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "sendBestScores"), object: nil)
        let playCount = defaults.integer(forKey: "playCount")
        if playCount % 4 == 0
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInterstitialAd"), object: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            //Replay button pressed
            if node.name == "replay"
            {
                fingerIsOnReplay = true
                print("Replay button touched")
                replayButton.fillColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0)
                
                var playCount = defaults.integer(forKey: "playCount")
                playCount += 1
                defaults.setValue(playCount, forKey: "playCount")
            }
            
            //Menu button pressed
            if node.name == "menu"
            {
                fingerIsOnMenu = true
                print("Menu button touched")
                menuButton.fillColor = UIColor(red: 100.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            }
            //Tweet button pressed
            if node.name == "tweet"
            {
                print("Tweet button touched")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "tweet"), object: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if fingerIsOnReplay
        {
            let flipH : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: self.view!.bounds.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: flipH)
            fingerIsOnReplay = false
            replayButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }
        
        if fingerIsOnMenu
        {
            let flipV = SKTransition.flipVertical(withDuration: 0.5)
            let scene = MenuScene(size: self.view!.bounds.size)
            self.view?.presentScene(scene, transition: flipV)
            fingerIsOnMenu = false
            menuButton.fillColor = UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if i <= score
        {
            scoreText.text = "Score: \(i)"
            i += 1
            if defaults.bool(forKey: "audio") == true
            {
                if i % 5 == 0
                {
                    playCoinAudio()
                }
                else if i < 5 && i  > 1
                {
                    playCoinAudio()
                    i + 2
                }
            }
        }
    }
    
    func playCoinAudio()
    {
        do
        {
            if let bundle = Bundle.main.path(forResource: "coin4", ofType: "wav")
            {
                let alertSound = URL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
                try audioPlayer = AVAudioPlayer(contentsOf: alertSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
