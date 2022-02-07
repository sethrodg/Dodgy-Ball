//
//  GameViewController.swift
//  Dodgy Ball
//
//  Created by Seth Rodgers on 5/25/15.
//  Copyright (c) 2015 Seth Rodgers. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GameKit
import AVFoundation
import Social

class GameViewController: UIViewController, ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate
{
    var scene: MenuScene!
    var skView: SKView!
    
    var bannerAd: ADBannerView!
    var fullAd: ADInterstitialAd!
    var interstitialAdView: UIView = UIView()
    
    let defaults = UserDefaults.standard
    
        var gcEnabled = Bool()
        var gcDefaultLeaderBoard = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Configure the view.
        skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
        
        //Banner
        bannerAd = ADBannerView(adType: ADAdType.banner)
        bannerAd.delegate = self
        bannerAd.isHidden = true
        bannerAd.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerAd)
        
        //Banner constraints
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "|[bannerAd]|", options: [], metrics: nil, views: ["bannerAd":bannerAd])
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerAd(50)]|", options: [], metrics: nil, views: ["bannerAd":bannerAd])
        self.view.addConstraints(constraintsH)
        self.view.addConstraints(constraintsV)
    
        //Create and configure the scene
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        
        //Present the scene
        skView.presentScene(scene)
        scene.scaleMode = .resizeFill
        
        authenticateLocalPlayer()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.tweet), name: NSNotification.Name(rawValue: "tweet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.sendBestScores), name: NSNotification.Name(rawValue: "sendBestScores"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showLeaderboard), name: NSNotification.Name(rawValue: "showLeaderboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "gameCenterViewControllerDidFinish", name: NSNotification.Name(rawValue: "gameCenterViewControllerDidFinish"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.loadInterstitialAd), name: NSNotification.Name(rawValue: "loadInterstitialAd"), object: nil)
    }
    
    func bannerViewWillLoadAd(_ banner: ADBannerView!)
    {
        print("Ad loading")
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!)
    {
        print("Ad loaded")
        self.bannerAd.isHidden = false
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!)
    {
        bannerAd.removeFromSuperview()
    }
    
    func loadInterstitialAd()
    {
        fullAd = ADInterstitialAd()
        fullAd.delegate = self
    }
    
    func interstitialAdWillLoad(_ interstitialAd: ADInterstitialAd!)
    {
        
    }
    
    func interstitialAdDidLoad(_ interstitialAd: ADInterstitialAd!)
    {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        view.addSubview(interstitialAdView)
        
        interstitialAd.present(in: interstitialAdView)
        UIViewController.prepareInterstitialAds()
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.automatic
    }
    
    func interstitialAdActionDidFinish(_ interstitialAd: ADInterstitialAd!)
    {
        interstitialAdView.removeFromSuperview()
    }
    
    func interstitialAdActionShouldBegin(_ interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool
    {
        return true
    }
    
    func interstitialAd(_ interstitialAd: ADInterstitialAd!, didFailWithError error: Error!)
    {
        
    }
    
    func interstitialAdDidUnload(_ interstitialAd: ADInterstitialAd!)
    {
        interstitialAdView.removeFromSuperview()
    }
    
    func tweet()
    {
        let score = defaults.integer(forKey: "bestScore")
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        {
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("My high score is \(score) on Dodgy Ball, go download it! https://appsto.re/us/Iug98.i")
            self.present(twitterSheet, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Accounts", message: "Please make sure you are logged into a twitter account to share", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func authenticateLocalPlayer()
    {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController: UIViewController?, error) -> Void in
    
        if((ViewController) != nil)
        {
            self.present(ViewController!, animated: true, completion: nil)
            print("GC login shown")
        }
        else if (localPlayer.isAuthenticated)
        {
            self.gcEnabled = true
            print("GC logged in")

            
            localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error) -> Void in

          
            if error != nil
            {
                print("Could not get default leaderboard ID")
            }
            else
            {
                self.gcDefaultLeaderBoard = leaderboardIdentifer!
            }
            })
        }
        else
        {
            self.gcEnabled = false
            print("Local player could not be authenticated, disabling game center")
        }
        }
    }
    
    func sendBestScores()
    {
        var bestScoreSent = 0
        if defaults.integer(forKey: "bestScoreSent") == 1
        {
            bestScoreSent = 1
        }
    
        let score = defaults.integer(forKey: "timerCount")
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        if score == bestScore && GKLocalPlayer.localPlayer().isAuthenticated || bestScoreSent == 0
        {
            let scoreReporter = GKScore(leaderboardIdentifier: "DodgyBallLeaderboard")
            
            scoreReporter.value = Int64(bestScore)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil
                {
                    print("error")
                }
                else
                {
                    bestScoreSent = 1
                    self.defaults.setValue(bestScoreSent, forKey: "bestScoreSent")
                    print("Score sent to leaderboard")
                }
            })
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func showLeaderboard()
    {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = "DodgyBallLeaderboard"
        self.present(gcVC, animated: true, completion: nil)
        print("Leaderboard shown")
    }

    override var shouldAutorotate : Bool
    {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        else
        {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool
    {
        return true
    }
}
