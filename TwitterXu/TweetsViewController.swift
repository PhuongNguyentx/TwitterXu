//
//  TweetsViewController.swift
//  TwitterXu
//
//  Created by Phương Nguyễn on 10/29/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    let refreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        refreshControl.addTarget(self, action: #selector(TweetsViewController.loadTimeline), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    
        loadTimeline()
     
    }
    func loadTimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.isMoreDataLoading = false
            self.refreshControl.endRefreshing()
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(_ sender: UIButton) {
        TwitterClient.sharedInstance?.logout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTweet" {
            if let nvc = segue.destination as? UINavigationController, let tweetDetailVC = nvc.topViewController as? TweetDetailViewController {
                let ip = tableView.indexPathForSelectedRow
                tweetDetailVC.tweet = tweets[(ip?.row)!]
            }
        }
        if segue.identifier == "updateTweet1" {
            if let nvc = segue.destination as? UINavigationController, let updateTweetVC = nvc.topViewController as? UpdateTweetViewController {
                updateTweetVC.user = User.currentUser
        
            }
        }
    }


}

extension TweetsViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
}

extension TweetsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                // Code to load more results
                loadTimeline()
            }
        }
    }
}
