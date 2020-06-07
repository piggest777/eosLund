//
//  NewsVC.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-10.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire
import SwiftyJSON

class NewsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var newsTypeSegmentControl: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    var newsArray = [News]()
    var pageNumber: Int = 1
    var maxYoutubeSearchResult: Int = 50
    var responseArrayCount: Int = 0
    private (set) var segmentControlStatus = "news"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        spinner.startAnimating()
        spinner.color = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
        getNewsHTMLResponse()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        setFooterView()
    }
    
    @objc func fetchNews() {
        //TODO: need to add number of pages control
        if segmentControlStatus == "news" {
            pageNumber += 1
            getNewsHTMLResponse()
        }
    }
    
    func loadCellContent() {
        if segmentControlStatus == "news" {
            getNewsHTMLResponse()
        } else if segmentControlStatus == "video"{
            loadingLbl.text = "LOADING VIDEO..."
            getVideoHTMLResponse()
        } else {
            segmentControlStatus = "news"
            getNewsHTMLResponse()
        }
    }
    
    //get json response from youtube channel
    func getVideoHTMLResponse() {
        loadingView.isHidden = false
        spinner.startAnimating()
        AF.request("https://www.googleapis.com/youtube/v3/search?key=\(API_KEY)&channelId=UCfoQAv5xCoEEEutwU998--w&part=snippet,id&order=date&maxResults=\(maxYoutubeSearchResult)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var videoIdLink: String?
                guard let itemsArray = json["items"].array else {return}
                self.responseArrayCount = itemsArray.count
                for item in itemsArray {
                    let id: Dictionary = item["id"].dictionaryValue
                    let kind: String = id["kind"]!.stringValue
                    if kind == "youtube#video" {
                        let videoId: String? = id["videoId"]?.stringValue
                        videoIdLink = videoId
                    } else {
                        break
                    }
                    let snippet = item["snippet"].dictionaryValue
                    let publishedAt:String? = snippet["publishedAt"]?.stringValue
                    let title: String? = snippet["title"]?.stringValue
                    let description: String? = snippet["description"]?.stringValue

                    if (videoIdLink != nil) && (publishedAt != nil) && (title != nil) && description != nil {
                        
                        let videoDate = self.dateFormateFrom(string: publishedAt!)
                    
                       let newVideo = News(header: title!, date: videoDate, text: description!, imageLink: videoIdLink!, newsLink: "https://www.youtube.com/watch?v=\(videoIdLink!)")
                        self.newsArray.append(newVideo)
                    }
                }
                self.loadingView.isHidden = true
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //get news from eos news webpage
    func getNewsHTMLResponse() {
        loadingView.isHidden = false
        loadingLbl.text = "LOADING NEWS..."
        AF.request("https://www.eoslund.se/om-eos/nyheter?page=\(pageNumber)").responseString { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                self.parseHTML(htmlData: utf8Text)
            }
        }
    }
    
    //parse news HTML
    func parseHTML(htmlData: String) {
        do {
            let html = htmlData
            let doc: Document = try SwiftSoup.parse(html)
            let newsCards: [Element] = try doc.getElementsByClass("card mt-4").array()
            for news in newsCards {
                var imgLink: String = " "
                if let img = try news.select("img").first(){
                    imgLink = try img.attr("src")
                } else {
                    imgLink = "https://www.eoslund.se/eos/svg/eos-logo.svg"
                }
                let newsDate = try news.getElementsByClass("date").first()?.text() ?? " "
                let newsHeader = try news.getElementsByClass("article-header").first()?.text() ?? " "
                let newsText = try news.getElementsByClass("mt-3").first()?.text() ?? " "
                let link = try news.select("a").first()?.attr("href") ?? "https://www.eoslund.se/404"
                
                let newNews: News = News(header: newsHeader, date: newsDate, text: newsText, imageLink: imgLink, newsLink: link)
                
                newsArray.append(newNews)
            }
            if newsArray.isEmpty == false {
                loadingView.isHidden = true
                spinner.stopAnimating()
            }
            tableView.reloadData()
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
    }
    
    func dateFormateFrom(string: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM dd,yyyy"

        if let date = dateFormatterGet.date(from: string) {
           let dateToReturn = dateFormatterOut.string(from: date)
            return dateToReturn
        } else {
           return " "
        }
        
    }
    
    //setup button to load new news or video in footer of table
    func setFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:
            80)
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.frame = CGRect(x: 20, y: 10, width: self.view.frame.width - 40, height: 40)
        button.setTitle("LOAD MORE", for: .normal)
        button.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1)
        if segmentControlStatus == "news" {
             button.addTarget(self, action: #selector(fetchNews), for: .touchUpInside)
        } else if segmentControlStatus == "video" {
            if responseArrayCount >= maxYoutubeSearchResult - 2 {
                maxYoutubeSearchResult += 50
                button.addTarget(self, action: #selector(fetchVideo), for: .touchUpInside)
            }
        }
        footerView.addSubview(button)
        tableView.tableFooterView = footerView
    }
    
    @objc func fetchVideo () {
       getVideoHTMLResponse()
    }
    
    @IBAction func segmentControlStatusWasChanged(_ sender: Any) {
        switch newsTypeSegmentControl.selectedSegmentIndex {
        case 0:
            segmentControlStatus = "news"
        case 1:
            segmentControlStatus = "video"
        default:
            segmentControlStatus = "news"
        }
        newsArray.removeAll()
        pageNumber = 1
        maxYoutubeSearchResult = 50
        loadCellContent()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell else { return UITableViewCell()}
        //TODO: check cells arrange before configure
        cell.configureCell(news: newsArray[indexPath.row], segmentControlStatus: segmentControlStatus)
        
        return cell
    }
}

