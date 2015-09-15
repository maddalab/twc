//
//  DisplayTweetViewController.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/15/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit

class DisplayTweetViewController: UIViewController {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.setImageWithURL(NSURL(string: (tweet?.user?.profileImageURL)!))
        userNameLabel.text = tweet?.user?.name
        userHandleLabel.text = "@\((tweet?.user?.screenname)!)"
        tweetText.text = tweet?.text
        retweetCountLabel.text = "\((tweet?.retweetCount)!)"
        favoritesLabel.text = "\((tweet?.favoriteCount)!)"
        
        favoriteImage.userInteractionEnabled = true
        favoriteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onFavorite:"))
        retweetImage.userInteractionEnabled = true
        retweetImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onRetweet:"))
        replyImage.userInteractionEnabled = true
        replyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onReply:"))
        
        if tweet!.favorited! {
            favoriteImage.image = UIImage(named: "fav-on")
        }

        if tweet!.retweeted! {
            retweetImage.image = UIImage(named: "retweet-on")
        }
    }

    func onFavorite(sender: UITapGestureRecognizer) {
        if tweet!.favorited! {
            TwitterClient.sharedInstance.undoFavoriteTweetWithCompletion(tweet!, completion: { (success, error) -> () in
                if success != nil {
                    self.favoriteImage.image = UIImage(named: "fav-default")
                    self.tweet!.favorited = false
                } else {
                    NSLog("Failed to undo favorite a tweet")
                }
            })
        } else {
            TwitterClient.sharedInstance.favoriteTweetWithCompletion(tweet!, completion: { (success, error) -> () in
                if success != nil {
                    self.favoriteImage.image = UIImage(named: "fav-on")
                    self.tweet!.favorited = true
                } else {
                    NSLog("Failed to favorite a tweet")
                }
            })
        }
    }
    
    func onRetweet(sender: UITapGestureRecognizer) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.undoRetweetTweetWithCompletion(tweet!, completion: { (success, error) -> () in
                if success != nil {
                    self.retweetImage.image = UIImage(named: "retweet-default")
                    self.tweet!.retweeted = false
                } else {
                    NSLog("Failed to undo retweet a tweet")
                }
            })
        } else {
            TwitterClient.sharedInstance.retweetTweetWithCompletion(tweet!, completion: { (success, error) -> () in
                if success != nil {
                    self.retweetImage.image = UIImage(named: "retweet-on")
                    self.tweet!.retweeted = true
                } else {
                    NSLog("Failed to retweet a tweet")
                }
            })
        }
    }
    
    func onReply(sender: UITapGestureRecognizer) {
        //performSegueWithIdentifier("replySegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
