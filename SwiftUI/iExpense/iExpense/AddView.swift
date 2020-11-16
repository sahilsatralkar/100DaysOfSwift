//
//  AddView.swift
//  iExpense
//
//  Created by Sahil Satralkar on 16/11/20.
//

import SwiftUI

struct AddView: View {
    //Properties declaration
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    //expenses from ContentView will be passed to this property
    @ObservedObject var expenses : Expenses
    
    //This line is required to dismiss the sheet within save button closure
    @Environment(\.presentationMode) var presentationMode
    
    //Two preset types of 'type'
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(AddView.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            //Trailing nav bar button to save entries
            .navigationBarItems(trailing: Button("Save"){
                //Check if amount entered is int
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    //Append item to expenses ObservedObject property
                    self.expenses.items.append(item)
                    //dismiss the sheet
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    //Alert boolean
                    showingAlert = true
                }
            })
            //Aalert to show error if Int not entered in amount field.
            .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text("Please enter numeric value in Amount"), dismissButton: .cancel())
                        }
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        //Code to show it properly in Preview window
        AddView(expenses: Expenses())
    }
}
