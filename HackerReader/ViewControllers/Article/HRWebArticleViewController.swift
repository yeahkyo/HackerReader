//
//  HRWebArticleViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/21.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRWebArticleViewController: HRArticleViewController {
    lazy var indicator : UIActivityIndicatorView! = {
        var aIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        aIndicator.frame = CGRectMake(0, 0, 100, 100)
        aIndicator.center = self.view.center
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    var webView : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.webView = UIWebView(frame: self.view.bounds)
        self.webView.delegate = self
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.indicator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
        self.webView.loadRequest(NSURLRequest(URL: self.url))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HRWebArticleViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.indicator.stopAnimating()
        
        let alert = UIAlertView(title: "Sorry", message: "article can't be loaded: " + (webView.request?.URLString)!, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
