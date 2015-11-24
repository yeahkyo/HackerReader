//
//  ZYDateUtility.swift
//  HackerReader
//
//  Created by Zhang Yan on 15/11/24.
//  Copyright © 2015年 Yeah. All rights reserved.
//

import Foundation

extension NSDate {
    func timeAgoString() -> String {
        let now = NSDate()
        let secondsDiff = Int(now.timeIntervalSinceDate(self))
        let minutesDiff = secondsDiff / 60
        let hoursDiff = minutesDiff / 60
        let daysDiff = hoursDiff / 24
        let monthDiff = daysDiff / 30
        let yearsDiff = monthDiff / 12
        
        if yearsDiff > 0 {
            return "\(yearsDiff)年前"
        } else if monthDiff > 0 {
            return "\(monthDiff)月前"
        } else if daysDiff > 0 {
            return "\(daysDiff)天前"
        } else if hoursDiff > 0 {
            return "\(hoursDiff)小时前"
        } else if minutesDiff > 0 {
            return "\(minutesDiff)分钟前"
        } else  {
            return "刚刚"
        }
    }
    
    class func dateTimeWithZoneTimeString(timeString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let dateTime = dateFormatter.dateFromString(timeString)
        return dateTime!
    }
}
