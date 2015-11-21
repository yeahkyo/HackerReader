//
//  HRArticleViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/18.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRArticleViewController: UIViewController {

    var url : NSURL!
    
    lazy var indicator : UIActivityIndicatorView! = {
        var aIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        aIndicator.frame = CGRectMake(0, 0, 100, 100)
        aIndicator.center = self.view.center
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    lazy var webView : UIWebView! = {
        var aWebView = UIWebView(frame: self.view.bounds)
        aWebView.delegate = self
        return aWebView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension HRArticleViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        self.indicator.startAnimating()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.indicator.stopAnimating()
        
        let alert = UIAlertView(title: "Sorry", message: "article can't be loaded", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
