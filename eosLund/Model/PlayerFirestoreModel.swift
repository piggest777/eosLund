//
//  PlayerFirestoreModel.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-08.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class Player {
    private(set) var playerName: String!
    private(set) var playerNumber: String!
    private(set) var playerPosition: String!
    private(set) var playerImageUrl: String!
    private(set) var playerId: String!
    private(set) var playerUpdateDate: Date!
    
    init(playerName: String, playerNumber: String, playerPosition: String, playerImageUrl: String, playerId: String, playerUpdateDate: Date) {
        self.playerName = playerName
        self.playerNumber = playerNumber
        self.playerPosition = playerPosition
        self.playerImageUrl = playerImageUrl
        self.playerId = playerId
        self.playerUpdateDate = playerUpdateDate
    }
    
    class func parsePlayerData (snapShot: QuerySnapshot?) -> [Player] {
        var players = [Player]()
        guard let snapshot = snapShot else {
            print("Can`t get Snapshot")
            return players}
        for document in snapshot.documents {
            let data = document.data()
            
            let playerName: String = data[PLAYER_NAME] as? String ?? " "
            let playerNumber: String = data[PLAYER_NUMBER] as? String ?? " "
            let playerPosition: String = data[PLAYER_POSITION] as? String ?? " "
            let playerImageURL: String = data[PLAYER_IMAGE_URL] as? String ?? " "
            let timestamp: Timestamp = data[PLAYER_UPDATE_DATE] as? Timestamp ?? Timestamp()
            let date: Date = timestamp.dateValue()
            let playerId: String = document.documentID
            
            let newPlayer = Player(playerName: playerName, playerNumber: playerNumber, playerPosition: playerPosition, playerImageUrl: playerImageURL, playerId: playerId, playerUpdateDate: date)
            players.append(newPlayer)
        }
        
        return players
    }
    
}
