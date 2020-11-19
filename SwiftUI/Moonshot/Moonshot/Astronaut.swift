//
//  Astronaut.swift
//  Moonshot
//
//  Created by Sahil Satralkar on 18/11/20.
//

import Foundation

//Create a struct anlogous to its JSON make it implement Codable and Identifiable
struct Astronaut : Codable, Identifiable {
    //Properties declaration
    let id : String
    let name: String
    let description : String
    
    //Method to fetch the astronaut names.
    func getAstronautMissions () -> String {
        
        var astronautMissions : String = ""
        let missions : [Mission] = Bundle.main.decode("missions.json")
        let astronauts : [Astronaut] = Bundle.main.decode("astronauts.json")
        for mission in missions {
            for crew in mission.crew {
                if self.id == crew.name {
                    astronautMissions += mission.displayName + " "
                }
            }
            
            
        }
        //Return the formatted string
        return "Missions : \(astronautMissions)"
    }
}
