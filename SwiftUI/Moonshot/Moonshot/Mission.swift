//
//  Mission.swift
//  Moonshot
//
//  Created by Sahil Satralkar on 18/11/20.
//

import Foundation

//Struct to conform to its JSON and it implements Codable and Identifiable.
struct Mission : Codable, Identifiable {
    //Struct within struct to reflect the JSON structure
    struct CrewRole: Codable {
        let name : String
        let role : String
    }
    //Struct properties
    let id : Int
    let launchDate : Date?
    let crew : [CrewRole]
    let description : String
    
    var displayName : String {
        "Apollo \(id)"
    }
    
    var image : String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate : String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
        
    }
    //Format the names of astronauts in required string
    var allNames : String {
        var temp = ""
        for team in crew {
            temp += team.name + " "
        }
        return temp
    }
}
