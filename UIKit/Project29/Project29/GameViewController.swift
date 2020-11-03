//
//  GameViewController.swift
//  Project29
//
//  Created by Sahil Satralkar on 02/11/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //Create an object of GameScene so that data can be transferred to it
    var currentGame: GameScene?

    //Declare IBOutlets
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var playerOneScore: UILabel!
    @IBOutlet var playerTwoScore: UILabel!
        
    @IBOutlet var windVelocity: UILabel!
    
    //Wind velocity variable with didDet for its label
    var windVelocityValue = 0.0 {
        
        didSet{
            if windVelocityValue < 0.0 {
                windVelocity.text = "Wind: \(abs(Int(windVelocityValue))) <-"
            } else {
                windVelocity.text = "Wind: \(abs(Int(windVelocityValue))) ->"
            }
        }
    }
    
    //Player 1 score variabel and didSet for its label
    var p1Score = 0 {
        didSet{
            playerOneScore.text = "Player 1 score : \(p1Score)"
        }
    }
    //Player 2 score variable and didSet for its label
    var p2Score = 0 {
        didSet{
            playerTwoScore.text = "Player 2 score : \(p2Score)"
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
        
        //Default values of angle and velocity of banana throw
        angleSlider.value = 45
        velocitySlider.value = 125
        
        //Default text
        windVelocity.text = "Wind: 0 <-"
        angleLabel.text = "Angle: 45°"
        velocityLabel.text = "Velocity: 125"
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //IBAction for angle slider value changed
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    //IBAction for velocty slider value changed
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    //Function called when Launch button is pressed
    @IBAction func launch(_ sender: Any) {
        
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        //Call GameScene launch method
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
        
    }
    
    //Function to toggle players for each turn
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
            
        }
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
    //Function to hide labels and sliders when game is finished
    func gameOver(){
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        playerNumber.isHidden = true
        
    }
}
