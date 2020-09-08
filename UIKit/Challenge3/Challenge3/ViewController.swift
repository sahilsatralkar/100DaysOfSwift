//
//  ViewController.swift
//  Challenge3
//
//  Created by Sahil Satralkar on 07/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Variables declaration
    var scoreLabel : UILabel!
    var display : UITextField!
    var buttonsView : UIView!
    var letterButtons = [UIButton]()
    let alphabetsArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var wordsArrayFromFile = [String]()
    var wordSelected = String()
    var questionString = ""
    var formedString = ""
    var charContainer = [Character]()
    var wordArrayCounter = 0
    var incorrectGuessCounter = 0
    
    //didSet method will set the scorelabel whenever score is changed.
    var score = 0 {
        didSet {
            
            scoreLabel.text = "Score : \(score)"
            
        }
    }
    
    //loadView method is overridden to set its views
    override func loadView() {
        
        //ViewController view is assigned the UIView object.
        view = UIView()
        view.backgroundColor = .white
        
        //Scorelabel is intitialized with its properties. tamic is false. Added as subview to view.
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score : 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        //display is intitialized with its properties. tamic is false. Added as subview to view.
        display = UITextField()
        display.translatesAutoresizingMaskIntoConstraints = false
        display.textAlignment = .center
        display.font = UIFont.systemFont(ofSize: 44)
        display.text = "????????"
        //This option will disable user interaction with the textField
        display.isUserInteractionEnabled = false
        view.addSubview(display)
        
        //buttonsView is intitialized with its properties. This will contain all Letter buttons. Added as subview to view.
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        //Content hugging property by default is 250. Here we set it as 1 to allow it to stretch vertically.
        buttonsView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        buttonsView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        //To add a dark grey border
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.darkGray.cgColor
        view.addSubview(buttonsView)
        
        //Here we add all the constraints for Labels, Buttons, View etc. as array elements
        NSLayoutConstraint.activate([
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant : 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            
            display.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            display.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6),
            display.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            display.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1),
            
            buttonsView.topAnchor.constraint(equalTo: display.bottomAnchor, constant: 20),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        //Fixed width and height for letter buttons
        let letterButtonWidth = 150
        let letterButtonHeight = 120
        var alphabetCount = 0
        
        //Buttons will be laid inside buttons view in a grid for 26 alphabets.
        for row in 0 ..< 5 {
            for col in 0 ..< 6 {
                
                if( alphabetCount < 26 ) {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 44, weight: .semibold)
                    //button title text will be replaced in code later.
                    letterButton.setTitle(alphabetsArray[alphabetCount], for: .normal)
                    //Frame is created which will have x axis, y axis, height and width for CGRect.
                    let frame = CGRect(x: col*letterButtonWidth, y: row*letterButtonHeight, width: letterButtonWidth, height: letterButtonHeight)
                    //assign the frame to buttons frame
                    letterButton.frame = frame
                    buttonsView.addSubview(letterButton)
                    //add all buttons to letterbuttons array.
                    letterButtons.append(letterButton)
                    //assign same target letterTapped for all buttons.
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    
                    alphabetCount += 1
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Method to load words from words.txt file
        loadWordsFromFile()
        //Method to load a level and start game
        loadLevel()
        
    }
    
    func loadWordsFromFile() {
        
        //words.txt file is loaded from bundle.
        if let levelFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            //Extract the file contents into a String constant.
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //This will create an array of string for each line in the file. Separator is newline character or \n
                wordsArrayFromFile = levelContents.components(separatedBy: "\n")
            }
        }
    }
    
    //Selector function when any of 26 letter buttons is pressed.
    @objc func letterTapped(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        var tempWord = ""
        
        for value in wordSelected {
            
            if String(value) == buttonTitle {
                charContainer.append(value)
            }
        }
        
        if !wordSelected.contains(buttonTitle) {
            incorrectGuessCounter += 1
        }
        
        if (incorrectGuessCounter == 7) {
            //Alert if wrong attempts are 7
            let ac = UIAlertController(title: "You Failed!", message: "Incorrect guesses have exceeded 7", preferredStyle: .alert)
            //levelFailed method is parameter to handler.
            ac.addAction(UIAlertAction(title: "Next", style: .default, handler: levelFailed))
            present(ac, animated: true)
            
        }
        //This loop will create the textfield comprised of letter guessed and question marks
        for ch in wordSelected {
            
            if charContainer.contains(ch) {
                tempWord.append(ch)
                
            } else {
                tempWord.append("?") 
                
            }
        }
        //Condition if user corrrectly guessed the word.
        if (tempWord == wordSelected ) {
            
            let ac = UIAlertController(title: "Good work!", message: "You have cleared the level!", preferredStyle: .alert)
            //levelCleared method is parameter to handler
            ac.addAction(UIAlertAction(title: "Next", style: .default, handler: levelCleared))
            present(ac, animated: true)
        }
        
        formedString = tempWord
        display.text = formedString
        //Hide the pressed button.
        sender.isHidden = true
  
    }
    
    //Function to load a new level.
    func loadLevel(){
        
        //all elements are shuffled in array.
        wordsArrayFromFile.shuffle()
        wordSelected = wordsArrayFromFile[wordArrayCounter]
        
        for _ in wordSelected {
            questionString.append("?")
        }
        formedString = questionString
        //text to display in textfied in '????' format.
        display.text = questionString
    }
    
    //Function to called when level cleared
    func levelCleared (action: UIAlertAction) {
        
        score += 1
        levelUp()
        
    }
    //Function to called when level is failed
    func levelFailed (action: UIAlertAction) {
        score -= 1
        levelUp()
        
    }
    
    //Function to load next word and reset the game.
    func levelUp() {
        
        //Counter to keep limt of words to 12.
        if (wordArrayCounter < 12) {
            wordArrayCounter += 1
        } else {
            wordArrayCounter = 0
        }
        
        wordSelected = wordsArrayFromFile[wordArrayCounter]
        
        questionString = ""
        charContainer.removeAll()
        for _ in wordSelected {
            questionString.append("?")
        }
        
        formedString = questionString
        display.text = questionString
        //Reset incorrect guessed counter
        incorrectGuessCounter = 0
        
        //Unhide all letter buttons.
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}
