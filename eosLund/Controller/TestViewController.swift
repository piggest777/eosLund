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
        parsePlayers(base: playersList)
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

func parsePlayers (base: [[Any]]) {
    let base = base
    var index = 0
    for player in base {
        let playerNumber: Int  = (player[0] as? Int)!
        let playerName = player[1] as! String
        let dayOfBirth = player[2] as! String
        let playerPosition = player[3] as! String
        let playersHeight = player[4] as! String
        let originalCountry = player[5] as! String
        let playerLeague = player[6] as! String
        let playerNationality = player[7] as! String
        let inEosfrom = player[8] as! String
        let updateDate = Date()
        let playerImgString = playerName.removingWhiteSpace()
        let playerImgUrl = "gs://eoslund-4ceb4.appspot.com/\(playerImgString).png"
        Firestore.firestore().collection("players").addDocument(data: [
            "playerName" : playerName,
            "playerNumber" : playerNumber,
            "playerPosition" : playerPosition,
            "playerImageURL" : playerImgUrl,
            "playerUpdateDate" : updateDate,
            "dayOfBirth" : dayOfBirth,
            "playerHeight" : playersHeight,
            "playerNationality" : playerNationality,
            "playerOriginalClub" : originalCountry,
            "playerInEOSFrom" : inEosfrom,
            "playerBigImageUrl" : playerImgUrl,
            "teamLeague" : playerLeague
        
        ])


        index += 1
        print("team #\(index)")
    }
    
}


let playersList = [
    [3, "Georgia de Leeuw", "1990-01-14", "Guard", "177", "Österrike", "SBLD", " 🇦🇹", "2019"],
[6, "Kajsa Lundahl", "1991-06-14", "Forward", "181", "IK Eos", "SBLD", " 🇸🇪", "2007 -2009, 2011"],
[7, "Dubravka Dacic", "1985-05-06", "Center", "201", "Italien", "SBLD", "🇮🇹", "2018"],
[8, "Louise Noaksson (C)", "1993-07-03", "Guard", "175", "Kvarnby", "SBLD", "🇸🇪", "2014"],
[9, "Vendela Genell", "1997-09-20", "Guard", "174", "IK Eos", "SBLD", "🇸🇪", "2011"],
[10, "Tove Hultin", "1996-04-17", "Guard", "167", "Lobas", "SBLD", "🇸🇪", "2014"],
[11, "Mary Goulding", "1996-08-24", "Forward", "183", "Nya Zeeland", "SBLD", "🇳🇿", "2019"],
[12, "Karoline Teigland", "1996-03-29", "Guard", "173", "Djursholm", "SBLD", "🇸🇪", "2017"],
[13, "Emelie Ånäs", "1999-06-08", "Guard", "175", "Täby", "SBLD", "🇸🇪", "2017"],
    [17, "Sofie Ljungcrantz", "1997-04-03", "Guard", "178", "IK Eos", "SBLD", "🇸🇪", "2019"],
[22, "Lena Frederiksen", "1993-02-02", "Forward", "180", "Malbas", "SBLD", "🇸🇪", "2019"],
[24, "Julia Nyström", "2002-02-27", "Guard", "165", "IK Eos", "SBLD", "🇸🇪", "2015"],


[00, "Kofi Adanovur", "1991-03-15", "Forward", "191", "Malbas", "SE Herr", "🇸🇪", "2010"],
[2, "Adnan Karovic", "1988-05-20", "Guard", "188", "Malmö IBK", "SE Herr", "🇸🇪", "2010"],
[4, "Tahe Mahmoud", "2000-05-28", "Guard", "189", "IK Eos", "SE Herr", "🇸🇪", "2013"],
[5, "Nils Gjörup", "1992-02-07", "Guard", "177", "Höken", "SE Herr", "🇸🇪", "2011"],
[6, "Gustav Sundström", "1991-05-31", "Forward", "197", "IK Eos", "SE Herr", "🇸🇪", "2010-2011, 2016"],
[8, "Andreas von Uthmann", "1996-11-21", "Forward", "197", "Djursholm", "SE Herr", "🇸🇪", "2018"],
[9, "David Niklasson", "1995-05-26", "Guard", "193", "Täby", "SE Herr", "🇸🇪", "2019"],
[10, "Marcus Dahlqvist", "1996-01-13", "Guard", "191", "Djursholm", "SE Herr", "🇸🇪", "2017"],
[11, "Johan Aasa", "1992-12-31", "Guard", "190", "Skellefteå", "SE Herr", "🇸🇪", "2017"],
[27, "Andrew Lundström", "1996-12-10", "Forward", "198", "Kanada", "SE Herr", "🇨🇦", "2019"],
[13, "Erik Nilsson", "1998-08-25", "Forward", "192", "Malbas", "SE Herr", "🇸🇪", "2018"],
[22, "Joel Svensson", "1996-07-19", "Guard", "185", "Tureberg", "SE Herr", "🇸🇪", "2019"],
[24, "Anton Almqvist", "1995-02-25", "Guard", "185", "Marbo", "SE Herr","🇸🇪", "2017"],
[27, "Carl Tjernberg", "1998-03-13", "Guard", "187", "Djursholm", "SE Herr", "🇸🇪", "2019"],
[55, "Olle Karlsson (C)", "1996-10-18", "Guard", "193", "Avans SK", "SE Herr", "🇸🇪", "2015"],
[97, "Hannes Berntson", "2002-09-24", "Guard", "175", "IK Eos", "SE Herr", "🇸🇪", "2015"],
[98, "Johan Rafstedt", "1999-08-17", "Guard", "182", "IK Eos", "SE Herr", "🇸🇪", "2013-2015, 2017"]
]

