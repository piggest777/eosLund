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
    
    @IBOutlet weak var tournamentBtnView: UIView!
    @IBOutlet weak var nextGameView: UIView!
    @IBOutlet weak var gameCoverImgView: UIImageView!
    @IBOutlet weak var nextGamePlaceLbl: UILabel!
    @IBOutlet weak var nextGameDateAndTimeLbl: UILabel!
    @IBOutlet weak var leagueSegmentControl: UISegmentedControl!
    @IBOutlet weak var firstTeamLogotipeImg: UIImageView!
    @IBOutlet weak var secondTeamLogotipeImg: UIImageView!
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
    @IBOutlet weak var moreThanAGameView: UIView!
    @IBOutlet weak var tournamentTableBtn: UIButton!
    @IBOutlet weak var counterStackView: UIStackView!
    @IBOutlet weak var nextGamePlaceAndTimeStackViewConstraint: NSLayoutConstraint!
    
    
    private var gamesArray = [Game]()
    private var teamArray = [TeamFirestoreModel]()
    private lazy var gamesReference:CollectionReference = Firestore.firestore().collection(GAMES_REF)
    private var teamsReference = Firestore.firestore().collection("teams")
    private var gameScheduleListener: ListenerRegistration!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //adopt information according iphone screen size
        if UIScreen.main.bounds.height > 667 {
            viewHidhConstraint.constant = halfHeightOfScreenSize - 50
            bigScreenGameInfoStackView.isHidden = false
            smalScreenGameInfoStackView.isHidden = true
            moreThanAGameView.isHidden = false
            nextGamePlaceLbl.font = UIFont(name: "AvenirNext-Medium", size: 20)
            nextGameDateAndTimeLbl.font = UIFont(name: "AvenirNext-Medium", size: 17)
            nextGamePlaceAndTimeStackViewConstraint.constant = 50
        } else {
            viewHidhConstraint.constant = halfHeightOfScreenSize
            bigScreenGameInfoStackView.isHidden = true
            smalScreenGameInfoStackView.isHidden = false
            moreThanAGameView.isHidden = true
            nextGamePlaceLbl.font = UIFont(name: "AvenirNext-Medium", size: 14)
            nextGameDateAndTimeLbl.font = UIFont(name: "AvenirNext-Medium", size: 12)
            nextGamePlaceAndTimeStackViewConstraint.constant = 35
        }
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        leagueSegmentControl.layer.cornerRadius = 5
        swipeNextGame()
        tournamentBtnView.isHidden = false
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
    
    //add swipe gesture to cover next game information
    func swipeNextGame () {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideNextGameView))
        swipe.direction = .up
        nextGameView.addGestureRecognizer(swipe)
    }
    
    @objc func hideNextGameView () {
        fullScheduleOpener()
    }
    
    //FIXME:   Do I really need this func?
    func roundedTopCorners() {
        if #available(iOS 11.0, *) {
            tournamentTableBtn.clipsToBounds = true
            tournamentTableBtn.layer.cornerRadius = 10
            tournamentTableBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    // create firebase listener for track changes in game online
    func setListener () {
        var leaugePredicate: [String] = ["SBLD"]
        if choosenLeague == "All" {
            leaugePredicate = ["SBLD", "SE Herr", "BE Dam"]
        } else {
            leaugePredicate = [choosenLeague]
        }
            gameScheduleListener = gamesReference
                .whereField(TEAM_LEAGUE, in: leaugePredicate)
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
    
    //get information about team from firebase and return team array
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
    
    
    //check if need to update team list information
    func checkTeamsUpdatePossibility(completionHandler: @escaping (Bool)->())  {
        if updateDate != nil, let teamRealmBase = TeamRealmObject.getAllRealmTeam(), !teamRealmBase.isEmpty {
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
                    //                    add transaction control
                } else { debugPrint("Can`t get updateDate from Firebase", error as Any)}
            }
        } else {
            print("Updating team base")
            upadateTeamRealmBase { success in
                if success {
                    completionHandler(true)
                }
            }
        }
    }
    
    
    //update iformation about team in realm local base
    func upadateTeamRealmBase (updaterStatus: @escaping (Bool)->() ) {
        loadTeamInfoFromFirebase { (returnedArray) in
            var index = 1
            for team in returnedArray {
                if index != returnedArray.count {
                    TeamRealmObject.updateTeamInfo(team: team)
                    index += 1
                } else {
                    TeamRealmObject.realmWriteWithCallback(team: team) { (success) in
                        if success {
                            updaterStatus(true)
                        }
                    }
                }
            }
            self.deleteUnnecessaryTeamsFromRealm(firebaseOriginalTeamsList: returnedArray)
        }
        updateDate = Date()
    }
    
    //delete team from realm if team don`t exist in firebase
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
    
    //load game information about next game by time
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
            
            let gameId  = nextGame.documentId
            let indexOf = gamesArray.firstIndex { (game) -> Bool in
                if game.documentId == gameId {
                    return true
                } else {
                    return false
                }
            }
            
            if let index = indexOf {
                let indexPath = IndexPath(row: index, section: 0)
                
                self.scheduleTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
            
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
                firstTeamLogotipeImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                secondTeamLogoBigImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
                secondTeamLogotipeImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
            } else {
                firstTeamNameLbl.text = oppositeTeam.teamName
                firstTeamNameBigLbl.text = firstTeamNameLbl.text
                secondTeamNameLbl.text = EOS_TEAM.teamName
                secondTeamNameBigLbl.text = secondTeamNameLbl.text
                nextGamePlaceLbl.text = "\(oppositeTeam.teamCity), \(oppositeTeam.homeArena)"
                secondTeamLogoBigImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                secondTeamLogotipeImg.setLogoImg(logoPath: EOS_TEAM.logoPathName)
                firstTeamLogoBigImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
                firstTeamLogotipeImg.setLogoImg(logoPath: oppositeTeam.logoPathName)
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
    
    //load tournament table by url in safari browser
    @IBAction func tournamentBtnWasPressed(_ sender: Any) {
        if choosenLeague != "All" {
            NetService.instance.getTournamentTableUrl(league: choosenLeague) { (returnedUrl) in
                if let urlString = returnedUrl {
                    if urlString.isValidURL {
                        let url =  URL(string:  urlString)
                        let safariVC = SFSafariViewController(url: url!)
                        self.present(safariVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func fullScheduleBtnWasPressed(_ sender: Any) {
        fullScheduleOpener()
    }
    
    //detect open or close information about next game and animate
    func fullScheduleOpener () {
        if isFullScheduleOpen == false {
            setupNextGameViewShowAndHide(view: nextGameView, hidden: !isFullScheduleOpen)
            isFullScheduleOpen = true
            fullScheduleBtn.setTitle("NEXT GAME INFO", for: .normal)
        } else if isFullScheduleOpen == true{
            setupNextGameViewShowAndHide(view: nextGameView, hidden: !isFullScheduleOpen)
            isFullScheduleOpen = false
            fullScheduleBtn.setTitle("REVEAL SCHEDULE", for: .normal)
        }
    }
    
    func setupNextGameViewShowAndHide(view: UIView, hidden: Bool) {
        DispatchQueue.main.async {
            UIView.transition(with: view, duration: 0.5, options: .showHideTransitionViews, animations: {
                view.isHidden = hidden
            })
        }
    }
    
    //setup view depend from league
    @IBAction func segmentControlWasSwitched(_ sender: Any) {
        switch leagueSegmentControl.selectedSegmentIndex{
        case 0:
            choosenLeague = "SBLD"
            gameCoverImgView.image = UIImage(named: "defaultCoverSBLD.jpg")
            tournamentBtnView.isHidden = false
        case 1:
            choosenLeague = "SE Herr"
            gameCoverImgView.image = UIImage(named: "defaultCoverSEH.jpg")
            tournamentBtnView.isHidden = false
        case 2:
            choosenLeague = "BE Dam"
            gameCoverImgView.image = UIImage(named: "defaultCoverBED.jpg")
            tournamentBtnView.isHidden = false
        case 3:
            choosenLeague = "All"
            gameCoverImgView.image = UIImage(named: "defaultCoverSBLD.jpg")
            tournamentBtnView.isHidden = true
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
        }
        else {return}
    }
}
