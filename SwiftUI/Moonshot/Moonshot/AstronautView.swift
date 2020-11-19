//
//  AstronautView.swift
//  Moonshot
//
//  Created by Sahil Satralkar on 19/11/20.
//

import SwiftUI

//View which is for each astronaut details
struct AstronautView: View {
    //Properties
    let astronaut : Astronaut
    let mission : Mission
    let astronautMission : String
    
    var body: some View {
        //View inside GeometryReder so it is flexible
        GeometryReader {
            geometry in
            //Make the view scrollable vertically
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    Text (self.astronautMission)
                    Text(self.astronaut.description)
                        .padding()
                        //Make the view higher property so ther is no clipping
                        .layoutPriority(1)
                }
            }
        }
        //Nav bar title in small text so its inline
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
        
    }
}

struct AstronautView_Previews: PreviewProvider {
    //Properties for preview
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions : [Mission] = Bundle.main.decode("missions.json")
    //Giving details for any element in array for preview
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], mission: missions[0], astronautMission: "")
    }
}
