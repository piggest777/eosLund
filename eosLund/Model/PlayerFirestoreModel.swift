//
//  PlayerFirestoreModel.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-08.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase


// Class with full player properties
class Player: BasicPlayer {
    
    private(set) var id: String!
    private(set) var imageUrl: String!
    private(set) var playerLeague: String!
    private(set) var updateDate: Date!
    private(set) var nationality: String!
    private(set) var originalClub: String!
    private(set) var inEosFrom: String!
    private(set) var bigImageURL: String!

    init(playerName: String, playerNumber: Int, playerPosition: String, playerImageUrl: String, playerId: String, playerLeague: String, playerUpdateDate: Date, playerHeight: String, playerDateOfBirth: String, playerNationality: String, playerOriginalClub: String, playerInEosFrom: String, playerBigImageURL: String) {
        
        self.imageUrl = playerImageUrl
        self.id = playerId
        self.playerLeague = playerLeague
        self.updateDate = playerUpdateDate
        self.nationality = playerNationality
        self.inEosFrom = playerInEosFrom
        self.originalClub = playerOriginalClub
        self.bigImageURL = playerBigImageURL
        super.init(name: playerName, number: playerNumber, dateOfBirth: playerDateOfBirth, height: playerHeight, position: playerPosition)
    }
    
    //get player info from firebase snapshot
    class func parsePlayerData (snapShot: QuerySnapshot?) -> [Player] {
        var players = [Player]()
        guard let snapshot = snapShot else {
            print("Can`t get players snapshot")
            return players}
        for document in snapshot.documents {
            let data = document.data()
            let playerName: String = data[PLAYER_NAME] as? String ?? " "
            let playerNumber: Int = data[PLAYER_NUMBER] as? Int ?? 0
            let playerPosition: String = data[PLAYER_POSITION] as? String ?? " "
            let playerImageURL: String = data[PLAYER_IMAGE_URL] as? String ?? "gs://eoslund-4ceb4.appspot.com/defaultAvatar.png"
            let playerBigImageURL: String = data[PLAYER_BIG_IMAGE_URL] as? String ?? ""
            let timestamp: Timestamp = data[PLAYER_UPDATE_DATE] as? Timestamp ?? Timestamp()
            let date: Date = timestamp.dateValue()
            let playerLeague: String = data[TEAM_LEAGUE] as? String ?? "undefined"
            let playerHeight: String = data[PLAYER_HEIGHT] as? String ?? ""
            let playerDateOfBirth: String = data[DAY_OF_BIRTH] as? String ?? ""
            let playerNationality: String = data[PLAYER_NATIONALITY] as? String ?? "NO INFO"
            let inEosFrom: String = data[PLAYER_INEOS_FROM] as? String ?? "NO INFO"
            let originalClub: String = data[PLAYER_ORIGINAL_CLUB] as? String ?? "NO INFO"
            let playerId: String = document.documentID
            
            let newPlayer = Player(playerName: playerName, playerNumber: playerNumber, playerPosition: playerPosition, playerImageUrl: playerImageURL, playerId: playerId, playerLeague: playerLeague, playerUpdateDate: date, playerHeight: playerHeight, playerDateOfBirth: playerDateOfBirth, playerNationality: playerNationality, playerOriginalClub: originalClub, playerInEosFrom: inEosFrom, playerBigImageURL: playerBigImageURL)
            players.append(newPlayer)
        }
        
        return players
    }
}
