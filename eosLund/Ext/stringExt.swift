//
//  stringExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-03.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    func removingWhiteSpace() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
}
