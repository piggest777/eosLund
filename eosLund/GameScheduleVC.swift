//
//  GameScheduleVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

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
    
//    var fullScheduleBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupButtonView()
        viewHidhConstraint.constant = view.frame.size.height/2
    }

    @IBAction func tournamentBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func fullScheduleBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func segmentControlWasSwitched(_ sender: Any) {
    }
    


//    override func viewWillLayoutSubviews() {
//
//        fullScheduleBtn.layer.cornerRadius = fullScheduleBtn.layer.frame.size.height/2
//        fullScheduleBtn.clipsToBounds = true
//        fullScheduleBtn.translatesAutoresizingMaskIntoConstraints = false
//    
//    }




    
}

