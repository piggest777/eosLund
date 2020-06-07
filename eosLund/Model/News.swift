//
//  News.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-10.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

class News {
    public private (set)  var header: String
    private (set) public var date: String
    private (set) public var text: String
    private (set) public var imageLink: String
    private (set) public var link: String

    init(header: String, date: String, text: String, imageLink: String, newsLink: String) {
        self.header = header
        self.date = date
        self.text = text
        self.imageLink = imageLink
        self.link = newsLink
    }
}
