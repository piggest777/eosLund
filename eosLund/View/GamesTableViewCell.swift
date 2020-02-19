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
    
    func configureCell(game: Game) {
        
        var oppositeTeam: TeamRealmObject?
        
        do {
             oppositeTeam = try Realm().object(ofType: TeamRealmObject.self, forPrimaryKey: game.oppositeTeamCode)
            print(oppositeTeam?.id)
        } catch  {
            debugPrint("Can`t get realm object by key")

        }
        
        if oppositeTeam == nil {
             oppositeTeam = TeamRealmObject(id: "NULL", teamName: "Team", teamCity: "", homeArena: "", logoPathName: "defaultLogo.png")
        }

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
        }
        
        
//        let currentDate = Date()
//        if currentDate < game.gameDateAndTime {
//            team1GameScoreView.isHidden = true
//            team2GameScoreView.isHidden = true
//        } else {
//            team1GameScoreView.isHidden = false
//            team2GameScoreView.isHidden = false
//            team1ScoreLbl.text = String(game.team1Score)
//            team2ScoreLbl.text = String(game.team2Score)
//        }
        
    }


}
