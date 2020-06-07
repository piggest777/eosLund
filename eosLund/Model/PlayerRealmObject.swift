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
    @objc dynamic public private(set) var playerNumber: Int = 404
    @objc dynamic public private(set) var playerPosition: String = ""
    @objc dynamic public private(set) var playerLeague: String = "undefined"
    @objc dynamic public private(set) var playerImage: Data = Data()
    @objc dynamic public private(set) var playerUpdateDate: Date = Date()
    @objc dynamic public private(set) var playerHeight: String = ""
    @objc dynamic public private(set) var playerDateOfBirth: String = ""
    @objc dynamic public private(set) var playerNationality: String = ""
    @objc dynamic public private(set) var playerOriginalClub: String = ""
    @objc dynamic public private(set) var playerInEosFrom: String = ""
    @objc dynamic public private(set) var playerBigImageUrl: String = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["playerNumber"]
    }
    
    convenience init(playerId: String, playerName: String, playerNumber: Int, playerPosition: String, playerImage: Data, playerLeague: String, playerUpdateDate: Date, playerHeight: String, playerDateOfBirth: String, playerOriginalClub: String, playerInEosFrom: String, playerNationality: String, playerBigImageUrl: String) {
        self.init()
        self.id = playerId
        self.playerNumber = playerNumber
        self.playerName = playerName
        self.playerPosition = playerPosition
        self.playerImage = playerImage
        self.playerLeague = playerLeague
        self.playerUpdateDate = playerUpdateDate
        self.playerHeight = playerHeight
        self.playerDateOfBirth = playerDateOfBirth
        self.playerNationality = playerNationality
        self.playerOriginalClub = playerOriginalClub
        self.playerInEosFrom = playerInEosFrom
        self.playerBigImageUrl = playerBigImageUrl
    }
    
    //update or add information about player in realm base
    static func updatePlayerInfo( player: Player, playerImage: UIImage, completionHandler:(Bool)->()) {
        let playerObject = PlayerRealmObject()
        playerObject.id = player.id
        playerObject.playerName = player.name
        playerObject.playerNumber = player.number
        playerObject.playerPosition = player.position
        let dataImage = playerImage.pngData()
        playerObject.playerImage = dataImage!
        playerObject.playerLeague = player.playerLeague
        playerObject.playerUpdateDate = Date()
        playerObject.playerHeight = player.height
        playerObject.playerDateOfBirth = player.dateOfBirth
        playerObject.playerNationality = player.nationality
        playerObject.playerOriginalClub = player.originalClub
        playerObject.playerInEosFrom = player.inEosFrom
        playerObject.playerBigImageUrl = player.bigImageURL
        
        do {
            let realm =  try Realm()
            try realm.write (
                transaction: {
                    realm.add(playerObject, update: .modified)
            },
                completion: {
                    completionHandler(true)
            })
        } catch  {
            debugPrint("Can`t update player in realm base")
        }
    }
    
//    get information about all players from realm base
    static func getAllPlayers () -> Results<PlayerRealmObject>?{
        do {
            let realm = try Realm()
            let players = realm.objects(PlayerRealmObject.self)
            return players
        } catch  {
            debugPrint("Can`t fetch data from realm base", error)
            return nil
        }
    }
    
    //get players from realm base filtered by specific league
    static func getRealmPredicatePlayerListForTable(league: String) -> Results<PlayerRealmObject>? {
        let leaguePredicate = NSPredicate(format: "playerLeague = %@", league)
        return PlayerRealmObject.getAllPlayers()?.filter(leaguePredicate).sorted(byKeyPath: "playerNumber")
    }
}
