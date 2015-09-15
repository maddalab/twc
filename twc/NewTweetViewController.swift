//
//  NewTweetViewController.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/15/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit

@objc protocol NewTweetDelegate {
    optional func onNewTweet()
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    
    var replyTweet: Tweet?
    var delegate: NewTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var user = User.currentUser!
        
        userNameLabel.text = user.name
        userHandleLabel.text = "@\(user.screenname!)"
        profileImage.setImageWithURL(NSURL(string: user.profileImageURL!))
        
        if let replyTweet = replyTweet {
            tweetText.text = "@\(replyTweet.user!.screenname!) "
        }
        
        tweetText.becomeFirstResponder()
        tweetText.delegate = self
        tweetButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        var length = count(tweetText.text)
        
        let charsLeft = 140 - length
        charCountLabel.attributedText = NSAttributedString(string: "\(charsLeft)")
        var color: UIColor!
        
        if length > 0 {
            tweetButton.enabled = true
        } else {
            tweetButton.enabled = false
        }
    }
    

    @IBAction func onTweetAction(sender: UIButton) {
        TwitterClient.sharedInstance.postTweetWithStatus(tweetText.text, respondingTo: replyTweet, completion: { (success, error) -> () in
            if (success == true) {
                self.delegate?.onNewTweet?()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                NSLog("Failed to post new tweet")
            }
        })
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
