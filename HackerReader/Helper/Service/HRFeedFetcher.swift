//
//  HRFeedFetcher.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Alamofire

enum HRFeedSitesAvailable : Int {
    case HackerNews = 1
    case RubyChina = 2
}

class HRFeedFetcher: NSObject {

    func feedsForSite(site: HRFeedSitesAvailable, success: (NSArray) -> Void) {
        self.feedsForSite(site, page: 1, success: success)
    }
    
    func feedsForSite(site: HRFeedSitesAvailable, page: Int, success: (NSArray) -> Void) {
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

    
}
