//
//  ContentView.swift
//  Convert It
//
//  Created by Sahil Satralkar on 05/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //Variable declared with @State annotation for 2 way binding.
    @State var userValueInKilograms = ""
    
    //another varable declared to compute the result.
    var computedValueInPounds : Double {
        //Typecasting userValueInKilograms to Double and also nill coalescence so if user inputs string it wont crash the app.
        let tempUserValueInKilograms = Double(userValueInKilograms) ?? 0
        let tempComputedValueInPounds = (tempUserValueInKilograms * 2.20462262185)
        return tempComputedValueInPounds
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Weight in Kilograms")) {
                    //variable is marked with $ prefix so there is 2 way binding. Any update to this value will refresh the whole body every time.
                    TextField("Weight", text: $userValueInKilograms)
                        //User will be shown keyboard of decimalPad type.
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Result")) {
                    //the specifier will limt the result to 3 decimal places.
                    Text("\(computedValueInPounds, specifier: "%.3f") pounds")
                }
            }
            //this will display text on the Navigation bar.
            .navigationBarTitle("Convert It", displayMode: .large)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
