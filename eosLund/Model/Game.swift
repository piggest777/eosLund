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
    private(set) var team1Name: String!
    private(set) var team2Name: String!
    private(set) var team1City: String!
    private(set) var team2City: String!
    private(set) var team1Score: Int!
    private(set) var team2Score: Int!
    private(set) var team1Players: String?
    private(set) var team2Players: String?
    private(set) var statsLink: String?
    private(set) var gameDescription: String?
    private(set) var gameCity: String!
    private(set) var gamePlace: String!
    private(set) var gameDateAndTime: Date!
    private(set) var teamLeague: String!
    private(set) var documentId: String!
    
    
    init(team1: Team, team2: Team, team1Score: Int, team2Score: Int, gameCity: String!, gamePlace: String!, gameDateAndTime: Date, teamLeague: String, documentId: String, team1Players: String?, team2Players: String?, statsLink: String?, gameDesc: String?) {
        self.team1Name = team1.name
        self.team2Name = team2.name
        self.team1City = team1.city
        self.team2City = team2.city
        self.team1Score = team1Score
        self.team2Score = team2Score
        self.gameCity = gameCity
        self.gamePlace = gamePlace
        self.gameDateAndTime = gameDateAndTime
        self.teamLeague = teamLeague
        self.documentId = documentId
        self.team1Players = team1Players
        self.team2Players = team2Players
        self.statsLink = statsLink
        self.gameDescription = gameDesc
    }
    
    class func parseData (snapshot: QuerySnapshot?) -> [Game]{
        var games = [Game]()
        guard let snapshot = snapshot else { return games }
        
        for document in snapshot.documents {
            let data = document.data()
            let team1Name: String = data[TEAM_1_NAME] as? String ?? "TEAM 1"
            let team2Name: String = data[TEAM_2_NAME] as? String ?? "TEAM 2"
            let team1City: String = data[TEAM_1_CITY] as? String ?? " "
            let team2City: String = data[TEAM_2_CITY] as? String ?? " "
            let team1Score: Int = data[TEAM_1_SCORE] as? Int ?? 0
            let team2Score: Int = data[TEAM_2_SCORE] as? Int ?? 0
            let gameCity: String = data[GAME_CITY] as? String ?? " "
            let gamePlace: String = data[GAME_PLACE] as? String ?? " "
            let dateAndTimeTimestamp: Timestamp = data[GAME_DATE_AND_TIME] as? Timestamp ?? Timestamp()
//           Need to add date convert to empty string if date return nil
            let gameDateAndTime = dateAndTimeTimestamp.dateValue()
            let teamLeague: String = data[TEAM_LEAGUE] as? String ?? "undefined"
            let documentId = document.documentID
            let team1Players: String? = data[TEAM_1_PLAYERS] as? String ?? nil
            let team2Players: String? = data[TEAM_2_PlAYERS] as? String ?? nil
            let gameDesc: String? = data[GAME_DESCRIPTION] as? String ?? nil
            let statsLink: String? = data[STATISTIC_LINK] as? String ?? nil
            
            
            
            var team1:Team?
            var team2: Team?
            var homeTeamScore: Int = 0
            var guestTeamScore: Int = 0
            var homeTeamPlayers: String?
            var guestTeamPlayers: String?
            
            func setupTeams(isTeam1HomeTeam: Bool) {
                if isTeam1HomeTeam {
                    team1 = Team(name: team1Name, city: team1City)
                    team2 = Team(name: team2Name, city: team2City)
                    homeTeamScore = team1Score
                    guestTeamScore = team2Score
                    homeTeamPlayers = team1Players
                    guestTeamPlayers = team2Players
                } else {
                    team1 = Team(name: team2Name, city: team2City)
                    team2 = Team(name: team1Name, city: team1City)
                    homeTeamScore = team2Score
                    guestTeamScore = team1Score
                    homeTeamPlayers = team2Players
                    guestTeamPlayers = team1Players
                }

            }
            
            if gameCity == "Lund" {
                if team1City == "Lund"{
                    setupTeams(isTeam1HomeTeam: true)
                } else if team2City == "Lund" {
                    setupTeams(isTeam1HomeTeam: false)
                } else {
                    setupTeams(isTeam1HomeTeam: true)
                }
            } else {
                if team1City == "Lund"{
                    setupTeams(isTeam1HomeTeam: false)
                } else if team2City == "Lund" {
                    setupTeams(isTeam1HomeTeam: true)
                } else {
                    setupTeams(isTeam1HomeTeam: false)
                }
            }
            
            let newGame = Game(team1: team1!, team2: team2!, team1Score: homeTeamScore, team2Score: guestTeamScore, gameCity: gameCity, gamePlace: gamePlace, gameDateAndTime: gameDateAndTime, teamLeague: teamLeague, documentId: documentId, team1Players: homeTeamPlayers, team2Players: guestTeamPlayers, statsLink: statsLink, gameDesc: gameDesc )
            
            games.append(newGame)
        }
        
        return games   
    }
}
