//
//  GameInfoVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-27.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import SafariServices

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
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    
    var game: Game!
    var firstTeamPlayersInfoLoaded: Bool = false
    var secondTeamPlayersInfoLoaded: Bool = false
    

    
    override func viewDidLayoutSubviews() {
        chooseViewsToDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicInfo()
    }
    
    func setupBasicInfo () {
        setupBasicInfoView()
        if let game = game {
            scorelbl.text = "\(game.team1Score ?? 0) : \(game.team2Score ?? 0)"
            teamsNamelbl.text = "\(game.team1Name ?? "Team 1") vs \(game.team2Name ?? "Team 2")"
            if let gameDate: Date = game.gameDateAndTime {
                gameTimelbl.text = gameDate.toString()
            } else {
                gameTimelbl.isHidden = true
            }
                gamePlaceLbl.text = "\(game.gameCity ?? " "), \(game.gamePlace ?? " ")"
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
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
        let textViewHeight = arg.contentSize.height
        descriptionViewHeight.constant = textViewHeight
    }
    
    func chooseViewsToDisplay () {
        gameDescriptionTextView.isHidden = true
        statsButtonView.isHidden = true
        
        if let gameStatHtml = game.statsLink {
            if gameStatHtml.isValidURL {
                setupBtnView()
                statsButtonView.isHidden = false
            }
        } else {
            statsButtonView.isHidden = true
        }
        
        if game.gameDescription != nil {
            let gameDesc = game.gameDescription
            let stringWithNewLine = gameDesc!.replacingOccurrences(of: "\\n", with: "\n")
            gameDescriptionTextView.isHidden = false
            gameDescriptionTextView.text = stringWithNewLine
            adjustUITextViewHeight(arg: gameDescriptionTextView)
        } else {
            gameDescriptionTextView.isHidden = true
        }
        
        if let teamPlayersListForFirstTeam = game.team1Players {
            if firstTeamPlayersInfoLoaded == false {
                addTeamList(for: game.team1Name, teamText: teamPlayersListForFirstTeam)
                firstTeamPlayersInfoLoaded = true
            }
        }
        
        if let teamPlayersForSeconTeam = game.team2Players {
            if secondTeamPlayersInfoLoaded == false{
                addTeamList(for: game.team1Name, teamText: teamPlayersForSeconTeam)
                secondTeamPlayersInfoLoaded = true
            }
        }
        
        scrollView.contentSize.height = stackView.frame.height
    }
    
    func addTeamList(for team: String, teamText: String) {
        
        let teamNameLbl = UILabelPadding()
        teamNameLbl.text = "\(team) players:"
        teamNameLbl.textAlignment = .center
        teamNameLbl.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        teamNameLbl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        teamNameLbl.adjustsFontSizeToFitWidth = true
        teamNameLbl.minimumScaleFactor = 0.5
        teamNameLbl.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(teamNameLbl)
        
        let textArray = teamText.components(separatedBy: ",")
        for player in textArray {
            let componentsArray = player.components(separatedBy: " ")
            let componentsWithoutSpases = componentsArray.filter { $0 != "" }
            let playerInfo = componentsWithoutSpases.joined(separator: " ")
            
            
            let playerLabel = UILabelPadding()
            playerLabel.text = playerInfo
            playerLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)
            playerLabel.textAlignment = .justified
            playerLabel.adjustsFontSizeToFitWidth = true
            playerLabel.minimumScaleFactor = 0.5
            playerLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
            playerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(playerLabel)
        }
    }
    
    let text: String = "Som utlovat blev gårdagens derby en fartfylld historia där båda lagen lade i högsta växeln redan från start. Matchen var i början mycket jämn innan Eos gjorde ett ryck i andra perioden och gick till pausvila med en tiopoängsledning. \n \n TeamQ4 startade bäst efter paus och vann den tredje perioden med sex poäng. En mycket spännande slutperiod av matchen väntade när nu Eos ledning krymp till ynka fyra poäng. Gästerna fortsatta på inslagen väg och åt upp poäng för poäng, med åtta minuter kvar av matchen var TeamQ4 ikapp, 78 – 78. Efter detta växlade Eos upp och tog återigen kommandot i matchen. Med drygt sex minuter kvar begärde gästerna en time-out efter att hemmalaget gjort fem raka poäng. 83 – 78 med 33.56 på matchuret. Pausen gav effekt och TeamQ4 spelade upp sig, jakten var igång! Poäng för poäng närmade sig gästerna hemmalaget i grönt och med 2.43 kvar på klockan var gästerna ikapp, 91 – 91. Närmare än så kom dock inte gästerna. Eos avslutade matchen genom att gasa igenom faran, anfall är som sagt lagets bästa försvar. Med åtta raka poäng och 1.12 kvar av matchen var poängen säkrade och jakten på Fryshuset fortsätter. Slutsiffrorna skrevs till 101 – 93 och ingen kan kräva pengarna tillbaka på grund av bristande underhållning. En stor eloge ska även riktas till de tillresta bortasupportrarna som matchen igenom stöttade sitt lag trots stort numerärt underläge."
    
    let teamText: String = """
    00    Kofi Adanovur 1991 Forward    191    Malbas,
    2    Adnan Karovic    1988    Guard    188    Malmö IBK,
    4    Tahe Mahmoud    2000    Guard    189    IK Eos,
    5    Nils Gjörup    1992    Guard    177    Höken,
    6    Gustav Sundström    1991    Forward    197    IK Eos,
    8    Andreas von Uthmann    1996    Forward    197    Djursholm,
    9    David Niklasson    1995    Guard    193    Täby,
    10    Marcus Dahlqvist    1996    Guard    191    Djursholm,
    11    Johan Aasa    1992    Guard    190    Skellefteå,
    12    Andrew Lundström    1996    Forward    198    Kanada,
    13    Erik Nilsson    1998    Forward    192    Malbas,
    22    Joel Svensson    1996    Guard    185    Tureberg,
    24    Anton Almqvist    1995    Guard    185    Marbo,
    27    Carl Tjernberg    1998    Guard    187    Djursholm,
    55    Olle Karlsson (C)    1996    Guard    193    Avans SK
"""
    
    @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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


extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

