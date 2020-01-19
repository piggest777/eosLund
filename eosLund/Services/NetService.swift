//
//  netService.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class NetService {
    
    static let instance = NetService()
    let firebaseStorage = Storage.storage()
    
    func getImageFromFirebaseStorage(imageURL: String, completionHandler: @escaping (UIImage?, Bool) -> ()) {
        let playerImageRef = firebaseStorage.reference(forURL: imageURL)
        var image = UIImage()
        playerImageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                debugPrint("can`t download image", error!)
                completionHandler(nil, false)
            } else {
                image = UIImage(data: data!)!
                completionHandler(image, true)
            }
        }
        
    }
    
}
