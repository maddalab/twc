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
    
    func getDuration() -> String {
        
        if let createdAt = createdAt {
            return createdAt.shortTimeAgoSinceNow()
        } else {
            return ""
        }
    }
}
