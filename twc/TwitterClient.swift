//
//  TwitterClient.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/14/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit


let twitterConsumerKey = "eVvLTDpt6PCdSPrnmOXm91kfE"
let twitterConsumerSecret = "EJRBXXheVIAGrUZ9czF6xhgq5aQM2vCLxBlXv3xr5tPpKQpBAi"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page.
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twc://oauth"), scope: nil, success: { (requestToken) -> Void in
            
                var authURL =  NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error) -> Void in
                completion(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var tweets = Tweet.tweetsFromArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
            }
        )
    }

    func postTweetWithStatus(status: String, respondingTo: Tweet?, completion: (success: Bool?, error: NSError?) -> ()) {
        var parameters: [String: String] = ["status": status]
        
        if let respondingTo = respondingTo {
            parameters["in_reply_to_status_id"] = "\(respondingTo.id!)"
        }
        
        POST("1.1/statuses/update.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(success: false, error: error)
        }
    }
    
    func favoriteTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        let parameters: [String: String] = ["id": "\(tweet.id!)"]
        println("\(parameters)")
        POST("1.1/favorites/create.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(success: false, error: error)
        }
    }
    
    func undoFavoriteTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        let parameters: [String: String] = ["id": "\(tweet.id!)"]
        println("\(parameters)")
        POST("1.1/favorites/destroy.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(success: false, error: error)
        }
    }
    
    func retweetTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(success: false, error: error)
        }
    }

    func undoRetweetTweetWithCompletion(tweet: Tweet, completion: (success: Bool?, error: NSError?) -> ()) {
        POST("1.1/statuses/destroy/\(tweet.id!).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(success: true, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(success: false, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken) -> Void in
            self.requestSerializer.saveAccessToken(accessToken)
            
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil,
                success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    var user = User(dictionary: response as! NSDictionary)
                    self.loginCompletion?(user: user, error: nil)
                    User.currentUser = user
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    self.loginCompletion?(user: nil, error: error)
                })
            }) { (error) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
    }
}
