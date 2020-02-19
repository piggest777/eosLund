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

class TeamInformationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var teamSelectorSegmentControl: UISegmentedControl!
    
    let firebaseDB = Firestore.firestore()
    let firebaseStorage = Storage.storage()
    var playerArrayFetchedFromFireBase = [Player]()
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
                    self.collectionView.reloadData()
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
            choosenLeague = "BE Herr"
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
                self.playerArrayFetchedFromFireBase.removeAll()
                
                let playerArray = Player.parsePlayerData(snapShot: snapshot)
                returnedPlayerArray(playerArray)
            }
        }
    }
    
    func trackFirebaseUpdate(playerArray: [Player], completionHandler: (Bool)->()) {
        for player in playerArray {
            guard let id = player.playerId,
                let updateDate = player.playerUpdateDate,
                let playerImageUrl = player.playerImageUrl,
                let _ = player.playerName,
                let _ = player.playerNumber,
                let _ = player.playerPosition
                
                else {
                    print("error to fetch player from firebase")
                    return
                    
            }
            
//            print(updateDate, player.playerName)
            
            guard let playersArrayFromRealmBase = PlayerRealmObject.getAllPlayers() else {
                debugPrint("Can`t get realm base to compare")
                return
            }
            
            if playersArrayFromRealmBase.isEmpty == false {
                let idsBase = getAllRealmBaseIds()
                if idsBase.contains(id) {
                    let realmsPlayer = getPlayerFromRealm(for: id, realmPlayerArray: playersArrayFromRealmBase)
                    
                    if realmsPlayer.playerUpdateDate < updateDate {
                        getImageFromFirebaseStorage(imageURL: playerImageUrl) { (image, succeed) in
                            if succeed {
                                PlayerRealmObject.updatePlayerInfo(player: player, playerImage: image!) { (success) in
                                    if success {
                                        self.collectionView.reloadData()
                                    }
                                }
                                print("Information updated succesfully")
                            } else {
                                debugPrint("Image dowload error")
                                //                                add try again later func
                            }
                        }
                    } else {
                        debugPrint("Player found and no need to update")
                    }
                } else {
                    print("try to create after")
                    createPlayerRealmObject(player: player)
                }
                
            } else {
                createPlayerRealmObject(player: player)
            }
        }
        completionHandler(true)
        
    }
    
    func getAllRealmBaseIds() -> [String]{
        let playersArray = PlayerRealmObject.getAllPlayers()!
        var idsBase = [String]()
        for player in playersArray {
            let id = player.id
            idsBase.append(id)
        }
        return idsBase
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
        getImageFromFirebaseStorage(imageURL: playerImageUrl) { (image, succed) in
            if succed {
                let dataImage = image!.pngData()
                let date = Date()
                PlayerRealmObject.addPlayerToRealmBase(playerId: player.playerId, playerName: player.playerName, playerNumber: player.playerNumber, playerPosition: player.playerPosition, playerImage: dataImage!, playerLeague: player.playerLeague, playerUpdateDate: date)
            }
        }
    }
    
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
