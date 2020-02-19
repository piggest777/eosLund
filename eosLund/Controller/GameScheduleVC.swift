//
//  GameScheduleVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class GameScheduleVC: UIViewController {
    
    @IBOutlet weak var nextGameView: UIView!
    @IBOutlet weak var gameCoverImgView: UIImageView!
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
    private var teamArray = [TeamFirestoreModel]()
    private lazy var gamesReference:CollectionReference = Firestore.firestore().collection(GAMES_REF)
    private var teamsReference = Firestore.firestore().collection("teams")
    private var gameScheduleListener: ListenerRegistration!
    private var isMenTeam: Bool = true
    private var timer = Timer()
    private var timeIntervalToNextGame: Double = 0.0
    private var isFullScheduleOpen = false
    private let halfHeightOfScreenSize = UIScreen.main.bounds.height/2 - 45
    
    var choosenLeague: String = "SBLD"
    
    let defaults = UserDefaults.standard
    
    var updateDate: Date? {
        get {
            return defaults.value(forKey: "teamsInfoWasUpdated") as? Date
        }
        set {
            defaults.set(newValue, forKey: "teamsInfoWasUpdated")
        }
    }
    
    
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
        view.setUpStatusBar()
        checkTeamsUpdatePossibility { (success) in
            if success {
                self.setListener()
            }
        }
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
    
    func loadTeamInfoFromFirebase(returnedTeamsArray: @escaping ([TeamFirestoreModel])-> ()) {
        teamsReference.getDocuments { (snapshot, error) in
            if error == nil {
                let teamArray = TeamFirestoreModel.parseTeamData(snapshot: snapshot)
                returnedTeamsArray(teamArray)
            } else {
                debugPrint("can`t get team array from Firebase", error as Any)
            }
        }
    }
    
    func checkTeamsUpdatePossibility(completionHandler: @escaping (Bool)->())  {
        if updateDate != nil {
            teamsReference.document("teamInfoUpdateDate").getDocument { (snapshot, error) in
                if error == nil {
                    guard let snapshot = snapshot else { return }
                    let data = snapshot.data()
                    if let timestampUpdateDate = data?["updateDate"] as? Timestamp {
                        let firebaseUpdateDate = timestampUpdateDate.dateValue()
                        if firebaseUpdateDate > self.updateDate! {
                            self.upadateTeamRealmBase { success in
                                if success {
                                     completionHandler(true)
                                }
                            }
                        } else {
                        print("Realm base already updated")
                        completionHandler(true)
                        }
                    }
                    
//                    add add else if can`t get firebase updatedate
//                    add control if date succesfully updated base doesn`t get
//                    add transaktion control
                } else { debugPrint("Can`t get updateDate from Firebase", error as Any)}
            }
        } else {
            upadateTeamRealmBase { success in
                if success {
                     completionHandler(true)
                }
            }
        }
    }
    
    func upadateTeamRealmBase (updaterStatus: @escaping (Bool)->() ) {
        loadTeamInfoFromFirebase { (returnedArray) in
            for team in returnedArray {
                TeamRealmObject.updateTeamInfo(team: team)
            }
            self.deleteUnnecessaryTeamsFromRealm(firebaseOriginalTeamsList: returnedArray)
        }
        updateDate = Date()
        updaterStatus(true)
    }
    
    func deleteUnnecessaryTeamsFromRealm(firebaseOriginalTeamsList: [TeamFirestoreModel]) {
        
        func getDifferenceToDeleteFromRealmBase(firebaseIdsArray: [String], realmIdsArray: [String]) -> [String] {
            var iDsToDelete = [String]()
            if realmIdsArray.isEmpty == false {
                for id in realmIdsArray {
                    if !firebaseIdsArray.contains(id) {
                        iDsToDelete.append(id)
                    }
                }
                return iDsToDelete
            } else {
                return iDsToDelete
            }
        }
        
        let teamRealmArray = TeamRealmObject.getAllRealmTeam()
        guard let realmArray = teamRealmArray else {return}
        let stringRealmArray = Array(realmArray)
        
        let firesbaseIDsArray = firebaseOriginalTeamsList.map { $0.id! }
        let realmIDsArray =  stringRealmArray.map{ $0.id}
        
        let realmArrayToDelete = getDifferenceToDeleteFromRealmBase(firebaseIdsArray: firesbaseIDsArray, realmIdsArray: realmIDsArray)
        
        
        if !realmArrayToDelete.isEmpty {
            for teamToDelete in realmArrayToDelete {
                TeamRealmObject.deleteRealmTeamBy(id: teamToDelete)
            }
        }
    }
    

    
    func loadInfoToNextGameView() {
        
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
            
            let oppositeTeam = TeamRealmObject.getTeamInfoById(id: nextGame.oppositeTeamCode)
            
            if let coverImageUrl = nextGame.gameCoverUrl {
                NetService.instance.getImageBy(url: coverImageUrl) { (image) in
                    if let coverImage = image {
                        self.gameCoverImgView.image = coverImage
                    }
                }
            }
            
            if nextGame.isHomeGame {
                firstTeamNameLbl.text = EOS_TEAM.teamName
                firstTeamNameBigLbl.text = firstTeamNameLbl.text
                secondTeamNameLbl.text = oppositeTeam.teamName
                secondTeamNameBigLbl.text = secondTeamNameLbl.text
                nextGamePlaceLbl.text = "\(EOS_TEAM.teamCity!), \(EOS_TEAM.homeArena!)"
                firstTeamLogoBigImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                firstTeamLogotipeImg = firstTeamLogoBigImg
                secondTeamLogoBigImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
                seconTeamLogotipeImg = secondTeamLogoBigImg
            } else {
                firstTeamNameLbl.text = oppositeTeam.teamName
                firstTeamNameBigLbl.text = firstTeamNameLbl.text
                secondTeamNameLbl.text = EOS_TEAM.teamName
                secondTeamNameBigLbl.text = secondTeamNameLbl.text
                nextGamePlaceLbl.text = "\(oppositeTeam.teamCity), \(oppositeTeam.homeArena)"
                secondTeamLogoBigImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                seconTeamLogotipeImg = secondTeamLogoBigImg
                firstTeamLogoBigImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
                firstTeamLogotipeImg = firstTeamLogoBigImg
            }
            nextGameDateAndTimeLbl.text = nextGame.gameDateAndTime.toString()
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
    
    func setLogoImg(logoPath: String) -> UIImage {
        if let logo = UIImage(named: "\(logoPath)") {
            return logo
        } else  {
            return UIImage(named: "defaultLogo.png")!
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
        
        NetService.instance.getTournamentTableUrl(league: choosenLeague) { (returnedUrl) in
            if let urlString = returnedUrl {
                if urlString.isValidURL {
                    let url =  URL(string:  urlString)
                    let safariVC = SFSafariViewController(url: url!)
                    self.present(safariVC, animated: true, completion: nil)
                }
            }
        }
        
//        performSegue(withIdentifier: "toTournamentTableVC", sender: sender)
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
            gameCoverImgView.image = UIImage(named: "defaultCoverSBLD.jpg")
        case 1:
            choosenLeague = "SE Herr"
            gameCoverImgView.image = UIImage(named: "defaultCoverSEH.jpg")
        case 2:
            choosenLeague = "BE Dam"
            gameCoverImgView.image = UIImage(named: "defaultCoverBED.jpg")
        default:
            choosenLeague = "SBLD"
            gameCoverImgView.image = UIImage(named: "defaultCoverSBLD.jpg")
        }
        
        
        if gameScheduleListener != nil {
            gameScheduleListener.remove()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toGameInfoVC", sender: gamesArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameInfoVC" {
            if let destinationVC = segue.destination as? GameInfoVC {
                if let game = sender as? Game {
                    destinationVC.game = game
                } else {
                    print("couldn`t find game")
                }
            }
            else { return }
        } else if segue.identifier == "toTournamentTableVC" {
            if let destinationVC = segue.destination as? TournamentTableVC {
                destinationVC.league = choosenLeague
            } else {
                return
            }
        }
        else {return}
    }
}




