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

    @IBOutlet weak var manBG: UIImageView!
    @IBOutlet weak var nextGamePlaceLbl: UILabel!
    @IBOutlet weak var nextGameDateAndTimeLbl: UILabel!
    @IBOutlet weak var manOrWomanSegmentControl: UISegmentedControl!
    @IBOutlet weak var firstTeamLogotipeImg: UIImageView!
    @IBOutlet weak var seconTeamLogotipeImg: UIImageView!
    @IBOutlet weak var firstTeamNameLbl: UILabel!
    @IBOutlet weak var secondTeamNameLbl: UILabel!
    @IBOutlet weak var leftDaysToGameLbl: UILabel!
    @IBOutlet weak var leftHoursToGameLbl: UILabel!
    @IBOutlet weak var leftMintoGameLbl: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var viewHidhConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullScheduleBtn: UIButton!
    
    private var gamesArray = [Game]()
    private lazy var gamesReference:CollectionReference = Firestore.firestore().collection(GAMES_REF)
    private var gameScheduleListener: ListenerRegistration!
    private var isMenTeam: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHidhConstraint.constant = view.frame.size.height/2
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if gameScheduleListener != nil {
            gameScheduleListener.remove()
        }
    }
    
    
    func setListener () {
        gameScheduleListener = gamesReference
        .whereField(IS_MEN_TEAM, isEqualTo: isMenTeam)
        .order(by: GAME_DATE_AND_TIME, descending: true)
        .addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint("error fetching docs: \(error)")
            } else {
                self.gamesArray.removeAll()
                self.gamesArray = Game.parseData(snapshot: snapshot)
                self.scheduleTableView.reloadData()
            }
            })
    }
    

    @IBAction func tournamentBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func fullScheduleBtnWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func segmentControlWasSwitched(_ sender: Any) {
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

