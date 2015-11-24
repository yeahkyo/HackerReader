//
//  HRHTMLParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

protocol HRHTMLParserProtocol {
    func parseForFeeds(html: String) -> [HRFeedModel]
    func parseForArticle(html: String) -> HRArticleModel 
    func parseForComments(html: String) -> [HRCommentModel]
}

class HRHTMLParser: NSObject, HRHTMLParserProtocol {
    
    static func hackerNewsParser() -> HRHTMLParser {
        return HRHTMLHackerNewsParser()
    }
    
    static func rubyChinaParser() -> HRHTMLParser {
        return HRHTMLRubyChinaParser()
    }
    
    static func mikeAshParser() -> HRHTMLParser {
        return HRHTMLMikeAshParser()
    }
    
    func parseForFeeds(html: String) -> [HRFeedModel] {
        preconditionFailure("This method must be overridden")
    }
    
    func parseForArticle(html: String) -> HRArticleModel {
        preconditionFailure("This method must be overridden")
    }
    
    func parseForComments(html: String) -> [HRCommentModel] {
        preconditionFailure("This method must be overridden")
    }
}
