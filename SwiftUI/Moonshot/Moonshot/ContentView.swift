//
//  ContentView.swift
//  Moonshot
//
//  Created by Sahil Satralkar on 18/11/20.
//

import SwiftUI

struct ContentView: View {
    
    //Fetch the JSON's into its analogous structs with Bundle extension
    let astronauts : [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions : [Mission] = Bundle.main.decode("missions.json")
    
    //To toggle the nav bar button to display date or astronaut names.
    @State private var toggle = false
    var body: some View {
        //All view inside NavigationView
        NavigationView {
            //List of missions array to make it into view of rows
            List(missions) { mission in
                //navigationLink for next screen and initialize the destination object
                NavigationLink(destination: MissionView(mission: mission, astronauts : astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        //Display depending on the toggle value
                        if toggle == false {
                            Text(mission.formattedLaunchDate)
                        } else {
                            Text(mission.allNames)
                        }
                        
                    }
                    
                }
            }
            .navigationBarTitle("Moonshot")
            //Set the nav bar button Toggle
            .navigationBarItems(trailing: Button(action : {
                self.toggle.toggle()
            })
            {
                Text("Toggle")
                
            })
        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

