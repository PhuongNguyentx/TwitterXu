//
//  TwitterClient.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/29/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com/"), consumerKey: "7b60BfYjmm3M4EX9bktsHNFWr", consumerSecret: "bnCKFqtlolCPji7fn2nscUR2l31zmWkKCafhDKb0DNf2KJSj8U")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string:"TwitterXu://oauth"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            
            let requestToken = (response?.token)! as String
            print("i got the request token= \(requestToken)")
            let authUrl = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken)")
            //UIApplication.shared.openURL((authUrl)!)
            UIApplication.shared.open(authUrl!, options: ["no links": String()], completionHandler: nil)
        }){ (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            self.currentAcount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }) {(error:Error?) -> Void in
            print("Error:\(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) ->()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func currentAcount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

}
