//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sahil Satralkar on 14/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //countries array contains the names of all countries whose flag images we have. Annotation @State is necessary for two way binding.
    @State private var countries = ["France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Estonia", "Russia", "Spain", "UK", "US"].shuffled()
    //This var will choose a random anwer for 3 flags displayed.
    @State private var correctAnswer = Int.random(in: 0...2)
    //This var is to toggle the Alert to display or not. Default is false
    @State private var showingScore = false
    //Correct answer which is chosen
    @State private var scoreTitle = ""
    //var to track the player score. +1 for correct answer and -1 for wrong.
    @State private var playerScore = 0
    
    var body: some View {
        //ZStack is parent stack to include everything above a background of colors.
        ZStack {
            //This will create gradient background.
            LinearGradient(gradient: Gradient(colors: [.red,.blue]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            //Vertical stack with spacing between the 2 Texts.
            VStack (spacing : 30) {
                VStack {
                    Text("Tap the flag of")
                    Text("\(countries[correctAnswer])")
                        //In built SwiftUI styling used for this Text.
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                //3 Buttons / flags are displayed used ForEach
                ForEach(0..<3) { number in
                    Button(action: {
                        //Action to perform when a button is clicked.
                        self.flagTapped(number)
                    }) {
                        //The buttons will be randon 3 images from Assets.
                        Image(self.countries[number])
                            //In built SwiftUI styling used for this Image.
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                VStack {
                    Text("Player Score: \(playerScore)")
                }
            }
            
        }
            //Alert code is after the parent ZStack but within body.
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("Your score is \(playerScore)"), dismissButton: .default(Text("Continue")) {
                    //Method to be called when Continue button within Alert is pressed.
                    self.askQuestion()
                    })
        }
    }
    
    //This method is an action for when any flag button is tapped by user.
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            //Set values when correct flag image clicked.
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            //Set values when wrong flag image clicked.
            scoreTitle = "Wrong! Thats the flag of \(countries[number])"
            playerScore -= 1
        }
        //This will call the .alert code
        showingScore = true
    }
    
    //This Method will change the couutries and its answer.
    func askQuestion() {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View  {
        ContentView()
    }
}
