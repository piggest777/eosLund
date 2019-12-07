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
    
    @objc dynamic public private(set) var id: String = ""
    @objc dynamic public private(set) var playerName: String = ""
    @objc dynamic public private(set) var playerNumber: String = ""
    @objc dynamic public private(set) var playerPosition: String = ""
    @objc dynamic public private(set) var playerImage: Data = Data()
    
    convenience init( playerName: String, playerNumber: String, playerPosition: String, playerImage: Data) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.playerNumber = playerNumber
        self.playerName = playerName
        self.playerPosition = playerPosition
        self.playerImage = playerImage
    }
    
    static func addPlayerToTable(playerName:String, playerNumber: String, playerPosition: String, playerImage: Data) {
        REALM_QUEUE.sync {
             let player = PlayerRealmObject(playerName: playerName, playerNumber: playerNumber, playerPosition: playerPosition, playerImage: playerImage)
                   
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
    
    static func getAllPlayers () -> Results<PlayerRealmObject>?{
        do {
           let realm = try Realm()
            let players = realm.objects(PlayerRealmObject.self)
            print(players)
            return players
        } catch  {
            debugPrint("Can`t fetch data")
            return nil
        }
    }
}
