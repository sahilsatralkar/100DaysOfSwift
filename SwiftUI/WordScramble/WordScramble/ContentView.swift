//
//  ContentView.swift
//  WordScramble
//
//  Created by Sahil Satralkar on 24/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //Variable declared which will have 2 way binding.
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        //NavigationVIew is the root view selected
        NavigationView {
            //VStack will have 3 views.
            VStack {
                //onCommit parameter will accept the method name which will be executed when user pressed enter/return key.
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    //This code will add a border to textbox.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    //This code will not capitalize first character of word entered in textbox.
                    .autocapitalization(.none)
                //List view is used to display the usedWords array
                List(usedWords, id: \.self) {
                    //This will add a image and text in HStack by default.
                    //Image used will be number of characters in word in a circle. Images are provided by apple.
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                //This will show the player score for words guessed.
                Text("Player Score : \(usedWords.count)")
            }
            //Title will be the root word from start.txt file
            .navigationBarTitle(rootWord)
            //onAppear will call the method startGame when the app is started.
            .onAppear(perform: startGame)
            //alert is displayed when user will input invalid word. Appropriate alert is shown accordingly.
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            //This will create a left bar button item in navigation bar.
            .navigationBarItems(leading: Button("Restart") {
                //call made to startGame method.
                self.startGame()
            })
        }
    }
    
    //Function to check and add the word entered by user.
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else {
            return
        }
        
        //exit if word is already guessed and create appropriate error
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            newWord = ""
            return
        }

        //exit if word guessed does not match the letters in the root word.
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            newWord = ""
            return
        }

        //exit if the word entered by user is not an actual word.
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            newWord = ""
            return
        }
        
        //If word entered is valide then push it in the usedWOrds array at position 0. All other entries are pushed below it.
        usedWords.insert(answer, at: 0)
        //Reset the text in textbox.
        newWord = ""
    }
    
    //Function to start new game or restart current game.
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                usedWords = []
                
                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    //Function will check if the word entered by user has alreaady been entered before to avoid duplication.
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //function to check if word entered by user can be formed from the root word.
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    //Function to check if word entered by user is a real word.
    func isReal(word: String) -> Bool {
        
        //Create a UITextChecker object.
        let checker = UITextChecker()
        //Create NSRange object and length must use utf16 encoding for count.
        let range = NSRange(location: 0, length: word.utf16.count)
        //Condition to disallow words shorter than 3 letters
        if (word.utf16.count < 4) {
            return false
        }
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        //NSNotFound is a special range value where the error in word was found. Below condition is false if word is not valid
        return misspelledRange.location == NSNotFound
    }
    
    //Function will create the alert to show the appropriate error message.
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
