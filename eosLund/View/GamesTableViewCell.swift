//
//  GamesTableViewCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-27.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import RealmSwift

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var team1NameLbl: UILabel!
    @IBOutlet weak var team2NameLbl: UILabel!
    @IBOutlet weak var gameDateTImeAndPlaceLbl: UILabel!
    @IBOutlet weak var team1GameScoreView: UIView!
    @IBOutlet weak var team2GameScoreView: UIView!
    @IBOutlet weak var hostTeamLogo: UIImageView!
    @IBOutlet weak var guestTeamLogo: UIImageView!
    
    func configureCell(game: Game) {
        
        var oppositeTeam: TeamRealmObject?
        
        do {
             oppositeTeam = try Realm().object(ofType: TeamRealmObject.self, forPrimaryKey: game.oppositeTeamCode)
        } catch  {
            debugPrint("Can`t get realm object by key")

        }
        
        if oppositeTeam == nil {
             oppositeTeam = TeamRealmObject(id: "NULL", teamName: "Team", teamCity: "", homeArena: "", logoPathName: "defaultLogo.png")
        }
        
//        let teams = chooseGameHost(hostIsEos: game.isHomeGame, oppositeTeam: oppositeTeam!)
        

        

        if game.isHomeGame {
            team1NameLbl.text = "\(EOS_TEAM.teamName!) \n \(EOS_TEAM.teamCity!)"
            team2NameLbl.text = "\(oppositeTeam!.teamName) \n \(oppositeTeam!.teamCity)"
            team1ScoreLbl.text = "\(game.eosScore!)"
            team2ScoreLbl.text = "\(game.oppositeTeamScore!)"
            let gameCity = EOS_TEAM.teamCity
            let gamePlace = EOS_TEAM.homeArena
            if let gameDateAndTime = game.gameDateAndTime {
                let gameTime = gameDateAndTime.toString(format: "d MMM yyyy, HH:mm")
                gameDateTImeAndPlaceLbl.text = "\(gameCity!), \(gamePlace!), \(gameTime)"
            } else {
                 gameDateTImeAndPlaceLbl.text = "\(gameCity!), \(gamePlace!)"
            }
            hostTeamLogo.setLogoImg(logoPath: EOS_TEAM.logoPathName)
            guestTeamLogo.setLogoImg(logoPath: oppositeTeam!.logoPathName)
        } else {
            team2NameLbl.text = "\(EOS_TEAM.teamName!) \n \(EOS_TEAM.teamCity!)"
            team1NameLbl.text = "\(oppositeTeam!.teamName) \n \(oppositeTeam!.teamCity)"
            team2ScoreLbl.text = "\(game.eosScore!)"
            team1ScoreLbl.text = "\(game.oppositeTeamScore!)"
            let gameCity = oppositeTeam!.teamCity
            let gamePlace = oppositeTeam!.homeArena
            if let gameDateAndTime = game.gameDateAndTime {
                let gameTime = gameDateAndTime.toString(format: "d MMM yyyy, HH:mm")
                gameDateTImeAndPlaceLbl.text = "\(gameCity), \(gamePlace), \(gameTime)"
            } else {
                 gameDateTImeAndPlaceLbl.text = "\(gameCity), \(gamePlace)"
            }
            hostTeamLogo.setLogoImg(logoPath: oppositeTeam!.logoPathName)
            guestTeamLogo.setLogoImg(logoPath: EOS_TEAM.logoPathName)
        }

        showScoreOrView(game: game)
    }
    
    func showScoreOrView(game: Game) {
        let currentDate = Date()
        if currentDate < game.gameDateAndTime {
            team1GameScoreView.isHidden = true
            team2GameScoreView.isHidden = true
            hostTeamLogo.isHidden = false
            guestTeamLogo.isHidden = false
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            team1GameScoreView.isHidden = false
            team2GameScoreView.isHidden = false
            hostTeamLogo.isHidden = true
            guestTeamLogo.isHidden = true
            self.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            
        }
    }
//
//    func chooseGameHost(hostIsEos: Bool, oppositeTeam: TeamRealmObject) -> (TeamFirestoreModel, TeamFirestoreModel) {
//
//        if hostIsEos {
//            let hostTeam = TeamFirestoreModel(id: "", teamName: EOS_TEAM.teamName, teamCity: EOS_TEAM.teamCity, homeArena: EOS_TEAM.homeArena, logoPathName: EOS_TEAM.logoPathName)
//            let guestTeam = TeamFirestoreModel(id: oppositeTeam.id, teamName: oppositeTeam.teamName, teamCity: oppositeTeam.teamCity, homeArena: oppositeTeam.homeArena, logoPathName: oppositeTeam.logoPathName)
//            return (hostTeam, guestTeam)
//        } else {
//            let hostTeam = TeamFirestoreModel(id: oppositeTeam.id, teamName: oppositeTeam.teamName, teamCity: oppositeTeam.teamCity, homeArena: oppositeTeam.homeArena, logoPathName: oppositeTeam.logoPathName)
//            let guestTeam = TeamFirestoreModel(id: "", teamName: EOS_TEAM.teamName, teamCity: EOS_TEAM.teamCity, homeArena: EOS_TEAM.homeArena, logoPathName: EOS_TEAM.logoPathName)
//            return (hostTeam, guestTeam)
//        }
//    }


}
