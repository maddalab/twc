//
//  TweetsViewController.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/14/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets: [Tweet]?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.estimatedRowHeight = 250
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        // Add refresh control to the tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.insertSubview(refreshControl, atIndex:0)
        
        loadData()
    }
    
    // When refresh is triggered, change the title and load the data
    func onRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading data...")
        loadData()
    }
    
    func loadData() {
        self.refreshControl.beginRefreshing()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if let tweets = tweets {
                self.tweets = tweets
                self.refreshControl.endRefreshing()
                self.tweetTableView.reloadData()
            } else {
                NSLog("Failed to load data \(error)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: UIButton) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onNewTweet() {
        loadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier!) {
            case "newTweetSegue":
                let newTweetViewController = segue.destinationViewController as! NewTweetViewController
                newTweetViewController.delegate = self
            case "viewTweetSegue":
                let displayTweetViewContoller = segue.destinationViewController as! DisplayTweetViewController
                let cell = sender as! UITableViewCell
                let indexPath = tweetTableView.indexPathForCell(cell)
                let tweet = tweets![indexPath!.row]
                displayTweetViewContoller.tweet = tweet
            default: NSLog("Unknown segue \(segue.identifier)")
        }
    }

}
