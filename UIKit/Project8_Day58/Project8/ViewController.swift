//
//  ViewController.swift
//  Project8
//
//  Created by Sahil Satralkar on 03/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Declaration of all variables
    var scoreLabel : UILabel!
    var cluesLabel : UILabel!
    var answersLabel :UILabel!
    var currentAnswer : UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    //New vars for string handling.
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    //Whenever score var is updated the score label will also update with didSet
    var score = 0 {
        didSet {
            scoreLabel.text = "Score : \(score)"
        }
    }
    
    var level = 1
    
    //LoadView function is overridden.
    override func loadView() {
        
        //view of ViewController is assigned to new UIView
        view = UIView()
        view.backgroundColor = .white
        
        //scoreLabel and its different properties are set and this view is added as subview to view.
        scoreLabel = UILabel()
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score : 0"
        view.addSubview(scoreLabel)
        
        //cluesLabel and its different properties are set and this view is added as subview to view.
        cluesLabel = UILabel()
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.textAlignment = .left
        //Content hugging property by default is 250. Here we set it as 1 to allow it to stretch vertically.
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        //answersLabel and its different properties are set and this view is added as subview to view.
        answersLabel = UILabel()
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        //Content hugging property by default is 250. Here we set it as 1 to allow it to stretch vertically.
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        //answersLabel and its different properties are set and this view is added as subview to view.
        currentAnswer = UITextField()
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        //This option will disable user interaction with the textField
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        //Submit button is created.
        let submit = UIButton(type: .system)
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        //Add target to our selector function submitTapped
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        //To add a dark grey border
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.darkGray.cgColor
        view.addSubview(submit)
        
        //Clear button is created.
        let clear = UIButton(type: .system)
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        //Add target to our selector function clearTapped
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        //To add a dark grey border
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.darkGray.cgColor
        view.addSubview(clear)
        
        //This will create a common view for all user selectable 20 buttons
        let buttonsView = UIView()
        //tamic i.e. translatesAutoresizingMaskIntoConstraints is false because we will provide constraints.
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //To add a dark grey border
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.darkGray.cgColor
        view.addSubview(buttonsView)
        
        //Here we add all the constraints for Labels, Buttons, View etc. as array elements
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant:  10),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor , constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            submit.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            submit.widthAnchor.constraint(equalToConstant: 80),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            clear.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            clear.widthAnchor.constraint(equalToConstant: 80),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        //Fixed width and height for letter buttons
        let letterButtonWidth = 150
        let letterButtonHeight = 80
        
        //Buttons will be laid inside buttons view in a 4x5 grid
        for row in 0 ..< 4 {
            for col in 0 ..< 5 {
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                //button title text will be replaced in code later.
                letterButton.setTitle("WWW", for: .normal)
                //Frame is created which will have x axis, y axis, height and width for CGRect.
                let frame = CGRect(x: col*letterButtonWidth, y: row*letterButtonHeight, width: letterButtonWidth, height: letterButtonHeight)
                //assign the frame to buttons frame
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                //add all buttons to letterbuttons array.
                letterButtons.append(letterButton)
                //assign same target letterTapped for all buttons.
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
            }

        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Method call to load the level in background thread.
        performSelector(inBackground: #selector(loadLevel), with: nil)

    }
    
    //Selector function when any of 20 letter buttons is pressed.
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        //This will hide the button
        sender.alpha = 0.1
    }
    
    //Selector function when clear button is tapped
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        //This will show the button which were hidden for that attempt.
        for btn in activatedButtons {
            btn.alpha = 1
        }

        activatedButtons.removeAll()
    }
    
    //Selector function when Submit button is tapped
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            //Alert message when level is cleared
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                //Handler has function to reload next level
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
            //Alert to show wrong guess
        else {
            let ac = UIAlertController(title: "Wrong Guess", message: "Press the clear button to restart guess", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
    }
    
    //Function to load the next level
    func levelUp(action: UIAlertAction) {
        
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        //Loadlevel function called to load the next level
        loadLevel()

        for btn in letterButtons {
            btn.alpha = 1
        }
    }

    //Load level will be called when starting app and to goto next level.
    //As per the fixed format of data within txt file. Relevant data is separated as required.
    @objc func loadLevel() {
        clueString = ""
        solutionString = ""
        letterBits = []
        
        //Levels are loaded from external files. 2 files are copied to project level 1 and level 2.
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            //Extract the file contents into a String constant.
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //This will create an array of string for each line in the file. Separator is newline character or \n
                var lines = levelContents.components(separatedBy: "\n")
                //all elements are shuffled in array.
                lines.shuffle()
                
                //This code will separate the array index as well as element value
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        letterBits.shuffle()
        
        //Updating screen tasks is taken on the Main thread.
        performSelector(onMainThread: #selector(updateScreen), with: nil, waitUntilDone: false)

    }
    
    //Selector function for the Main thread.
    @objc func updateScreen() {
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
}

