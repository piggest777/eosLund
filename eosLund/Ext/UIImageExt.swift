//
//  UIImageExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-12.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func setLogoImg(logoPath: String) {
        if let logo = UIImage(named: "\(logoPath)") {
            self.image = logo
        } else  {
            self.image = UIImage(named: "defaultLogo.png")!
        }
    }
}
