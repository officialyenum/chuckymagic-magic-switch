//
//  MenuScene.swift
//  MagicSwitch
//
//  Created by Chukwuyenum Opone on 29/02/2020.
//  Copyright © 2020 Chukwuyenum Opone. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addMusic()
        addLogo()
        addLabel()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.name = "logo"
        logo.size = CGSize(width: frame.width/4, height: frame.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(logo)
        
        
    }
    
    func addMusic() {
        let music_bg = SKAudioNode(fileNamed: "game_bg")
        music_bg.autoplayLooped = true
        addChild(music_bg)
        
    }
    func openGameScene() {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
    func addLabel() {
        let playLabel = SKLabelNode(text: "Tap logo to Play")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 45.0
        playLabel.fontColor = UIColor.white
        playLabel.isUserInteractionEnabled = true
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
        
        
        let highScoreLabel = SKLabelNode(text: "Highscore: " + "\(UserDefaults.standard.integer(forKey: "HighScore"))")
        
        highScoreLabel.fontName = "AvenirNext-Italic"
        highScoreLabel.fontSize = 25.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height*4)
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "RecentScore: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        
        recentScoreLabel.fontName = "AvenirNext-Italic"
        recentScoreLabel.fontSize = 25.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
    }
    
    func animate(label: SKLabelNode) {
        //let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        //let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        
        
        let scaleOut = SKAction.scale(by: 1.1, duration: 0.25)
        let scaleIn = SKAction.scale(by: 0.9, duration: 0.25)
        
        let sequence = SKAction.sequence([scaleOut,scaleIn])
        label.run(SKAction.repeatForever(sequence))
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: UITouch in touches {
            
            let touchPoint: String = atPoint(touch.location(in: self)).name ?? ""
            
            if (touchPoint == "logo") {
                openGameScene()
                return
            }
        }
    }
}
