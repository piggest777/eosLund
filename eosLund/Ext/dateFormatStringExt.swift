//
//  dateFormatStringExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-13.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

extension String {
    
    func dateFormateFrom(string: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM dd,yyyy"

        if let date = dateFormatterGet.date(from: string) {
           let dateToReturn = dateFormatterOut.string(from: date)
            return dateToReturn
        } else {
           return " "
        }
        
    }
    
}
