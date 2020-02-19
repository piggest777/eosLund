//
//  Games.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-27.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class Game {

    private(set) var eosTeamCode: String!
    private(set) var oppositeTeamCode: String!
    private(set) var isHomeGame: Bool!
    private(set) var eosScore: Int!
    private(set) var oppositeTeamScore: Int!
    private(set) var gameDateAndTime: Date!
    private(set) var teamLeague: String!
    private(set) var documentId: String!
    private(set) var eosPlayers: String?
    private(set) var oppositeTeamPlayers: String?
    private(set) var statsLink: String?
    private(set) var gameDescription: String?
    private(set) var gameCoverUrl: String?
    
    
    init(eosTeamCode: String, oppositeTeamCode: String, eosScore: Int, oppositeTeamScore: Int, isHomeGame: Bool, gameDateAndTime: Date, teamLeague: String, documentId: String, eosPlayers: String?, oppositeTeamPlayers: String?, statsLink: String?, gameDesc: String?, gameCoverUrl: String?) {
        self.eosTeamCode = eosTeamCode
        self.oppositeTeamCode = oppositeTeamCode
        self.isHomeGame = isHomeGame
       
        self.eosScore = eosScore
        self.oppositeTeamScore = oppositeTeamScore
        self.gameDateAndTime = gameDateAndTime
        self.teamLeague = teamLeague
        self.documentId = documentId
        self.eosPlayers = eosPlayers
        self.oppositeTeamPlayers = oppositeTeamPlayers
        self.statsLink = statsLink
        self.gameDescription = gameDesc
        self.gameCoverUrl = gameCoverUrl
    }
    
    class func parseData (snapshot: QuerySnapshot?) -> [Game]{
        var games = [Game]()
        guard let snapshot = snapshot else { return games }
        
        for document in snapshot.documents {
            let data = document.data()
            let eosTeamCode: String = data[EOS_CODE] as? String ?? "EOS"
            let oppositeTeamCode: String = data[OPPOSITE_TEAM_CODE] as? String ?? "TEAM"
            let isHomeGame: Bool = data[IS_HOME_GAME] as? Bool ?? true
            let eosScore: Int = data[EOS_SCORES] as? Int ?? 0
            let oppositeTeamScores: Int = data[OPPOSITE_TEAM_SCORES] as? Int ?? 0
            let dateAndTimeTimestamp: Timestamp = data[GAME_DATE_AND_TIME] as? Timestamp ?? Timestamp()
//           Need to add date convert to empty string if date return nil
            let gameDateAndTime = dateAndTimeTimestamp.dateValue()
            let teamLeague: String = data[TEAM_LEAGUE] as? String ?? "undefined"
            let documentId = document.documentID
            let eosPlayers: String? = data[EOS_PLAYERS] as? String ?? nil
            let oppositeTeamPlayers: String? = data[OPPOSITE_TEAM_PLAYERS] as? String ?? nil
            let gameDesc: String? = data[GAME_DESCRIPTION] as? String ?? nil
            let statsLink: String? = data[STATISTIC_LINK] as? String ?? nil
            let gameCoverUrl: String?  = data[GAME_COVER_URL] as? String ?? nil
            
            
            
//            var team1:Team?
//            var team2: Team?
//            var homeTeamScore: Int = 0
//            var guestTeamScore: Int = 0
//            var homeTeamPlayers: String?
//            var guestTeamPlayers: String?
            
//            func setupTeams(isTeam1HomeTeam: Bool) {
//                if isTeam1HomeTeam {
//                    team1 = Team(name: team1Name, city: team1City)
//                    team2 = Team(name: team2Name, city: team2City)
//                    homeTeamScore = team1Score
//                    guestTeamScore = team2Score
//                    homeTeamPlayers = team1Players
//                    guestTeamPlayers = team2Players
//                } else {
//                    team1 = Team(name: team2Name, city: team2City)
//                    team2 = Team(name: team1Name, city: team1City)
//                    homeTeamScore = team2Score
//                    guestTeamScore = team1Score
//                    homeTeamPlayers = team2Players
//                    guestTeamPlayers = team1Players
//                }
//
//            }
            
//            if gameCity == "Lund" {
//                if team1City == "Lund"{
//                    setupTeams(isTeam1HomeTeam: true)
//                } else if team2City == "Lund" {
//                    setupTeams(isTeam1HomeTeam: false)
//                } else {
//                    setupTeams(isTeam1HomeTeam: true)
//                }
//            } else {
//                if team1City == "Lund"{
//                    setupTeams(isTeam1HomeTeam: false)
//                } else if team2City == "Lund" {
//                    setupTeams(isTeam1HomeTeam: true)
//                } else {
//                    setupTeams(isTeam1HomeTeam: false)
//                }
//            }
            
            let newGame = Game(eosTeamCode: eosTeamCode, oppositeTeamCode: oppositeTeamCode, eosScore: eosScore, oppositeTeamScore: oppositeTeamScores, isHomeGame: isHomeGame, gameDateAndTime: gameDateAndTime, teamLeague: teamLeague, documentId: documentId, eosPlayers: eosPlayers, oppositeTeamPlayers: oppositeTeamPlayers, statsLink: statsLink, gameDesc: gameDesc, gameCoverUrl: gameCoverUrl)
            
            games.append(newGame)
        }
        
        return games   
    }
}
