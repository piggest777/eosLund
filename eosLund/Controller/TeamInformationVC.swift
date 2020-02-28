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
    
    let firebaseDB = Firestore.firestore()
    let firebaseStorage = Storage.storage()
//    var playerArrayFetchedFromFireBase = [Player]()
    var realmFetchedArray: Results<PlayerRealmObject>?
    var choosenLeague: String = "SBLD"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let leaguePredicate = NSPredicate(format: "playerLeague = %@", choosenLeague)
        realmFetchedArray = PlayerRealmObject.getAllPlayers()?.filter(leaguePredicate).sorted(byKeyPath: "playerNumber")
        fetchInfoFromFireBase { (returnedPlayerArray) in
            self.trackFirebaseUpdate(playerArray: returnedPlayerArray) { (success) in
                if success {
                    print("Update complete")
                    self.realmFetchedArray = PlayerRealmObject.getAllPlayers()?.filter(leaguePredicate).sorted(byKeyPath: "playerNumber")
//                    self.collectionView.reloadData()
                }
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
    
    func fetchInfoFromFireBase(returnedPlayerArray: @escaping ([Player])-> ()) {
        firebaseDB.collection(PLAYERS_REF).getDocuments { (snapshot, error) in
            if error != nil {
                debugPrint("can`t fetch documents")
                return
            } else {
//                self.playerArrayFetchedFromFireBase.removeAll()
                
                let playerArray = Player.parsePlayerData(snapShot: snapshot)
                returnedPlayerArray(playerArray)
            }
        }
    }
    
    func trackFirebaseUpdate(playerArray: [Player], completionHandler: (Bool)->()) {
        
        var baseStatus: RealmBaseStatus
        var IDsToUpdate = [String]()
        var IDsToDelete = [String]()
        
        guard let playersArrayFromRealmBase = PlayerRealmObject.getAllPlayers() else {
            debugPrint("Can`t get realm base to compare")
            return
        }
        
        if playersArrayFromRealmBase.isEmpty {
            baseStatus = .notExist
            let firIds = playerArray.map { $0.playerId! }
            IDsToUpdate.append(contentsOf: firIds)
        } else {
            var realmIds = getAllRealmBaseIds(realmArray: playersArrayFromRealmBase)
            let firebasIds = getAllFirIds(firArray: playerArray)
            
            for id in firebasIds {
                let fbID = id.0
                let fbUpdateDate = id.1
                
                if let realmUpdateDate = realmIds[fbID]  {
                    if fbUpdateDate > realmUpdateDate {
                        IDsToUpdate.append(fbID)
                        realmIds.removeValue(forKey: fbID)
                    } else {
                        realmIds.removeValue(forKey: fbID)
                    }
                } else {
                    IDsToUpdate.append(id.0)
                }
            }
            IDsToDelete.append(contentsOf: Array(realmIds.keys))
            
            if IDsToDelete.isEmpty && IDsToUpdate.isEmpty {
                baseStatus = .readyToUse
            } else {
                baseStatus = .needToBeUpdate
            }
        }
        
        let playerArrayToUpdate: [Player] = playerArray.filter {
            if IDsToUpdate.contains($0.playerId) {
                return true
            } else {
                return false
            }
        }

        switch baseStatus {
        case .notExist:
            print("All players need to be update")
            updateRealmBase(players: playerArrayToUpdate)
        case .readyToUse:
            print("All players already updated")
        case .needToBeUpdate:
            updateRealmBase(players: playerArrayToUpdate)
            deleteObjectsFromRealm(iDsToDelete: IDsToDelete)
            print("some players was updated")
            
        }
        
        completionHandler(true)
        
//        for player in playerArray {
//
//            guard let id = player.playerId,
//                let updateDate = player.playerUpdateDate,
//                let playerImageUrl = player.playerImageUrl,
//                let _ = player.playerName,
//                let _ = player.playerNumber,
//                let _ = player.playerPosition
////                Check does  player have leauge???
//
//                else {
//                    print("error to fetch player from firebase")
//                    return
//
//            }
//
//            guard let playersArrayFromRealmBase = PlayerRealmObject.getAllPlayers() else {
//                debugPrint("Can`t get realm base to compare")
//                return
//            }
//
//            if playersArrayFromRealmBase.isEmpty == false {
//                let idsBase = getAllRealmBaseIds()
//                if idsBase.contains(id) {
//                    var realmsPlayer: PlayerRealmObject?
//                    do {
//                    let player = try Realm().object(ofType: PlayerRealmObject.self, forPrimaryKey: id)
//                        realmsPlayer = player
//                    } catch  {
//                        debugPrint("Can`t find Player in RealmBase by id", error)
//                    }
//
//                    guard let unwPlayer = realmsPlayer else {
//                        return
//                    }
//
//                    if unwPlayer.playerUpdateDate < updateDate {
////                        check valid URL
//                        getImageFromFirebaseStorage(imageURL: playerImageUrl) { (image, succeed) in
//                            if succeed {
//                                PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (success) in
//                                    if success {
//                                        self.collectionView.reloadData()
//                                    }
//                                }
//                                print("Information updated succesfully")
//                            } else {
//                                debugPrint("Image dowload error")
//                                //                                add try again later func
//                            }
//                        }
//                    } else {
//                        debugPrint("Player found and no need to update")
//                    }
//                } else {
//                    print("try to create after")
//                    createPlayerRealmObject(player: player)
//                }
//
//            } else {
//                createPlayerRealmObject(player: player)
//            }
//        }
//        completionHandler(true)
        
    }
    
    
    func updateRealmBase(players: [Player]) {
        var index = 1
        for player in players {
            print(player.playerName)
            getImageFromFirebaseStorage(imageURL: player.playerImageUrl) { (image, succees) in
                    if succees {
                        if index == players.count {
                            PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (succees) in
                                if succees {
                                    self.collectionView.reloadData()
                                }
                            }
                        } else {
                            PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (success) in
                                if succees {
                                    index += 1
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func deleteObjectsFromRealm (iDsToDelete: [String]) {
        for id in iDsToDelete {
            do {
                guard let realmObject = try Realm().object(ofType: PlayerRealmObject.self, forPrimaryKey: id) else {
                    print("can`t find player to delete")
                    continue

                }
                let realm = try Realm()
                try realm.write {
                    realm.delete(realmObject)
                }
            } catch  {
                debugPrint("Can`t delete Player from Realm", error)
            }
        }
    }
    
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
    
    func getAllFirIds (firArray: [Player]) -> [(String, Date)] {
        var base = [(String, Date)]()
        for player in firArray {
            let id = player.playerId
            let updateDate = player.playerUpdateDate
            base.append((id!, updateDate!))
        }
        return base
    }
    
//    rewrite get player by Id func
    func getPlayerFromRealm(for id: String, realmPlayerArray: Results<PlayerRealmObject>) -> PlayerRealmObject {
        var playerToReturn = PlayerRealmObject()
        for player in  realmPlayerArray {
            if player.id == id {
                playerToReturn = player
                break
            }
        }
        return playerToReturn
    }
    
    func createPlayerRealmObject(player: Player) {
        let playerImageUrl = player.playerImageUrl!
//        Check if url is valid
        getImageFromFirebaseStorage(imageURL: playerImageUrl) { (image, succeed) in
            if succeed {
                let dataImage = image!.pngData()
                let date = Date()
                PlayerRealmObject.addPlayerToRealmBase(playerId: player.playerId, playerName: player.playerName, playerNumber: player.playerNumber, playerPosition: player.playerPosition, playerImage: dataImage!, playerLeague: player.playerLeague, playerUpdateDate: date) { (success) in
                    if success {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
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
