//
//  HRFeedViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRFeedViewController: UITableViewController {

    var feedArray : NSMutableArray = NSMutableArray()
    var articleViewController : HRArticleViewController!
    
    var feedSource : HRSitesAvailable
    
    private var isLoading = false
    private var page = 1
    
    required init(feedSource: HRSitesAvailable) {
        self.feedSource = feedSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if feedSource == HRSitesAvailable.HackerNews {
            self.title = "HN"
        } else if feedSource == HRSitesAvailable.RubyChina {
            self.title = "RubyChina"
        } else if feedSource == HRSitesAvailable.MikeAsh {
            self.title = "MikeAsh"
        }
        
        self.articleViewController = HRArticleViewController.articleViewControllerFor(self.feedSource)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor.whiteColor()
        self.refreshControl!.tintColor = UIColor.orangeColor()
        self.refreshControl?.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)

        self.loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func refreshData() {
        self.loadData()
    }
    
    private func loadData() {
        let fetcher : HRContentFetcher = HRContentFetcher()
        
        fetcher.feedsForSite(feedSource, success: {[weak self] (feedArray) -> Void in
            if let wself = self {
                wself.feedArray.removeAllObjects()
                wself.feedArray.addObjectsFromArray(feedArray as [AnyObject])
                wself.refreshControl?.endRefreshing()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableView.reloadData()
                })
            }

            }, failure: { ()->Void in
        })
    }
    
    private func loadNextPage() {
        let fetcher : HRContentFetcher = HRContentFetcher()
        self.isLoading = true
        
        fetcher.feedsForSite(feedSource, page: ++self.page, success: { [weak self](feedArray) -> Void in
            if let wself = self {
                wself.feedArray.addObjectsFromArray(feedArray as [AnyObject])
                wself.isLoading = false
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.tableView.reloadData()
                })
            }
            }, failure:  { () -> Void in
                
        })
    }
}


extension HRFeedViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("HomeCell")
        if (cell == nil) {
            cell = UITableViewCell()
            cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont.systemFontOfSize(12.0)
        }
        
        let feed : HRFeedModel = self.feedArray[indexPath.row] as! HRFeedModel
        cell?.textLabel?.text = feed.title
        if feed.imageURLString != nil {
            cell?.imageView?.sd_setImageWithURL(NSURL(string: feed.imageURLString), placeholderImage: UIImage(named: "DefaultImage"))
        }
        
        if (!self.isLoading && indexPath.row >= self.feedArray.count - 2) {
            self.loadNextPage();
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
}

extension HRFeedViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feed : HRFeedModel! = self.feedArray[indexPath.row] as! HRFeedModel
        
        self.articleViewController.sourceSite = self.feedSource
        self.articleViewController.title = self.title
        self.articleViewController.url = NSURL(string: feed.urlString as String)
        
        self.navigationController?.pushViewController(self.articleViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
