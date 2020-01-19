//
//  TeamCollectionViewCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-05.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var playerImgView: UIImageView!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerNumberLbl: UILabel!
    @IBOutlet weak var playerPositionLbl: UILabel!
    
    
    func configureCell (playerName: String, playerNumber: Int, playerPosition: String, playerImage: UIImage) {
        
        playerImgView.image = playerImage
        playerNameLbl.text = playerName
        playerNumberLbl.text = "Nr \(playerNumber)"
        playerPositionLbl.text = playerPosition
    }
}
