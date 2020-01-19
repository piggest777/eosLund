//
//  CoachVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-09.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class CoachVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var leagueLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var choosenLeague: String!
    let firebaseDB = Firestore.firestore()
    var coachesArray = [Coach]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpLeagueLbl()
        getCouachArray()
    }
    
    func setUpLeagueLbl () {
        switch choosenLeague {
        case "SBLD":
            leagueLbl.text = "SWEDISH BASKETBALL LEAGUE WOMAN"
        case "BE Herr":
            leagueLbl.text = "BASKETETTAN MAN"
        case "BE Dam":
            leagueLbl.text = "BASKETETTAN WOMAN"
        default:
            leagueLbl.text = ""
        }
    }
    
    func getCouachArray() {
        firebaseDB.collection("staff").document(choosenLeague!).collection("coaches").getDocuments { (snapshot, error) in
            if error != nil {
                debugPrint("error while get coaches info")
            } else {
                self.coachesArray = Coach.parseData(snapshot: snapshot)
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coachesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "staffCell", for: indexPath) as? CoachCollectionViewCell else { return UICollectionViewCell() }
        
        let staff = coachesArray[indexPath.row]
            
        cell.configureCell(staff: staff)
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
    

}
