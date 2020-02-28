//
//  TeamRealmObject.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-08.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation
import RealmSwift

class TeamRealmObject: Object {
    @objc dynamic public private(set) var id: String = "NULL"
    @objc dynamic public private(set) var teamName: String = "Team"
    @objc dynamic public private(set) var teamCity: String = ""
    @objc dynamic public private(set) var homeArena: String =  ""
    @objc dynamic public private(set) var logoPathName: String = "defaultTeamLogo.png"
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, teamName: String, teamCity: String, homeArena: String, logoPathName: String){
        self.init()
        self.id = id
        self.teamName = teamName
        self.teamCity = teamCity
        self.homeArena = homeArena
        self.logoPathName = logoPathName
    }
    
    static func addTeamToRealmBase(id: String, teamName:String, teamCity: String, homeArena: String, logoPatnName: String) {
        REALM_QUEUE.sync {
            let newTeam = TeamRealmObject(id: id, teamName: teamName, teamCity: teamCity, homeArena: homeArena, logoPathName: logoPatnName)
            
            do{
                let realm = try Realm()
                
                try realm.write {
                    realm.add(newTeam)
                }
            } catch {
                debugPrint("can`t add new team to Realm Base", error)
            }
        }
    }
    
    static func updateTeamInfo(team: TeamFirestoreModel) {
        let realmTeam = TeamRealmObject()
        realmTeam.id = team.id
        realmTeam.teamName = team.teamName
        realmTeam.teamCity = team.teamCity
        realmTeam.homeArena = team.homeArena
        realmTeam.logoPathName = team.logoPathName
        
        do {
           let realm =  try Realm()
            try realm.write {
                realm.add(realmTeam, update: .modified)
            }
        } catch  {
            debugPrint("can`t update team info", error)
        }
    }
    
    static func getAllRealmTeam() -> Results<TeamRealmObject>?{
        do {
           let realm = try Realm()
            let teams = realm.objects(TeamRealmObject.self)
            return teams
        } catch  {
            debugPrint("Can`t get team`s list from realm", error)
            return nil
        }
    }
    
    static func deleteRealmTeamBy(id: String) {
        do {
            
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: TeamRealmObject.self, forPrimaryKey: id)
            
            guard let object = objectToDelete else {return}
            try! realm.write {
                realm.delete(object)
            }
            
        } catch  {
            debugPrint("Can`t delete RealmTeamObject", error)
        }
    }
    
    static func getTeamInfoById(id: String) -> TeamRealmObject {

        let defaultOppositeTeam = TeamRealmObject(id: "", teamName: "Team", teamCity: "", homeArena: "", logoPathName: "defaultLogo.png")
        
         do {
            let realmOppositeTeam = try Realm().object(ofType: TeamRealmObject.self, forPrimaryKey: id)
             return realmOppositeTeam ?? defaultOppositeTeam
         } catch  {
            debugPrint("Can`t get team info from Realm Base", error)
             return defaultOppositeTeam
         }
     }
    
    static func realmWriteWithCallback(team: TeamFirestoreModel, completion: @escaping (Bool)->()) {
        let realmTeam = TeamRealmObject()
        realmTeam.id = team.id
        realmTeam.teamName = team.teamName
        realmTeam.teamCity = team.teamCity
        realmTeam.homeArena = team.homeArena
        realmTeam.logoPathName = team.logoPathName
        
        do {
           let realm =  try Realm()
            try realm.write(
                transaction: {
                    realm.add(realmTeam)
                },
                completion: {
                    completion(true)
            })
        } catch  {
            debugPrint("can`t update team info", error)
        }
    }
}
