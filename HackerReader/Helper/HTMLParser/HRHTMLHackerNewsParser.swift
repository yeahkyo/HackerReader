//
//  HRHTMLHackerNewsParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/24.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import Fuzi

class HRHTMLHackerNewsParser: HRHTMLParser {
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
