//
//  HRCommentModel.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/23.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import UIKit

class HRCommentModel: NSObject {
    var userName: String!
    var userAvatarURL: NSURL!
    var content: String!
    
    var time: NSDate! {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let dateTime = dateFormatter.dateFromString(self.timeText)
        return dateTime!
    }
    var timeText: String!
    var timeAgoText: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        
//        let now = NSDate()
//        let timeAgo = now.timeIntervalSinceDate(self.time)

        return self.time.timeAgoString()
    }
}
 