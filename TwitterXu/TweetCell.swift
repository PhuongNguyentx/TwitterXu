//
//  TweetCell.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/30/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var screenName: UILabel!

    @IBOutlet weak var descriptionTweet: UILabel!
    
    @IBOutlet weak var retweeted: UILabel!
    @IBOutlet weak var tweetCreated: UILabel!
    var tweet: Tweet! {
        didSet{
            if tweet.profileUserTweetUrl != nil {
                profileImage.setImageWith(tweet.profileUserTweetUrl!)
                
            } else {
                profileImage.image = nil
            }
            tweetName.text = tweet.userTweet
            let screenNameString = tweet.screenNameTweet
            screenName.text = "@\(screenNameString!)"
            
            if tweet.retweeted == false {
                retweeted.isHidden = true
                retweeted.text = "You posted"
            } else {
                retweeted.isHidden = true
                retweeted.text = "You retweeted"
            }
            descriptionTweet.text = tweet.text
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d y"
            tweetCreated.text = formatter.string(from: tweet.timestamp as! Date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
