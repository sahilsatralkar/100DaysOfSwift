//
//  GameScene.swift
//  Project29
//
//  Created by Sahil Satralkar on 02/11/20.
//

import SpriteKit
import GameplayKit

//Collision type enums for each collision item. It increments by twice the value.
enum CollisionTypes : UInt32 {
    
    case banana = 1
    case building = 2
    case player = 4
    
}

//GameScene confirms to SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Decalare a weak variable for GameViewController
    weak var viewController : GameViewController?

    //Create nodes and building nodes array
    var buildings = [BuildingNode]()
    var player1 : SKSpriteNode!
    var player2 : SKSpriteNode!
    var banana : SKSpriteNode!
    var gameOverLabel : SKSpriteNode!
    
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        
        //Set background color with HSB
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        //Function calls
        createBuildings()
        createPlayers()
        
        //Set physicsWorld delegate to GameScene
        physicsWorld.contactDelegate = self
        
        //Create gameOverLabel and assign its properties
        gameOverLabel = SKSpriteNode(imageNamed: "text_gameover")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        //Assign an random gravity dx for the wind effect
        physicsWorld.gravity.dx = CGFloat.random(in: -5.0...5.0)
        //Sent the wind values to viewcontroller label to display
        viewController?.windVelocityValue = Double(physicsWorld.gravity.dx)
        
    }
    
    //Function to draw random buildings
    func createBuildings(){
        
        //Start buildings from -15 x coordinates
        var currentX : CGFloat = -15
        
        while currentX < 1024 {
            
            //Create random sized buildings within given ranges
            let size = CGSize(width: Int.random(in: 2 ... 4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            //Create buillding nodes and give position
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            
            //Add building node to Gamscene and also to buildings array
            addChild(building)
            buildings.append(building)
        }
    }
    
    //Function called when launch button pressed
    func launch(angle: Int, velocity: Int) {
        
        //Set speed and angle in radians
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        //Create banana SpriteNode and assign attributes
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        //This option is for precise collision detection
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            //Set banana position and speed for player 1
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            //Create sequence for animation of banana throw
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let seq = SKAction.sequence([raiseArm,pause,lowerArm])
            player1.run(seq)
            
            //Set impulse for banana
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            //Set banana position and speed for player 2
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            //Create sequence for animation of banana throw
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let seq = SKAction.sequence([raiseArm,pause,lowerArm])
            player2.run(seq)
            
            //Set impulse for banana
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
        
    }
    
    //Function to convert values from degrees to radians
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    //Function to create both players
    func createPlayers(){
        
        //Create player 1 SpriteNode and assign attributes
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1building = buildings[1]
        player1.position = CGPoint(x: player1building.position.x, y: player1building.position.y + ((player1building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        //Create player 1 SpriteNode and assign attributes
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2building.position.x, y: player2building.position.y + ((player2building.size.height + player2.size.height) / 2))
        addChild(player2)
        
    }
    
    //Function is called internally when there is collision
    func didBegin(_ contact: SKPhysicsContact) {
        //Set first body and second body conditions
        let firstBody : SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        //Function calls according to collision type. If Score is more than 3 than Game is over.
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        if firstNode.name == "banana" && secondNode.name == "player1" {
            viewController?.p2Score += 1
            
            if  let p2Score = viewController?.p2Score  {
                if p2Score >= 3 {
                    gameOverLabel.isHidden = false
                }
            }
            
            destroy(player : player1)
        }
        if firstNode.name == "banana" && secondNode.name == "player2" {
            
            viewController?.p1Score += 1
            
            if  let p1Score = viewController?.p1Score  {
                if p1Score >= 3 {
                    gameOverLabel.isHidden = false
                }
            }
            destroy(player : player2)
        }
        
        //Create new wind speeds for each throw
        physicsWorld.gravity.dx = CGFloat.random(in: -5.0...5.0)
        viewController?.windVelocityValue = Double(physicsWorld.gravity.dx)
    }
    
    //Function called when banana hits building
    func bananaHit(building: SKNode, atPoint contactPoint : CGPoint) {
        
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at : buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
        
    }
    
    //Function to toggle players after each turn
    func changePlayer(){
        if currentPlayer == 1 {
            currentPlayer = 2
        
        } else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    //Function called when collsion between banana and player
    func destroy(player: SKSpriteNode){
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if gameOverLabel.isHidden == false {
            viewController?.gameOver()
        } else {
        
        //Code has to be called on main thread only
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
           
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
        }
        
    }
    
    //Internal function called after each frame change
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        //Remove banana from GameScene condition
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
}
