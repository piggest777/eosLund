//
//  ViewExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-01.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

extension UIView {
    
    func setUpStatusBar(){
         if #available(iOS 13.0, *) {
                    let app = UIApplication.shared
                    let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                    
                    let statusbarView = UIView()

                    statusbarView.backgroundColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
                    self.addSubview(statusbarView)
                  
                    statusbarView.translatesAutoresizingMaskIntoConstraints = false
                    statusbarView.heightAnchor
                        .constraint(equalToConstant: statusBarHeight).isActive = true
                    statusbarView.widthAnchor
                        .constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
                    statusbarView.topAnchor
                        .constraint(equalTo: self.topAnchor).isActive = true
                    statusbarView.centerXAnchor
                        .constraint(equalTo: self.centerXAnchor).isActive = true
                  
                } else {
                    let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                    statusBar?.backgroundColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
                }
    }
}
