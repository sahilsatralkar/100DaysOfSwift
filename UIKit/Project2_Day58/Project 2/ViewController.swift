//
//  ViewController.swift
//  Project 2
//
//  Created by Sahil Satralkar on 05/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //IBOutlets for the 3 flags to be displayed on screen.
    //These flags are actually buttons with flag image as background.
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    
    // Variable to store a random number between 0 & 2.
    // This random number will be selected as the Answer among 3 flags
    var answerSelector = Int.random(in: 0 ... 2)
    
    var answer: Bool?
    
    // Variable to count the number of questions displayed.
    var questionCounter = 0
    
    var flagsArray = [Int]()
    var highScore = -11
    
    //Create new UserDefaults object
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        answer = true
        //Add the names of country flag to an array.
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","spain","uk","us"]
        
        //Internal function called which will display the first screen
        askQuestion(uiAlert: nil)
        
        //Fetch values from userDefaults if it exists or create new key.
        if let tempHighScores = defaults.object(forKey: "highScore") as? Int {
            highScore = tempHighScores
        } else {
            
            defaults.set(-11, forKey: "highScore")
        }
        
    }
    
    //This is a common IBAction for all 3 buttons/flags in screen.
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        
        //Code for animation when the flag is tapped
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        //UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: [], animations: {
            sender.imageView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        }) { (finished) in
            //Unhide button after finishing animation
            //sender.isHidden = false
            sender.imageView?.transform = .identity
        }
        
        
        
        //Variable to count the number of attempts made by user.
        questionCounter += 1
        
        //If user attempts more than 10 times then alert is shown with just the Final score.
        if (questionCounter > 10) {
            
            //New UIAlertController created
            let ac = UIAlertController(title: "Final Score", message: "\(score)", preferredStyle: .alert)
            //New UIAlertAction created. handler label is passed the askQuestion function as parameter.
            let action = UIAlertAction(title: "OK", style: .default, handler: askQuestion)
            //The UIAlertAction is added to UIAlertController
            ac.addAction(action)
            //Present the alert
            self.present(ac, animated: true)
            
            
        }
            //All 3 buttons are assigned Tag values as 0,1 & 3 respectively in Main.storyboard, Attributes inspector
            //This condition is true if the user click on the correct flag.
        else if sender.tag == answerSelector {
            
            //score variable is updated
            score += 1
            //answer variable is updated
            answer = true
            //New UIAlertController created
            let ac = UIAlertController(title: "Correct Answer", message: "+1 point", preferredStyle: .alert)
            //New UIAlertAction created. handler label is passed the askQuestion function as parameter.
            let action = UIAlertAction(title: "OK", style: .default, handler: askQuestion)
            //The UIAlertAction is added to UIAlertController
            ac.addAction(action)
            //Present the alert
            self.present(ac, animated: true)
            
        }
            // This condition is true if the user clicks on the wrong flag
        else {
            
            //score variable is updated
            score -= 1
            //answer variable is updated
            answer = false
            //New UIAlertController created. This will display the Name of the wrong flag clicked by user within the alert
            let ac = UIAlertController(title: "Wrong! Thats the flag of \(countries[flagsArray[sender.tag]].uppercased())", message: "-1 point", preferredStyle: .alert)
            //New UIAlertAction created. handler label is passed the askQuestion function as parameter.
            let action = UIAlertAction(title: "OK", style: .default, handler: askQuestion)
            ac.addAction(action)
            //Present the alert
            self.present(ac, animated: true)
            
        }
        
    }
    
    //This function will be called each time to load the questions on screen.
    //Parameter is kept optional so that it can be passed nil value. Nil value is passed when this function is called in override viewDidLoad().
    func askQuestion(uiAlert: UIAlertAction?) {
        
        //This code will randomly fetch a integer between 0 & 10 and set it to flag1
        //Values of flag2 and flag3 are also between 1 & 10 but all 3 values will be unique. So no duplicate flag is displayed at once.
        let flag1 = Int.random(in: 0 ..< 11)
        var flag2 = 0
        var flag3 = 0
        while true {
            flag2 = Int.random(in: 0 ..< 11)
            if flag2 == flag1 {
                continue
            } else {
                while true {
                    flag3 = Int.random(in: 0 ..< 11)
                    if flag3 != flag2 && flag3 != flag1 {
                        break
                    } else {
                        continue
                    }
                }
                break
            }
        }
        
        // Condition to keep the maximum number of questions asked to user is 10.
        if answer != nil && questionCounter < 10 {
            
            flagsArray = [flag1, flag2, flag3]
            answerSelector = Int.random(in: 0 ... 2)
            
            //title property is the text for the Navigation bar label at top.
            //This will show Country name of the correct answer and Total score.
            title = "\(countries[flagsArray[answerSelector]].uppercased())    Total Score:\(score)"
            
            //Setting the 3 flag images on the 3 buttons.
            button1.setImage((UIImage(named: countries[flagsArray[0]])), for: .normal)
            button2.setImage((UIImage(named: countries[flagsArray[1]])), for: .normal)
            button3.setImage((UIImage(named: countries[flagsArray[2]])), for: .normal)
            
            //Code to give a border to all buttons
            button1.layer.borderWidth = 1
            button1.layer.borderColor = UIColor.darkGray.cgColor
            button2.layer.borderWidth = 1
            button2.layer.borderColor = UIColor.darkGray.cgColor
            button3.layer.borderWidth = 1
            button3.layer.borderColor = UIColor.darkGray.cgColor
            
        }
            
        else
        {
            //Condition to check if it is a new high score then give a new message. Update the value in userDefaults
            if (score > highScore) {
                title = "New Highest Score:\(score)"
                defaults.set(score, forKey: "highScore")
            }
            else {
                title = "Final Score:\(score)"
            
            }
        }
        
    }
    
}

