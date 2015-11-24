//
//  HRHTMLParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

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
    
    func parseForComments(html: String) -> [HRCommentModel] {
        preconditionFailure("This method must be overridden")
    }
}
