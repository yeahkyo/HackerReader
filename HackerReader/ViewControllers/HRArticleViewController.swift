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
        case .MikeAsh:
            return HRWebArticleViewController()
        }
    }
}
