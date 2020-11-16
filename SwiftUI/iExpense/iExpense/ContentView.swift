//
//  ContentView.swift
//  iExpense
//
//  Created by Sahil Satralkar on 16/11/20.
//

import SwiftUI

//struct declared with required properties. Confirms to Identifiable and Codable protocol.
struct ExpenseItem : Identifiable, Codable {
    
    //struct confirms to Identifiable so property named id is compulsory
    let id = UUID()
    let name : String
    let type : String
    let amount : Int

}

//class is created so that its object can be freely passed to AddView
class Expenses : ObservableObject {
    
    @Published var items : [ExpenseItem] {
        
        didSet {
            //Code to fetch data from Userdefaults. If not present it sents zero or false and not nil
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    //Initialiser created for class that will create UserDefaults entry
    init() {
        
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        //if items not present in userdegaults than assign an empty array.
        self.items = []
    }
}


struct ContentView: View {
    
    //marked as ObservedObject because it will be read with AddView
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        //NavigationView created and it contains List child
        NavigationView {
            List {
                ForEach (expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading ){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        //Giving diferent font size depending on amount value
                        if (item.amount < 10){
                            Text("$\(item.amount)")
                                .font(.system(size: 15))
                        } else if (item.amount < 100){
                            Text("$\(item.amount)")
                                .font(.system(size: 18))
                        } else {
                            Text("$\(item.amount)")
                                .font(.system(size: 20))
                        }
                        
                        
                    }
                }
                //onDelete is called on ForEach and method name is passed
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            //Two buttons each on Nav bar. EditButton is a builtin method.
            .navigationBarItems(leading: EditButton(), trailing:
                                    Button(action : {
                                        self.showingAddExpense = true
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )
            
            
        }
        //COde to present the second sheet with showingAddExpense boolean passed
        .sheet(isPresented: $showingAddExpense) {
            //Sent expenses as parameter to AddView
            AddView(expenses: self.expenses)
        }
        
    }
    
    //Function to remove individual items
    func removeItems( at offsets : IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
