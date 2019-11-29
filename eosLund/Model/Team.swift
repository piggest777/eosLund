//
//  Team.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-29.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation

class Team {
   private(set)var name: String
   private(set) var city: String
  
    init(name: String, city:String) {
        self.name = name
        self.city = city
    }
}
