//
//  TweetTableViewCell.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/15/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetedImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            tweetText.text = tweet.text
            userHandleLabel.text = "@\(tweet.user!.screenname!)"
            if let user = tweet.user {
                userNameLabel.text = user.name
                profileImage.setImageWithURL(NSURL(string: user.profileImageURL!))
            }
            retweetedLabel.hidden = true
            timestampLabel.text = tweet.getCompactDate()
            if (tweet.favorited!) {
                favoriteImage.image = UIImage(named: "fav-on")
            } else {
                favoriteImage.image = UIImage(named: "fav-default")
            }
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweet-on")
            } else {
                retweetImage.image = UIImage(named: "retweet-default")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
    }

}
