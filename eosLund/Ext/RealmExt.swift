//
//  RealmExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-22.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    func write(transaction block: () -> Void, completion: () -> Void) throws {
        try write(block)
        completion()
    }
}
