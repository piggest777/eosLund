//
//  UIViewControllerExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-10.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSFSafariVCFor(url:String) {
        let readMore =  URL(string:  url)
        let safariVC = SFSafariViewController(url: readMore!)
        present(safariVC, animated: true, completion: nil)
    }
}
