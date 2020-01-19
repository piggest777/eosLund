//
//  PlayerRealmObject.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-06.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import RealmSwift

class PlayerRealmObject: Object {
    
    @objc dynamic public private(set) var id: String = UUID().uuidString
    @objc dynamic public private(set) var playerName: String = ""
    @objc dynamic public private(set) var playerNumber: Int = 0
    @objc dynamic public private(set) var playerPosition: String = ""
    @objc dynamic public private(set) var playerLeague: String = "undefined"
    @objc dynamic public private(set) var playerImage: Data = Data()
    @objc dynamic public private(set) var playerUpdateDate: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["playerNumber"]
    }
    
    convenience init(playerId: String, playerName: String, playerNumber: Int, playerPosition: String, playerImage: Data, playerLeague: String, playerUpdateDate: Date) {
        self.init()
        self.id = playerId
        self.playerNumber = playerNumber
        self.playerName = playerName
        self.playerPosition = playerPosition
        self.playerImage = playerImage
        self.playerLeague = playerLeague
        self.playerUpdateDate = playerUpdateDate
    }
    
    static func addPlayerToRealmBase(playerId:String, playerName:String, playerNumber: Int, playerPosition: String, playerImage: Data, playerLeague: String, playerUpdateDate: Date) {
        REALM_QUEUE.sync {
             let player = PlayerRealmObject(playerId: playerId, playerName: playerName, playerNumber: playerNumber, playerPosition: playerPosition, playerImage: playerImage, playerLeague: playerLeague, playerUpdateDate: playerUpdateDate)
                   
                   do {
                       let realm = try Realm()
                        try realm.write {
                           realm.add(player)
                       }
                   } catch {
                       debugPrint("Can`t save player")
                   }
        }
    }
    
    static func updatePlayerInfo( player: Player, playerImage: UIImage, completionHandler:(Bool)->()) {
        let playerObject = PlayerRealmObject()
        playerObject.id = player.playerId
        playerObject.playerName = player.playerName
        playerObject.playerNumber = player.playerNumber
        playerObject.playerPosition = player.playerPosition
        let dataImage = playerImage.pngData()
        playerObject.playerImage = dataImage!
        playerObject.playerLeague = player.playerLeague
        playerObject.playerUpdateDate = Date()
        
        do {
           let realm =  try Realm()
            try realm.write {
                realm.add(playerObject, update: .modified)
                print(playerObject)
            }
            completionHandler(true)
        } catch  {
            debugPrint("Can`t update player")
        }
    }
    
    static func getAllPlayers () -> Results<PlayerRealmObject>?{
        do {
           let realm = try Realm()
            let players = realm.objects(PlayerRealmObject.self)
//            print(players.first?.playerName)
            return players
        } catch  {
            debugPrint("Can`t fetch data", error)
            return nil
        }
    }
    
//   static func getPlayer(for id: String) -> p? {
//        do {
//            let realm = try Realm(configuration: RealmConfig.runDataConfig)
//            
//            return realm.object(ofType: Run.self, forPrimaryKey: id)
//        } catch {
//            return nil
//        }
//    }
}
