//
//  TestViewController.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-13.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTeamToBase(base: teamBase)
    }
    
    let teamBase = [
    
   ["A3 Basket Umeå",    "A3",    "Umeå",    "Umeå Energi Arena",    "A3 Basket.png"],
    ["AIK Basket",    "AIK",    "Solna", "Vasalundshallen",    "AIK Basket.png"],
    ["Alvik Basket",    "ALV",    "Stockholm",    "Åkeshovshallen",    "Alvik Basket.png"],
    ["Bankeryds Basket",    "BKR",    "Bankeryd",    "Attarpshallen A",    "Bankeryds Basket.png"],
    ["Borås Basket",    "BOR",    "Boras",    "Boråshallen",    "Borås Basket.png"],
    ["Brahe Basket",    "BRA",    "Huskvarna",   "Huskvarna Sporthall",    "Brahe Basket.png"],
     ["Djurgården Basket",    "DIF",    "Stockholm",    "Brännkyrkahallen S",    "Djurgården Basket.png"],
     ["Helsingborg BBK",    "HBBK",    "Helsingborg",    "GA-hallen",    "Helsingborg BBK.png"],
    ["Högsbo Basket",    "HÖG",    "Göteborg",    "Gothia Arena 2",    "Högsbo Basket.png"],
     ["Huddinge Basket",    "HDD",    "Huddinge",    "Stuvstahallen",    "Huddinge Basket.png"],
     ["Eos Basket",    "EOS",    "Lund",    "Eoshallen",    "eosLogo.png"],
     ["Blackeberg Basket",    "BLB",    "Stockholm",    "Vällingbyhallen S",    "KFUM Blackeberg.png"],
    ["Fryshuset Basket",    "FRH",    "Stockholm",    "Fryshuset",    "Fryshuset Basket.png"],
     ["Lidingö Basket",    "LDN",    "Lidingö",    "Hersby Sporthall",    "KFUM Lidingö.png"],
     ["Östersund",    "OSS",    "Östersund",    "Östersunds Sporthall",     "KFUM Östersund.png"],
     ["Uppsala Basket",    "UPP",    "Uppsala",    "SEB USIF Arena",    "Uppsala Basket.png"],
     ["Lobas",    "LBS",    "Lomma",    "Pilängshallen",    "Lobas.png"],
     ["Luleå Basket",    "LUL",   "Luleå",    "Luleå Energi Arena",    "Luleå Basket.png"],
    ["Luleå Stars",    "LLS",    "Luleå",    "Hälsans Hus",    "Luleå Stars.png"],
     ["Marbo Basket",    "MRB",   "Kinna",   "Kinnahallen",    "Marbo Basket.png"],
     ["Mark Basket",    "MAR",    "Kinna",    "Kinnahallen",    "Mark Basket.png"],
     ["Norrköping Dolphins",    "NOR",    "Norrköping",    "Stadium Arena A",    "Norrköping Dolphins.png"],
    ["Norrort",    "NRR",    "Täby",    "Tibblehallen CC",    "Norrort Basket.png"],
     ["Oskarshamn",    "OHB",    "Oskarshamn",    "Sporthallen A",    "Oskarshamn Basket.png"],
    ["RIG Luleå",    "RLL",    "Luleå",    "Hälsans Hus",    "RIG Luleå.png"],
     ["RIG Mark",    "MST",    "Kinna",    "Kinnahallen",    "RIG Mark.png"],
     ["SBBK",    "SBBK",    "Södertälje",    "Rosenborgsskolan",    "SBBK.png"],
     ["Team4Q",    "T4Q",   "Helsingborg",    "GA-hallen",    "Team4Q.png"],
     ["Telge Basket",    "SÖD",    "Sodertalje",    "Täljehallen",    "Telge Basket.png"],
     ["Trelleborg Pirates",    "TBP",    "Trelleborg",    "Liljeborgsskolans sporthall",    "Trelleborg Basket.png"],
    ["Västerås Basket",    "VSB",    "Västerås",    "Viksängsskolan",    "Västerås Basket.png"],
    ["Visby Ladies",    "VIS",    "Visby",    "ICA Maxi Arena",    "Visby Ladies.png"],
    ["Wetterbygden Sparks",    "WET",    "Huskvarna",    "Huskvarna Sporthall",    "Wetterbygden Basketball.png"]
]
    
    func addTeamToBase(base: [[String]]) {
        
        let bases = teamBase
        var index = 0
        for base in bases {
            let id = base[1]
            let name = base[0]
            let city = base[2]
            let homeArena = base[3]
            let logoPath = base[4]
            Firestore.firestore().collection("teams").document(id).setData([
                "teamName" : name,
                "teamCity" : city,
                "homeArena" : homeArena,
                "logoPathName" : logoPath
            ])
            index += 1
            print("team #\(index)")
        }
        
    }
}
