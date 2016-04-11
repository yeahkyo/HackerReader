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
    case MikeAsh = 3
}

let HRSitesBaseURL = [HRSitesAvailable.HackerNews: "https://news.ycombinator.com/news",
    .RubyChina: "https://ruby-china.org/topics",
    .MikeAsh: "https://mikeash.com/pyblog"
]

class HRContentFetcher: NSObject {

    func feedsForSite(site: HRSitesAvailable, success: (NSArray) -> Void, failure: () -> Void) {
        self.feedsForSite(site, page: 1, success: success, failure: failure)
    }
    
    func feedsForSite(site: HRSitesAvailable, page: Int, success: (NSArray) -> Void, failure: () -> Void) {
        var url = HRSitesBaseURL[site]!
        var parser : HRHTMLParser
        var pageParameter = ""
        switch site {
        case .HackerNews:
//            parser = HRHTMLParser.hackerNewsParser()
            parser = HRHTMLParserFactory.htmlParserFor(.HackerNews)
            pageParameter = "p"
        case .RubyChina:
            parser = HRHTMLParserFactory.htmlParserFor(.RubyChina)
//            parser = HRHTMLParser.rubyChinaParser()
            pageParameter = "page"
        case .MikeAsh:
//             parser = HRHTMLMikeAshParser()
            parser = HRHTMLParserFactory.htmlParserFor(.MikeAsh)
        }
        
        if page > 1 {
            if pageParameter == "" {
                failure()
                return
            }
            url = url + "?" + pageParameter + "=" + String(page)
        }
        
        Alamofire.request(.GET, url)
            .response(completionHandler: {(request, response, data, error) -> Void in
                if let validData = data {
                    
                    let html = String(data: validData, encoding: NSUTF8StringEncoding)!
                    let feedArray : NSArray = parser.parseForFeeds(html)
                    
                    if feedArray.count > 0 {
                        success(feedArray)
                    } else {
                        failure()
                    }
                    
                } else {
                    failure()
                }
            })
    }
    
    // Temp here
    func articleForSite(site: HRSitesAvailable, url: NSURL, success: (HRArticleModel) -> Void) {
        let parser : HRHTMLParser
        if site == .RubyChina {
//            parser = HRHTMLParser.rubyChinaParser()
            parser = HRHTMLParserFactory.htmlParserFor(.RubyChina)
        } else {
//            parser = HRHTMLParser()
            parser = HRHTMLParserFactory.htmlParserFor(.HackerNews)
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





