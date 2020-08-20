//
//  ContentView.swift
//  BetterRest
//
//  Created by Sahil Satralkar on 19/08/20.
//  Copyright © 2020 Sahil Satralkar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    //@State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    
    @State private var bedTime = ""
    
    let model = SleepCalculator()
    var components : DateComponents {
        
        return Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    }
    
    var hour :Int {
        
        return (components.hour ?? 0) * 60 * 60
    }
    
    var minute : Int {
        
        return (components.minute ?? 0) * 60
    }
    
    var prediction : SleepCalculatorOutput {
        return try! model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
    }
    var sleepTime : Date {
        
        return wakeUp - prediction.actualSleep
    }
    
    var formatDate : String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: sleepTime)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                        
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of coffee")
                        .font(.headline)
                    Picker ("Number of people" , selection: $coffeeAmount) {
                        ForEach ( 1 ..< 21) {
                            //below code uses short hand for closure and $0 is the first parameter.
                            if ($0 == 1) {
                                Text("\($0) cup")
                            }
                            else {
                                Text("\($0) cups")
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Sleep time: ")
                        .font(.headline)
                    Text("\(formatDate)")
                    .font(.largeTitle)
                    
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
