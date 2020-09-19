//
//  WhackSlot.swift
//  Project14
//
//  Created by Sahil Satralkar on 17/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
        
    }
    
    func show (hideTime : Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
            
        } else {
            
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
        emitterEffects(effects: "mudParticlesShow", show: true)
        
    }
    
    func hide() {
        if !isVisible { return }
        emitterEffects(effects: "mudParticlesHide", show: false)
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
        
    }
    
    func hit () {
        
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        
        emitterEffects(effects: "smokeEffects", show: false)
    }
    
    func emitterEffects(effects : String, show : Bool){
        var emitterChoice = SKEmitterNode()
        switch effects {
        case "smokeEffects" :
            guard let emitter = SKEmitterNode(fileNamed: "smokeEmitter") else { return }
            emitterChoice = emitter
        case "mudParticlesHide" :
            guard let emitter = SKEmitterNode(fileNamed: "mudParticles") else { return }
            emitterChoice = emitter
        case "mudParticlesShow" :
            guard let emitter = SKEmitterNode(fileNamed: "mudParticles") else { return }
            emitterChoice = emitter
        default :
            print("Default Switch")
            
        }
        
        if show == true {
            emitterChoice.position = CGPoint(x: self.charNode.position.x, y: self.charNode.position.y + 80)
        }
        else {
            emitterChoice.position = CGPoint(x: self.charNode.position.x, y: self.charNode.position.y)
            
        }
        
        emitterChoice.zPosition = self.charNode.zPosition
        //Add as child
        self.addChild(emitterChoice)
    }
    
}
