//
//  CoachCollectionViewCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class CoachCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    
    func configureCell(staff: Coach){
        profileImageView.image = UIImage(named: "defaultAvatar.png")
        nameLbl.text = staff.staffName
        positionLbl.text = staff.staffPosition
        
        if staff.imageViewURL != "NO IMAGE" {
            if staff.imageViewURL.isValidURL {
                NetService.instance.getImageFromFirebaseStorage(imageURL: staff.imageViewURL) { (downloadedImage, success) in
                    if success {
                        self.profileImageView.image = downloadedImage!
                    } else {
                        print("Can`t get staff image")
                    }
                }
            } else {
                profileImageView.image = UIImage(named:"defaultAvatar.png")
            }
        } else {
            profileImageView.image = UIImage(named:"defaultAvatar.png")
        }
    }
}
