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
        do {
            let defaultArticlePath = NSBundle.mainBundle().pathForResource("default_article", ofType: "html")
            var defaultArticle = try String(contentsOfFile: defaultArticlePath!)
            defaultArticle = defaultArticle.stringByReplacingOccurrencesOfString("[[ title ]]", withString: (self.article?.title)!)
                .stringByReplacingOccurrencesOfString("[[ authorName ]]", withString: (self.article?.authorName)!)
                .stringByReplacingOccurrencesOfString("[[ timeText ]]", withString: (self.article?.time.timeAgoString())!)
                .stringByReplacingOccurrencesOfString("[[ content ]]", withString: (self.article?.content)!)
            
            var commentsPartial = ""
            let commentPath = NSBundle.mainBundle().pathForResource("_comment", ofType: "html")
            let commentTemplate = try String(contentsOfFile: commentPath!)
            for comment in (self.article?.comments)! {
                commentsPartial = commentsPartial + commentTemplate.stringByReplacingOccurrencesOfString("[[ avatarSrc ]]", withString: String(comment.userAvatarURL!)).stringByReplacingOccurrencesOfString("[[ userName ]]", withString: comment.userName).stringByReplacingOccurrencesOfString("[[ timeText ]]", withString: comment.time.timeAgoString()).stringByReplacingOccurrencesOfString("[[ content ]]", withString: comment.content)
            }

            defaultArticle = defaultArticle.stringByReplacingOccurrencesOfString("[[ comments ]]", withString: commentsPartial)
            
            self.webView.loadHTMLString(defaultArticle, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath))
        } catch let error {
            print(error)
        }
    }
}
