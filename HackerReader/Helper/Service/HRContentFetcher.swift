//
//  HRFeedFetcher.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Alamofire

enum HRSitesAvailable : Int {
    case HackerNews = 1
    case RubyChina = 2
}

class HRContentFetcher: NSObject {

    func feedsForSite(site: HRSitesAvailable, success: (NSArray) -> Void) {
        self.feedsForSite(site, page: 1, success: success)
    }
    
    func feedsForSite(site: HRSitesAvailable, page: Int, success: (NSArray) -> Void) {
        var url : String
        var parser : HRHTMLParser
        var pageParameter = ""
        if site == .HackerNews {
            url = "https://news.ycombinator.com/news"
            parser = HRHTMLParser.hackerNewsParser()
            pageParameter = "p"
        } else if site == .RubyChina {
            url = "https://ruby-china.org/topics"
            parser = HRHTMLParser.rubyChinaParser()
            pageParameter = "page"
        } else {
            url = "about:blank"
            parser = HRHTMLParser()
        }
        
        if page > 1 {
            url = url + "?" + pageParameter + "=" + String(page)
        }
        
        Alamofire.request(.GET, url)
            .response(completionHandler: {(request, response, data, error) -> Void in
                if let validData = data {
                    
                    let html = String(data: validData, encoding: NSUTF8StringEncoding)!
                    let feedArray : NSArray = parser.parseForFeeds(html)
                    
                    success(feedArray)
                }
            })
    }
    
    // Temp here
    func articleForSite(site: HRSitesAvailable, url: NSURL, success: (HRArticleModel) -> Void) {
        let parser : HRHTMLParser
        if site == .RubyChina {
            parser = HRHTMLParser.rubyChinaParser()
        } else {
            parser = HRHTMLParser()
        }
        
        Alamofire.request(.GET, url)
            .response { (request, response, data, error) -> Void in
                if let validData = data {
                    let html  = String(data: validData, encoding: NSUTF8StringEncoding)
                    let article = parser.parseForArticle(html!)
                    
                    success(article)
                }
        }
    }
}





