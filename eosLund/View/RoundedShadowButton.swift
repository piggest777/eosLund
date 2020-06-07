//
//  RoundedShadowButton.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-27.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
    }
}
