//
//  HRHomeViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/18.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import SDWebImage

class HRHomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let hackerNewsNavigationController = UINavigationController()
        hackerNewsNavigationController.viewControllers = [HRFeedViewController(feedSource: HRFeedSitesAvailable.HackerNews)]
        hackerNewsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .Bookmarks, tag: 0)
        
        let rubyChinaNavigationController = UINavigationController()
        rubyChinaNavigationController.viewControllers = [HRFeedViewController(feedSource: HRFeedSitesAvailable.RubyChina)]
        rubyChinaNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .History, tag: 1)

        self.viewControllers = [hackerNewsNavigationController, rubyChinaNavigationController]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  }
