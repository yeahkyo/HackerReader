//
//  HRHTMLMikeAshParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/24.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Fuzi

class HRHTMLMikeAshParser: HRHTMLParser {
    
    func parseForFeeds(html: String) -> [HRFeedModel] {
        let array = NSMutableArray()
        do {
            let doc = try HTMLDocument(string: html)
            
            for item in doc.css("div.blogsummarytitle a") {
                let feed = HRFeedModel()
                feed.title = item.stringValue
                feed.urlString = item["href"]
                if !feed.urlString.hasPrefix("http") {
                    feed.urlString = "\(HRSitesBaseURL[.MikeAsh]!)/\(feed.urlString)"
                }
                array.addObject(feed)
            }
            
        } catch let error {
            print(error)
        }
        
        return array.copy() as! [HRFeedModel]
    }

    func parseForArticle(html: String) -> HRArticleModel {
        return HRArticleModel()
    }
    
    func parseForComments(html: String) -> [HRCommentModel] {
        return []
    }
}
