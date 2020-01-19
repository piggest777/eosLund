//
//  GamesTableViewCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-27.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var team1NameLbl: UILabel!
    @IBOutlet weak var team2NameLbl: UILabel!
    @IBOutlet weak var gameDateTImeAndPlaceLbl: UILabel!
    @IBOutlet weak var team1GameScoreView: UIView!
    @IBOutlet weak var team2GameScoreView: UIView!
    
    func configureCell(game: Game) {
        
        team1NameLbl.text = "\(game.team1Name!) \n \(game.team1City!)"
        team2NameLbl.text = "\(game.team2Name!) \n \(game.team2City!)"
                    team1ScoreLbl.text = String(game.team1Score)
                    team2ScoreLbl.text = String(game.team2Score)
        
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
        

        
        let gameCity = game.gameCity!
        let gamePlace = game.gamePlace!
        let gameDateAndTime = game.gameDateAndTime
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
        
        let gametime = formatter.string(from: gameDateAndTime!)
        
        
        gameDateTImeAndPlaceLbl.text = "\(String(describing: gameCity)), \(String(describing: gamePlace)), \(gametime)" 
    }


}
