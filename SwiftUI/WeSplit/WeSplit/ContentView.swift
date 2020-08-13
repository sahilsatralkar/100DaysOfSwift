//
//  ContentView.swift
//  WeSplit
//
//  Created by Sahil Satralkar on 01/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    let tipPercentages = ["10", "15", "20", "25", "0"]
    var totalPerPerson : Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage]) ?? 0
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
        
    }
    var originalAmount : Double {
        let orderAmount = Double(checkAmount) ?? 0
        let tipSelection = Double(tipPercentages[tipPercentage]) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        return tipValue + orderAmount
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    Picker ("Number of people" , selection: $numberOfPeople) {
                        ForEach ( 2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                    
                }
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Total Amount")) {
                    Text("$\(originalAmount, specifier: "%.2f")")
                }
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit", displayMode: .inline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
