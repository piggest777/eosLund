//
//  Couch.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class Coach {
    private (set) var imageViewURL: String
    private(set) var staffName: String
    private(set) var staffPosition: String
    
    init(imageViewURL: String, staffName:String, staffPosition:String) {
        self.imageViewURL = imageViewURL
        self.staffName = staffName
        self.staffPosition = staffPosition
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Coach] {
        var coachArray = [Coach]()
        
        func makeCoachesFirstInArray(coachesArray: [Coach]) -> [Coach] {
            var index = 0
           var sortedArray = coachesArray
            for staff in coachesArray {
                if staff.staffPosition == "Coach" {
                    sortedArray.remove(at: index)
                    sortedArray.insert(staff, at: 0)
                    index += 1
                } else {
                    index += 1
                }
            }
            return sortedArray
        }
        
        guard let snapshot = snapshot else { return coachArray }
        
        for document in snapshot.documents {
            let data = document.data()
            
            let imageURL = data["coachImageURL"] as? String ?? "NO IMAGE"
            let name = data["coachName"] as? String ?? " "
            let position = data["coachPosition"] as? String ?? " "
            
            let newStaff = Coach(imageViewURL: imageURL, staffName: name, staffPosition: position)
            coachArray.append(newStaff)
        }
        let newArray = makeCoachesFirstInArray(coachesArray: coachArray)
        return newArray
    }
    

    
}
