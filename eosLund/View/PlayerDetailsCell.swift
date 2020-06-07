//
//  PlayerDetailsCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-05-24.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class PlayerDetailsCell: UITableViewCell {

    @IBOutlet weak var playerNumberLbl: UILabel!
    @IBOutlet weak var nameAndPositionLbl: UILabel!
    @IBOutlet weak var yearOfBirthday: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCell(player: BasicPlayer) {
        if player.number != 404{
            playerNumberLbl.text = String(player.number)
        } else {
            playerNumberLbl.text = "--"
        }
        
        nameAndPositionLbl.text = "\(player.name), \(player.position)"
        yearOfBirthday.text = player.dateOfBirth
        heightLbl.text = player.height
    }
}
