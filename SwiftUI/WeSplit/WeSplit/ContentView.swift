//
//  ContentView.swift
//  WeSplit
//
//  Created by Sahil Satralkar on 01/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //The 3 required variables are declared with @State annotation so that it can have 2 way binding.
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    
    @State private var toggleColor = false
    
    //Array to show the possible tip percent.
    let tipPercentages = ["10", "15", "20", "25", "0"]
    
    //This variable will compute its value based on values other variables.
    var totalPerPerson : Double {
        
        //typecasting int to double
        let peopleCount = Double(numberOfPeople + 2)
        //typecating tipPercentages to double with nill coalescence.
        let tipSelection = Double(tipPercentages[tipPercentage]) ?? 0
        //typecasting checkamount string to double with nill coalescence.
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
        
    }
    
    //Variable to compute total bill amount based on values of variables.
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
                    //$ before checkamount means 2 way binding. Any change to checkAmount will refresh the whole body.
                    TextField("Amount", text: $checkAmount)
                        //When user clicks on this field, keybad of decimal type is shown.
                        .keyboardType(.decimalPad)
                    //this picker whill give optin to choose number of people from 2 to 100.
                    Picker ("Number of people" , selection: $numberOfPeople) {
                        ForEach ( 2 ..< 100) {
                            //below code uses short hand for closure and $0 is the first parameter.
                            Text("\($0) people")
                        }
                    }
                }
                //Header within section means the text is displayed as one with Picker.
                Section(header: Text("How much tip do you want to leave?")) {
                    //2 way binding on this picker with tipPercentage. Any change to tipPercent will refresh the whole body.
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    //below code will display picke in segmented style.
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total Amount")) {
                    //specifier will limit the double value to 2 decimal places
                    Text("$\(originalAmount, specifier: "%.2f")")
                }
                Section(header: Text("Amount per person")) {
                    //specifier will limit the double value to 2 decimal places
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                        //terniary operator to change font red if 0 tip selected.
                        .foregroundColor(tipPercentage == 4 ? .red : .none)
                }
            }
            //code to display the navigation bar text
            .navigationBarTitle("WeSplit", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
