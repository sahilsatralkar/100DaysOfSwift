//
//  GameScene.swift
//  Project26
//
//  Created by Sahil Satralkar on 26/10/20.
//

import SpriteKit
import GameplayKit
//Import for detecting motion from device accelerometer
import CoreMotion

//This enum is for categoryBitMask for each object. Every object is double the previous value
enum CollisionTypes : UInt32 {
    case player = 1
    case wall = 2
    case star = 16
    case vortex = 8
    case teleport = 4
    case finish = 32
    
}

//Class alos confirms to SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Declaring variables
    var player: SKSpriteNode!
    var lastTouchPosition : CGPoint?
    
    var motionManager : CMMotionManager?
    var scoreLabel : SKLabelNode!
    
    //Coordinates for initial ball position
    let ballStartPosition = CGPoint(x: 96, y: 672)
    var isGameOver = false
    var levelNumber = 1
    
    //Variable to track player score and label is auto set by didSet method
    var score = 0 {
        
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        loadLevel()
        createPlayer(position: ballStartPosition)
        //Assign gravity as zero for now
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        //Create CMMotionManager object to track device movements.
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
    }
    
    //Function to load the level is called initailly as well as loading next level
    func loadLevel(){
        
        //Create background with attributes
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Create score label with attributes
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint( x : 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        //Load file url
        guard let levelURL = Bundle.main.url(forResource: "level\(String(levelNumber))", withExtension: "txt") else {
            fatalError("Could not find level\(String(levelNumber)).txt in the app bundle.")
        }
        //load contents of txt file
        guard let levelString = try? String(contentsOf : levelURL) else {
            fatalError("Could not find level\(String(levelNumber)).txt in the app bundle.")
        }
        //Separate lines in file to an array of strings
        let lines = levelString.components(separatedBy: "\n")
        
        //User reversed enumerated as y axis is at bottom in Spritekit.
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x:(64 * column ) + 32, y : (64 * row) + 32)
                //Create the scene as per each character in text files
                if letter == "x" {
                    //load wall
                    loadWall(position : position)
                    
                } else if letter == "v" {
                    //load vortex
                    loadVortex(position: position)
                    
                    
                } else if letter == "s" {
                    //load star
                    loadStar( position: position)
                    
                    
                } else if letter == "f" {
                    //load finish point
                    loadFinish(position: position)
                    
                    
                } else if letter == " " {
                    //empty space
                } else if letter == "t" {
                    //load teleport
                    loadTeleport(position:position)
                }
                else {
                    fatalError("Unknown level letter: \(letter)")
                }
                
            }
        }
    }
    
    //Func for t letter
    func loadTeleport(position : CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "teleport")
        node.position = position
        node.name = "teleport"
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        createNode(node: node)
        
    }
    
    //Func for f letter
    func loadFinish ( position: CGPoint ){
        
        let node = SKSpriteNode(imageNamed: "finish")
        node.position = position
        node.name = "finish"
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        createNode(node: node)
        
    }
    
    //Func for s letter
    func loadStar(position : CGPoint) {
        
        let node = SKSpriteNode(imageNamed: "star")
        node.position = position
        node.name = "star"
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        createNode(node: node)
        
    }
    
    //Func for v letter
    func loadVortex(position: CGPoint){
        
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        createNode(node: node)
    }
    
    //Func for w letter
    func loadWall (position : CGPoint ){
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
        
    }
    
    func createNode(node : SKSpriteNode) {
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
        
    }
    
    //Create the rolling ball
    func createPlayer(position : CGPoint ) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        //Assign the categorybitmask, contacttestbitmask and collisionbitmask properties
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.teleport.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.star.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location  = touch.location(in: self)
        lastTouchPosition = location
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location  = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    //Function ia auto called by system for each change in frame
    override func update(_ currentTime: TimeInterval) {
        
        guard isGameOver == false else { return }
        
        //This code runs only for the simulator
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        //Else code runs on the real device
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    //Function is called when there is collision between nodes
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
        
        
    }
    
    //Function is called by didBegin method.
    func playerCollided(with node: SKNode){
        
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            score -= 1
            
            //Animation efects played in sequence
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            //Reset player
            let seq = SKAction.sequence([move,scale,remove])
            player.run(seq) {
                [weak self] in
                self?.createPlayer(position: self!.ballStartPosition)
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
            
        } else if node.name == "finish" {
            levelNumber += 1
            
            removeAllChildren()
            loadLevel()
            createPlayer(position: ballStartPosition)
            
        } else if node.name == "teleport" {
            player.removeFromParent()
            createPlayer(position: CGPoint(x: 96, y: 160))
            
        }
    }
}


