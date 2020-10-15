//
//  GameScene.swift
//  Project20
//
//  Created by Sahil Satralkar on 14/10/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Declaration of variables
    var gameTimer : Timer?
    var fireworks = [SKNode]()
    
    var scoreLabel : SKLabelNode!
    var gameOverLabel : SKSpriteNode!
    
    var countLaunches = 0
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    //Score with didSet method for label
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
   
    override func didMove(to view: SKView) {
        
        //Set background woth its properties
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Create scoreLabel with its properties
        scoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        //Create gameOverLabel and assign its properties
        gameOverLabel = SKSpriteNode(imageNamed: "text_gameover")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        //Assign gameTimer with 6 sec interval
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
      
    }
    
    //WIll be called vy launchfireworks to create fireworks
    func createFirework ( xMovement : CGFloat, x : Int, y : Int) {
        
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        //Property to describe color blending
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        
        //Create a path
        let path = UIBezierPath()
        path.move(to: .zero)
        
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        //Create emitter
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        //Append fireworks
        fireworks.append(node)
        addChild(node)
        
    }
    
    //Method will be called be timer every 6sec
    @objc func launchFireworks() {
         
        let movementAmount: CGFloat = 1800

        //Will create random launches of 5 fireworks each
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)

        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        default:
            break
        }
        
        //Update launch counter
        countLaunches += 1
        
        //Game over if number of launches exceed
        if countLaunches > 4 {
            
            gameTimer?.invalidate()
            gameTimer = nil
            
            //Display gameover label with 2 seconds delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.gameOverLabel.isHidden = false
                
            }
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode ) {
    
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
            
            //Will remove explosion emitter node after 3 secs delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                emitter.removeFromParent()
                
            }
            
        }
        firework.removeFromParent()
        
        
    }
    
    func explodeFireworks() {
        
        var numExploded = 0

            for (index, fireworkContainer) in fireworks.enumerated().reversed() {
                guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" {
                    // destroy this firework!
                    explode(firework: fireworkContainer)
                    fireworks.remove(at: index)
                    numExploded += 1
                }
            }
        
            //Calculate score
            switch numExploded {
            case 0:
                // nothing – rubbish!
                break
            case 1:
                score += 200
            case 2:
                score += 500
            case 3:
                score += 1500
            case 4:
                score += 2500
            default:
                score += 4000
            }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in  nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
            
        }
        
    }
    
   
}
