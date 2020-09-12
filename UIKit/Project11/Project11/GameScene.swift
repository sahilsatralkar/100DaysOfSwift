//
//  GameScene.swift
//  Project11
//
//  Created by Sahil Satralkar on 11/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SpriteKit

//Delegate property for Physics added to class
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Declarations of variables and labels with their respective didSets
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    let ballNamesArray = ["ballBlue", "ballCyan","ballRed","ballGreen","ballGrey","ballPurple","ballYellow"]
    var numberOfBalls = 0
    
    override func didMove(to view: SKView) {
        
        //Create background from SKSpriteNode and add as child
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        //Make frame as SKPhysicsBody
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        //Create edit Label with properties and add as child
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        //Create score label with properties and add as child
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        //call makeSlot function multiple times
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        //call makeBouncer multiple times
        makeBouncert(at: CGPoint(x: 0, y: 0))
        makeBouncert(at: CGPoint(x: 254, y: 0))
        makeBouncert(at: CGPoint(x: 512, y: 0))
        makeBouncert(at: CGPoint(x: 768, y: 0))
        makeBouncert(at: CGPoint(x: 1024, y: 0))
        
    }
    
    //Function to track when touched on screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            //toggle editing mode label
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                
                //If on edit mode. This will create obstacles.
                if editingMode {
                    //Creating box shaped with random colors.
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.name = "pin"
                    //Add random rotation to box
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    //Add physics to body
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    //make the box fixed.
                    box.physicsBody?.isDynamic = false
                    //add box as child.
                    addChild(box)
                }
                    
                //If not in edit mode. Create free falling balls.
                else if (numberOfBalls <= 5) {
                    //Create new ball SKSprikeNode and its peoperties.
                    let randomElement = Int.random(in: 0...6)
                    let ball = SKSpriteNode(imageNamed: ballNamesArray[randomElement])
                    ball.name = "ball"
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    //restitution is bounciness of ball 1 being max.
                    ball.physicsBody?.restitution = 0.8
                    ball.position = CGPoint(x: location.x, y: 650)
                    //add as child.
                    addChild(ball)
                    numberOfBalls += 1
                }
            }
        }
    }
    
    //Function to make bouncer objects ar the base of screen.
    func makeBouncert(at position: CGPoint) {
        //Create new bouncer SKSpriteNode and its properties then add as child
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    //Function to make slot objects between bouncers at the base of screen.
    func makeSlot ( at position : CGPoint, isGood : Bool) {
        
        //Create 2 SKSPriteNodes for slots and the glow
        var slotBase : SKSpriteNode
        var slotGlow : SKSpriteNode
        //Types of slots/Glow based on the parameter value.
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
            
        }
        else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        //Assign them position coordinates
        slotBase.position = position
        slotGlow.position = position
        
        //Assign slotBase SKPhysics of its own size. Make it non dynamic
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        //add as child
        addChild(slotBase)
        addChild(slotGlow)
        
        //Make the glow image rotating
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    //Function to calculate score. It will keep track of collision between ball and slot.
    //If collision is with good slot then points added else deducted.
    //SKNode is parent class of SKSpriteNode
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            numberOfBalls -= 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "pin" {
            destroy (ball:ball)
            destroy(ball: object)
        }
    }
    
    //Function called from collisionBetween function to destroy balls with animation effects.
    func destroy(ball: SKNode) {
        //create new KSEmitterNode from FireParticles.sks file
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            //Animation at the coordinates of ball
            fireParticles.position = ball.position
            //Add as child
            addChild(fireParticles)
        }
        //Remove ball after animation effect.
        ball.removeFromParent()
    }
    
    //Function is called internally when 2 objects collide
    func didBegin(_ contact: SKPhysicsContact) {
        //bodyA is the first body of contact
        guard let nodeA = contact.bodyA.node else { return }
        //bodyB is the first body of contact
        guard let nodeB = contact.bodyB.node else { return }
        
        //THese conditions make sure that any conditions of contact is covered for score counting
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
}
