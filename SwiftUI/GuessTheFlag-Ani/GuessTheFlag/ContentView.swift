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
    //var to track the player score. +1 for correct answer and -1 for wrong.
    @State private var playerScore = 0
    
    @State private var degrees = 180.0
    @State private var scale : CGFloat = 1.0
    var xAxis : CGFloat = 0.0
    var yAxis : CGFloat = 0.0
   
    
    var body: some View {
        //ZStack is parent stack to include everything above a background of colors.
        ZStack {
            //This will create gradient background.
            LinearGradient(gradient: Gradient(colors: [.green,.blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
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
                        //The buttons will be random 3 images from Assets.
                        //FlagImage(image: self.countries[number])
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .rotation3DEffect(.degrees(self.degrees), axis: (x: 1, y: 0, z: 0))
                            .scaleEffect(self.scale)
                            .animation(.easeIn(duration: 2))
                    }
                }
                VStack {
                    Text("Player Score: \(playerScore)")
                        .font(.headline)
                }
            }
        }
    }
    
    //This method is an action for when any flag button is tapped by user.
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            //Set values when correct flag image clicked.
            
            
            //self.xAxis = 1.0
            degrees = degrees == 0.0 ? 360.0 : 0.0
            
            //playerScore += 1
        } else {
            //Set values when wrong flag image clicked.
            
            //xAxis = 0.0
            degrees = degrees == 0.0 ? 360.0 : 0.0
            //playerScore -= 1
        }
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.playerScore += 1
            self.askQuestion()
        }
    }
    
    //This Method will change the couutries and its answer.
    func askQuestion() {
        correctAnswer = Int.random(in: 0...2)
        countries.shuffle()
        
    }
}

// This will make a new View common to all the 3 buttons and their modifier
struct FlagImage : View {
    var image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View  {
        ContentView()
    }
}
