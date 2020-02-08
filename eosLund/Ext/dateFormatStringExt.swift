//
//  dateFormatStringExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-13.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String = "d MMMM yyyy, HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
}
