//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Sahil Satralkar on 14/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            CapsuleView(text: "First")
            CapsuleView(text : "Second")
        }
    }
}


struct CapsuleView : View {
    var text : String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
