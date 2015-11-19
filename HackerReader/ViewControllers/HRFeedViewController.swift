//
//  HRFeedViewController.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/19.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRFeedViewController: UIViewController {

    var tableView : UITableView!
    var feedArray : NSMutableArray = NSMutableArray()
    var articleViewController : HRArticleViewController = HRArticleViewController()
    
    var feedSource : HRFeedSitesAvailable
    
    required init(feedSource: HRFeedSitesAvailable) {
        self.feedSource = feedSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if feedSource == HRFeedSitesAvailable.HackerNews {
            self.title = "HN"
        } else if feedSource == HRFeedSitesAvailable.RubyChina {
            self.title = "RubyChina"
        }

        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)

        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadData() {
        let fetcher : HRFeedFetcher = HRFeedFetcher()
        
        fetcher.newest(feedSource) { [weak self](feedArray) -> Void in
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


extension HRFeedViewController: UITableViewDataSource {
    
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
        
        let feed : HRFeedModel = self.feedArray[indexPath.row] as! HRFeedModel
        cell?.textLabel?.text = feed.title
        if feed.imageURLString != nil {
            cell?.imageView?.sd_setImageWithURL(NSURL(string: feed.imageURLString), placeholderImage: UIImage(named: "DefaultImage"))
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
}

extension HRFeedViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feed : HRFeedModel! = self.feedArray[indexPath.row] as! HRFeedModel
        self.articleViewController.title = feed.title as String
        self.articleViewController.url = NSURL(string: feed.urlString as String)
        
        self.navigationController?.pushViewController(self.articleViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
