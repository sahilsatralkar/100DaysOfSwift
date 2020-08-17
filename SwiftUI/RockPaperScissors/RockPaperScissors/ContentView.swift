//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Sahil Satralkar on 17/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //Variable to store names of images.
    var gameMoves = ["rock","paper","scissors"]
    //# variables to track the state of game.
    @State var currentChoice : Int =  Int.random(in: 0 ... 2)
    @State var winOrLose : Bool = Bool.random()
    @State private var playerScore : Int = 0
    
    
    var body: some View {
        //ZStack is the parent stack.
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white,.white, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack (spacing : 30) {
                VStack{
                    
                    Text("iPhone's Move: \(gameMoves[currentChoice].uppercased())")
                    Text("Choose Result: \(winOrLose ? "WIN" : "LOSE")")
                    
                    
                }
                //This will create the 3 buttons for Rock , paper and scissors.
                ForEach(0..<3) { number in
                    Button(action: {
                        //Action to perform when a button is clicked.
                        self.buttonTapped(flagNumber : number)
                        
                    }) {
                        //Create buttons with game images from Assets.
                        ButtonImage(image : self.gameMoves[number])
                        
                        
                    }
                }
                Text("User Score : \(playerScore)")
            }
        }
    }
    //Function contains the conditional logic for the game.
    func buttonTapped(flagNumber : Int) {
        
        if currentChoice == 0 && flagNumber == 1  && winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
            
        } else if currentChoice == 0 && flagNumber == 2 && !winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
            
        } else if currentChoice == 1 && flagNumber == 2 && winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
        
        } else if currentChoice == 1 && flagNumber == 0 && !winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
        } else if currentChoice == 2 && flagNumber == 0 && winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
            
        } else if currentChoice == 2 && flagNumber == 1 && !winOrLose {
            playerScore += 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
            
        } else {
            playerScore -= 1
            currentChoice = Int.random(in: 0 ... 2)
            winOrLose = Bool.random()
        }
    }
}

// This will make a new View common to all the 3 buttons and their modifier
struct ButtonImage : View {
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
    static var previews: some View {
        ContentView()
    }
}
