//
//  TournamentTableVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-02-14.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire


class TournamentTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var leaugeLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var league: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadInfoFromUrl(league: league)
    }
    
    func loadInfoFromUrl (league: String) {
        NetService.instance.getTournamentTableUrl(league: league) { (retunedUrl) in
            if let url = retunedUrl {
                if url.isValidURL {
                    self.getHTML(url: url)
                } else {
                        debugPrint("returned nil instead url")
                }
        }
    }
    }
    
    func getHTML(url: String) {
        AF.request(url).responseString { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                self.parseHTML(htmlData: utf8Text)
            }
        }
    }
    
    func parseHTML(htmlData: String) {
        do {
            let html = htmlData
            let doc: Document = try SwiftSoup.parse(html)
            let table: Element? = try doc.getElementById("11-301-standings-container")
            

//            for news in newsCards {
//                var imgLink: String = " "
//                if let img = try news.select("img").first(){
//                    imgLink = try img.attr("src")
//                } else {
//                    imgLink = "https://www.eoslund.se/eos/svg/eos-logo.svg"
//                }
//                let newsDate = try news.getElementsByClass("date").first()?.text() ?? " "
//                let newsHeader = try news.getElementsByClass("article-header").first()?.text() ?? " "
//                let newsText = try news.getElementsByClass("mt-3").first()?.text() ?? " "
//                let link = try news.select("a").first()?.attr("href") ?? "https://www.eoslund.se/404"
//
//                let newNews: NewsInstance = NewsInstance(header: newsHeader, date: newsDate, text: newsText, imageLink: imgLink, newsLink: link)
//
//                newsArray.append(newNews)
//            }
//            if newsArray.isEmpty == false {
//                loadingView.isHidden = true
//                spinner.stopAnimating()
//            }
//            tableView.reloadData()
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}
