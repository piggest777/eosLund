//
//  ViewController.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-13.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var wv: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadYoutube(videoID: "qhKx-AtMnqA")
    }
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        wv.load( URLRequest(url: youtubeURL) )
    }
}
