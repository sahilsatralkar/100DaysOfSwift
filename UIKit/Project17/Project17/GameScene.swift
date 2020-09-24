//
//  GameScene.swift
//  Project17
//
//  Created by Sahil Satralkar on 23/09/20.
//

import SpriteKit
import GameplayKit

//Class confirms to SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Create variable nodes
    var starfield : SKEmitterNode!
    var player : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    
    //array of file names of image
    var possibleEnemies = ["ball", "hammer", "tv"]
    //Timer object
    var gameTimer : Timer?
    //game variables
    var isGameOver = false
    var enemyCount = 0
    var timeInterval = 1.0
    //score variable with didSet to update scoreLabel
    var score = 0 {
        
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    
    override func didMove(to view: SKView) {
        //black background
        backgroundColor = .black
        
        //Create the starfied emitter properties
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        //property to start the starfied 10 secs in advance.
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        //-1 position in Z plane
        starfield.zPosition = -1
        
        //Create player properties
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        //Apply physicsBody
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        //Create scoreLabel
        scoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        //gravity propery of physicsWorld is made zero
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        //gameTimer runs createEnemy method and repeats it continuosly.
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        
        
    }
    
    //Selector method for gameTimer
    @objc func createEnemy(){
        
        //enemy Counter is incremented
        enemyCount += 1
        
        //Contidion to increase speed of objects after every 10 enemies
        if enemyCount > 10 {
            //gameTimer is invalidated before creating a new one to avoid duplicate timers.
            gameTimer?.invalidate()
            timeInterval -= 0.1
            
            gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            //rest enemyCounter
            enemyCount = 0
        
        }
        //Create random element enemy
        guard let enemy = possibleEnemies.randomElement() else { return }
        //New SKSPriteNode with enemy image
        let sprite = SKSpriteNode(imageNamed: enemy)
        //enemy position x is kept beyond screen size and random y within range.
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        //Apply SKPhysicsBody to sprite
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        //Assign -400 velocity in x axis
        sprite.physicsBody?.velocity = CGVector(dx: -400, dy: 0)
        //Spin the object
        sprite.physicsBody?.angularVelocity = 5
        //No damping to body to simulate space
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        
    }
    
    //Method called internally per frame
    override func update(_ currentTime: TimeInterval) {
        
        //Remove nodes when they disapper from screen when x is -300
        for node in children {
            if node.position.x  < -300 {
                
                node.removeFromParent()
                
            }
        }
        //Score is number of frames game is running
        if !isGameOver {
            score += 1
        }
        
    }
    
    //Called internally when system detects touches on screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        //Keep the position of player within y axis limited values as follows
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        //Update player position as per finger movements on screen
        player.position = location
        
    }
    
    //Game over when player lifts his finger
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.removeFromParent()
        isGameOver = true
        
    }
    
    //Function called internally when there is contact between physics body
    func didBegin(_ contact: SKPhysicsContact) {
        //Add explosion
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        
        player.removeFromParent()
        isGameOver = true
        //Stop gameTimer to stop additional objects after game over
        gameTimer?.invalidate()
        
        //score label schanged to Final Scores
        scoreLabel.text = "Final Score: \(score)"
    }
}
