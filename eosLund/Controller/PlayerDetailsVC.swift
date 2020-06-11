//
//  PlayerDetailsVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-05-24.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var game: Game!
    var isEosTeam: Bool!
    var realmPlayerArray: Results<PlayerRealmObject>?
    var playerArray: [BasicPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if isEosTeam {
            getEosPlayersFromRealm(game: game)
            teamNameLbl.text = "EOS PLAYERS"
        } else {
            let team = TeamRealmObject.getTeamInfoById(id: game.oppositeTeamCode)
            if team.teamName == "Team" {
                teamNameLbl.text = "PLAYERS LIST"
            } else {
                teamNameLbl.text = "\(team.teamName) players"
            }
            parseDataWithRegExpFromGameInfo(game: game)
        }
    }
    
    //load eos players from realm base
    func getEosPlayersFromRealm(game:Game) {
        guard let realmPlayerArray = PlayerRealmObject.getRealmPredicatePlayerListForTable(league: game.teamLeague) else {return}
        
        for player in realmPlayerArray {
            
            let yearOfBirth = getYearFromDate(stringDate: player.playerDateOfBirth)
            
            let position = convertFullPositionToLetter(positionName: player.playerPosition)
            let newPlayer: BasicPlayer = BasicPlayer(name: player.playerName, number: player.playerNumber, dateOfBirth: yearOfBirth, height: player.playerHeight, position: position)
            
            playerArray.append(newPlayer)
        }
        tableView.reloadData()
    }
    
    // find and separate player number, height and year of birth from string
    func parseDataWithRegExpFromGameInfo(game: Game) {
        
        guard let playersString = game.oppositeTeamPlayers else { return }
        
        let textArray = playersString.components(separatedBy: ",")
        for player in textArray {
            
            var playerInfoString = player.replacingOccurrences(of: "/t", with: " ")

             
            
            let playerNumberPattern = "\\b[0-9]{1,2}\\b"
            let playerHeightPattern = "\\b[0-9]{3}\\b"
            let playerYearOfBirth = "\\b[0-9]{4}\\b"
            let positionPattern = "Forward|Center|Guard"
            
            let number = findPatternInString(pattern: playerNumberPattern, sourceString: playerInfoString)
            playerInfoString.removingRegexMatches(pattern: playerNumberPattern, replaceWith: "")
            let height = findPatternInString(pattern: playerHeightPattern, sourceString: playerInfoString)
            playerInfoString.removingRegexMatches(pattern: playerHeightPattern, replaceWith: "")
            let yearOfBirth = findPatternInString(pattern: playerYearOfBirth, sourceString: playerInfoString)
            playerInfoString.removingRegexMatches(pattern: playerYearOfBirth, replaceWith: "")
            let position = findPatternInString(pattern: positionPattern, sourceString: playerInfoString)
            playerInfoString.removingRegexMatches(pattern: positionPattern, replaceWith: "")
            let positionLetter = convertFullPositionToLetter(positionName: position)
            
            playerInfoString = normalizePlayerString(player: playerInfoString)
            
            let newPlayer = BasicPlayer(name: playerInfoString, number: Int(number) ?? 404, dateOfBirth: yearOfBirth, height: height, position: positionLetter)
            playerArray.append(newPlayer)
        }
        tableView.reloadData()
    }
    
    func normalizePlayerString(player string: String) -> String {
        let componentsArray = string.components(separatedBy: " ")
        let componentsWithoutSpases = componentsArray.filter { $0 != "" }
        return componentsWithoutSpases.joined(separator: " ")
    }
    
    func getYearFromDate(stringDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let localDate = formatter.date(from: stringDate) else { return "" }
        let year = String(Calendar.current.component(.year, from: localDate))
        return year
    }
    
    //convert player position to possition letter
    func convertFullPositionToLetter(positionName: String) -> String {
        let lowerCasedPosition = positionName.lowercased()
        
        switch lowerCasedPosition {
        case "forward":
            return "F"
        case "center":
                return "C"
        case "guard":
                return "G"
        default:
            return ""
        }
    }
    
    func findPatternInString(pattern: String, sourceString: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            guard let result = regex.firstMatch(in: sourceString, options: [], range: NSRange(sourceString.startIndex..., in: sourceString)) else {return "--"}
            guard let range = Range(result.range, in: sourceString) else {return "--"}
            
            return String(sourceString[range])
            
        } catch  {
            return "--"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerDetailsCell", for: indexPath)  as? PlayerDetailsCell else { return UITableViewCell() }
        
        let player = playerArray[indexPath.row]

        cell.configureCell(player: player)
        
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
