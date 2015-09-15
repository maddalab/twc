//
//  ViewController.swift
//  twc
//
//  Created by Bhaskar Maddala on 9/14/15.
//  Copyright (c) 2015 Bhaskar Maddala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TwitterClient.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            if let user = user {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                NSLog("User login failed")
            }
        }
    }
}

