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
    @IBOutlet weak var gameDateTimeAndPlaceLbl: UILabel!
    @IBOutlet weak var team1GameScoreView: UIView!
    @IBOutlet weak var team2GameScoreView: UIView!
    @IBOutlet weak var hostTeamLogo: UIImageView!
    @IBOutlet weak var guestTeamLogo: UIImageView!
    
    
    //get information about team from realm and configure game cell according this information
    func configureCell(game: Game, isCommon: Bool) {
        
        
        let oppositeTeam = setupOppositeTeam(for: game.oppositeTeamCode)

        //TODO: check if it really needed to use nullcheck for team
// if is home game make eos first team in cell another move eos to second position
        if game.isHomeGame {
            team1NameLbl.text = "\(EOS_TEAM.teamName!) \n \(EOS_TEAM.teamCity!)"
            team2NameLbl.text = "\(oppositeTeam.teamName) \n \(oppositeTeam.teamCity)"
            team1ScoreLbl.text = "\(game.eosScore!)"
            team2ScoreLbl.text = "\(game.oppositeTeamScore!)"
            let gameCity = EOS_TEAM.teamCity
            let gamePlace = EOS_TEAM.homeArena
            setupGameAndTimeLabel(isCommon: isCommon, gameCity: gameCity, gamePlace: gamePlace , gameTime: game.gameDateAndTime, gameLeague: game.teamLeague)
            hostTeamLogo.setLogoImg(logoPath: EOS_TEAM.logoPathName)
            guestTeamLogo.setLogoImg(logoPath: oppositeTeam.logoPathName)
        } else {
            team2NameLbl.text = "\(EOS_TEAM.teamName!) \n \(EOS_TEAM.teamCity!)"
            team1NameLbl.text = "\(oppositeTeam.teamName) \n \(oppositeTeam.teamCity)"
            team2ScoreLbl.text = "\(game.eosScore!)"
            team1ScoreLbl.text = "\(game.oppositeTeamScore!)"
            let gameCity = oppositeTeam.teamCity
            let gamePlace = oppositeTeam.homeArena
            setupGameAndTimeLabel(isCommon: isCommon, gameCity: gameCity, gamePlace: gamePlace , gameTime: game.gameDateAndTime, gameLeague: game.teamLeague)
            hostTeamLogo.setLogoImg(logoPath: oppositeTeam.logoPathName)
            guestTeamLogo.setLogoImg(logoPath: EOS_TEAM.logoPathName)
        }
        highLightWinnerScore()
        showScoreOrView(game: game)
    }
    
    func highLightWinnerScore(){
        team1ScoreLbl.textColor = UIColor.white
        team2ScoreLbl.textColor = UIColor.white
        let scoreLblTxt1 = team1ScoreLbl.text
        let scoreLblTxt2 = team2ScoreLbl.text
        
        if Int(scoreLblTxt1!)! > Int(scoreLblTxt2!)! {
            team1ScoreLbl.textColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            team2ScoreLbl.textColor = UIColor.white
        } else if Int(scoreLblTxt1!)! < Int(scoreLblTxt2!)!{
            team1ScoreLbl.textColor = UIColor.white
            team2ScoreLbl.textColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        }
    }
    
    func setupGameAndTimeLabel(isCommon: Bool, gameCity: String?, gamePlace: String?, gameTime: Date?, gameLeague: String) {
//        if isCommon {
//            gameDateTimeAndPlaceLbl.text = gameLeague
//            return
//        }
        if let gameTime, let gamePlace, let gameCity {
            let time = gameTime.toString(format: "d MMM yyyy, HH:mm")
            if isCommon {
                gameDateTimeAndPlaceLbl.text = "\(gameLeague), \(gameCity), \(gamePlace)"
                return
            }
            gameDateTimeAndPlaceLbl.text = "\(gameCity), \(gamePlace), \(time)"
           
        } else {
             gameDateTimeAndPlaceLbl.text = ""
        }
    }
    
    func setupOppositeTeam(for key: String) -> TeamRealmObject {
        do {
            return try Realm().object(ofType: TeamRealmObject.self, forPrimaryKey: key) ?? TeamRealmObject(id: "NULL", teamName: "Team", teamCity: "", homeArena: "", logoPathName: "defaultLogo.png")
        } catch  {
            debugPrint("Can`t get realm object by key")
            return TeamRealmObject(id: "NULL", teamName: "Team", teamCity: "", homeArena: "", logoPathName: "defaultLogo.png")
        }
    }
    
    //if game was played show score in another case show team lable
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
            self.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.5)
        }
    }
}
