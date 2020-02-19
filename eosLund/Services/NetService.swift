//
//  netService.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage

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
    
    func getImageBy(url: String, completionHandler: @escaping (UIImage?)->()) {

        AF.request(url).responseImage { (response) in
            if response.error == nil {
                if let responseImge = response.value {
                    completionHandler(responseImge)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getTournamentTableUrl(league: String, completionHandler: @escaping (String?)->()) {
        

        Firestore.firestore().collection("tournamentTablesUrl").document("\(league)").getDocument { (snapshot, error) in
            if error == nil {
                guard let data = snapshot?.data() else { return }
                let returnedUrl: String? = data["url"] as? String ?? nil
               completionHandler(returnedUrl)
            }
            else {
            debugPrint("can`t get tournament url", error as Any)
                completionHandler(nil)
        }
        }
    }
   
}
