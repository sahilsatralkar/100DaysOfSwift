//
//  ContentView.swift
//  MultiplyFun
//
//  Created by Sahil Satralkar on 02/09/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var multiplyTable = 1
    @State private var numberOfQuestions = [5, 10, 20 , 50]
    @State private var numberOfQuestionsSelected = 0
    @State private var inputString = ""
    
    
    var body: some View {
        
        Group {
            VStack(alignment: .leading, spacing: 0) {
                Text("Select the muliplication table")
                    .font(.headline)
                
                Stepper(value: $multiplyTable, in: 1...12, step: 1) {
                    Text("Table of \(multiplyTable)")
                    
                }
            
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Select number of questions")
                    .font(.headline)
                
                Stepper(value: $numberOfQuestionsSelected, in: 0...3, step: 1 ) {
                    Text("\(numberOfQuestions[numberOfQuestionsSelected]) questions selected")
                    
                }
            }
            VStack {
                
                Button(action: {
                    print("Start")
                }) {
                    //Create buttons with game images from Assets.
//                    Image("buttonDefault")
//                        .renderingMode(.original)
                    Text("Start")
                        .fontWeight(.bold)
                        .font(.headline)
                        .frame(width: 200, height: 100, alignment: .center)
                        .background(Color.red)
                        
                        
                }
                //Text("Start")
            }
            VStack {
                Text ("8 x 9")
                TextField("Enter your Answer", text: $inputString)
                    .keyboardType(.numberPad)
            }
            VStack {
                Text ("Player Score: ")
                
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
