//
//  GameScene.swift
//  MagicSwitch
//
//  Created by Chukwuyenum Opone on 29/02/2020.
//  Copyright © 2020 Chukwuyenum Opone. All rights reserved.
//

import SpriteKit
import UIKit

enum PlayElements {
    static let elementals = ["fire","water","dark","earth"]
}

enum SwitchState: Int {
    case fire,water,dark,earth
}

class GameScene: SKScene {
    
    var ringSwitch: SKSpriteNode!
    var switchState = SwitchState.fire
    var currentelementIndex:Int?
    
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var score = 0
    var gravity = -1.5
    
    override func didMove(to view: SKView) {
        addMusic()
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0,dy: gravity)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        ringSwitch = SKSpriteNode(imageNamed: "ringCircle")
        ringSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        ringSwitch.position = CGPoint(x: frame.midX, y: frame.minY + ringSwitch.size.height)
        ringSwitch.zPosition = CGFloat(ZPositions.ringZ)
        ringSwitch.physicsBody = SKPhysicsBody(circleOfRadius: ringSwitch.size.width/2)
        
        ringSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        ringSwitch.physicsBody?.isDynamic = false
        addChild(ringSwitch)
        
        scoreLabel.fontName = "Avenir"
        scoreLabel.fontSize = 18.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX + frame.size.width/3, y: frame.midY + frame.size.height/2 - 30)
        scoreLabel.zPosition = CGFloat(ZPositions.labelZ)
        addChild(scoreLabel)
        
        spawnElement()
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    func checkScore() {
        switch score {
        case 5:
            gravity -= 0.5
            setupPhysics()
        case 10:
            gravity -= 1.0
            setupPhysics()
        case 25:
            gravity -= 1.5
            setupPhysics()
        case 50:
            gravity -= 2.0
            setupPhysics()
        default:
            return
        }
    }
    
    func spawnElement() {
        currentelementIndex = Int(arc4random_uniform(UInt32(4)))
        let element = SKSpriteNode(imageNamed: PlayElements.elementals[currentelementIndex!])
        //element.size = CGSize(width: 30.0, height: 30.0)
        element.name = "Element"
        element.position = CGPoint(x: frame.midX, y:frame.maxY)
        element.zPosition = CGFloat(ZPositions.elementZ)
        element.physicsBody = SKPhysicsBody(circleOfRadius: element.size.width/2)
        element.physicsBody?.categoryBitMask = PhysicsCategories.elementCategory
        element.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        element.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(element)
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .fire
        }
        
        ringSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func addMusic() {
        let music_bg = SKAudioNode(fileNamed: "game_bg")
        music_bg.autoplayLooped = true
        addChild(music_bg)
        
    }
    
    func addWinSound() {
        run(SKAction.playSoundFileNamed("win", waitForCompletion: false))
    }
    
    func addLoseSound() {
        run(SKAction.playSoundFileNamed("game_over", waitForCompletion: false))
    }
    
    func gameOver() {
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore"){
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.elementCategory | PhysicsCategories.switchCategory {
            if let element = contact.bodyA.node?.name == "Element" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentelementIndex == switchState.rawValue {
                    score += 1
                    checkScore()
                    updateScoreLabel()
                    addWinSound()
                    element.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        element.removeFromParent()
                        self.spawnElement()
                    })
                } else {
                    addLoseSound()
                    gameOver()
                }
            }
        }
    }
}
