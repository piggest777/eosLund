//
//  RoundedView.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-19.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class RoundedView: UIView {

        override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
