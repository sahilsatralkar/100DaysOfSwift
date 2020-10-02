//
//  GameScene.swift
//  Challenge6
//
//  Created by Sahil Satralkar on 01/10/20.
//

import SpriteKit
import GameplayKit

//Class confirms to SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel : SKLabelNode!
    var timerLabel : SKLabelNode!
    var gameOverLabel : SKSpriteNode!
    
    //array of file names of imagear2
    var targets = ["BadChar1", "BadChar2", "BadChar3","BadChar4", "GoodChar1","GoodChar2","GoodChar3"]
    //Timer object
    var gameTimer : Timer?
    var targetTimer : Timer?
    
    var charNodesArray = [SKSpriteNode]()
    
    
    var timeLeft = 10 {
        
        didSet {
            timerLabel.text = "Time remaining: \(timeLeft)"
        }
        
    }
    
    //score variable with didSet to update scoreLabel
    var score = 0 {
        
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        //black background
        backgroundColor = .black
        
        //Create scoreLabel
        scoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
        scoreLabel.position = CGPoint(x: 5, y: 730)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = -1
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        //Create timerLabel
        timerLabel = SKLabelNode(fontNamed: "ChalkDuster")
        timerLabel.position = CGPoint(x: 665, y: 730)
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.zPosition = -1
        addChild(timerLabel)
        
        gameOverLabel = SKSpriteNode(imageNamed: "text_gameover")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        
        //gameTimer runs createEnemy method and repeats it continuosly.
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneMinuteTimer), userInfo: nil, repeats: true)
        
        targetTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
        
    }
    
    @objc func oneMinuteTimer()
    {
        timeLeft -= 1
        
        if timeLeft <= 0 {
            gameTimer?.invalidate()
            gameTimer = nil
            targetTimer?.invalidate()
            targetTimer = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.gameOverLabel.isHidden = false
                self.run(SKAction.playSoundFileNamed("gameOver.caf", waitForCompletion: false))
            }
        }
    }
    
    @objc func createTargets () {
        
        for _ in 0..<3 {
            
            let randomCount = Int.random(in: 0..<7)
            let tempTargetImage = targets[randomCount]
            let tempNode = SKSpriteNode(imageNamed: tempTargetImage)
            
            if randomCount <= 3 {
                tempNode.name = "Bad"
            } else {
                tempNode.name = "Good"
            }
            
            charNodesArray.append(tempNode)
            
        }
        
        let charNode1 = charNodesArray[0]
        let charNode2 = charNodesArray[1]
        let charNode3 = charNodesArray[2]
        
        charNode1.position = CGPoint(x: 10, y: 100)
        charNode2.position = CGPoint(x: 1200, y: 350)
        charNode3.position = CGPoint(x: 10, y: 600)
        
        addChild(charNode1)
        addChild(charNode2)
        addChild(charNode3)
        
        charNode1.run(SKAction.moveTo(x: 1200, duration: 3))
        charNode2.run(SKAction.moveTo(x: -100, duration: 3))
        charNode3.run(SKAction.moveTo(x: 1200, duration: 3))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            charNode1.removeFromParent()
            charNode2.removeFromParent()
            charNode3.removeFromParent()
            
        }
        
        charNodesArray.removeAll()
        
    }
    
    //Method called internally per frame
    override func update(_ currentTime: TimeInterval) {
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let emitter = SKEmitterNode(fileNamed: "smokeEffect") else { return }
        
        
        for node in tappedNodes {
            
            if node.name == "Good" {
                score -= 20
                node.removeFromParent()
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                emitter.position = CGPoint(x: node.position.x, y: node.position.y)
                emitter.zPosition = 1
                addChild(emitter)
            } else if node.name == "Bad" {
                
                score += 10
                node.removeFromParent()
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                emitter.position = CGPoint(x: node.position.x, y: node.position.y)
                emitter.zPosition = 1
                addChild(emitter)
            }
            
        }
        
    }
    
}
