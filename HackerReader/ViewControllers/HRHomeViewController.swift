//
//  HRHomeViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/18.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRHomeViewController: UIViewController {

    var tableView : UITableView!
    var feedArray : NSMutableArray = NSMutableArray()
    var articleViewController : HRArticleViewController = HRArticleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Hacker Reader"
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadData() {
        let fetcher : HRFeedFetcher = HRFeedFetcher()
        
        fetcher.newest(.RubyChina) { [weak self](feedArray) -> Void in
            if let wself = self {
                wself.feedArray.removeAllObjects()
                wself.feedArray.addObjectsFromArray(feedArray as [AnyObject])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableView.reloadData()
                })
            }
        }
    
    }
}

extension HRHomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("HomeCell")
        if (cell == nil) {
            cell = UITableViewCell()
            cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont.systemFontOfSize(12.0)
        }

        let feed = self.feedArray[indexPath.row]
        cell?.textLabel?.text = feed.title

        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
}

extension HRHomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feed : HRFeedModel! = self.feedArray[indexPath.row] as! HRFeedModel
        self.articleViewController.title = feed.title as String
        self.articleViewController.url = NSURL(string: feed.urlString as String)
        self.navigationController?.pushViewController(self.articleViewController, animated: true)
    }
    
}