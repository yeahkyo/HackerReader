//
//  HRHTMLRubyChinaParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/24.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Fuzi

class HRHTMLRubyChinaParser: HRHTMLParser {
    func parseForFeeds(html: String) -> [HRFeedModel] {
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
        
        return array.copy() as! [HRFeedModel]
    }
    
    func parseForArticle(html: String) -> HRArticleModel {
        let article = HRArticleModel()
        
        do {
            let doc = try HTMLDocument(string: html)
            
            article.content = doc.css("article").first?.rawXML
            article.title = doc.css("h1").first?.stringValue
            article.authorName = doc.css("div.media-body div.info a")[1]!.stringValue
            article.comments = self.parseForComments(html)
            article.time = NSDate.dateTimeWithZoneTimeString(doc.css("div.topic-detail div.panel-heading .info abbr").first!["title"]!)
        } catch let error {
            print(error)
        }
        
        return article
    }
    
    func parseForComments(html: String) -> [HRCommentModel] {
        let comments = NSMutableArray()
        
        do {
            let doc = try HTMLDocument(string: html)
            
            for replyHtml in doc.css("div.reply") {
                if replyHtml.css("div.deleted").count > 0 {
                    continue
                }
                
                let comment = HRCommentModel()
                comment.content = replyHtml.css("div.markdown").first?.rawXML
                comment.userName = replyHtml.css("div.info span.name").first?.stringValue
                comment.time = NSDate.dateTimeWithZoneTimeString((replyHtml.css("div.info span.time abbr").first?["title"])!)
                
                var avatarUrlString = (replyHtml.css("div.avatar img").first?["src"])! as String
                if !avatarUrlString.hasPrefix("http") {
                    avatarUrlString = "https:" + avatarUrlString
                }
                comment.userAvatarURL = NSURL(string: avatarUrlString)
                
                comments.addObject(comment)
            }
        } catch let error {
            print(error)
        }
        
        return comments.copy() as! [HRCommentModel]
    }
}
