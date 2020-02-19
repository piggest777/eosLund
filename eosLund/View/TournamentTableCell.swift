//
//  TournamentTableCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-14.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class TournamentTableCell: UITableViewCell {

    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var teamNameLbl: UILabel!
    @IBOutlet weak var matchCountsLbl: UILabel!
    @IBOutlet weak var winCountsLbl: UILabel!
    @IBOutlet weak var loseCountLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
