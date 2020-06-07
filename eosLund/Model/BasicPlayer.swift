//
//  BasicPlayer.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-06-03.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

class BasicPlayer {
    private (set) var name: String
    private (set) var number: Int
    private (set) var dateOfBirth: String
    private (set) var height: String
    private (set) var position: String
    
    init(name: String, number: Int, dateOfBirth: String, height: String, position: String) {
        self.name = name
        self.number = number
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.position = position
    }
}
