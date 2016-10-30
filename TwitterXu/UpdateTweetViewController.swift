//
//  UpdateTweetViewController.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/30/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit

class UpdateTweetViewController: UIViewController {
    @IBOutlet weak var userTweetImage: UIImageView!

    @IBOutlet weak var nameTweet: UILabel!
    
    @IBOutlet weak var screenNameTweet: UILabel!
    
    @IBOutlet weak var textTweet: UITextField!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user.profileUrl != nil {
            userTweetImage.setImageWith(user.profileUrl!)
            
        } else {
            userTweetImage.image = nil
        }
        nameTweet.text = user.name
        let screenNameString = user.screenName
        screenNameTweet.text = "@\(screenNameString!)"
        

        // Do any additional setup after loading the view.
    }
    @IBAction func onUpdate(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
