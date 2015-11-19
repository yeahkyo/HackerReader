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
    
    func newest(site: HRFeedSitesAvailable, success: (NSArray) -> Void) {
        var url : String
        var parser : HRHTMLParser
        if site == .HackerNews {
            url = "https://news.ycombinator.com/news"
            parser = HRHTMLParser.hackerNewsParser()
        } else if site == .RubyChina {
            url = "https://ruby-china.org/topics"
            parser = HRHTMLParser.rubyChinaParser()
        } else {
            url = "about:blank"
            parser = HRHTMLParser()
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
