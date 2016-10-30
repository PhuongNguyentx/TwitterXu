//
//  TweetDetailViewController.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/30/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var ImageProfileDetail: UIImageView!
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var timeTweetDetail: UILabel!
    @IBOutlet weak var descriptionDetail: UILabel!
    @IBOutlet weak var screenNameDetail: UILabel!
    
    var tweet: Tweet!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tweet.profileUserTweetUrl != nil {
            ImageProfileDetail.setImageWith(tweet.profileUserTweetUrl!)
            
        } else {
            ImageProfileDetail.image = nil
        }
        nameDetail.text = tweet.userTweet
        let screenNameString = tweet.screenNameTweet
        screenNameDetail.text = "@\(screenNameString!)"
        
        descriptionDetail.text = tweet.text
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        timeTweetDetail.text = formatter.string(from: tweet.timestamp as! Date)


    }
    @IBAction func onHome(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                if segue.identifier == "updateTweet" {
                    if let nvc = segue.destination as? UINavigationController, let updateTweetVC = nvc.topViewController as? UpdateTweetViewController {
//                        TwitterClient.sharedInstance?.currentAcount(success: { (user: User) in
//                            User.currentUser = user
//                        }, failure: { (error: Error) in
//                            print(error.localizedDescription)
//                        })
                        updateTweetVC.user = User.currentUser
                    }
                }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
