//
//  GameInfoVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-27.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

class GameInfoVC: UIViewController {
    
    @IBOutlet weak var leagueLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var homeTeamLogoImg: UIImageView!
    @IBOutlet weak var guestTeamLogoimg: UIImageView!
    @IBOutlet weak var scorelbl: UILabel!
    @IBOutlet weak var teamsNamelbl: UILabel!
    @IBOutlet weak var gameTimelbl: UILabel!
    @IBOutlet weak var gamePlaceLbl: UILabel!
    @IBOutlet weak var gameDescriptionTextView: UITextView!
    @IBOutlet weak var statsButtonView: UIView!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var mainGameInfoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var oppositePlayerListBtn: RoundedShadowButton!
    
    var game: Game!
    
    override func viewDidLayoutSubviews() {
        chooseViewsToDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicInfo()
    }
    
    func setupBasicInfo() {
        setupBasicInfoView()
        switchLeague()
        let realmBasedOppositeTeam = TeamRealmObject.getTeamInfoById(id: game.oppositeTeamCode)
        if let game = game {
            if game.isHomeGame{
                scorelbl.text = "\(game.eosScore ?? 0) : \(game.oppositeTeamScore ?? 0)"
                teamsNamelbl.text = "\(EOS_TEAM.teamName ?? "Eos Basket") vs \(realmBasedOppositeTeam.teamName)"
                if let gameDate: Date = game.gameDateAndTime {
                    gameTimelbl.text = gameDate.toString()
                } else {
                    gameTimelbl.isHidden = true
                }
                
                if let gameCity = EOS_TEAM.teamCity, let homeArena = EOS_TEAM.homeArena {
                    gamePlaceLbl.text = "\(gameCity), \(homeArena)"
                } else {
                    gamePlaceLbl.isHidden = true
                }
                
                guestTeamLogoimg.setLogoImg(logoPath: realmBasedOppositeTeam.logoPathName)
                homeTeamLogoImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
            } else {
                scorelbl.text = "\(game.oppositeTeamScore ?? 0) : \(game.eosScore ?? 0)"
                teamsNamelbl.text = "\(realmBasedOppositeTeam.teamName) vs \(EOS_TEAM.teamName ?? "Eos Basket")"
                if let gameDate: Date = game.gameDateAndTime {
                    gameTimelbl.text = gameDate.toString()
                } else {
                    gameTimelbl.isHidden = true
                }
                
                if realmBasedOppositeTeam.teamCity != "" && realmBasedOppositeTeam.homeArena != "" {
                    gamePlaceLbl.text = "\(realmBasedOppositeTeam.teamCity), \(realmBasedOppositeTeam.homeArena)"
                } else {
                    gamePlaceLbl.isHidden = true
                }
                guestTeamLogoimg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                homeTeamLogoImg.setLogoImg(logoPath: realmBasedOppositeTeam.logoPathName)
            }
            
        }
    }
    
    func switchLeague() {
        let gameLeague = game.teamLeague
        
        switch gameLeague {
        case "SBLD":
            leagueLbl.text = "SWEDISH BASKETBAL LEAGUE WOMEN"
            if let image = UIImage(named: "defaultCoverSBLD.jpg") {
                gameImg.image = image
            } else {
                print("no cover image")
            }
        case "SE Herr":
            leagueLbl.text = "SUPERETTAN MEN"
            gameImg.image = UIImage(named: "defaultCoverSEH.jpg")
        case "BE Dam":
            leagueLbl.text = "BASKETETTAN WOMEN"
            gameImg.image = UIImage(named: "defaultCoverBED.jpg")
        default:
            leagueLbl.text = ""
            gameImg.image = UIImage(named: "defaultCoverSBLD.jpg")
        }
        
        if let gameCoverLink = game.gameCoverUrl {
            NetService.instance.getImageBy(url: gameCoverLink) { (image) in
                if let coverImage = image {
                    self.gameImg.image = coverImage
                }
            }
        }
    }
    
    func setupBasicInfoView () {
        mainGameInfoView.layer.cornerRadius = 30
        mainGameInfoView.layer.shadowColor = UIColor.darkGray.cgColor
        mainGameInfoView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        mainGameInfoView.layer.shadowRadius  = 5
        mainGameInfoView.layer.shadowOpacity = 1.0
        mainGameInfoView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        mainGameInfoView.layer.borderWidth = 2
    }
    
    func setupBtnView () {
        statisticBtn.layer.cornerRadius = statisticBtn.layer.frame.size.height/2
        statisticBtn.layer.shadowColor = UIColor.darkGray.cgColor
        statisticBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        statisticBtn.layer.shadowRadius = 5
        statisticBtn.layer.shadowOpacity = 1
        statisticBtn.layer.borderColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
        statisticBtn.layer.borderWidth = 5
        statisticBtn.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        statisticBtn.isEnabled = true
    }
    
    func adjustUITextViewHeight(textView : UITextView)
    {
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.isScrollEnabled = false
        textView.frame.size.width = UIScreen.main.bounds.width
        textView.sizeToFit()
    }
    
    func chooseViewsToDisplay () {
        gameDescriptionTextView.isHidden = true
        statsButtonView.isHidden = true
        oppositePlayerListBtn.isHidden = true
        
        if let gameStatHtml = game.statsLink {
            if gameStatHtml.isValidURL {
                statisticBtn.isHidden = false
                setupBtnView()
            }
        } else {
            statisticBtn.isHidden = true
        }
        
        if game.gameDescription != nil {
            let gameDesc = game.gameDescription
            let stringWithNewLine = gameDesc!.replacingOccurrences(of: "\\n", with: "\n")
            gameDescriptionTextView.isHidden = false
            gameDescriptionTextView.text = stringWithNewLine
            adjustUITextViewHeight(textView: gameDescriptionTextView)
        } else {
            gameDescriptionTextView.isHidden = true
        }
        
        if game.oppositeTeamPlayers != nil {
            oppositePlayerListBtn.isHidden = false
        }
        scrollView.contentSize.height = stackView.frame.height
    }
    
    
    func presentPlayerList(isEosPlayers: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let playersDetailsVC = storyBoard.instantiateViewController(withIdentifier: "playerDetailsVC") as! PlayerDetailsVC
        playersDetailsVC.game = game
        playersDetailsVC.isEosTeam = isEosPlayers
        present(playersDetailsVC, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playerListBtnPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            presentPlayerList(isEosPlayers: true)
        } else if sender.tag == 1 {
            presentPlayerList(isEosPlayers: false)
        }
    }
    
    @IBAction func openStatisticBtnPressed(_ sender: Any) {
        if let statsLink = game.statsLink  {
            if statsLink.isValidURL {
                let url = URL(string: statsLink)
                let safariVC = SFSafariViewController(url: url!)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
}
