//
//  NewsCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-10.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireImage
import YoutubePlayer_in_WKWebView

class NewsCell: UITableViewCell, WKYTPlayerViewDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsHeaderLbl: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var yotubeBtnImage: UIImageView!
    @IBOutlet weak var readMoreBtn: RoundedBtn!
    @IBOutlet weak var playerView: WKYTPlayerView!
    var url: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self
    }
    
    override func layoutSubviews() {
        bgView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bgView.layer.shadowOpacity = 0.25
        bgView.layer.shadowRadius = 5.0
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.cornerRadius = 15
    }
    
    func configureCell(news: News, segmentControlStatus: String) {
        newsHeaderLbl.text = news.header.uppercased()
        newsDate.text = news.date
        newsText.text = news.text
      
        
//        configure cell depend from switch to video or news
        func newsConfigureCell() {
            newsImage.isHidden = false
            readMoreBtn.setTitle("READ MORE", for: .normal)
            playerView.isHidden = true
            newsImage.image = UIImage(named: "default-news-image.png")
            url = "https://www.eoslund.se/\(news.link)"
            let imageLink = news.imageLink
            AF.request(imageLink).responseImage { (response) in
                if let image = response.value {
                    self.newsImage.image = image
                } else {
                    self.newsImage.image = UIImage(named: "default-news-image.png")
                }
            }
        }
        
        func videoConfigureCell() {
            newsImage.isHidden = true
            playerView.isHidden = false
            readMoreBtn.setTitle("OPEN IN WEB", for: .normal)
            yotubeBtnImage.isHidden = false
            url = news.link            
            playerView.setPlaybackQuality(.HD720)
            playerView.load(withVideoId: news.imageLink)
        }
        
        switch segmentControlStatus {
        case "news":
            newsConfigureCell()
        case "video":
            videoConfigureCell()
        default:
            newsConfigureCell()
        }
    }
    
    //prepare webwiew for youtube video
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        let preloadView = UIView()
        preloadView.backgroundColor = UIColor.lightGray
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0.3442408442, green: 0.5524554849, blue: 0.9224796891, alpha: 1)
        preloadView.addSubview(spinner)

        let xCenter = (UIScreen.main.bounds.width - 20)/2
            spinner.frame = CGRect(x: xCenter, y: 100, width: 20, height: 20)
        spinner.startAnimating()
        return preloadView
    }
    
    @IBAction func openNewsBtnPressed(_ sender: Any) {
        self.window?.rootViewController?.presentSFSafariVCFor(url: url)
    }
}
