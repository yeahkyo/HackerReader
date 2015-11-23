//
//  HRArticleViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/18.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRArticleViewController: UIViewController {
    var sourceSite : HRSitesAvailable?
    var url : NSURL!
    
    class func articleViewControllerFor(site: HRSitesAvailable) -> HRArticleViewController {
        switch site {
        case .HackerNews:
            return HRWebArticleViewController()
        case .RubyChina:
            return HRDefaultArticleViewController()
        }
    }
}

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
        let title = "<h1 class='title'>" + (self.article?.title)! + "</h1><div class='author'>"
        let bodyHeader = "<header>" + title + (self.article?.authorName)! + "</div></header>"
        let bodyArticle = "<article>" + (self.article?.content)! + "</article>"
        let html : String! = headHtml + "<body>" + bodyHeader + bodyArticle + "</body>"
        
        self.webView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath))
    }
}