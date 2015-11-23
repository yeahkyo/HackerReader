//
//  HRHTMLParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Fuzi

protocol HRHTMLParserProtocol {
    func parseForFeeds(html: String) -> NSArray
}

class HRHTMLParser: NSObject, HRHTMLParserProtocol {
    
    static func hackerNewsParser() -> HRHTMLParser {
        return HRHTMLHackerNewsParser()
    }
    
    static func rubyChinaParser() -> HRHTMLParser {
        return HRHTMLRubyChinaParser()
    }
    
    func parseForFeeds(html: String) -> NSArray {
        preconditionFailure("This method must be overridden")
    }
    
    func parseForArticle(html: String) -> HRArticleModel {
        preconditionFailure("This method must be overridden")
    }
}

class HRHTMLHackerNewsParser : HRHTMLParser {
    override func parseForFeeds(html: String) -> NSArray {
        let array = NSMutableArray()
        do {
            let doc = try HTMLDocument(string: html)
            
            for item in doc.css("tr.athing td.title > a") {
                let feed = HRFeedModel()
                feed.title = item.stringValue
                feed.urlString = item["href"]
                array.addObject(feed)
            }
            
        } catch let error {
            print(error)
        }
        
        return array.copy() as! NSArray
    }
}

class HRHTMLRubyChinaParser : HRHTMLParser {
    override func parseForFeeds(html: String) -> NSArray {
        let array = NSMutableArray()
        do {
            let doc = try HTMLDocument(string: html)
            
            for item in doc.css("div.topic") {
                let info = item.css(".infos .title > a").first
                let avatar = item.css(".avatar img").first
                let feed = HRFeedModel()
                feed.title = info!.stringValue
                feed.urlString = "https://ruby-china.org" + info!["href"]!
                feed.imageURLString = avatar!["src"]!
                array.addObject(feed)
            }
            
        } catch let error {
            print(error)
        }
        
        return array.copy() as! NSArray
    }
    
    override  func parseForArticle(html: String) -> HRArticleModel {
        let article = HRArticleModel()
        
        do {
            let doc = try HTMLDocument(string: html)
            
            article.content = doc.css("article").first?.rawXML
            article.title = doc.css("h1").first?.stringValue
//            article.authorName = doc.css("div.media-body div.info a[data-author]").firs?.stringValue
            article.authorName = doc.css("div.media-body div.info a")[1]!.stringValue
            
        } catch let error {
            print(error)
        }
        
        return article
    }
}
