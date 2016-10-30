//
//  Tweet.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/29/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userTweet: String?
    var screenNameTweet: String?
    var profileUserTweetUrl: URL?
    var retweeted: Bool = false
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        let retweetedString = dictionary["retweeted"] as? String
        if retweetedString == "true" {
            retweeted = true
        } else {
            retweeted = false
        }

        userTweet = dictionary.value(forKeyPath: "user.name") as? String
        screenNameTweet = dictionary.value(forKeyPath: "user.screen_name") as? String
        let profileUserTweetString = dictionary.value(forKeyPath: "user.profile_image_url") as? String
        if let profileUserTweetString = profileUserTweetString {
            profileUserTweetUrl = URL(string: profileUserTweetString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
