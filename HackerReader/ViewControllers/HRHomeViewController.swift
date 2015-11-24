//
//  HRHomeViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/18.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit
import SDWebImage

class HRHomeViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationBar.tintColor = UIColor.blackColor()
        
        let tabBarController = UITabBarController()
        tabBarController.title = "Hacker Reader"
        let backBarItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        tabBarController.navigationItem.backBarButtonItem = backBarItem
        
        let hackerNewsViewController = HRFeedViewController(feedSource: HRSitesAvailable.HackerNews)
        hackerNewsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .Bookmarks, tag: 0)
        let rubyChinaViewController = HRFeedViewController(feedSource: HRSitesAvailable.RubyChina)
        rubyChinaViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .History, tag: 1)
        let mikeAshViewController = HRFeedViewController(feedSource: HRSitesAvailable.MikeAsh)
        mikeAshViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .History, tag: 2)
        
        tabBarController.viewControllers = [hackerNewsViewController, rubyChinaViewController, mikeAshViewController]
        
        self.viewControllers = [tabBarController]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  }
