//
//  MissionView.swift
//  Moonshot
//
//  Created by Sahil Satralkar on 18/11/20.
//

import SwiftUI

//View to show the second screen
struct MissionView: View {
    
    struct CrewMember {
        let role : String
        var astronaut : Astronaut 
        var astronautMissions : String
    }
    //Properties
    let mission : Mission
    let astronaults : [CrewMember]
    
    var body: some View {
        //GeometryReader is view to be flexible view
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth : geometry.size.width * 0.7)
                        .padding(.top)
                    Text(self.mission.formattedLaunchDate)
                    Text(self.mission.description)
                        .padding()
                    //Create rows for each astronaut
                    ForEach(self.astronaults, id: \.role) {
                        crewmember in
                        //NavigationLink to goto Astronaut details
                        NavigationLink(destination : AstronautView(astronaut: crewmember.astronaut, mission: mission, astronautMission: crewmember.astronautMissions)) {
                            //Formatting of Astronaut details in Horizontal stack
                            HStack {
                                Image(crewmember.astronaut.id)
                                    .resizable()
                                    .frame(width:83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary,lineWidth: 1))
                                VStack(alignment : .leading) {
                                    Text(crewmember.astronaut.name)
                                        .font(.headline)
                                    Text(crewmember.role)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer(minLength: 25)
                }
            }
            
        }
        //Nav title inline styling to show small font
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    //Initializer of view
    init(mission: Mission, astronauts : [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: {$0.id == member.name}) {
                matches.append(CrewMember(role: member.role, astronaut: match, astronautMissions: match.getAstronautMissions()))
            } else {
                fatalError("Missing \(member)")
            }
            
        }
        self.astronaults = matches
        
    }
}

struct MissionView_Previews: PreviewProvider {
    
    //Declare properties for preview
    static let missions : [Mission] = Bundle.main.decode("missions.json")
    static let astronauts : [Astronaut] = Bundle.main.decode("astronauts.json")
    //load details of any one element in array for preview
    static var previews: some View {
        MissionView(mission : missions[0], astronauts: astronauts)
    }
}
