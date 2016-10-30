//
//  User.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/29/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagLine = dictionary["description"] as? String
        
    }
    static let userDidLogoutNotification = "UserDidlogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
//            if _currentUser == nil {
//                let defaults = UserDefaults.standard
//                let userData = defaults.object(forKey: "currentUserData") as? Data
//                if let userData = userData {
//                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
//                    _currentUser = User(dictionary: dictionary)
//                }
//            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user 
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
