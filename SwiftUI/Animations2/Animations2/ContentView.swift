//
//  ContentView.swift
//  Animations2
//
//  Created by Sahil Satralkar on 29/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //Text fr
    let letters = Array("Voldemort")
    let letters2 = Array("-:Nagini")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [self.enabled ? .red : .blue,self.enabled ?.blue : .red]), startPoint: .top, endPoint: .bottom)
                
                .edgesIgnoringSafeArea(.all)
            VStack(spacing : 10) {
                HStack(spacing: 0) {
                    
                    ForEach(0..<letters.count) { num in
                        Text(String(self.letters[num]))
                            .padding(5)
                            .font(.largeTitle)
                            .background(self.enabled ? LinearGradient(gradient: Gradient(colors: [.blue,.red]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.red,.blue]), startPoint: .top, endPoint: .bottom))
                            .offset(self.dragAmount)
                            .animation(Animation.default.delay(Double(num) / 10))
                    }
                    
                }
                HStack(spacing: 0) {
                    
                    ForEach(0..<letters2.count) { num in
                        Text(String(self.letters2[num]))
                            .padding(5)
                            .font(.largeTitle)
                            .background(self.enabled ? LinearGradient(gradient: Gradient(colors: [.blue,.red]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.red,.blue]), startPoint: .top, endPoint: .bottom))
                            .offset(self.dragAmount)
                            .animation(Animation.default.delay(Double(num) / 10))
                    }
                    
                }
            }
        }
            
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { _ in
                    self.dragAmount = .zero
                    self.enabled.toggle()
            }
        )
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
