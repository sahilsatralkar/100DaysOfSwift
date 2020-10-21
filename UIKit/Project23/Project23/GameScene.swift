//
//  GameScene.swift
//  Project23
//
//  Created by Sahil Satralkar on 19/10/20.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum ForceBomb {
    case never, always, random, evil
}

enum SequenceType: CaseIterable {
    case fastEvil, oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

enum Constants{
    
    static let popupTimeConstant = 0.9
    static let popupTimeMultiple = 0.991
    static let chainDelayConstant = 3.0
    static let chainDelayMultiple = 0.99
    static let physicsWorldConstant : CGFloat = 0.85
    static let physicsWorldMultiple : CGFloat = 1.02
    static let lifeScale : CGFloat = 1.3
    static let fadeOutDuration = 0.25
    
    
}
class GameScene: SKScene {
    var gameScore : SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG : SKShapeNode!
    var activeSliceFG : SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    
    var activeEnemies = [SKSpriteNode]()
    
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = Constants.popupTimeConstant
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = Constants.chainDelayConstant
    var nextSequenceQueued = true
    var isGameEnded = false
    
    var gameOverLabel : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x:512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = Constants.physicsWorldConstant
        
        //Create gameOverLabel and assign its properties
        gameOverLabel = SKSpriteNode(imageNamed: "text_gameover")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.fastEvil, .oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
        
    }
    
    func createScore() {
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
        
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
            
        }
        
        
    }
    
    func createSlices() {
        
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
        
        
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        } else if forceBomb == .evil {
            enemyType = 2
        }
        
        if enemyType == 0 {
            // 1
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            // 2
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // 3
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            // 4
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try?  AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            // 5
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        } else if enemyType == 1 {
            
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
            
        } else {
            
            enemy = SKSpriteNode(imageNamed: "penguinEvil")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "evilEnemy"
            
        }
        
        
        
        // 2
        let randomAngularVelocity = CGFloat.random(in: -3...3 )
        let randomXVelocity: Int
        let randomYVelocity: Int
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        if enemyType == 0 || enemyType == 1 {
            
            let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
            enemy.position = randomPosition
            
            if randomPosition.x < 256 {
                randomXVelocity = Int.random(in: 8...15)
            } else if randomPosition.x < 512 {
                randomXVelocity = Int.random(in: 3...5)
            } else if randomPosition.x < 768 {
                randomXVelocity = -Int.random(in: 3...5)
            } else {
                randomXVelocity = -Int.random(in: 8...15)
            }
            
            randomYVelocity = Int.random(in: 24...32)
            
            // 5
            
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
            
            addChild(enemy)
            activeEnemies.append(enemy)
            
        } else {
            
            enemy.position = CGPoint(x: 64, y: -128)

            enemy.physicsBody?.velocity = CGVector(dx: 600, dy: 1200)
            
            addChild(enemy)
            activeEnemies.append(enemy)
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameEnded {
            return
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy" || node.name == "evilEnemy" {
                // destroy penguin
                // 1
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                if node.name == "enemy" {
                    score += 1
                } else if node.name == "evilEnemy" {
                    score += 10
                }
                
                
                
                // 2
                node.name = ""
                
                // 3
                node.physicsBody?.isDynamic = false
                
                // 4
                let scaleOut = SKAction.scale(to: 0.001, duration: Constants.fadeOutDuration)
                let fadeOut = SKAction.fadeOut(withDuration: Constants.fadeOutDuration)
                let group = SKAction.group([scaleOut, fadeOut])
                
                // 5
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                // 6
                
                // 7
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                // 8
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                // destroy bomb
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: Constants.fadeOutDuration)
                let fadeOut = SKAction.fadeOut(withDuration: Constants.fadeOutDuration)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
        
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    func playSwooshSound() {
        
        isSwooshSoundActive = true
        let randomNumber = Int.random(in: 1 ... 3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound){
            [weak self] in
            self?.isSwooshSoundActive = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: Constants.fadeOutDuration))
        activeSliceFG.run(SKAction.fadeOut(withDuration: Constants.fadeOutDuration))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    func redrawActiveSlice() {
        
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
        
    }
    
    func subtractLife() {
        lives -= 1

        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))

        var life: SKSpriteNode

        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }

        life.texture = SKTexture(imageNamed: "sliceLifeGone")

        life.xScale = Constants.lifeScale
        life.yScale = Constants.lifeScale
        life.run(SKAction.scale(to: 1, duration:0.1))
    }
    
    func endGame(triggeredByBomb : Bool) {
        
        if isGameEnded {
            return
        }

        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        gameOverLabel.isHidden = false

        bombSoundEffect?.stop()
        bombSoundEffect = nil

        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()

                        if node.name == "enemy" {
                            node.name = ""
                            subtractLife()

                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                        } else if node.name == "bombContainer" {
                            node.name = ""
                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                        }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                    self?.tossEnemies()
                }
                
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs – stop the fuse sound!
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func tossEnemies() {
        if isGameEnded {
            return
        }
        
        popupTime *= Constants.popupTimeMultiple
        chainDelay *= Constants.chainDelayMultiple
        physicsWorld.speed *= Constants.physicsWorldMultiple
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        
        case .fastEvil :
            createEnemy(forceBomb: .evil)
            
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .two:
            createEnemy()
            createEnemy()
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
            
        case .fastChain:
            createEnemy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        
        
        }
        
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
}
