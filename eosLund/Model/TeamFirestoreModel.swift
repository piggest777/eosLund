//
//  TeamFirestoreModel.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class TeamFirestoreModel  {
    private(set) var id: String!
    private(set) var teamName: String!
    private(set) var teamCity: String!
    private(set) var homeArena: String!
    private(set) var logoPathName: String!
    
    init(id: String, teamName: String, teamCity: String, homeArena: String, logoPathName: String) {
        self.id = id
        self.teamName = teamName
        self.teamCity = teamCity
        self.homeArena = homeArena
        self.logoPathName = logoPathName
    }
    
    class func parseTeamData(snapshot: QuerySnapshot?) -> [TeamFirestoreModel]{
        var teamArray = [TeamFirestoreModel]()
        
        guard let snapshot = snapshot else {
            print("Can`t get teams snapshot")
            return teamArray}
        
        for document in snapshot.documents {
            let data = document.data()
            let id = document.documentID
            let teamName = data[TEAM_NAME] as? String ?? "Team"
            let teamCity = data[TEAM_CITY] as? String ?? ""
            let homeArena = data[HOME_ARENA] as? String ?? ""
            let logoPathName = data[LOGO_PATH_NAME] as? String ?? "defaultTeamLogo.png"
            
            let newTeam: TeamFirestoreModel = TeamFirestoreModel(id: id, teamName: teamName, teamCity: teamCity, homeArena: homeArena, logoPathName: logoPathName)
            
            if id != "teamInfoUpdateDate" {
                teamArray.append(newTeam)
            }
            
        }
        
        return teamArray
        
    }
}
