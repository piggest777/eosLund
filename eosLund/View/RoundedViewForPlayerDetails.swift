//
//  RoundedViewForPlayerDetails.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-06-11.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class RoundedViewForPlayerDetails: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
//        layer.borderWidth = 2
//        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
