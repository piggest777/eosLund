//
//  SecondViewController.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import RealmSwift

enum RealmBaseStatus {
    case notExist
    case needToBeUpdate
    case readyToUse
}

class TeamInformationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var teamSelectorSegmentControl: UISegmentedControl!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let firebaseDB = Firestore.firestore()
    let firebaseStorage = Storage.storage()
    var realmFetchedArray: Results<PlayerRealmObject>?
    var choosenLeague: String = "SBLD"
    
    let defaults = UserDefaults.standard
    
    //save or get player update base date
    var playerBaseUpdateDate: Date? {
        get
        {
            return defaults.value(forKey: "PlayersBaseUpdateDate") as? Date
        }
        set
        {
            defaults.set(newValue, forKey: "PlayersBaseUpdateDate")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        progressBar.isHidden = true
        realmFetchedArray = PlayerRealmObject.getRealmPredicatePlayerListForTable(league: choosenLeague)
        
        //update player base according base status
        trackFirebaseUpdateDate() { (baseStatus) in
            
            switch baseStatus {
            case .notExist:
                print("All players need to be update")
                self.fetchInfoFromFireBase { (returnedPlayerArray) in
                    self.updateRealmBase(players: returnedPlayerArray)
                }
            case .needToBeUpdate:
                self.fetchInfoFromFireBase { (returnedPlayerArray) in
                    var IDsToUpdate = [String]()
                    var IDsToDelete = [String]()
                    guard let playersArrayFromRealmBase = PlayerRealmObject.getAllPlayers() else {
                        debugPrint("Can`t get realm base to compare")
                        return
                    }
                    var realmIds = self.getAllRealmBaseIds(realmArray: playersArrayFromRealmBase)
                    let firebasIds = self.getAllFirIds(firArray: returnedPlayerArray)
                    
                    for id in firebasIds {
                        let firID = id.0
                        let firUpdateDate = id.1
                        
                        if let realmUpdateDate = realmIds[firID]  {
                            if firUpdateDate > realmUpdateDate {
                                IDsToUpdate.append(firID)
                                realmIds.removeValue(forKey: firID)
                            } else {
                                realmIds.removeValue(forKey: firID)
                            }
                        } else {
                            IDsToUpdate.append(id.0)
                        }
                    }
                    IDsToDelete.append(contentsOf: Array(realmIds.keys))
                    
                    if IDsToDelete.isEmpty && IDsToUpdate.isEmpty {
                        return
                    } else {
                        let playerArrayToUpdate: [Player] = returnedPlayerArray.filter {
                            if IDsToUpdate.contains($0.id) {
                                return true
                            } else {
                                return false
                            }
                        }
                        self.updateRealmBase(players: playerArrayToUpdate)
                        self.deleteObjectsFromRealm(iDsToDelete: IDsToDelete)
                        print("some players was updated")
                    }
                }
            case .readyToUse:
                print("All players already updated")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.setUpStatusBar()
        collectionView.reloadData()
    }
    
    @IBAction func teamChangedSegmentControl(_ sender: Any) {
        
        switch teamSelectorSegmentControl.selectedSegmentIndex {
        case 0:
            choosenLeague = "SBLD"
        case 1:
            choosenLeague = "SE Herr"
        case 2:
            choosenLeague = "BE Dam"
        default:
            choosenLeague = "SBLD"
        }
        realmFetchedArray = PlayerRealmObject.getAllPlayers()?.filter("playerLeague = '\(choosenLeague)'").sorted(byKeyPath: "playerNumber")
        collectionView.reloadData()
    }
    
    //get players from firebase
    func fetchInfoFromFireBase(returnedPlayerArray: @escaping ([Player])-> ()) {
        firebaseDB.collection(PLAYERS_REF).getDocuments { (snapshot, error) in
            if error != nil {
                debugPrint("can`t fetch players from firebase")
                return
            } else {
                let playerArray = Player.parsePlayerData(snapShot: snapshot)
                returnedPlayerArray(playerArray)
            }
        }
    }
    
    //track if firebase has new version of player base
    func trackFirebaseUpdateDate(completionHandler: @escaping (RealmBaseStatus)->()) {
        guard let playersArrayFromRealmBase = PlayerRealmObject.getAllPlayers() else {
            debugPrint("Can`t get realm base to compare")
            return
        }
        
        if playersArrayFromRealmBase.isEmpty || playerBaseUpdateDate == nil  {
            completionHandler(.notExist)
        } else {
            firebaseDB.collection("baseUpdateDate").document("playersBaseUpdateDate").getDocument { (snapshot, error) in
                if error == nil {
                    if let data = snapshot?.data(), let updateTimestamp = data["date"] as? Timestamp {
                        let updateDateFromFir = updateTimestamp.dateValue()
                        if let clientUpdateDate = self.playerBaseUpdateDate {
                            if updateDateFromFir > clientUpdateDate {
                                completionHandler(.needToBeUpdate)
                            } else {
                                completionHandler(.readyToUse)
                            }
                        } else {
                            completionHandler(.notExist)
                        }
                    }
                }
            }
        }
    }
    
    //load player information from firebase to realm base
    func updateRealmBase(players: [Player]) {
        progressBar.isHidden = false
        let playersCount = players.count
        var index = 1
        for player in players {
            getImageFromFirebaseStorage(imageURL: player.imageUrl) { (image, succees) in
                if succees {
                    if index == players.count {
                        PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (succees) in
                            if succees {
                                self.collectionView.reloadData()
                                self.progressBar.isHidden = true
                                self.playerBaseUpdateDate = Date()
                            }
                        }
                    } else {
                        PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (success) in
                            if succees {
                                index += 1
                                self.progressBar.setProgress(Float(index)/Float(playersCount), animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //delete player from realm base if player not exist in firebase
    func deleteObjectsFromRealm (iDsToDelete: [String]) {
        for id in iDsToDelete {
            do {
                guard let realmObject = try Realm().object(ofType: PlayerRealmObject.self, forPrimaryKey: id) else {
                    print("can`t find player in realm base to delete")
                    continue
                }
                let realm = try Realm()
                try realm.write {
                    realm.delete(realmObject)
                }
            } catch  {
                debugPrint("Can`t delete player from Realm", error)
            }
        }
    }
    
    //get all players ids from realm
    func getAllRealmBaseIds(realmArray: Results<PlayerRealmObject>) -> [String: Date]{
        let playersArray = realmArray
        var idsBase = [String: Date]()
        for player in playersArray {
            let id = player.id
            let updateDate = player.playerUpdateDate
            idsBase[id] = updateDate
        }
        return idsBase
    }
    
    //get all players ids from firebase
    func getAllFirIds (firArray: [Player]) -> [(String, Date)] {
        var base = [(String, Date)]()
        for player in firArray {
            let id = player.id
            let updateDate = player.updateDate
            base.append((id!, updateDate!))
        }
        return base
    }
    
    
    //get player image from firebase storage or load default
    func getImageFromFirebaseStorage(imageURL: String, completionHandler: @escaping (UIImage?, Bool) -> ()) {
        let playerImageRef = firebaseStorage.reference(forURL: imageURL)
        var image = UIImage()
        
        if imageURL.isValidURL {
            playerImageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if error != nil {
                    debugPrint("can`t download image", error!)
                    image = UIImage(named: "defaultAvatar")!
                    completionHandler(image, true)
                } else {
                    image = UIImage(data: data!)!
                    completionHandler(image, true)
                }
            }
        } else {
            image = UIImage(named: "defaultAvatar")!
            completionHandler(image, true)
        }
    }
    
    @IBAction func couchInfoBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCoachVC", sender: Any?.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmFetchedArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamCollectionViewCell else {return UICollectionViewCell()}
        
        guard let player = realmFetchedArray?[indexPath.row] else {
            return TeamCollectionViewCell()
        }
        let dataImage = player.playerImage
        let imageFromData = UIImage(data: dataImage)
        cell.configureCell(playerName: player.playerName, playerNumber: player.playerNumber, playerPosition: player.playerPosition, playerImage: imageFromData!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns : CGFloat = 2
        
        let spaceBetweenCells : CGFloat = 10
        let paddig : CGFloat = 20
        let cellDimension = ((collectionView.bounds.width - paddig) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        
        let hightCellDimension = cellDimension * 1.33 + 50
        
        return CGSize(width: cellDimension, height: hightCellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPlayerDetailVC", sender: realmFetchedArray![indexPath.row])
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayerDetailVC" {
            if let destinationVC = segue.destination as? PlayerInfoVC {
                if let player = sender as? PlayerRealmObject{
                    destinationVC.player = player
                }
            }
        } else if segue.identifier == "toCoachVC" {
            if let destinationVC = segue.destination as? CoachVC {
                destinationVC.choosenLeague = choosenLeague
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CoachFooterCollectionReusableView", for: indexPath)
            
            return footerView
        }
        fatalError()
    }
}
