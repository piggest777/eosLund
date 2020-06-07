//
//  PlayerInfoVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-12-23.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class PlayerInfoVC: UIViewController {
    
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerNumberLbl: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var nationalityLbl: UILabel!
    @IBOutlet weak var originalClubLbl: UILabel!
    @IBOutlet weak var inEOSFromLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playerLeague: UILabel!
    
    var player: PlayerRealmObject!
    let firebaseStorage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlayerInfo()
    }
    
    
    //get information about player direct from firebase by player id
    func loadPlayerInfo(){
        let playerInfoRef = Firestore.firestore()
        setupMainPlayerInfo()
        playerInfoRef.collection("players").document(player.id).getDocument { (snapshot, error) in
            if error != nil {
                debugPrint("problem to get player`s information from firebase")
            } else {
                guard let data = snapshot?.data() else {return}
                let birthDate = data[DAY_OF_BIRTH] as? String ?? "NO INFO"
                let age = self.calculateAgeFromDateOfBirth(date: birthDate)
                self.ageLbl.text = age
                self.heightLbl.text = data[PLAYER_HEIGHT] as? String ?? "NO INFO"
                let nationalityData = data[PLAYER_NATIONALITY] as? String ?? "NO INFO"
                if nationalityData == "NO INFO" {
                    self.setFontSize(isNoInfoAboutNationality: true, nationalityData: nationalityData)
                } else {
                    self.setFontSize(isNoInfoAboutNationality: false, nationalityData: nationalityData)
                }
                self.originalClubLbl.text = data[PLAYER_ORIGINAL_CLUB] as? String ?? "NO INFO"
                self.inEOSFromLbl.text = data[PLAYER_INEOS_FROM] as? String ?? "NO INFO"
                let imageUrl: String = data[PLAYER_BIG_IMAGE_URL] as? String ?? "NO IMAGE DATA"
                self.getBigPlayerImage(imageURL: imageUrl)
            }
        }
    }
    
    //get age by date of birth
    func calculateAgeFromDateOfBirth (date: String) -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = formatter.date(from: date)
        
        let currentDate = Date()
        
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.maximumUnitCount = 1
        componentsFormatter.unitsStyle = .full
        componentsFormatter.allowedUnits = [.year]
        
        guard dateFromString != nil  else {
            return "NO INFO"
        }
        
        let yearString = componentsFormatter.string(from: dateFromString!, to: currentDate)
        let charArray = Array(yearString!)
        var numericString = String()
        for i in 0...charArray.count {
            let character = charArray[i]
            if let _ = Int(String (character)) {
                numericString.append(character)
            } else {
                break
            }
        }
        return numericString
    }
    
    func setupMainPlayerInfo() {
        guard let player = player else { return }
        
        playerNameLbl.text = player.playerName
        playerNumberLbl.text = "Number \(player.playerNumber)"
        positionLbl.text = player.playerPosition
        
        switch player.playerLeague {
        case "SBLD":
            playerLeague.text = "SWEDISH BASKETBALL LEAGUE WOMAN"
            playerImageView.image = UIImage(named: "defaultBigPlayerImage")
        case "SE Herr":
            playerLeague.text = "SUPERETTAN MAN"
            playerImageView.image = UIImage(named: "defaultBigPlayerImageMan")
        case "BE Dam":
            playerLeague.text = "BASKETETTAN WOMAN"
            playerImageView.image = UIImage(named: "defaultBigPlayerImage")
        default:
            playerLeague.text = ""
        }
        
    }
    
    // FIXME:   if valid url check?
    func getBigPlayerImage(imageURL: String) {
        if imageURL != "NO IMAGE DATA" {
            let imageRef = firebaseStorage.reference(forURL: imageURL)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if error != nil {
                    self.setDefaultImage()
                    debugPrint("can`t download big image")
                } else {
                    guard let imageData = data else {
                        print("Big image data is nil")
                        self.setDefaultImage()
                        return
                    }
                    self.playerImageView.image = UIImage(data: imageData)
                }
            }
            
        } else {
            setDefaultImage()
        }
    }
    
    //change font size for flag emoji depend from exist information or not
    func setFontSize(isNoInfoAboutNationality: Bool, nationalityData: String) {
        if isNoInfoAboutNationality == true {
            self.nationalityLbl.font = UIFont(name: "AvenirNext-UltraLight", size: 20)
        } else {
            self.nationalityLbl.font = UIFont(name: "AvenirNext-UltraLight", size: 33)
        }
        nationalityLbl.text = nationalityData
    }
    
    func setDefaultImage(){
        playerImageView.image = UIImage(named: "defaultBigPlayerImage.png")
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
