//
//  GameScheduleVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class GameScheduleVC: UIViewController {

    @IBOutlet weak var nextGameView: UIView!
    @IBOutlet weak var manBG: UIImageView!
    @IBOutlet weak var nextGamePlaceLbl: UILabel!
    @IBOutlet weak var nextGameDateAndTimeLbl: UILabel!
    @IBOutlet weak var leagueSegmentControl: UISegmentedControl!
    @IBOutlet weak var firstTeamLogotipeImg: UIImageView!
    @IBOutlet weak var seconTeamLogotipeImg: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    @IBOutlet weak var leftDaysToGameLbl: UILabel!
    @IBOutlet weak var leftHoursToGameLbl: UILabel!
    @IBOutlet weak var leftMintoGameLbl: UILabel!
    @IBOutlet weak var daysGameLbl: UILabel!
    @IBOutlet weak var hoursGameLbl: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var viewHidhConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullScheduleBtn: UIButton!
    @IBOutlet weak var noGameCover: UIView!
    @IBOutlet weak var smalScreenGameInfoStackView: UIStackView!
    @IBOutlet weak var bigScreenGameInfoStackView: UIStackView!
    @IBOutlet weak var firstTeamLogoBigImg: UIImageView!
    @IBOutlet weak var firstTeamNameBigLbl: UILabel!
    @IBOutlet weak var secondTeamNameBigLbl: UILabel!
    @IBOutlet weak var secondTeamLogoBigImg: UIImageView!
    
    
    private var gamesArray = [Game]()
    private lazy var gamesReference:CollectionReference = Firestore.firestore().collection(GAMES_REF)
    private var gameScheduleListener: ListenerRegistration!
    private var isMenTeam: Bool = true
    private var timer = Timer()
    private var timeIntervalToNextGame: Double = 0.0
    private var isFullScheduleOpen = false
    private let halfHeightOfScreenSize = UIScreen.main.bounds.height/2 - 45
    
    var choosenLeague: String = "SBLD"
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
        return UIStatusBarStyle.default   // Make dark again
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHidhConstraint.constant = halfHeightOfScreenSize
        if UIScreen.main.bounds.height > 667 {
            bigScreenGameInfoStackView.isHidden = false
            smalScreenGameInfoStackView.isHidden = true
        } else {
            bigScreenGameInfoStackView.isHidden = true
            smalScreenGameInfoStackView.isHidden = false
        }
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        leagueSegmentControl.layer.cornerRadius = 5
        swipeNextGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
        view.setUpStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if gameScheduleListener != nil {
            gameScheduleListener.remove()
        }
        timer.invalidate()
    }
    
    func swipeNextGame () {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideNextGameView))
        swipe.direction = .up
        nextGameView.addGestureRecognizer(swipe)
    }
    
    @objc func hideNextGameView () {
        fullScheduleOpener()
        
    }
    
    func setListener () {
        gameScheduleListener = gamesReference
        .whereField(TEAM_LEAGUE, isEqualTo: choosenLeague)
        .order(by: GAME_DATE_AND_TIME, descending: false)
        .addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint("error fetching docs: \(error)")
            } else {
                self.noGameCover.isHidden = true
                self.gamesArray.removeAll()
                self.gamesArray = Game.parseData(snapshot: snapshot)
                self.scheduleTableView.reloadData()
                self.loadInfoToNextGameView()
            }
            })
    }
    
    func loadInfoToNextGameView() {

        
//        need to add function to hide nextgame section if no games on future or change next game information
        guard gamesArray.count != 0 else {
            noGameCover.isHidden = false
            return
        }
        let filteredGamesArray = gamesArray.filter { (game) -> Bool in
            let currentDate = Date()
            if game.gameDateAndTime > currentDate {
                return true
            } else {
                return false
            }
        }
        
        if let nextGame: Game = filteredGamesArray.first {
            noGameCover.isHidden = true
        
        firstTeamNameLbl.text = nextGame.team1Name
            firstTeamNameBigLbl.text = firstTeamNameLbl.text
        secondTeamNameLbl.text = nextGame.team2Name
            secondTeamNameBigLbl.text = secondTeamNameLbl.text
        nextGamePlaceLbl.text = "\(nextGame.gameCity!), \(nextGame.gamePlace!)"
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
        
        nextGameDateAndTimeLbl.text = formatter.string(from: nextGame.gameDateAndTime)
        let currentDate = Date()
        timeIntervalToNextGame = nextGame.gameDateAndTime.timeIntervalSince(currentDate)
        updateTimerLbl(timeInterval: timeIntervalToNextGame)
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else if filteredGamesArray.first == nil {
            isFullScheduleOpen = false
            fullScheduleOpener()
            noGameCover.isHidden = false
        }
    }
    
    @objc func updateTimer() {
        if timeIntervalToNextGame > 0.0 {
            timeIntervalToNextGame -= 60.0
            updateTimerLbl(timeInterval: timeIntervalToNextGame)
        } else {
            timer.invalidate()
        }
    }
    
    func updateTimerLbl(timeInterval: Double) {
        if timeInterval > 0.0 {
            let days = Int(timeIntervalToNextGame / (24 * 3600))
            let hours = Int(timeIntervalToNextGame.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes = Int(timeIntervalToNextGame) / 60 % 60
            
            leftDaysToGameLbl.text = String(days)
            leftHoursToGameLbl.text = String(hours)
            leftMintoGameLbl.text = String(minutes)
            if days <= 1 {
                daysGameLbl.text = "Day"
            } else {
                daysGameLbl.text = "Days"
            }
            
            if hours <= 1 {
                hoursGameLbl.text = "Hour"
            } else {
                hoursGameLbl.text = "Hours"
            }
        } else {
            leftDaysToGameLbl.text = "00"
            leftHoursToGameLbl.text = "00"
            leftMintoGameLbl.text = "00"
        }
    }
    

    @IBAction func tournamentBtnWasPressed(_ sender: Any) {
    }
    
    
    @IBAction func fullScheduleBtnWasPressed(_ sender: Any) {
        fullScheduleOpener()
    }
    
    func fullScheduleOpener () {
        if isFullScheduleOpen == false {
            
            setupNextGameViewShowAndHide(view: nextGameView, hidden: !isFullScheduleOpen)
            isFullScheduleOpen = true
            fullScheduleBtn.setTitle("NEXT GAME INFO", for: .normal)

        } else {
            setupNextGameViewShowAndHide(view: nextGameView, hidden: !isFullScheduleOpen)
            isFullScheduleOpen = false
            fullScheduleBtn.setTitle("REVEAL SCHEDULE", for: .normal)
        }
        
    }
    
    func setupNextGameViewShowAndHide(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .showHideTransitionViews, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func segmentControlWasSwitched(_ sender: Any) {
        switch leagueSegmentControl.selectedSegmentIndex{
    case 0:
        choosenLeague = "SBLD"
    case 1:
        choosenLeague = "BE Herr"
    case 2:
        choosenLeague = "BE Dam"
    default:
        choosenLeague = "SBLD"
    }
        
        gameScheduleListener.remove()
        timer.invalidate()
        setListener()
    }
      
}

extension GameScheduleVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GamesTableViewCell else { return UITableViewCell()}
        
        cell.configureCell(game: gamesArray[indexPath.row])
        
        return cell
    }
  
}




