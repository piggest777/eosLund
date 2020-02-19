//
//  ArrayExt.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
