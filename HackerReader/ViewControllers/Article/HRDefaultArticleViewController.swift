//
//  HRDefaultArticleViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/24.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRDefaultArticleViewController : HRArticleViewController {
    var article : HRArticleModel?
    
    lazy var webView : UIWebView! = {
        var aWebView = UIWebView(frame: self.view.bounds)
        return aWebView
    }()
    
    override var url : NSURL! {
        didSet {
            let fetcher = HRContentFetcher()
            self.indicator.startAnimating()
            
            fetcher.articleForSite(sourceSite!, url: url) {[weak self] (newArticle) -> Void in
                if let wself = self {
                    wself.article = newArticle
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        wself.indicator.stopAnimating()
                        wself.reloadArticle()
                    })
                }
            }
        }
    }
    
    lazy var indicator : UIActivityIndicatorView! = {
        var aIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        aIndicator.frame = CGRectMake(0, 0, 100, 100)
        aIndicator.center = self.view.center
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.webView)
        
        self.view.addSubview(self.indicator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.loadHTMLString("", baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func reloadArticle() {
        let headHtml = "<head><link type='text/css' rel='stylesheet' href='article.css'></head>"
        
        let headerTitle = "<h1 class='title'>  \((self.article?.title)!) </h1><div class='author'>"
        let bodyHeader = "<header> \(headerTitle) \((self.article?.authorName)!) </div></header>"
        let bodyArticle = "<article> \((self.article?.content)!) </article>"
        
        var commentsHtml = ""
        for comment in (self.article?.comments)! {
            let commentHtml = "<div class='comment'><div class='avatar'><img src='\(comment.userAvatarURL!)'></div><div class='infos'>\(comment.userName) \(comment.timeAgoText)</div><div class='content'>\(comment.content!)</div></div>"
            commentsHtml.appendContentsOf(commentHtml)
        }
        let bodyComments = "<div class='comments'>\(commentsHtml)</div>"
        
        let html : String! = "\(headHtml) <body> \(bodyHeader) \(bodyArticle) \(bodyComments) </body>"
        
        self.webView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath))
    }
}
