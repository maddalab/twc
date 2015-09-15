//
//  Tweet.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/14/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit


class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var id: Int?
    
    init(dictionary: NSDictionary) {

        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        createdAt = formatter.dateFromString(createdAtString!)
        
        id = dictionary["id"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
    }
    
    class func tweetsFromArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
    
    func getCompactDate() -> String {
        if createdAt == nil {
            return ""
        }
        let units: NSCalendarUnit = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth
        let components: NSDateComponents = NSCalendar.currentCalendar().components(units, fromDate: createdAt!, toDate: NSDate(), options: nil)
        
        if (components.month > 0) {
            return "\(components.month)m"
        } else if (components.day > 0) {
            return "\(components.day)d"
        } else if (components.hour > 0) {
            return "\(components.hour)h"
        } else if (components.minute > 0) {
            return "\(components.minute)m"
        } else {
            return "Now"
        }
    }
}
