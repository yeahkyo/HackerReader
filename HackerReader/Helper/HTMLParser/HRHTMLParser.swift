//
//  HRHTMLParser.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

protocol HRHTMLParser {
    func parseForFeeds(html: String) -> [HRFeedModel]
    func parseForArticle(html: String) -> HRArticleModel 
    func parseForComments(html: String) -> [HRCommentModel]
}

class HRHTMLParserFactory: NSObject {
    static func htmlParserFor(site: HRSitesAvailable) -> HRHTMLParser {
        switch site {
        case .HackerNews:
            return HRHTMLHackerNewsParser()
        case .RubyChina:
            return HRHTMLRubyChinaParser()
        case .MikeAsh:
            return HRHTMLMikeAshParser()
        }
    }
}

//class HRHTMLParser: NSObject, HRHTMLParserProtocol {
//    
//    static func hackerNewsParser() -> HRHTMLParser {
//        return HRHTMLHackerNewsParser()
//    }
//    
//    static func rubyChinaParser() -> HRHTMLParser {
//        return HRHTMLRubyChinaParser()
//    }
//    
//    static func mikeAshParser() -> HRHTMLParser {
//        return HRHTMLMikeAshParser()
//    }
//    
//    func parseForFeeds(html: String) -> [HRFeedModel] {
//        preconditionFailure("This method must be overridden")
//    }
//    
//    func parseForArticle(html: String) -> HRArticleModel {
//        preconditionFailure("This method must be overridden")
//    }
//    
//    func parseForComments(html: String) -> [HRCommentModel] {
//        preconditionFailure("This method must be overridden")
//    }
//}
