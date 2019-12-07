//
//  SecondViewController.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit

class TeamInformationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var teamSelectorSegmentControl: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.setUpStatusBar()
        collectionView.reloadData()
    }
    
    @IBAction func teamChangedSegmentControl(_ sender: Any) {
    }
    
    @IBAction func addTestPlayer(_ sender: Any) {
        let image = UIImage(named: "Mary_Goulding")
        let imageToData = image?.pngData()
        PlayerRealmObject.addPlayerToTable(playerName: "Mary Goulding", playerNumber: "Nr 11", playerPosition: "Forward", playerImage: imageToData!)
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlayerRealmObject.getAllPlayers()?.count ?? 00
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamCollectionViewCell else {return UICollectionViewCell()}
        guard let player = PlayerRealmObject.getAllPlayers()?[indexPath.row] else {
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
    


}

