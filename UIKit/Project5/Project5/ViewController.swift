//
//  ViewController.swift
//  Project5
//
//  Created by Sahil Satralkar on 20/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //Array to store words from text file
    var allWords = [String]()
    //Array to store words guessed by user from 1 word selected in title.
    var usedWords = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This will set the right bar button in navigation bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        //This will set the left bar button in navigation bar.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        //Code to fetch the url path for the text input file.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //This will create a single string of all the contents in the text file
            if let startWords = try? String(contentsOf: startWordsURL) {
                //This will separate words in to array elements.
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        //If no words in text file
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        
    

        
        
        //This will do initial game loading
        startGame()
    }
    
    //This function will set the navigation bar tile to a random word from the allwords array.
    func startGame() {
        
        
        if let tempTitleWord = defaults.string(forKey: "titleWord") {
            title = tempTitleWord
        } else {
            title = allWords.randomElement()
            defaults.set(title, forKey: "titleWord")
        }
        if let tempUsedWords = defaults.object(forKey: "usedWords") as? [String] {
            usedWords = tempUsedWords
        } else {
            usedWords.removeAll(keepingCapacity: true)
            defaults.set(usedWords, forKey: "usedWords")
        }

        tableView.reloadData()
    }
    
    //Function for restart game from the beginning.
    @objc func restartGame() {
        
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        //
        save()
        tableView.reloadData()
    }
    
    //Function when Add button in clicked.
    @objc func addButtonTapped() {
        
        //New UIAlertController object
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        //Uset input textfield added.
        ac.addTextField()
        //UIAlertAction object is created.
        let submitAction = UIAlertAction(title: "OK", style: .default) {
            //This is handler closure with trailing syntax.
            // weak ViewController and weak UIAlertController object is requred within closure.
            [weak self, weak ac] action in
            //text from the single Textfield is extracted from UIAlertController object.
            guard let answer = ac?.textFields?[0].text else { return }
            //Text value is passed to submit functin withn ViewController.
            self?.submit(answer)
        }
        //Action is added to UIAlertController.
        ac.addAction(submitAction)
        //Present Alert.
        present(ac, animated: true)
    }
    
    //This method will verify the value entered by user within the alert.
    func submit(_ answer: String) {
        //All checks are done on lowercased word
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    
                    usedWords.insert(answer, at: 0)
                    //
                    save()
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorMessageAlert(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                    
                }
            } else {
                errorMessageAlert(errorTitle: "Word used already", errorMessage: "Be more original!")
                
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorMessageAlert(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
            
        }
        
    }
    //Function to create alert messages for invalid answers by user.
    func errorMessageAlert(errorTitle : String, errorMessage: String) {
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    //Function to check if the letter given by user matches the word in title.
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    //Function to check duplicates.
    func isOriginal(word: String) -> Bool {
        var tempArray = [String]()
        for usedWord in usedWords {
            tempArray.append(usedWord.lowercased())
        }
        
        return !tempArray.contains(word)
    }
    
    //Function to check if value entered by user is a real word.
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        if range.length <= 3 {
            return false
        }
        if word == (title ?? "") {
            return false
        }
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    //Compulsory implementation for UITableViewControllre to get the number of rowas to be displayed.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    //Compulsory implementation to assign table cell with data source.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    
    func save(){
        let titleText = title
        defaults.set(titleText, forKey: "titleWord")
        defaults.set(usedWords, forKey: "usedWords")
        
    }
    
}

