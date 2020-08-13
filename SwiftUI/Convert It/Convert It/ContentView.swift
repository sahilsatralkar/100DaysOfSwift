//
//  ContentView.swift
//  Convert It
//
//  Created by Sahil Satralkar on 05/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var userValueInKilograms = ""
    
    var computedValueInPounds : Double {
        let tempUserValueInKilograms = Double(userValueInKilograms) ?? 0
        let tempComputedValueInPounds = (tempUserValueInKilograms * 2.20462262185)
        return tempComputedValueInPounds
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Weight in Kilograms")) {
                    TextField("Weight", text: $userValueInKilograms)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Result")) {
                    Text("\(computedValueInPounds, specifier: "%.3f") pounds")
                }
            }
            .navigationBarTitle("Convert It", displayMode: .large)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
